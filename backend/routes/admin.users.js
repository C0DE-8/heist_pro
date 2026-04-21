const express = require("express");
const bcrypt = require("bcryptjs");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

const USER_FIELDS = `
  id, email, username, full_name, role, is_verified, is_blocked,
  referral_code, wallet_address, game_id, cop_point,
  trade_pin_changed, created_at, updated_at
`;

function normalizeEmail(email) {
  return String(email || "").trim().toLowerCase();
}

function cleanString(value) {
  return String(value || "").trim();
}

function nullableString(value) {
  const next = cleanString(value);
  return next || null;
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function parseBoolean(value, field) {
  if (value === true || value === 1 || value === "1") return 1;
  if (value === false || value === 0 || value === "0") return 0;
  const err = new Error(`${field} must be true or false`);
  err.statusCode = 400;
  throw err;
}

function parseNonNegativeInteger(value, field) {
  const next = Number(value);
  if (!Number.isInteger(next) || next < 0) {
    const err = new Error(`${field} must be a non-negative whole number`);
    err.statusCode = 400;
    throw err;
  }
  return next;
}

async function getUserById(userId) {
  const [[user]] = await pool.query(
    `SELECT ${USER_FIELDS}
     FROM users
     WHERE id = ?
     LIMIT 1`,
    [userId]
  );

  return user || null;
}

async function ensureUnique(field, value, userId, label) {
  if (!value) return;

  const [[existing]] = await pool.query(
    `SELECT id FROM users WHERE ${field} = ? AND id <> ? LIMIT 1`,
    [value, userId]
  );

  if (existing) {
    const err = new Error(`${label} already exists`);
    err.statusCode = 400;
    throw err;
  }
}

router.get("/", async (req, res) => {
  try {
    const search = cleanString(req.query.search);
    const role = cleanString(req.query.role);
    const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
    const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 50, 1), 100);
    const offset = (page - 1) * limit;

    const where = [];
    const params = [];

    if (search) {
      where.push(
        "(email LIKE ? OR username LIKE ? OR full_name LIKE ? OR wallet_address LIKE ? OR game_id LIKE ?)"
      );
      const like = `%${search}%`;
      params.push(like, like, like, like, like);
    }

    if (role) {
      if (!["user", "admin"].includes(role)) {
        return res.status(400).json({ message: "Invalid role filter" });
      }
      where.push("role = ?");
      params.push(role);
    }

    const whereSql = where.length ? `WHERE ${where.join(" AND ")}` : "";

    const [[countRow]] = await pool.query(
      `SELECT COUNT(*) AS total FROM users ${whereSql}`,
      params
    );

    const [users] = await pool.query(
      `SELECT ${USER_FIELDS}
       FROM users
       ${whereSql}
       ORDER BY created_at DESC, id DESC
       LIMIT ? OFFSET ?`,
      [...params, limit, offset]
    );

    return res.json({
      users,
      pagination: {
        page,
        limit,
        total: Number(countRow?.total || 0),
        total_pages: Math.ceil(Number(countRow?.total || 0) / limit),
      },
    });
  } catch (err) {
    console.error("admin users list error:", err);
    return res.status(500).json({ message: "Error fetching users" });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const userId = parseInt(req.params.id, 10);
    if (!userId) return res.status(400).json({ message: "Invalid user ID" });

    const user = await getUserById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    const [[stats]] = await pool.query(
      `SELECT
         (SELECT COUNT(*) FROM heist_participants WHERE user_id = ?) AS joined_heists,
         (SELECT COUNT(*) FROM heist_submissions WHERE user_id = ?) AS heist_submissions,
         (SELECT COUNT(*) FROM heist WHERE winner_user_id = ?) AS won_heists,
         (SELECT COUNT(*) FROM manual_payin_requests WHERE user_id = ?) AS payins,
         (SELECT COUNT(*) FROM payout_requests WHERE user_id = ?) AS payout_requests`,
      [userId, userId, userId, userId, userId]
    );

    return res.json({ user, stats });
  } catch (err) {
    console.error("admin user detail error:", err);
    return res.status(500).json({ message: "Error fetching user" });
  }
});

router.patch("/:id", async (req, res) => {
  try {
    const adminId = req.user.userId;
    const userId = parseInt(req.params.id, 10);
    if (!userId) return res.status(400).json({ message: "Invalid user ID" });

    const current = await getUserById(userId);
    if (!current) return res.status(404).json({ message: "User not found" });

    const updates = [];
    const params = [];

    if (req.body?.email !== undefined) {
      const email = normalizeEmail(req.body.email);
      if (!isValidEmail(email)) return res.status(400).json({ message: "Invalid email address" });
      await ensureUnique("email", email, userId, "Email");
      updates.push("email = ?");
      params.push(email);
    }

    if (req.body?.username !== undefined) {
      const username = cleanString(req.body.username);
      if (!username) return res.status(400).json({ message: "Username is required" });
      await ensureUnique("username", username, userId, "Username");
      updates.push("username = ?");
      params.push(username);
    }

    if (req.body?.full_name !== undefined) {
      updates.push("full_name = ?");
      params.push(nullableString(req.body.full_name));
    }

    if (req.body?.role !== undefined) {
      const role = cleanString(req.body.role);
      if (!["user", "admin"].includes(role)) return res.status(400).json({ message: "Invalid role" });
      if (userId === adminId && role !== "admin") {
        return res.status(400).json({ message: "You cannot remove your own admin role" });
      }
      updates.push("role = ?");
      params.push(role);
    }

    if (req.body?.is_verified !== undefined) {
      const isVerified = parseBoolean(req.body.is_verified, "is_verified");
      updates.push("is_verified = ?");
      params.push(isVerified);
    }

    if (req.body?.is_blocked !== undefined) {
      const isBlocked = parseBoolean(req.body.is_blocked, "is_blocked");
      if (userId === adminId && isBlocked) {
        return res.status(400).json({ message: "You cannot block your own account" });
      }
      updates.push("is_blocked = ?");
      params.push(isBlocked);
    }

    if (req.body?.cop_point !== undefined) {
      updates.push("cop_point = ?");
      params.push(parseNonNegativeInteger(req.body.cop_point, "cop_point"));
    }

    if (req.body?.referral_code !== undefined) {
      const referralCode = nullableString(req.body.referral_code);
      await ensureUnique("referral_code", referralCode, userId, "Referral code");
      updates.push("referral_code = ?");
      params.push(referralCode);
    }

    if (req.body?.wallet_address !== undefined) {
      const walletAddress = nullableString(req.body.wallet_address);
      await ensureUnique("wallet_address", walletAddress, userId, "Wallet address");
      updates.push("wallet_address = ?");
      params.push(walletAddress);
    }

    if (req.body?.game_id !== undefined) {
      const gameId = nullableString(req.body.game_id);
      await ensureUnique("game_id", gameId, userId, "Game ID");
      updates.push("game_id = ?");
      params.push(gameId);
    }

    if (req.body?.new_password !== undefined) {
      const password = String(req.body.new_password || "");
      if (password.length < 8) {
        return res.status(400).json({ message: "New password must be at least 8 characters" });
      }
      const passwordHash = await bcrypt.hash(password, 12);
      updates.push("password_hash = ?");
      params.push(passwordHash);
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(userId);
    await pool.query(`UPDATE users SET ${updates.join(", ")} WHERE id = ?`, params);

    const user = await getUserById(userId);
    return res.json({ message: "User updated", user });
  } catch (err) {
    console.error("admin user update error:", err);
    return res.status(err.statusCode || 500).json({
      message: err.statusCode ? err.message : "Error updating user",
    });
  }
});

router.delete("/:id", async (req, res) => {
  try {
    const adminId = req.user.userId;
    const userId = parseInt(req.params.id, 10);
    if (!userId) return res.status(400).json({ message: "Invalid user ID" });
    if (userId === adminId) {
      return res.status(400).json({ message: "You cannot delete your own account" });
    }

    const [result] = await pool.query("DELETE FROM users WHERE id = ?", [userId]);
    if (!result.affectedRows) return res.status(404).json({ message: "User not found" });

    return res.json({ message: "User deleted" });
  } catch (err) {
    console.error("admin user delete error:", err);
    if (err.code === "ER_ROW_IS_REFERENCED_2" || err.errno === 1451) {
      return res.status(409).json({
        message: "User has related records and cannot be deleted safely",
      });
    }
    return res.status(500).json({ message: "Error deleting user" });
  }
});

module.exports = router;
