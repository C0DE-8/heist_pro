// routes/auth.js  (CommonJS)
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { pool } = require("../conf/db");
const {
  sendRegistrationOtpEmail,
  sendPasswordResetOtpEmail,
} = require("../lib/mail");
const {
  cleanUserAgent,
  countAccountsForDevice,
  ensureGodEyesSchema,
  getClientIp,
  getDeviceKey,
  recordActivity,
} = require("../services/godEyes.service");
const {
  ensureLevelProgressTables,
  awardConfiguredXp,
} = require("../services/levelProgress.service");

const router = express.Router();

/* ------------------------------ helpers ------------------------------ */
function generateReferralCode() {
  const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  return Array.from({ length: 8 }, () =>
    alphabet[Math.floor(Math.random() * alphabet.length)]
  ).join("");
}

function validateUsername(username) {
  const normalizedUsername = String(username || "").trim();
  const reservedUsernames = new Set(["cop", "copup", "copupbid", "admin"]);
  const loweredUsername = normalizedUsername.toLowerCase();

  if (!normalizedUsername) {
    return "Username is required";
  }

  if (normalizedUsername.length < 2) {
    return "Username must be at least 2 characters";
  }

  if (reservedUsernames.has(loweredUsername)) {
    return "That username is not allowed";
  }

  return null;
}

function generateWalletAddress() {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let walletAddress = "cop";
  for (let i = 0; i < 20; i++) {
    walletAddress += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return walletAddress;
}
function generateGameId() {
  const base = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const pick = (n) =>
    Array.from({ length: n }, () => base[Math.floor(Math.random() * base.length)]).join("");
  return `${pick(4)}-${pick(4)}-${pick(4)}`;
}

async function generateUniqueReferralCode(conn) {
  for (let attempt = 0; attempt < 10; attempt += 1) {
    const code = generateReferralCode();
    const [[existing]] = await conn.query(
      "SELECT id FROM users WHERE referral_code = ? LIMIT 1",
      [code]
    );
    if (!existing) return code;
  }

  throw new Error("Unable to generate a unique referral code");
}

async function ensureAffiliateRole(conn = pool) {
  await conn.query(
    "ALTER TABLE users MODIFY role enum('user','affiliate','admin') NOT NULL DEFAULT 'user'"
  );
}

/* ------------------------------- SEND OTP ------------------------------- */
// POST /api/auth/send-otp
router.post("/send-otp", async (req, res) => {
  try {
    const { email, name } = req.body || {};
    if (!email) return res.status(400).json({ message: "Email is required" });

    const normalizedEmail = String(email).trim().toLowerCase();

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(normalizedEmail)) {
      return res.status(400).json({ message: "Invalid email address" });
    }

    const [exists] = await pool.query(
      "SELECT id FROM users WHERE email = ? LIMIT 1",
      [normalizedEmail]
    );
    if (exists.length) {
      return res.status(400).json({ message: "Email already registered" });
    }

    const otp = Math.floor(100000 + Math.random() * 900000);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

    await pool.query(
      `INSERT INTO otps (email, otp, expires_at)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE otp = VALUES(otp), expires_at = VALUES(expires_at)`,
      [normalizedEmail, otp, expiresAt]
    );

    await sendRegistrationOtpEmail(
      normalizedEmail,
      otp,
      name || "New CopUp User"
    );

    res.json({ message: "OTP sent to your email" });
  } catch (err) {
    console.error("send-otp error:", err);
    res.status(500).json({ message: "Error sending OTP" });
  }
});

/* -------------------------------- REGISTER ------------------------------- */
// POST /api/auth/register
router.post("/register", async (req, res) => {
  let conn;
  try {
    const {
      username,
      email,
      full_name,
      password,
      otp,
      referralCode,
      referral_code,
      ref,
      account_type,
      role,
    } = req.body || {};

    const normalizedUsername = String(username || "").trim();
    const normalizedEmail = String(email || "").trim().toLowerCase();
    const normalizedFullName = String(full_name || "").trim() || null;
    const normalizedOtp = String(otp || "").trim();
    const normalizedReferralCode =
      String(referralCode || referral_code || ref || "").trim() || null;
    const requestedRole =
      String(account_type || role || "").trim().toLowerCase() === "affiliate"
        ? "affiliate"
        : "user";
    const usernameError = validateUsername(normalizedUsername);
    const registrationIp = getClientIp(req);
    const registrationDeviceKey = getDeviceKey(req);

    if (!normalizedEmail || !password || !normalizedOtp) {
      return res.status(400).json({ message: "username, email, password, otp are required" });
    }
    if (usernameError) {
      return res.status(400).json({ message: usernameError });
    }

    conn = await pool.getConnection();
    await ensureGodEyesSchema(conn);
    if (requestedRole === "affiliate") {
      await ensureAffiliateRole(conn);
    }
    if (registrationDeviceKey) {
      const deviceAccounts = await countAccountsForDevice(registrationDeviceKey, conn);
      if (deviceAccounts >= 3) {
        return res.status(429).json({
          message: "This device has reached the 3 account limit.",
        });
      }
    }
    await conn.beginTransaction();
    const rollbackAndRespond = async (status, message) => {
      await conn.rollback();
      return res.status(status).json({ message });
    };

    const [[dupEmail]] = await conn.query("SELECT COUNT(*) AS c FROM users WHERE email = ?", [
      normalizedEmail,
    ]);
    if (dupEmail.c) {
      return rollbackAndRespond(400, "Email already exists");
    }

    const [[dupUser]] = await conn.query("SELECT COUNT(*) AS c FROM users WHERE username = ?", [
      normalizedUsername,
    ]);
    if (dupUser.c) {
      return rollbackAndRespond(400, "Username already exists");
    }

    if (normalizedFullName) {
      const [[dupFull]] = await conn.query("SELECT COUNT(*) AS c FROM users WHERE full_name = ?", [
        normalizedFullName,
      ]);
      if (dupFull.c) {
        return rollbackAndRespond(400, "Full name already exists");
      }
    }

    // OTP check + expiry
    const [otpRows] = await conn.query(
      "SELECT email, otp, expires_at FROM otps WHERE email = ? AND otp = ? LIMIT 1",
      [normalizedEmail, normalizedOtp]
    );
    if (!otpRows.length) {
      return rollbackAndRespond(400, "Invalid OTP");
    }
    if (new Date(otpRows[0].expires_at).getTime() < Date.now()) {
      return rollbackAndRespond(400, "OTP has expired");
    }

    const password_hash = await bcrypt.hash(password, 12);
    const userReferralCode = await generateUniqueReferralCode(conn);
    const walletAddress = generateWalletAddress();
    const gameId = generateGameId();
    let referrerId = null;

    if (normalizedReferralCode) {
      const [[referrer]] = await conn.query(
        "SELECT id FROM users WHERE referral_code = ? LIMIT 1",
        [normalizedReferralCode]
      );
      referrerId = referrer?.id || null;
    }

    const [result] = await conn.query(
      `INSERT INTO users
        (email, username, full_name, password_hash, role, is_verified, is_blocked,
         referral_code, wallet_address, game_id, registration_ip, registration_device_key, last_seen_at)
       VALUES
        (?, ?, ?, ?, ?, 1, 0, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)`,
      [
        normalizedEmail,
        normalizedUsername,
        normalizedFullName,
        password_hash,
        requestedRole,
        userReferralCode,
        walletAddress,
        gameId,
        registrationIp,
        registrationDeviceKey,
      ]
    );

    const newUserId = result.insertId;

    if (referrerId && Number(referrerId) !== Number(newUserId)) {
      await conn.query(
        `INSERT INTO referrals (referrer_id, referred_id)
         VALUES (?, ?)
         ON DUPLICATE KEY UPDATE referrer_id = referrer_id`,
        [
          referrerId,
          newUserId,
        ]
      );
    }

    await conn.query("DELETE FROM otps WHERE email = ?", [normalizedEmail]);
    await conn.commit();
    await recordActivity({
      userId: newUserId,
      eventType: "register",
      path: "/register",
      method: "POST",
      ipAddress: registrationIp,
      userAgent: cleanUserAgent(req),
      deviceKey: registrationDeviceKey,
      metadata: {
        account_type: requestedRole,
        referral_code: normalizedReferralCode,
      },
    });
    res.status(201).json({ message: "User registered successfully" });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("register error:", err);
    res.status(500).json({ message: "Error registering user" });
  } finally {
    if (conn) conn.release();
  }
});

/* ---------------------------------- LOGIN --------------------------------- */
// POST /api/auth/login  (identifier = email OR username)
router.post("/login", async (req, res) => {
  try {
    const { identifier, password } = req.body || {};
    if (!identifier || !password) {
      return res.status(400).json({ message: "identifier and password are required" });
    }

    const [rows] = await pool.query(
      `SELECT id, email, username, password_hash, role, is_verified, is_blocked
       FROM users
       WHERE email = ? OR username = ?
       LIMIT 1`,
      [identifier, identifier]
    );
    const user = rows[0];
    const ipAddress = getClientIp(req);
    const deviceKey = getDeviceKey(req);
    const userAgent = cleanUserAgent(req);

    if (!user || !user.is_verified) {
      await recordActivity({
        userId: user?.id || null,
        eventType: "login_failed",
        path: "/login",
        method: "POST",
        ipAddress,
        userAgent,
        deviceKey,
        metadata: { identifier: String(identifier || "").trim(), reason: "not_found_or_unverified" },
      });
      return res.status(401).json({ message: "Invalid credentials or account not verified" });
    }
    if (user.is_blocked) {
      await recordActivity({
        userId: user.id,
        eventType: "login_failed",
        path: "/login",
        method: "POST",
        ipAddress,
        userAgent,
        deviceKey,
        metadata: { reason: "blocked" },
      });
      return res.status(403).json({ message: "Account is blocked" });
    }

    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) {
      await recordActivity({
        userId: user.id,
        eventType: "login_failed",
        path: "/login",
        method: "POST",
        ipAddress,
        userAgent,
        deviceKey,
        metadata: { reason: "bad_password" },
      });
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const token = jwt.sign(
      { userId: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES || "7d" }
    );

    await ensureGodEyesSchema();
    await ensureLevelProgressTables(pool);
    await pool.query(
      "UPDATE users SET last_login_at = CURRENT_TIMESTAMP, last_seen_at = CURRENT_TIMESTAMP WHERE id = ?",
      [user.id]
    );
    const loginDay = new Date().toISOString().slice(0, 10);
    await awardConfiguredXp(pool, {
      userId: user.id,
      source: "daily_login",
      sourceId: loginDay,
      metadata: { path: "/login" },
    });
    await recordActivity({
      userId: user.id,
      eventType: "login",
      path: "/login",
      method: "POST",
      ipAddress,
      userAgent,
      deviceKey,
    });

    res.json({
      token,
      user: { id: user.id, username: user.username, email: user.email, role: user.role },
    });
  } catch (err) {
    console.error("login error:", err);
    res.status(500).json({ message: "Error logging in" });
  }
});

/* ------------------------- FORGOT / RESET PASSWORD ------------------------ */
// POST /api/auth/forget-password
router.post("/forget-password", async (req, res) => {
  try {
    const { email } = req.body || {};
    if (!email) return res.status(400).json({ message: "Email is required" });

    const [rows] = await pool.query("SELECT id FROM users WHERE email = ? LIMIT 1", [email]);
    if (!rows.length) return res.status(404).json({ message: "Email not found" });

    const otp = Math.floor(100000 + Math.random() * 900000);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

    await pool.query(
      `INSERT INTO otps (email, otp, expires_at)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE otp = VALUES(otp), expires_at = VALUES(expires_at)`,
      [email, otp, expiresAt]
    );

    await sendPasswordResetOtpEmail(email, otp);
    res.json({ message: "OTP sent to your email" });
  } catch (err) {
    console.error("forget-password error:", err);
    res.status(500).json({ message: "Error sending OTP" });
  }
});

// POST /api/auth/reset-password
router.post("/reset-password", async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body || {};
    if (!email || !otp || !newPassword) {
      return res.status(400).json({ message: "email, otp, newPassword are required" });
    }

    const [otpRows] = await pool.query(
      "SELECT otp, expires_at FROM otps WHERE email = ? AND otp = ? LIMIT 1",
      [email, otp]
    );
    if (!otpRows.length) return res.status(400).json({ message: "Invalid OTP" });
    if (new Date(otpRows[0].expires_at).getTime() < Date.now()) {
      return res.status(400).json({ message: "OTP has expired" });
    }

    const password_hash = await bcrypt.hash(newPassword, 12);
    await pool.query("UPDATE users SET password_hash = ? WHERE email = ?", [password_hash, email]);

    await pool.query("DELETE FROM otps WHERE email = ?", [email]);

    res.json({ message: "Password reset successfully" });
  } catch (err) {
    console.error("reset-password error:", err);
    res.status(500).json({ message: "Error resetting password" });
  }
});

module.exports = router;
