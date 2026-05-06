const express = require("express");
const { pool } = require("../conf/db");
const { getAdminChatIds, notifyAdmins, telegramPost } = require("../services/telegram");

const router = express.Router();
const TELEGRAM_ADMIN_NOTE = "Processed by Copupbid AI Review System";
const TELEGRAM_REJECTION_REASON = "Declined by Copupbid AI Validation";

function escapeHtml(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function formatAmount(value, currency = "NGN") {
  const n = Number(value);
  const amount = Number.isFinite(n) ? n.toLocaleString() : "0";
  return `${amount} ${currency}`;
}

function displayUser(row) {
  return escapeHtml(row?.full_name || row?.username || row?.email || `User #${row?.user_id}`);
}

function normalizeAction(value) {
  const action = String(value || "").trim().toLowerCase();
  if (action === "approve") return "approved";
  if (action === "reject") return "rejected";
  return null;
}

function parseCallbackData(data) {
  const parts = String(data || "").split(":");
  if (parts.length !== 4 || parts[0] !== "tx") return null;
  const type = parts[1];
  const status = normalizeAction(parts[2]);
  const requestId = Number(parts[3]);
  if (!["payin", "payout"].includes(type) || !status || !requestId) return null;
  return { type, status, requestId };
}

function isAllowedTelegramChat(chatId) {
  const allowedIds = new Set(getAdminChatIds().map(String));
  return allowedIds.has(String(chatId));
}

// Use a configured admin ID for Telegram reviews, or fall back to the first admin user.
async function getTelegramAdminId() {
  const configuredId = Number(process.env.TELEGRAM_REVIEW_ADMIN_ID || 0);
  if (configuredId) return configuredId;

  const [[admin]] = await pool.query(
    "SELECT id FROM users WHERE role = 'admin' ORDER BY id ASC LIMIT 1"
  );
  return admin?.id || null;
}

// Review a pending pay-in from a Telegram button and save rejection_reason on rejection.
async function reviewPayin({ requestId, status, adminId }) {
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[request]] = await conn.query(
      `SELECT p.id, p.user_id, p.amount_ngn, p.coin_amount, p.status,
              u.full_name, u.username, u.email
       FROM manual_payin_requests p
       JOIN users u ON u.id = p.user_id
       WHERE p.id = ?
       LIMIT 1 FOR UPDATE`,
      [requestId]
    );

    if (!request) {
      await conn.rollback();
      return { ok: false, message: "Pay-in request not found" };
    }
    if (request.status !== "pending") {
      await conn.rollback();
      return { ok: false, message: `Pay-in request is already ${request.status}` };
    }

    if (status === "approved") {
      await conn.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
        request.coin_amount,
        request.user_id,
      ]);
    }

    await conn.query(
      `UPDATE manual_payin_requests
       SET status = ?, admin_id = ?, admin_note = ?, rejection_reason = ?, reviewed_at = NOW()
       WHERE id = ?`,
      [
        status,
        adminId,
        TELEGRAM_ADMIN_NOTE,
        status === "rejected" ? TELEGRAM_REJECTION_REASON : null,
        requestId,
      ]
    );

    await conn.commit();
    return {
      ok: true,
      message: `Pay-in ${status}`,
      notification:
        `<b>Manual Pay-in ${status === "approved" ? "Approved" : "Rejected"} from Telegram</b>\n\n` +
        `<b>Request ID:</b> <code>${request.id}</code>\n` +
        `<b>User:</b> ${displayUser(request)}\n` +
        `<b>Amount:</b> ${formatAmount(request.amount_ngn)}\n` +
        `<b>Credit:</b> ${Number(request.coin_amount).toLocaleString()} CP\n` +
        `<b>Admin ID:</b> ${adminId ? `<code>${adminId}</code>` : "Telegram"}\n` +
        `<b>Status:</b> ${escapeHtml(status)}`,
    };
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("telegram payin review error:", err);
    return { ok: false, message: "Error reviewing pay-in" };
  } finally {
    if (conn) conn.release();
  }
}

// Review a pending payout from a Telegram button and save rejection_reason on rejection.
async function reviewPayout({ requestId, status, adminId }) {
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[request]] = await conn.query(
      `SELECT p.id, p.user_id, p.cop_points, p.amount_ngn, p.status,
              p.account_name, p.account_number, p.bank_name,
              u.full_name, u.username, u.email
       FROM payout_requests p
       JOIN users u ON u.id = p.user_id
       WHERE p.id = ?
       LIMIT 1 FOR UPDATE`,
      [requestId]
    );

    if (!request) {
      await conn.rollback();
      return { ok: false, message: "Payout request not found" };
    }
    if (request.status !== "pending") {
      await conn.rollback();
      return { ok: false, message: `Payout request is already ${request.status}` };
    }

    if (status === "rejected") {
      await conn.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
        request.cop_points,
        request.user_id,
      ]);
    }

    await conn.query(
      `UPDATE payout_requests
       SET status = ?, admin_id = ?, admin_note = ?, rejection_reason = ?, reviewed_at = NOW()
       WHERE id = ?`,
      [
        status,
        adminId,
        TELEGRAM_ADMIN_NOTE,
        status === "rejected" ? TELEGRAM_REJECTION_REASON : null,
        requestId,
      ]
    );

    await conn.commit();
    return {
      ok: true,
      message: `Payout ${status}`,
      notification:
        `<b>Payout ${status === "approved" ? "Approved" : "Rejected"} from Telegram</b>\n\n` +
        `<b>Request ID:</b> <code>${request.id}</code>\n` +
        `<b>User:</b> ${displayUser(request)}\n` +
        `<b>Requested:</b> ${Number(request.cop_points).toLocaleString()} CP\n` +
        `<b>Amount:</b> ${formatAmount(request.amount_ngn)}\n` +
        `<b>Account:</b> ${escapeHtml(request.account_name)} / <code>${escapeHtml(request.account_number)}</code>\n` +
        `<b>Bank:</b> ${escapeHtml(request.bank_name || "N/A")}\n` +
        `<b>Admin ID:</b> ${adminId ? `<code>${adminId}</code>` : "Telegram"}\n` +
        `<b>Status:</b> ${escapeHtml(status)}`,
    };
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("telegram payout review error:", err);
    return { ok: false, message: "Error reviewing payout" };
  } finally {
    if (conn) conn.release();
  }
}

// Send quick feedback to the admin who clicked a Telegram inline button.
async function answerCallback(callbackQueryId, text, showAlert = false) {

  if (!callbackQueryId) return;
  await telegramPost("answerCallbackQuery", {
    callback_query_id: callbackQueryId,
    text,
    show_alert: showAlert,
  }).catch((err) => console.error("telegram callback answer error:", err.response?.data || err.message));
}

// Remove buttons after a successful review so the same request is not clicked twice.
async function removeInlineKeyboard(callbackQuery) {
  const message = callbackQuery?.message;
  if (!message?.chat?.id || !message?.message_id) return;
  await telegramPost("editMessageReplyMarkup", {
    chat_id: message.chat.id,
    message_id: message.message_id,
    reply_markup: { inline_keyboard: [] },
  }).catch((err) => console.error("telegram keyboard remove error:", err.response?.data || err.message));
}

function validateWebhookSecret(req) {
  const secret = process.env.TELEGRAM_WEBHOOK_SECRET;
  if (!secret) return true;
  return (
    req.get("x-telegram-bot-api-secret-token") === secret ||
    String(req.query.secret || "") === secret
  );
}

// Get Telegram webhook status
router.get("/webhook-info", async (req, res) => {
  if (!validateWebhookSecret(req)) {
    return res.status(403).json({ ok: false, message: "Invalid Telegram webhook secret" });
  }

  try {
    const data = await telegramPost("getWebhookInfo", {});
    return res.json({ ok: true, telegram: data });
  } catch (err) {
    console.error("telegram webhook info error:", err.response?.data || err.message);
    return res.status(500).json({
      ok: false,
      message: "Error fetching Telegram webhook info",
      error: err.response?.data || err.message,
    });
  }
});

// Register Telegram webhook
router.post("/set-webhook", async (req, res) => {
  if (!validateWebhookSecret(req)) {
    return res.status(403).json({ ok: false, message: "Invalid Telegram webhook secret" });
  }

  try {
    const webhookUrl =
      req.body?.url ||
      process.env.TELEGRAM_WEBHOOK_URL ||
      `${req.protocol}://${req.get("host")}/api/admin/telegram/webhook`;

    const payload = {
      url: webhookUrl,
      allowed_updates: ["callback_query"],
    };

    if (process.env.TELEGRAM_WEBHOOK_SECRET) {
      payload.secret_token = process.env.TELEGRAM_WEBHOOK_SECRET;
    }

    const data = await telegramPost("setWebhook", payload);
    return res.json({ ok: true, webhook_url: webhookUrl, telegram: data });
  } catch (err) {
    console.error("telegram set webhook error:", err.response?.data || err.message);
    return res.status(500).json({
      ok: false,
      message: "Error setting Telegram webhook",
      error: err.response?.data || err.message,
    });
  }
});

// Handle Telegram admin actions
router.post("/webhook", async (req, res) => {
  try {
    if (!validateWebhookSecret(req)) {
      console.warn("telegram webhook rejected: invalid secret");
      return res.status(403).json({ ok: false, message: "Invalid Telegram webhook secret" });
    }

    const callbackQuery = req.body?.callback_query;
    if (!callbackQuery) return res.json({ ok: true });

    const chatId = callbackQuery.message?.chat?.id;
    console.log("telegram callback received:", {
      data: callbackQuery.data,
      chat_id: chatId,
      from_id: callbackQuery.from?.id,
    });

    if (!isAllowedTelegramChat(chatId)) {
      await answerCallback(callbackQuery.id, "This Telegram chat is not allowed.", true);
      return res.json({ ok: true });
    }

    const action = parseCallbackData(callbackQuery.data);
    if (!action) {
      await answerCallback(callbackQuery.id, "Unknown action.", true);
      return res.json({ ok: true });
    }

    const adminId = await getTelegramAdminId();
    const result =
      action.type === "payin"
        ? await reviewPayin({ requestId: action.requestId, status: action.status, adminId })
        : await reviewPayout({ requestId: action.requestId, status: action.status, adminId });

    await answerCallback(callbackQuery.id, result.message, !result.ok);

    if (result.ok) {
      await removeInlineKeyboard(callbackQuery);
      notifyAdmins(result.notification).catch((err) =>
        console.error("telegram review notify error:", err.message)
      );
    }

    return res.json({ ok: true });
  } catch (err) {
    console.error("telegram webhook error:", err.response?.data || err.message);
    return res.json({ ok: false });
  }
});

module.exports = router;
