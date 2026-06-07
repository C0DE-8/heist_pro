const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const { ensureGodEyesSchema } = require("../services/godEyes.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function clean(value) {
  return String(value || "").trim();
}

function parseLimit(value, fallback = 50, max = 100) {
  const next = parseInt(value, 10);
  if (!Number.isFinite(next)) return fallback;
  return Math.min(Math.max(next, 1), max);
}

function parseId(value) {
  const next = parseInt(value, 10);
  return Number.isInteger(next) && next > 0 ? next : null;
}

const USER_SELECT = `
  u.id,
  u.email,
  u.username,
  u.full_name,
  u.role,
  u.is_verified,
  u.is_blocked,
  u.cop_point,
  u.referral_code,
  u.wallet_address,
  u.game_id,
  u.registration_ip,
  u.registration_device_key,
  u.last_login_at,
  u.last_seen_at,
  u.created_at,
  u.updated_at
`;

router.get("/", async (req, res) => {
  try {
    await ensureGodEyesSchema();

    const search = clean(req.query.search);
    const status = clean(req.query.status);
    const risk = clean(req.query.risk);
    const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
    const limit = parseLimit(req.query.limit);
    const offset = (page - 1) * limit;

    const where = [];
    const params = [];

    if (search) {
      where.push(
        `(u.email LIKE ? OR u.username LIKE ? OR u.full_name LIKE ? OR u.wallet_address LIKE ?
          OR u.game_id LIKE ? OR u.registration_ip LIKE ? OR u.registration_device_key LIKE ?)`
      );
      const like = `%${search}%`;
      params.push(like, like, like, like, like, like, like);
    }

    if (status === "blocked") where.push("u.is_blocked = 1");
    if (status === "active") where.push("u.is_blocked = 0");
    if (status === "admin") {
      where.push("u.role = ?");
      params.push("admin");
    }

    const riskJoin = `
      LEFT JOIN (
        SELECT registration_device_key, COUNT(*) AS device_accounts
        FROM users
        WHERE registration_device_key IS NOT NULL AND registration_device_key <> ''
        GROUP BY registration_device_key
      ) dupe_device ON dupe_device.registration_device_key = u.registration_device_key
      LEFT JOIN (
        SELECT registration_ip, COUNT(*) AS ip_accounts
        FROM users
        WHERE registration_ip IS NOT NULL AND registration_ip <> ''
        GROUP BY registration_ip
      ) dupe_ip ON dupe_ip.registration_ip = u.registration_ip
    `;

    if (risk === "device") where.push("COALESCE(dupe_device.device_accounts, 0) >= 3");
    if (risk === "ip") where.push("COALESCE(dupe_ip.ip_accounts, 0) >= 3");

    const whereSql = where.length ? `WHERE ${where.join(" AND ")}` : "";

    const [[countRow]] = await pool.query(
      `SELECT COUNT(*) AS total FROM users u ${riskJoin} ${whereSql}`,
      params
    );

    const [users] = await pool.query(
      `SELECT
         ${USER_SELECT},
         COALESCE(activity.login_count, 0) AS login_count,
         COALESCE(activity.visit_count, 0) AS visit_count,
         COALESCE(activity.failed_login_count, 0) AS failed_login_count,
         activity.last_activity_at,
         COALESCE(activity.distinct_ips, 0) AS distinct_ips,
         COALESCE(activity.distinct_devices, 0) AS distinct_devices,
         COALESCE(dupe_device.device_accounts, 0) AS same_device_accounts,
         COALESCE(dupe_ip.ip_accounts, 0) AS same_ip_accounts
       FROM users u
       ${riskJoin}
       LEFT JOIN (
         SELECT
           user_id,
           SUM(event_type = 'login') AS login_count,
           SUM(event_type = 'visit') AS visit_count,
           SUM(event_type = 'login_failed') AS failed_login_count,
           MAX(created_at) AS last_activity_at,
           COUNT(DISTINCT NULLIF(ip_address, '')) AS distinct_ips,
           COUNT(DISTINCT NULLIF(device_key, '')) AS distinct_devices
         FROM user_activity_events
         WHERE user_id IS NOT NULL
         GROUP BY user_id
       ) activity ON activity.user_id = u.id
       ${whereSql}
       ORDER BY COALESCE(u.last_seen_at, u.last_login_at, activity.last_activity_at, u.created_at) DESC, u.id DESC
       LIMIT ? OFFSET ?`,
      [...params, limit, offset]
    );

    const [[totals]] = await pool.query(
      `SELECT
         COUNT(*) AS total_users,
         SUM(is_blocked = 1) AS blocked_users,
         SUM(role = 'admin') AS admin_users,
         SUM(registration_device_key IS NOT NULL AND registration_device_key <> '') AS users_with_device,
         SUM(registration_ip IS NOT NULL AND registration_ip <> '') AS users_with_ip
       FROM users`
    );

    return res.json({
      users,
      totals,
      pagination: {
        page,
        limit,
        total: Number(countRow?.total || 0),
        total_pages: Math.ceil(Number(countRow?.total || 0) / limit),
      },
    });
  } catch (err) {
    console.error("admin god eyes list error:", err);
    return res.status(500).json({ message: "Error loading God Eyes data" });
  }
});

router.get("/:id", async (req, res) => {
  try {
    await ensureGodEyesSchema();
    const userId = parseId(req.params.id);
    if (!userId) return res.status(400).json({ message: "Invalid user ID" });

    const [[user]] = await pool.query(
      `SELECT ${USER_SELECT}
       FROM users u
       WHERE u.id = ?
       LIMIT 1`,
      [userId]
    );
    if (!user) return res.status(404).json({ message: "User not found" });

    const [[stats]] = await pool.query(
      `SELECT
         SUM(event_type = 'login') AS login_count,
         SUM(event_type = 'visit') AS visit_count,
         SUM(event_type = 'register') AS register_count,
         SUM(event_type = 'login_failed') AS failed_login_count,
         COUNT(DISTINCT NULLIF(ip_address, '')) AS distinct_ips,
         COUNT(DISTINCT NULLIF(device_key, '')) AS distinct_devices,
         MIN(created_at) AS first_activity_at,
         MAX(created_at) AS last_activity_at
       FROM user_activity_events
       WHERE user_id = ?`,
      [userId]
    );

    const [recentActivity] = await pool.query(
      `SELECT id, event_type, path, method, ip_address, user_agent, device_key, metadata, created_at
       FROM user_activity_events
       WHERE user_id = ?
       ORDER BY created_at DESC, id DESC
       LIMIT 80`,
      [userId]
    );

    const [topPages] = await pool.query(
      `SELECT path, COUNT(*) AS visits, MAX(created_at) AS last_visit_at
       FROM user_activity_events
       WHERE user_id = ? AND event_type = 'visit' AND path IS NOT NULL
       GROUP BY path
       ORDER BY visits DESC, last_visit_at DESC
       LIMIT 20`,
      [userId]
    );

    const relatedParams = [];
    const relatedWhere = ["id <> ?"];
    relatedParams.push(userId);
    if (user.registration_device_key) {
      relatedWhere.push("registration_device_key = ?");
      relatedParams.push(user.registration_device_key);
    }
    if (user.registration_ip) {
      relatedWhere.push("registration_ip = ?");
      relatedParams.push(user.registration_ip);
    }

    const relatedSql =
      relatedWhere.length > 1
        ? `WHERE ${relatedWhere[0]} AND (${relatedWhere.slice(1).join(" OR ")})`
        : "WHERE id = 0";

    const [relatedUsers] = await pool.query(
      `SELECT id, email, username, full_name, role, is_blocked, registration_ip, registration_device_key, created_at
       FROM users
       ${relatedSql}
       ORDER BY created_at DESC
       LIMIT 30`,
      relatedParams
    );

    return res.json({ user, stats, recentActivity, topPages, relatedUsers });
  } catch (err) {
    console.error("admin god eyes detail error:", err);
    return res.status(500).json({ message: "Error loading user activity" });
  }
});

router.patch("/:id/block", async (req, res) => {
  try {
    await ensureGodEyesSchema();
    const adminId = req.user.userId;
    const userId = parseId(req.params.id);
    if (!userId) return res.status(400).json({ message: "Invalid user ID" });
    if (userId === adminId) return res.status(400).json({ message: "You cannot block your own account" });

    const isBlocked = req.body?.is_blocked === true || req.body?.is_blocked === 1 || req.body?.is_blocked === "1";
    const reason = clean(req.body?.reason);
    const [[user]] = await pool.query("SELECT id FROM users WHERE id = ? LIMIT 1", [userId]);
    if (!user) return res.status(404).json({ message: "User not found" });

    await pool.query("UPDATE users SET is_blocked = ? WHERE id = ?", [isBlocked ? 1 : 0, userId]);
    await pool.query(
      `INSERT INTO user_activity_events
        (user_id, event_type, path, method, ip_address, user_agent, device_key, metadata)
       VALUES (?, 'admin_block', '/admin/god-eyes', 'PATCH', NULL, NULL, NULL, ?)`,
      [userId, JSON.stringify({ is_blocked: isBlocked, reason: reason || null, admin_id: adminId })]
    );

    return res.json({ message: isBlocked ? "User blocked" : "User unblocked" });
  } catch (err) {
    console.error("admin god eyes block error:", err);
    return res.status(500).json({ message: "Error updating block status" });
  }
});

module.exports = router;
