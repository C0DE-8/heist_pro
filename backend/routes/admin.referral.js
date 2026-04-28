const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const {
  ensureReferralSettings,
  normalizeSettings,
} = require("../services/referralReward.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function parsePositiveInteger(value, field) {
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed <= 0) {
    throw new Error(`${field} must be greater than 0`);
  }
  return parsed;
}

function parseBooleanFlag(value) {
  if (typeof value === "boolean") return value ? 1 : 0;
  if (value === 1 || value === "1") return 1;
  if (value === 0 || value === "0") return 0;
  throw new Error("is_enabled must be true or false");
}

async function buildReferralAdminResponse(db) {
  const settings = await ensureReferralSettings(db);

  const [[summary]] = await db.query(
    `SELECT
       COUNT(*) AS tracked_users,
       COUNT(CASE WHEN rewarded_at IS NOT NULL THEN 1 END) AS rewarded_users,
       COUNT(CASE WHEN rewarded_at IS NULL THEN 1 END) AS pending_users,
       COALESCE(SUM(joined_heists), 0) AS total_join_count,
       COALESCE(SUM(awarded_cop_points), 0) AS total_rewards_awarded
     FROM referral_reward_progress
     WHERE reset_version = ?`,
    [settings.reset_version]
  );

  const [progress] = await db.query(
    `SELECT
       p.id,
       p.reset_version,
       p.referrer_id,
       p.referred_user_id,
       p.joined_heists,
       p.rewarded_at,
       p.awarded_cop_points,
       p.last_joined_heist_id,
       p.last_joined_at,
       p.created_at,
       p.updated_at,
       referrer.username AS referrer_username,
       referrer.full_name AS referrer_full_name,
       referred.username AS referred_username,
       referred.full_name AS referred_full_name,
       referred.email AS referred_email
     FROM referral_reward_progress p
     JOIN users referrer ON referrer.id = p.referrer_id
     JOIN users referred ON referred.id = p.referred_user_id
     WHERE p.reset_version = ?
     ORDER BY p.rewarded_at IS NULL DESC, p.joined_heists DESC, p.updated_at DESC`,
    [settings.reset_version]
  );

  return {
    settings,
    summary: {
      tracked_users: Number(summary.tracked_users || 0),
      rewarded_users: Number(summary.rewarded_users || 0),
      pending_users: Number(summary.pending_users || 0),
      total_join_count: Number(summary.total_join_count || 0),
      total_rewards_awarded: Number(summary.total_rewards_awarded || 0),
    },
    progress: progress.map((row) => ({
      ...row,
      joined_heists: Number(row.joined_heists || 0),
      awarded_cop_points: Number(row.awarded_cop_points || 0),
      is_rewarded: Boolean(row.rewarded_at),
    })),
  };
}

router.get("/", async (req, res) => {
  try {
    const data = await buildReferralAdminResponse(pool);
    return res.json(data);
  } catch (err) {
    console.error("admin referral get error:", err);
    return res.status(500).json({ message: "Error fetching referral reward settings" });
  }
});

router.patch("/", async (req, res) => {
  let conn;
  try {
    const updates = [];
    const params = [];

    if (req.body?.is_enabled !== undefined) {
      updates.push("is_enabled = ?");
      params.push(parseBooleanFlag(req.body.is_enabled));
    }

    if (req.body?.required_heist_joins !== undefined) {
      updates.push("required_heist_joins = ?");
      params.push(parsePositiveInteger(req.body.required_heist_joins, "required_heist_joins"));
    }

    if (req.body?.reward_cop_points !== undefined) {
      updates.push("reward_cop_points = ?");
      params.push(parsePositiveInteger(req.body.reward_cop_points, "reward_cop_points"));
    }

    if (!updates.length) {
      return res.status(400).json({ message: "No updates provided" });
    }

    conn = await pool.getConnection();
    await conn.beginTransaction();
    await ensureReferralSettings(conn);

    updates.push("updated_by = ?");
    params.push(req.user.userId);

    params.push(1);
    await conn.query(
      `UPDATE admin_referral_settings
       SET ${updates.join(", ")}
       WHERE id = ?`,
      params
    );

    const settings = normalizeSettings(
      (
        await conn.query(
          `SELECT id, is_enabled, required_heist_joins, reward_cop_points, reset_version,
                  updated_by, last_reset_by, last_reset_at, created_at, updated_at
           FROM admin_referral_settings
           WHERE id = 1
           LIMIT 1 FOR UPDATE`
        )
      )[0][0]
    );

    await conn.commit();

    const data = await buildReferralAdminResponse(pool);
    return res.json({
      message: "Referral reward settings updated",
      ...data,
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin referral update error:", err);
    return res.status(400).json({ message: err.message || "Error updating referral reward settings" });
  } finally {
    if (conn) conn.release();
  }
});

router.post("/reset", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const settings = await ensureReferralSettings(conn);

    await conn.query(
      `UPDATE admin_referral_settings
       SET reset_version = ?,
           updated_by = ?,
           last_reset_by = ?,
           last_reset_at = NOW()
       WHERE id = 1`,
      [settings.reset_version + 1, req.user.userId, req.user.userId]
    );

    await conn.commit();
    const data = await buildReferralAdminResponse(pool);
    return res.json({ message: "Referral reward progress reset", ...data });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin referral reset error:", err);
    return res.status(500).json({ message: "Error resetting referral rewards" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
