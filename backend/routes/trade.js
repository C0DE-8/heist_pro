const express = require("express");
const bcrypt = require("bcryptjs");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");

const router = express.Router();
const DEFAULT_TRADE_PIN = "0000";

router.use(authenticateToken);
router.use((req, res, next) => {
  if (req.user?.role !== "user") {
    return res.status(403).json({ message: "User access required" });
  }
  return next();
});

function cleanWalletAddress(value) {
  return String(value || "").trim();
}

function cleanNote(value) {
  const note = String(value || "").trim();
  return note ? note.slice(0, 255) : null;
}

function parseCopPoints(value) {
  const n = Number(value);
  return Number.isInteger(n) && n > 0 ? n : null;
}

function isValidPin(pin) {
  return /^\d{4}$/.test(String(pin || ""));
}

async function verifyTradePin(user, pin) {
  if (!isValidPin(pin)) return false;
  if (!user.trade_pin_hash) return String(pin) === DEFAULT_TRADE_PIN;
  return bcrypt.compare(String(pin), user.trade_pin_hash);
}

router.get("/pin-status", async (req, res) => {
  try {
    const [[user]] = await pool.query(
      `SELECT id, trade_pin_hash, trade_pin_changed
       FROM users
       WHERE id = ?
       LIMIT 1`,
      [req.user.userId]
    );
    if (!user) return res.status(404).json({ message: "User not found" });

    return res.json({
      has_pin: Boolean(user.trade_pin_hash),
      pin_changed: Boolean(user.trade_pin_changed),
      must_change_pin: !user.trade_pin_changed,
    });
  } catch (err) {
    console.error("trade pin status error:", err);
    return res.status(500).json({ message: "Error fetching trade PIN status" });
  }
});

router.patch("/pin", async (req, res) => {
  const currentPin = String(req.body?.current_pin || "");
  const newPin = String(req.body?.new_pin || "");

  if (!isValidPin(currentPin) || !isValidPin(newPin)) {
    return res.status(400).json({ message: "PIN must be exactly 4 numbers" });
  }
  if (newPin === DEFAULT_TRADE_PIN) {
    return res.status(400).json({ message: "Choose a PIN other than 0000" });
  }
  if (newPin === currentPin) {
    return res.status(400).json({ message: "New PIN must be different" });
  }

  try {
    const [[user]] = await pool.query(
      `SELECT id, trade_pin_hash, trade_pin_changed
       FROM users
       WHERE id = ?
       LIMIT 1`,
      [req.user.userId]
    );
    if (!user) return res.status(404).json({ message: "User not found" });

    const validCurrentPin = await verifyTradePin(user, currentPin);
    if (!validCurrentPin) return res.status(401).json({ message: "Invalid current PIN" });

    const pinHash = await bcrypt.hash(newPin, 12);
    await pool.query(
      "UPDATE users SET trade_pin_hash = ?, trade_pin_changed = 1 WHERE id = ?",
      [pinHash, req.user.userId]
    );

    return res.json({ message: "Trade PIN updated", pin_changed: true });
  } catch (err) {
    console.error("trade pin update error:", err);
    return res.status(500).json({ message: "Error updating trade PIN" });
  }
});

router.post("/send", async (req, res) => {
  const senderId = req.user.userId;
  const walletAddress = cleanWalletAddress(req.body?.wallet_address);
  const copPoints = parseCopPoints(req.body?.cop_points);
  const pin = String(req.body?.pin || "");
  const note = cleanNote(req.body?.note);

  if (!walletAddress) return res.status(400).json({ message: "wallet_address is required" });
  if (!copPoints) return res.status(400).json({ message: "cop_points must be greater than 0" });
  if (!isValidPin(pin)) return res.status(400).json({ message: "PIN must be exactly 4 numbers" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[recipientLookup]] = await conn.query(
      `SELECT id
       FROM users
       WHERE wallet_address = ? AND role = 'user'
       LIMIT 1`,
      [walletAddress]
    );
    if (!recipientLookup) {
      await conn.rollback();
      return res.status(404).json({ message: "Recipient wallet not found" });
    }
    if (Number(recipientLookup.id) === Number(senderId)) {
      await conn.rollback();
      return res.status(400).json({ message: "You cannot send cop_point to yourself" });
    }

    const firstId = Math.min(Number(senderId), Number(recipientLookup.id));
    const secondId = Math.max(Number(senderId), Number(recipientLookup.id));
    const [lockedUsers] = await conn.query(
      `SELECT id, username, wallet_address, cop_point, trade_pin_hash, trade_pin_changed
       FROM users
       WHERE id IN (?, ?)
       ORDER BY id ASC
       FOR UPDATE`,
      [firstId, secondId]
    );

    const sender = lockedUsers.find((user) => Number(user.id) === Number(senderId));
    const recipient = lockedUsers.find((user) => Number(user.id) === Number(recipientLookup.id));
    if (!sender || !recipient) {
      await conn.rollback();
      return res.status(404).json({ message: "User not found" });
    }
    if (!sender.trade_pin_changed) {
      await conn.rollback();
      return res.status(403).json({ message: "Change your default trade PIN before sending" });
    }

    const validPin = await verifyTradePin(sender, pin);
    if (!validPin) {
      await conn.rollback();
      return res.status(401).json({ message: "Invalid trade PIN" });
    }
    if (Number(sender.cop_point) < copPoints) {
      await conn.rollback();
      return res.status(400).json({ message: "Insufficient cop_point" });
    }

    const senderBalanceBefore = Number(sender.cop_point);
    const recipientBalanceBefore = Number(recipient.cop_point);
    const senderBalanceAfter = senderBalanceBefore - copPoints;
    const recipientBalanceAfter = recipientBalanceBefore + copPoints;

    await conn.query("UPDATE users SET cop_point = ? WHERE id = ?", [
      senderBalanceAfter,
      senderId,
    ]);
    await conn.query("UPDATE users SET cop_point = ? WHERE id = ?", [
      recipientBalanceAfter,
      recipient.id,
    ]);

    const [result] = await conn.query(
      `INSERT INTO cop_point_transfers
        (sender_user_id, recipient_user_id, recipient_wallet_address, cop_points,
         sender_balance_before, sender_balance_after,
         recipient_balance_before, recipient_balance_after, note)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        senderId,
        recipient.id,
        recipient.wallet_address,
        copPoints,
        senderBalanceBefore,
        senderBalanceAfter,
        recipientBalanceBefore,
        recipientBalanceAfter,
        note,
      ]
    );

    await conn.commit();
    return res.status(201).json({
      message: "cop_point sent",
      transfer: {
        id: result.insertId,
        recipient_user_id: recipient.id,
        recipient_username: recipient.username,
        recipient_wallet_address: recipient.wallet_address,
        cop_points: copPoints,
        sender_balance_after: senderBalanceAfter,
      },
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("trade send error:", err);
    return res.status(500).json({ message: "Error sending cop_point" });
  } finally {
    if (conn) conn.release();
  }
});

router.get("/transfers", async (req, res) => {
  try {
    const page = Math.max(1, Number.parseInt(req.query.page, 10) || 1);
    const limit = Math.max(1, Math.min(50, Number.parseInt(req.query.limit, 10) || 20));
    const offset = (page - 1) * limit;

    const [[countRow]] = await pool.query(
      `SELECT COUNT(*) AS total
       FROM cop_point_transfers
       WHERE sender_user_id = ? OR recipient_user_id = ?`,
      [req.user.userId, req.user.userId]
    );
    const total = Number(countRow?.total || 0);

    const [rows] = await pool.query(
      `SELECT
         t.id, t.sender_user_id, sender.username AS sender_username,
         t.recipient_user_id, recipient.username AS recipient_username,
         t.recipient_wallet_address, t.cop_points, t.note, t.created_at
       FROM cop_point_transfers t
       JOIN users sender ON sender.id = t.sender_user_id
       JOIN users recipient ON recipient.id = t.recipient_user_id
       WHERE t.sender_user_id = ? OR t.recipient_user_id = ?
       ORDER BY t.created_at DESC, t.id DESC
       LIMIT ? OFFSET ?`,
      [req.user.userId, req.user.userId, limit, offset]
    );

    return res.json({
      transfers: rows.map((row) => ({
        ...row,
        direction: Number(row.sender_user_id) === Number(req.user.userId) ? "sent" : "received",
      })),
      pagination: {
        page,
        limit,
        total,
        total_pages: Math.max(1, Math.ceil(total / limit)),
        has_next: page * limit < total,
        has_prev: page > 1,
      },
    });
  } catch (err) {
    console.error("trade transfers error:", err);
    return res.status(500).json({ message: "Error fetching transfers" });
  }
});

module.exports = router;
