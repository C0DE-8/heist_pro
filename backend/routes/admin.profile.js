const express = require("express");
const bcrypt = require("bcryptjs");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function excludedSql(alias, excludedUserIds) {
  if (!excludedUserIds.length) return { sql: "", params: [] };
  return {
    sql: ` AND ${alias}.id NOT IN (${excludedUserIds.map(() => "?").join(", ")})`,
    params: excludedUserIds,
  };
}

function normalizeEmail(email) {
  return String(email || "").trim().toLowerCase();
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

async function getAdminProfile(userId) {
  const [[admin]] = await pool.query(
    `SELECT id, email, username, full_name, role, is_verified, is_blocked,
            referral_code, wallet_address, game_id, cop_point, created_at, updated_at
     FROM users
     WHERE id = ? AND role = 'admin'
     LIMIT 1`,
    [userId]
  );

  return admin || null;
}

async function getSavedExcludedUserIds() {
  const [rows] = await pool.query(
    `SELECT user_id
     FROM admin_analytics_user_exclusions
     ORDER BY user_id ASC`
  );
  return rows.map((row) => Number(row.user_id)).filter(Boolean);
}

router.get("/", async (req, res) => {
  try {
    const admin = await getAdminProfile(req.user.userId);
    if (!admin) return res.status(404).json({ message: "Admin not found" });
    const excludedUserIds = await getSavedExcludedUserIds();
    const exclusion = excludedSql("u", excludedUserIds);

    const [[userStats]] = await pool.query(
      `SELECT
         (SELECT COUNT(*) FROM users) AS total_users,
         COUNT(*) AS included_users,
         (SELECT COUNT(*) FROM users WHERE role = 'admin') AS total_admins,
         COUNT(CASE WHEN u.role = 'user' THEN 1 END) AS total_regular_users,
         COUNT(CASE WHEN u.is_verified = 1 THEN 1 END) AS verified_users,
         COUNT(CASE WHEN u.is_blocked = 1 THEN 1 END) AS blocked_users,
         COALESCE(SUM(u.cop_point), 0) AS total_cop_points
       FROM users u
       WHERE 1 = 1 ${exclusion.sql}`,
      exclusion.params
    );

    const [[heistStats]] = await pool.query(
      `SELECT
         COUNT(*) AS total_heists,
         COUNT(CASE WHEN status = 'pending' THEN 1 END) AS pending_heists,
         COUNT(CASE WHEN status = 'hold' THEN 1 END) AS hold_heists,
         COUNT(CASE WHEN status = 'started' THEN 1 END) AS started_heists,
         COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_heists,
         COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled_heists,
         COALESCE(SUM(prize_cop_points), 0) AS total_prize_cop_points
       FROM heist`
    );

    const [[activityStats]] = await pool.query(
      `SELECT
         (SELECT COUNT(*) FROM heist_participants) AS total_participants,
         (SELECT COUNT(*) FROM heist_submissions) AS total_submissions,
         (SELECT COUNT(*) FROM heist_submissions WHERE status = 'submitted') AS submitted_results,
         (SELECT COUNT(*) FROM affiliate_user_links) AS affiliate_links,
         (SELECT COUNT(*) FROM affiliate_user_referrals) AS affiliate_referrals,
         (SELECT COUNT(*) FROM affiliate_tasks) AS affiliate_tasks,
         (SELECT COUNT(*) FROM affiliate_task_progress WHERE is_completed = 1) AS completed_affiliate_tasks`
    );

    const [[rewardStats]] = await pool.query(
      `SELECT
         COALESCE(SUM(CASE WHEN p.is_completed = 1 THEN t.reward_cop_points ELSE 0 END), 0)
           AS affiliate_rewards_awarded
       FROM affiliate_task_progress p
       JOIN affiliate_tasks t ON t.id = p.task_id`
    );

    const [recentHeists] = await pool.query(
      `SELECT id, name, status, min_users, ticket_price, prize_cop_points,
              total_questions, winner_user_id, countdown_ends_at, created_at
       FROM heist
       ORDER BY created_at DESC
       LIMIT 10`
    );

    const [recentUsers] = await pool.query(
      `SELECT id, email, username, full_name, role, is_verified, is_blocked,
              cop_point, created_at
       FROM users u
       WHERE 1 = 1 ${exclusion.sql}
       ORDER BY created_at DESC
       LIMIT 10`,
      exclusion.params
    );

    let excludedStats = { excluded_users: 0, excluded_user_coin_balance: 0 };
    if (excludedUserIds.length) {
      [[excludedStats]] = await pool.query(
        `SELECT
           COUNT(*) AS excluded_users,
           COALESCE(SUM(cop_point), 0) AS excluded_user_coin_balance
         FROM users
         WHERE id IN (${excludedUserIds.map(() => "?").join(", ")})`,
        excludedUserIds
      );
    }

    const analyticsPreview = {
      excluded_user_ids: excludedUserIds,
      excluded_users: Number(excludedStats.excluded_users || 0),
      excluded_user_coin_balance: Number(excludedStats.excluded_user_coin_balance || 0),
      filtered_user_coin_balance: Number(userStats.total_cop_points || 0),
      displayed_recent_users: recentUsers.length,
    };

    userStats.total_users = Number(userStats.total_users || 0);
    userStats.included_users = Number(userStats.included_users || 0);
    userStats.total_admins = Number(userStats.total_admins || 0);
    userStats.total_regular_users = Number(userStats.total_regular_users || 0);
    userStats.verified_users = Number(userStats.verified_users || 0);
    userStats.blocked_users = Number(userStats.blocked_users || 0);
    userStats.total_cop_points = Number(userStats.total_cop_points || 0);
    userStats.excluded_users = analyticsPreview.excluded_users;
    userStats.excluded_user_coin_balance = analyticsPreview.excluded_user_coin_balance;

    const normalizedRecentUsers = recentUsers.map((user) => ({
      ...user,
      cop_point: Number(user.cop_point || 0),
    }));

    return res.json({
      admin,
      stats: {
        users: userStats,
        heists: heistStats,
        activity: activityStats,
        rewards: rewardStats,
        analytics: analyticsPreview,
      },
      recent_heists: recentHeists,
      recent_users: normalizedRecentUsers,
    });
  } catch (err) {
    console.error("admin profile error:", err);
    return res.status(500).json({ message: "Error fetching admin profile" });
  }
});

router.patch("/", async (req, res) => {
  try {
    const adminId = req.user.userId;
    const updates = [];
    const params = [];

    if (req.body?.username !== undefined) {
      const username = String(req.body.username || "").trim();
      if (!username) return res.status(400).json({ message: "Username is required" });

      const [[existing]] = await pool.query(
        "SELECT id FROM users WHERE username = ? AND id <> ? LIMIT 1",
        [username, adminId]
      );
      if (existing) return res.status(400).json({ message: "Username already exists" });

      updates.push("username = ?");
      params.push(username);
    }

    if (req.body?.full_name !== undefined) {
      const fullName = String(req.body.full_name || "").trim();
      updates.push("full_name = ?");
      params.push(fullName || null);
    }

    if (req.body?.email !== undefined) {
      const email = normalizeEmail(req.body.email);
      if (!isValidEmail(email)) return res.status(400).json({ message: "Invalid email address" });

      const [[existing]] = await pool.query(
        "SELECT id FROM users WHERE email = ? AND id <> ? LIMIT 1",
        [email, adminId]
      );
      if (existing) return res.status(400).json({ message: "Email already exists" });

      updates.push("email = ?");
      params.push(email);
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(adminId);
    const [result] = await pool.query(
      `UPDATE users SET ${updates.join(", ")} WHERE id = ? AND role = 'admin'`,
      params
    );

    if (!result.affectedRows) return res.status(404).json({ message: "Admin not found" });

    const admin = await getAdminProfile(adminId);
    return res.json({ message: "Admin profile updated", admin });
  } catch (err) {
    console.error("admin profile update error:", err);
    return res.status(500).json({ message: "Error updating admin profile" });
  }
});

router.patch("/password", async (req, res) => {
  try {
    const adminId = req.user.userId;
    const currentPassword = String(req.body?.current_password || "");
    const newPassword = String(req.body?.new_password || "");

    if (!currentPassword || !newPassword) {
      return res.status(400).json({ message: "current_password and new_password are required" });
    }
    if (newPassword.length < 8) {
      return res.status(400).json({ message: "New password must be at least 8 characters" });
    }
    if (newPassword === currentPassword) {
      return res.status(400).json({ message: "New password must be different" });
    }

    const [[admin]] = await pool.query(
      `SELECT id, password_hash
       FROM users
       WHERE id = ? AND role = 'admin'
       LIMIT 1`,
      [adminId]
    );
    if (!admin) return res.status(404).json({ message: "Admin not found" });

    const validPassword = await bcrypt.compare(currentPassword, admin.password_hash);
    if (!validPassword) return res.status(401).json({ message: "Invalid current password" });

    const passwordHash = await bcrypt.hash(newPassword, 12);
    await pool.query("UPDATE users SET password_hash = ? WHERE id = ? AND role = 'admin'", [
      passwordHash,
      adminId,
    ]);

    return res.json({ message: "Admin password updated" });
  } catch (err) {
    console.error("admin password update error:", err);
    return res.status(500).json({ message: "Error updating admin password" });
  }
});

module.exports = router;
