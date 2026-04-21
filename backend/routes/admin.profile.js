const express = require("express");
const bcrypt = require("bcryptjs");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

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

router.get("/", async (req, res) => {
  try {
    const admin = await getAdminProfile(req.user.userId);
    if (!admin) return res.status(404).json({ message: "Admin not found" });

    const [[userStats]] = await pool.query(
      `SELECT
         COUNT(*) AS total_users,
         COUNT(CASE WHEN role = 'admin' THEN 1 END) AS total_admins,
         COUNT(CASE WHEN role = 'user' THEN 1 END) AS total_regular_users,
         COUNT(CASE WHEN is_verified = 1 THEN 1 END) AS verified_users,
         COUNT(CASE WHEN is_blocked = 1 THEN 1 END) AS blocked_users,
         COALESCE(SUM(cop_point), 0) AS total_cop_points
       FROM users`
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
       FROM users
       ORDER BY created_at DESC
       LIMIT 10`
    );

    return res.json({
      admin,
      stats: {
        users: userStats,
        heists: heistStats,
        activity: activityStats,
        rewards: rewardStats,
      },
      recent_heists: recentHeists,
      recent_users: recentUsers,
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
