const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function toPositiveNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) && n > 0 ? n : null;
}

function toPositiveInteger(value) {
  const n = Number(value);
  return Number.isInteger(n) && n > 0 ? n : null;
}

function normalizeReviewStatus(value) {
  const status = String(value || "").trim().toLowerCase();
  return status === "approved" || status === "rejected" ? status : null;
}

async function getCoinRate(conn = pool) {
  const [[rate]] = await conn.query(
    "SELECT id, unit, price, currency FROM coin_rate WHERE id = 1 LIMIT 1"
  );
  return rate || null;
}

router.get("/settings", async (req, res) => {
  try {
    const [[paymentAccount]] = await pool.query(
      `SELECT id, account_name, account_number, account_type, bank_name,
              instructions, is_active, created_at, updated_at
       FROM payment_accounts
       WHERE is_active = 1
       ORDER BY id DESC
       LIMIT 1`
    );
    const rate = await getCoinRate();
    return res.json({ payment_account: paymentAccount || null, coin_rate: rate });
  } catch (err) {
    console.error("admin transaction settings error:", err);
    return res.status(500).json({ message: "Error fetching settings" });
  }
});

router.put("/payment-info", async (req, res) => {
  const accountName = String(req.body?.account_name || "").trim();
  const accountNumber = String(req.body?.account_number || "").trim();
  const accountType = String(req.body?.account_type || "").trim();
  const bankName = req.body?.bank_name ? String(req.body.bank_name).trim() : null;
  const instructions = req.body?.instructions || null;

  if (!accountName || !accountNumber || !accountType) {
    return res.status(400).json({ message: "Account name, number, and type are required" });
  }

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    await conn.query("UPDATE payment_accounts SET is_active = 0 WHERE is_active = 1");
    const [result] = await conn.query(
      `INSERT INTO payment_accounts
        (account_name, account_number, account_type, bank_name, instructions, is_active, created_by)
       VALUES (?, ?, ?, ?, ?, 1, ?)`,
      [accountName, accountNumber, accountType, bankName, instructions, req.user.userId]
    );

    await conn.commit();
    return res.json({
      message: "Payment info updated",
      payment_account: {
        id: result.insertId,
        account_name: accountName,
        account_number: accountNumber,
        account_type: accountType,
        bank_name: bankName,
        instructions,
        is_active: 1,
      },
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin payment info update error:", err);
    return res.status(500).json({ message: "Error updating payment info" });
  } finally {
    if (conn) conn.release();
  }
});

router.put("/coin-rate", async (req, res) => {
  const unit = toPositiveInteger(Number(req.body?.unit));
  const price = toPositiveNumber(req.body?.price);
  const currency = String(req.body?.currency || "NGN").trim().toUpperCase();

  if (!unit) return res.status(400).json({ message: "unit must be greater than 0" });
  if (!price) return res.status(400).json({ message: "price must be greater than 0" });

  try {
    await pool.query(
      `INSERT INTO coin_rate (id, unit, price, currency)
       VALUES (1, ?, ?, ?)
       ON DUPLICATE KEY UPDATE unit = VALUES(unit), price = VALUES(price), currency = VALUES(currency)`,
      [unit, price, currency]
    );

    return res.json({
      message: "Coin rate updated",
      coin_rate: { id: 1, unit, price, currency },
    });
  } catch (err) {
    console.error("admin coin rate update error:", err);
    return res.status(500).json({ message: "Error updating coin rate" });
  }
});

router.get("/payins", async (req, res) => {
  try {
    const status = req.query.status ? String(req.query.status).toLowerCase() : null;
    const params = [];
    let where = "";
    if (status) {
      where = "WHERE p.status = ?";
      params.push(status);
    }

    const [rows] = await pool.query(
      `SELECT p.id, p.user_id, u.username, u.email, p.amount_ngn, p.coin_amount,
              p.status, p.proof_reference, p.proof_url, p.user_note, p.admin_note,
              p.rejection_reason, p.reviewed_at, p.created_at
       FROM manual_payin_requests p
       JOIN users u ON u.id = p.user_id
       ${where}
       ORDER BY p.created_at DESC`,
      params
    );
    return res.json({ payins: rows });
  } catch (err) {
    console.error("admin payins list error:", err);
    return res.status(500).json({ message: "Error fetching pay-ins" });
  }
});

router.patch("/payins/:id/review", async (req, res) => {
  const requestId = Number(req.params.id);
  const status = normalizeReviewStatus(req.body?.status);
  const adminNote = req.body?.admin_note || null;
  const rejectionReason = req.body?.rejection_reason || req.body?.reason || null;

  if (!requestId) return res.status(400).json({ message: "Invalid pay-in request" });
  if (!status) return res.status(400).json({ message: "Status must be approved or rejected" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[request]] = await conn.query(
      `SELECT id, user_id, coin_amount, status
       FROM manual_payin_requests
       WHERE id = ?
       LIMIT 1 FOR UPDATE`,
      [requestId]
    );
    if (!request) {
      await conn.rollback();
      return res.status(404).json({ message: "Pay-in request not found" });
    }
    if (request.status !== "pending") {
      await conn.rollback();
      return res.status(400).json({ message: "Pay-in request already reviewed" });
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
        req.user.userId,
        adminNote,
        status === "rejected" ? rejectionReason : null,
        requestId,
      ]
    );

    await conn.commit();
    return res.json({
      message: status === "approved" ? "Pay-in approved" : "Pay-in rejected",
      credited_cop_point: status === "approved" ? request.coin_amount : 0,
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin payin review error:", err);
    return res.status(500).json({ message: "Error reviewing pay-in" });
  } finally {
    if (conn) conn.release();
  }
});

router.get("/payouts", async (req, res) => {
  try {
    const status = req.query.status ? String(req.query.status).toLowerCase() : null;
    const params = [];
    let where = "";
    if (status) {
      where = "WHERE p.status = ?";
      params.push(status);
    }

    const [rows] = await pool.query(
      `SELECT p.id, p.user_id, u.username, u.email, p.cop_points, p.amount_ngn,
              p.status, p.account_name, p.account_number, p.account_type, p.bank_name,
              p.user_note, p.admin_note, p.rejection_reason, p.reviewed_at, p.created_at
       FROM payout_requests p
       JOIN users u ON u.id = p.user_id
       ${where}
       ORDER BY p.created_at DESC`,
      params
    );
    return res.json({ payouts: rows });
  } catch (err) {
    console.error("admin payouts list error:", err);
    return res.status(500).json({ message: "Error fetching payouts" });
  }
});

router.patch("/payouts/:id/review", async (req, res) => {
  const requestId = Number(req.params.id);
  const status = normalizeReviewStatus(req.body?.status);
  const adminNote = req.body?.admin_note || null;
  const rejectionReason = req.body?.rejection_reason || req.body?.reason || null;

  if (!requestId) return res.status(400).json({ message: "Invalid payout request" });
  if (!status) return res.status(400).json({ message: "Status must be approved or rejected" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[request]] = await conn.query(
      `SELECT id, user_id, cop_points, status
       FROM payout_requests
       WHERE id = ?
       LIMIT 1 FOR UPDATE`,
      [requestId]
    );
    if (!request) {
      await conn.rollback();
      return res.status(404).json({ message: "Payout request not found" });
    }
    if (request.status !== "pending") {
      await conn.rollback();
      return res.status(400).json({ message: "Payout request already reviewed" });
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
        req.user.userId,
        adminNote,
        status === "rejected" ? rejectionReason : null,
        requestId,
      ]
    );

    await conn.commit();
    return res.json({
      message: status === "approved" ? "Payout approved" : "Payout rejected",
      refunded_cop_point: status === "rejected" ? request.cop_points : 0,
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin payout review error:", err);
    return res.status(500).json({ message: "Error reviewing payout" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
