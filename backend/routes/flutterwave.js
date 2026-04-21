const express = require("express");
const axios = require("axios");
const { authenticateToken } = require("../middleware/auth");

const router = express.Router();

const FLW_BASE_URL = process.env.FLW_BASE_URL || "https://api.flutterwave.com/v3";

function getFlutterwaveHeaders() {
  const secretKey = process.env.FLW_SECRET_KEY;
  if (!secretKey) {
    throw new Error("FLW_SECRET_KEY is not configured");
  }

  return {
    Authorization: `Bearer ${secretKey}`,
    "Content-Type": "application/json",
  };
}

function normalizeBank(bank) {
  const name = String(bank?.name || "").trim();
  const code = String(bank?.code || "").trim();
  return name && code ? { name, code } : null;
}

router.use(authenticateToken);

// api/flutterwave/banks
router.get("/banks", async (req, res) => {
  try {
    const response = await axios.get(`${FLW_BASE_URL}/banks/NG`, {
      headers: getFlutterwaveHeaders(),
    });

    const banks = Array.isArray(response.data?.data)
      ? response.data.data
          .map(normalizeBank)
          .filter(Boolean)
          .sort((a, b) => a.name.localeCompare(b.name))
      : [];

    return res.json({ banks });
  } catch (err) {
    console.error("flutterwave banks error:", err.response?.data || err.message);
    return res.status(500).json({ message: "Error fetching banks" });
  }
});

// api/flutterwave/resolve-account
router.post("/resolve-account", async (req, res) => {
  const accountBank = String(req.body?.account_bank || "").trim();
  const accountNumber = String(req.body?.account_number || "").trim();

  if (!accountBank) return res.status(400).json({ message: "account_bank is required" });
  if (!accountNumber) return res.status(400).json({ message: "account_number is required" });
  if (!/^\d+$/.test(accountNumber)) {
    return res.status(400).json({ message: "account_number must contain digits only" });
  }
  if (accountNumber.length !== 10) {
    return res.status(400).json({ message: "account_number must be 10 digits" });
  }

  try {
    const response = await axios.post(
      `${FLW_BASE_URL}/accounts/resolve`,
      {
        account_bank: accountBank,
        account_number: accountNumber,
      },
      { headers: getFlutterwaveHeaders() }
    );

    const data = response.data?.data;
    const accountName = String(data?.account_name || "").trim();
    if (!accountName) {
      return res.json({ verified: false, message: "Unable to verify account" });
    }

    return res.json({
      verified: true,
      account_name: accountName,
      account_number: accountNumber,
      bank_code: accountBank,
    });
  } catch (err) {
    console.error("flutterwave resolve account error:", err.response?.data || err.message);
    return res.json({ verified: false, message: "Unable to verify account" });
  }
});

module.exports = router;
