const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");
const { upload } = require("../middleware/upload");

const router = express.Router();
const PAYOUT_FEE_RATE = 0.1;

function toPositiveNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) && n > 0 ? n : null;
}

function toPositiveInteger(value) {
  const n = Number(value);
  return Number.isInteger(n) && n > 0 ? n : null;
}

async function getCoinRate(conn = pool) {
  const [[rate]] = await conn.query(
    "SELECT id, unit, price, currency FROM coin_rate WHERE id = 1 LIMIT 1"
  );
  if (!rate || Number(rate.unit) <= 0 || Number(rate.price) <= 0) return null;
  return rate;
}

function coinsFromAmount(amountNgn, rate) {
  const coins = Math.floor((Number(amountNgn) / Number(rate.price)) * Number(rate.unit));
  return Number.isFinite(coins) && coins > 0 ? coins : 0;
}

function amountFromPayinCoins(copPoints, rate) {
  const amount = (Number(copPoints) / Number(rate.unit)) * Number(rate.price);
  return Number.isFinite(amount) && amount > 0 ? Number(amount.toFixed(2)) : 0;
}

function amountFromCoins(copPoints, rate) {
  const grossAmount = (Number(copPoints) / Number(rate.unit)) * Number(rate.price);
  const netAmount = grossAmount * (1 - PAYOUT_FEE_RATE);
  return Number.isFinite(netAmount) && netAmount > 0 ? Number(netAmount.toFixed(2)) : 0;
}

function getPagination(query) {
  const page = Math.max(1, Number.parseInt(query.page, 10) || 1);
  const limitRaw = Number.parseInt(query.limit, 10) || 10;
  const limit = Math.max(1, Math.min(50, limitRaw));
  const offset = (page - 1) * limit;
  return { page, limit, offset };
}

function makePagination({ page, limit, total }) {
  return {
    page,
    limit,
    total,
    total_pages: Math.max(1, Math.ceil(total / limit)),
    has_next: page * limit < total,
    has_prev: page > 1,
  };
}

function uploadReceipt(req, res, next) {
  upload.single("receipt")(req, res, (err) => {
    if (err) {
      return res.status(400).json({ message: err.message || "Receipt upload failed" });
    }
    return next();
  });
}

router.get("/payment-info", async (req, res) => {
  try {
    const [[paymentAccount]] = await pool.query(
      `SELECT id, account_name, account_number, account_type, bank_name, instructions
       FROM payment_accounts
       WHERE is_active = 1
       ORDER BY id DESC
       LIMIT 1`
    );
    const rate = await getCoinRate();

    return res.json({
      payment_account: paymentAccount || null,
      coin_rate: rate
        ? {
            unit: rate.unit,
            price: rate.price,
            currency: rate.currency,
          }
        : null,
    });
  } catch (err) {
    console.error("payment info error:", err);
    return res.status(500).json({ message: "Error fetching payment info" });
  }
});

router.use(authenticateToken);

router.post("/payins", uploadReceipt, async (req, res) => {
  const userId = req.user.userId;
  const requestedCoins = toPositiveInteger(Number(req.body?.coin_amount));
  const requestedAmountNgn = toPositiveNumber(req.body?.amount_ngn);
  const proofReference = req.body?.proof_reference || null;
  const proofUrl = req.file ? `/uploads/${req.file.filename}` : req.body?.proof_url || null;
  const userNote = req.body?.note || req.body?.user_note || null;

  if (!requestedCoins && !requestedAmountNgn) {
    return res.status(400).json({ message: "coin_amount is required" });
  }
  if (!proofUrl) {
    return res.status(400).json({ message: "Payment receipt is required" });
  }

  try {
    const rate = await getCoinRate();
    if (!rate) return res.status(400).json({ message: "Coin rate is not configured" });

    const coinAmount = requestedCoins || coinsFromAmount(requestedAmountNgn, rate);
    const amountNgn = requestedCoins
      ? amountFromPayinCoins(requestedCoins, rate)
      : requestedAmountNgn;
    if (!coinAmount) {
      return res.status(400).json({ message: "Coin amount is too low" });
    }
    if (!amountNgn) {
      return res.status(400).json({ message: "Unable to calculate payment amount" });
    }

    const [result] = await pool.query(
      `INSERT INTO manual_payin_requests
        (user_id, amount_ngn, coin_rate_unit, coin_rate_price, coin_amount,
         proof_reference, proof_url, user_note, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending')`,
      [
        userId,
        amountNgn,
        rate.unit,
        rate.price,
        coinAmount,
        proofReference,
        proofUrl,
        userNote,
      ]
    );

    return res.status(201).json({
      message: "Pay-in request submitted",
      request: {
        id: result.insertId,
        amount_ngn: amountNgn,
        coin_amount: coinAmount,
        status: "pending",
      },
    });
  } catch (err) {
    console.error("create payin error:", err);
    return res.status(500).json({ message: "Error submitting pay-in request" });
  }
});

router.get("/payins", async (req, res) => {
  try {
    const pagination = getPagination(req.query);
    const [[countRow]] = await pool.query(
      `SELECT COUNT(*) AS total
       FROM manual_payin_requests
       WHERE user_id = ?`,
      [req.user.userId]
    );
    const total = Number(countRow?.total || 0);
    const [rows] = await pool.query(
      `SELECT id, amount_ngn, coin_amount, status, proof_reference, proof_url,
              user_note, admin_note, rejection_reason, reviewed_at, created_at
       FROM manual_payin_requests
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT ? OFFSET ?`,
      [req.user.userId, pagination.limit, pagination.offset]
    );
    return res.json({
      payins: rows,
      pagination: makePagination({ ...pagination, total }),
    });
  } catch (err) {
    console.error("user payins error:", err);
    return res.status(500).json({ message: "Error fetching pay-ins" });
  }
});

router.post("/payouts", async (req, res) => {
  const userId = req.user.userId;
  const copPoints = toPositiveInteger(Number(req.body?.cop_points));
  const accountName = String(req.body?.account_name || "").trim();
  const accountNumber = String(req.body?.account_number || "").trim();
  const accountType = String(req.body?.account_type || "").trim();
  const bankName = req.body?.bank_name ? String(req.body.bank_name).trim() : null;
  const userNote = req.body?.note || req.body?.user_note || null;

  if (!copPoints) return res.status(400).json({ message: "cop_points must be greater than 0" });
  if (!accountName || !accountNumber || !accountType) {
    return res.status(400).json({ message: "Payout account details are required" });
  }

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const rate = await getCoinRate(conn);
    if (!rate) {
      await conn.rollback();
      return res.status(400).json({ message: "Coin rate is not configured" });
    }

    const [[user]] = await conn.query(
      "SELECT id, cop_point FROM users WHERE id = ? LIMIT 1 FOR UPDATE",
      [userId]
    );
    if (!user) {
      await conn.rollback();
      return res.status(404).json({ message: "User not found" });
    }
    if (Number(user.cop_point) < copPoints) {
      await conn.rollback();
      return res.status(400).json({ message: "Insufficient cop_point" });
    }

    const amountNgn = amountFromCoins(copPoints, rate);

    await conn.query("UPDATE users SET cop_point = cop_point - ? WHERE id = ?", [
      copPoints,
      userId,
    ]);

    const [result] = await conn.query(
      `INSERT INTO payout_requests
        (user_id, cop_points, amount_ngn, coin_rate_unit, coin_rate_price,
         account_name, account_number, account_type, bank_name, user_note, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')`,
      [
        userId,
        copPoints,
        amountNgn,
        rate.unit,
        rate.price,
        accountName,
        accountNumber,
        accountType,
        bankName,
        userNote,
      ]
    );

    await conn.commit();
    return res.status(201).json({
      message: "Payout request submitted",
      request: {
        id: result.insertId,
        cop_points: copPoints,
        amount_ngn: amountNgn,
        status: "pending",
      },
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("create payout error:", err);
    return res.status(500).json({ message: "Error submitting payout request" });
  } finally {
    if (conn) conn.release();
  }
});

router.get("/payouts", async (req, res) => {
  try {
    const pagination = getPagination(req.query);
    const [[countRow]] = await pool.query(
      `SELECT COUNT(*) AS total
       FROM payout_requests
       WHERE user_id = ?`,
      [req.user.userId]
    );
    const total = Number(countRow?.total || 0);
    const [rows] = await pool.query(
      `SELECT id, cop_points, amount_ngn, status, account_name, account_number,
              account_type, bank_name, user_note, admin_note, rejection_reason,
              reviewed_at, created_at
       FROM payout_requests
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT ? OFFSET ?`,
      [req.user.userId, pagination.limit, pagination.offset]
    );
    return res.json({
      payouts: rows,
      pagination: makePagination({ ...pagination, total }),
    });
  } catch (err) {
    console.error("user payouts error:", err);
    return res.status(500).json({ message: "Error fetching payouts" });
  }
});

router.get("/mine", async (req, res) => {
  try {
    const [payins] = await pool.query(
      `SELECT id, amount_ngn, coin_amount, status, rejection_reason, reviewed_at, created_at
       FROM manual_payin_requests
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT 20`,
      [req.user.userId]
    );
    const [payouts] = await pool.query(
      `SELECT id, cop_points, amount_ngn, status, rejection_reason, reviewed_at, created_at
       FROM payout_requests
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT 20`,
      [req.user.userId]
    );

    return res.json({ payins, payouts });
  } catch (err) {
    console.error("user transactions error:", err);
    return res.status(500).json({ message: "Error fetching transactions" });
  }
});

module.exports = router;
