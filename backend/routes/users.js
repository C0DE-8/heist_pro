const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");

const router = express.Router();

function normalizeEmail(email) {
  return String(email || "").trim().toLowerCase();
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function cleanUsername(username) {
  return String(username || "").trim();
}

async function getUserProfile(userId) {
  const [[user]] = await pool.query(
    `SELECT id, email, username, full_name, role, is_verified, is_blocked,
            referral_code, wallet_address, game_id, cop_point, created_at, updated_at
     FROM users
     WHERE id = ?
     LIMIT 1`,
    [userId]
  );

  return user || null;
}

router.get("/profile", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const user = await getUserProfile(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    const [[heistStats]] = await pool.query(
      `SELECT
         COUNT(DISTINCT hp.id) AS joined_heists,
         COUNT(DISTINCT CASE WHEN hp.status = 'submitted' THEN hp.id END) AS submitted_heists,
         COUNT(DISTINCT CASE WHEN h.status = 'started' THEN hp.id END) AS active_heists,
         COUNT(DISTINCT CASE WHEN h.winner_user_id = ? THEN h.id END) AS won_heists
       FROM heist_participants hp
       JOIN heist h ON h.id = hp.heist_id
       WHERE hp.user_id = ?`,
      [userId, userId]
    );

    const [[submissionStats]] = await pool.query(
      `SELECT
         COUNT(*) AS total_submissions,
         COALESCE(MAX(correct_count), 0) AS best_correct_count,
         COALESCE(AVG(score_percent), 0) AS average_score_percent
       FROM heist_submissions
       WHERE user_id = ? AND status = 'submitted'`,
      [userId]
    );

    const [[affiliateStats]] = await pool.query(
      `SELECT
         (SELECT COUNT(*) FROM affiliate_user_links WHERE affiliate_user_id = ?) AS total_links,
         (SELECT COALESCE(SUM(total_clicks), 0) FROM affiliate_user_links WHERE affiliate_user_id = ?) AS total_clicks,
         (SELECT COALESCE(SUM(total_heist_joins), 0) FROM affiliate_user_links WHERE affiliate_user_id = ?) AS total_heist_joins,
         (SELECT COUNT(*) FROM affiliate_user_referrals WHERE affiliate_user_id = ?) AS referred_joins`,
      [userId, userId, userId, userId]
    );

    const [[taskStats]] = await pool.query(
      `SELECT
         COUNT(*) AS total_task_progress,
         COUNT(CASE WHEN p.is_completed = 1 THEN 1 END) AS completed_tasks,
         COALESCE(SUM(CASE WHEN p.is_completed = 1 THEN t.reward_cop_points ELSE 0 END), 0) AS affiliate_rewards_earned
       FROM affiliate_task_progress p
       JOIN affiliate_tasks t ON t.id = p.task_id
       WHERE p.user_id = ?`,
      [userId]
    );

    const [recentHeists] = await pool.query(
      `SELECT h.id, h.name, h.status, h.prize_cop_points, hp.status AS participant_status,
              hp.joined_at, h.countdown_ends_at
       FROM heist_participants hp
       JOIN heist h ON h.id = hp.heist_id
       WHERE hp.user_id = ?
       ORDER BY hp.joined_at DESC
       LIMIT 10`,
      [userId]
    );

    const [affiliateProgress] = await pool.query(
      `SELECT t.id AS task_id, t.heist_id, h.name AS heist_name, t.required_joins,
              t.reward_cop_points, t.is_active, p.current_joins,
              p.is_completed, p.rewarded_at
       FROM affiliate_task_progress p
       JOIN affiliate_tasks t ON t.id = p.task_id
       JOIN heist h ON h.id = t.heist_id
       WHERE p.user_id = ?
       ORDER BY p.is_completed ASC, t.required_joins ASC, p.id DESC
       LIMIT 20`,
      [userId]
    );

    return res.json({
      user,
      stats: {
        heists: heistStats,
        submissions: submissionStats,
        affiliate: affiliateStats,
        affiliate_tasks: taskStats,
      },
      recent_heists: recentHeists,
      affiliate_task_progress: affiliateProgress,
    });
  } catch (err) {
    console.error("user profile error:", err);
    return res.status(500).json({ message: "Error fetching profile" });
  }
});

router.patch("/profile", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const updates = [];
    const params = [];

    if (req.body?.username !== undefined) {
      const username = cleanUsername(req.body.username);
      if (!username) return res.status(400).json({ message: "Username is required" });

      const [[existing]] = await pool.query(
        "SELECT id FROM users WHERE username = ? AND id <> ? LIMIT 1",
        [username, userId]
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
        [email, userId]
      );
      if (existing) return res.status(400).json({ message: "Email already exists" });

      updates.push("email = ?");
      params.push(email);
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(userId);
    await pool.query(`UPDATE users SET ${updates.join(", ")} WHERE id = ?`, params);

    const user = await getUserProfile(userId);
    return res.json({ message: "Profile updated", user });
  } catch (err) {
    console.error("user profile update error:", err);
    return res.status(500).json({ message: "Error updating profile" });
  }
});

module.exports = router;
