const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const {
  ensureLevelProgressTables,
  parsePositiveInt,
  parseNonNegativeInt,
  adjustUserXp,
  getUserProgress,
  listLevels,
  auditAdminAction,
} = require("../services/levelProgress.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

router.use(async (req, res, next) => {
  try {
    await ensureLevelProgressTables(pool);
    next();
  } catch (err) {
    console.error("admin level schema check error:", err);
    res.status(500).json({ message: "Error preparing level progress schema" });
  }
});

function normalizeBoolean(value, fallback = true) {
  if (value === undefined || value === null || value === "") return fallback ? 1 : 0;
  return value === true || value === 1 || value === "1" || value === "true" ? 1 : 0;
}

router.get("/summary", async (req, res) => {
  try {
    const [[totals]] = await pool.query(
      `SELECT
         (SELECT COUNT(*) FROM user_xp_totals) AS users_with_xp,
         (SELECT COALESCE(SUM(total_xp), 0) FROM user_xp_totals) AS total_xp,
         (SELECT COUNT(*) FROM user_level_rewards) AS rewards_earned,
         (SELECT COUNT(*) FROM user_level_rewards WHERE status = 'claimed') AS rewards_claimed,
         (SELECT COUNT(*) FROM user_level_rewards WHERE status = 'redeemed') AS rewards_redeemed,
         (SELECT COUNT(*) FROM user_level_rewards WHERE status = 'expired') AS rewards_expired`
    );
    const [recentLevelUps] = await pool.query(
      `SELECT r.id, r.user_id, u.username, u.email, r.status, r.earned_at,
              ld.level_order, ld.roman_label, b.name AS badge_name
       FROM user_level_rewards r
       JOIN users u ON u.id = r.user_id
       JOIN level_definitions ld ON ld.id = r.level_definition_id
       JOIN level_badges b ON b.id = ld.badge_id
       ORDER BY r.earned_at DESC
       LIMIT 20`
    );
    return res.json({ summary: totals, recent_level_ups: recentLevelUps });
  } catch (err) {
    console.error("admin level summary error:", err);
    return res.status(500).json({ message: "Error fetching level summary" });
  }
});

router.get("/badges", async (req, res) => {
  try {
    const [badges] = await pool.query(
      `SELECT id, name, badge_order, image_path, is_active, created_at, updated_at
       FROM level_badges
       ORDER BY badge_order ASC`
    );
    return res.json({ badges });
  } catch (err) {
    console.error("admin badges error:", err);
    return res.status(500).json({ message: "Error fetching badges" });
  }
});

router.post("/badges", async (req, res) => {
  const name = String(req.body?.name || "").trim();
  const badgeOrder = parsePositiveInt(req.body?.badge_order, "badge_order");
  const imagePath = req.body?.image_path ? String(req.body.image_path).trim() : null;
  const isActive = normalizeBoolean(req.body?.is_active, true);

  if (!name) return res.status(400).json({ message: "Badge name is required" });
  if (!badgeOrder.ok) return res.status(400).json({ message: badgeOrder.message });

  try {
    const [result] = await pool.query(
      `INSERT INTO level_badges (name, badge_order, image_path, is_active)
       VALUES (?, ?, ?, ?)`,
      [name, badgeOrder.value, imagePath, isActive]
    );
    return res.status(201).json({
      message: "Badge created",
      badge: { id: result.insertId, name, badge_order: badgeOrder.value, image_path: imagePath, is_active: isActive },
    });
  } catch (err) {
    console.error("admin badge create error:", err);
    return res.status(500).json({ message: "Error creating badge" });
  }
});

router.patch("/badges/:id", async (req, res) => {
  const badgeId = Number(req.params.id);
  if (!badgeId) return res.status(400).json({ message: "Invalid badge id" });

  const name = req.body?.name !== undefined ? String(req.body.name || "").trim() : undefined;
  const imagePath = req.body?.image_path !== undefined ? String(req.body.image_path || "").trim() || null : undefined;
  const isActive = req.body?.is_active !== undefined ? normalizeBoolean(req.body.is_active, true) : undefined;
  const badgeOrder = req.body?.badge_order !== undefined
    ? parsePositiveInt(req.body.badge_order, "badge_order")
    : null;
  if (name === "") return res.status(400).json({ message: "Badge name cannot be empty" });
  if (badgeOrder && !badgeOrder.ok) return res.status(400).json({ message: badgeOrder.message });

  const updates = [];
  const params = [];
  if (name !== undefined) {
    updates.push("name = ?");
    params.push(name);
  }
  if (badgeOrder) {
    updates.push("badge_order = ?");
    params.push(badgeOrder.value);
  }
  if (imagePath !== undefined) {
    updates.push("image_path = ?");
    params.push(imagePath);
  }
  if (isActive !== undefined) {
    updates.push("is_active = ?");
    params.push(isActive);
  }
  if (!updates.length) return res.status(400).json({ message: "No badge fields to update" });

  try {
    params.push(badgeId);
    await pool.query(`UPDATE level_badges SET ${updates.join(", ")} WHERE id = ?`, params);
    return res.json({ message: "Badge updated" });
  } catch (err) {
    console.error("admin badge update error:", err);
    return res.status(500).json({ message: "Error updating badge" });
  }
});

router.get("/definitions", async (req, res) => {
  try {
    const levels = await listLevels(pool);
    return res.json({ levels });
  } catch (err) {
    console.error("admin level definitions error:", err);
    return res.status(500).json({ message: "Error fetching level definitions" });
  }
});

router.post("/definitions", async (req, res) => {
  const badgeId = parsePositiveInt(req.body?.badge_id, "badge_id");
  const levelOrder = parsePositiveInt(req.body?.level_order, "level_order");
  const badgeLevel = parsePositiveInt(req.body?.badge_level, "badge_level");
  const romanLabel = String(req.body?.roman_label || "").trim().toUpperCase();
  const xpRequired = parseNonNegativeInt(req.body?.xp_required, "xp_required");
  const couponAmount = parseNonNegativeInt(
    req.body?.coupon_copup_jr_amount ?? 0,
    "coupon_copup_jr_amount"
  );
  const isActive = normalizeBoolean(req.body?.is_active, true);

  if (!badgeId.ok) return res.status(400).json({ message: badgeId.message });
  if (!levelOrder.ok) return res.status(400).json({ message: levelOrder.message });
  if (!badgeLevel.ok) return res.status(400).json({ message: badgeLevel.message });
  if (!romanLabel) return res.status(400).json({ message: "roman_label is required" });
  if (!xpRequired.ok) return res.status(400).json({ message: xpRequired.message });
  if (!couponAmount.ok) return res.status(400).json({ message: couponAmount.message });

  try {
    const [result] = await pool.query(
      `INSERT INTO level_definitions
        (badge_id, level_order, badge_level, roman_label, xp_required, coupon_copup_jr_amount, is_active)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        badgeId.value,
        levelOrder.value,
        badgeLevel.value,
        romanLabel,
        xpRequired.value,
        couponAmount.value,
        isActive,
      ]
    );
    return res.status(201).json({
      message: "Level definition created",
      level: {
        id: result.insertId,
        badge_id: badgeId.value,
        level_order: levelOrder.value,
        badge_level: badgeLevel.value,
        roman_label: romanLabel,
        xp_required: xpRequired.value,
        coupon_copup_jr_amount: couponAmount.value,
        is_active: isActive,
      },
    });
  } catch (err) {
    console.error("admin level definition create error:", err);
    return res.status(500).json({ message: "Error creating level definition" });
  }
});

router.patch("/definitions/:id", async (req, res) => {
  const levelId = Number(req.params.id);
  if (!levelId) return res.status(400).json({ message: "Invalid level id" });

  const xpRequired = req.body?.xp_required !== undefined
    ? parseNonNegativeInt(req.body.xp_required, "xp_required")
    : null;
  const couponAmount = req.body?.coupon_copup_jr_amount !== undefined
    ? parseNonNegativeInt(req.body.coupon_copup_jr_amount, "coupon_copup_jr_amount")
    : null;
  const isActive = req.body?.is_active !== undefined ? normalizeBoolean(req.body.is_active, true) : undefined;
  if (xpRequired && !xpRequired.ok) return res.status(400).json({ message: xpRequired.message });
  if (couponAmount && !couponAmount.ok) return res.status(400).json({ message: couponAmount.message });

  const updates = [];
  const params = [];
  if (xpRequired) {
    updates.push("xp_required = ?");
    params.push(xpRequired.value);
  }
  if (couponAmount) {
    updates.push("coupon_copup_jr_amount = ?");
    params.push(couponAmount.value);
  }
  if (isActive !== undefined) {
    updates.push("is_active = ?");
    params.push(isActive);
  }
  if (!updates.length) return res.status(400).json({ message: "No level fields to update" });

  try {
    params.push(levelId);
    await pool.query(`UPDATE level_definitions SET ${updates.join(", ")} WHERE id = ?`, params);
    return res.json({ message: "Level definition updated" });
  } catch (err) {
    console.error("admin level definition update error:", err);
    return res.status(500).json({ message: "Error updating level definition" });
  }
});

router.get("/xp-rules", async (req, res) => {
  try {
    const [rules] = await pool.query(
      `SELECT source, xp_amount, label, is_active, updated_by, created_at, updated_at
       FROM xp_source_rules
       ORDER BY source ASC`
    );
    return res.json({ rules });
  } catch (err) {
    console.error("admin xp rules error:", err);
    return res.status(500).json({ message: "Error fetching XP rules" });
  }
});

router.patch("/xp-rules/:source", async (req, res) => {
  const source = String(req.params.source || "").trim().toLowerCase();
  const xpAmount = parseNonNegativeInt(req.body?.xp_amount, "xp_amount");
  const label = req.body?.label ? String(req.body.label).trim() : null;
  const isActive = normalizeBoolean(req.body?.is_active, true);

  if (!source) return res.status(400).json({ message: "Invalid XP source" });
  if (!xpAmount.ok) return res.status(400).json({ message: xpAmount.message });

  try {
    await pool.query(
      `INSERT INTO xp_source_rules (source, xp_amount, label, is_active, updated_by)
       VALUES (?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
         xp_amount = VALUES(xp_amount),
         label = VALUES(label),
         is_active = VALUES(is_active),
         updated_by = VALUES(updated_by)`,
      [source, xpAmount.value, label || source, isActive, req.user.userId]
    );
    return res.json({ message: "XP rule updated" });
  } catch (err) {
    console.error("admin xp rule update error:", err);
    return res.status(500).json({ message: "Error updating XP rule" });
  }
});

router.get("/users/:userId", async (req, res) => {
  const userId = Number(req.params.userId);
  if (!userId) return res.status(400).json({ message: "Invalid user id" });

  try {
    const [[user]] = await pool.query(
      "SELECT id, username, email, full_name, role FROM users WHERE id = ? LIMIT 1",
      [userId]
    );
    if (!user) return res.status(404).json({ message: "User not found" });
    const progress = await getUserProgress(pool, userId);
    return res.json({ user, progress });
  } catch (err) {
    console.error("admin user progress error:", err);
    return res.status(500).json({ message: "Error fetching user progress" });
  }
});

router.post("/users/:userId/adjust-xp", async (req, res) => {
  const userId = Number(req.params.userId);
  const xpAmount = Number(req.body?.xp_amount);
  const reason = String(req.body?.reason || "").trim();
  if (!userId) return res.status(400).json({ message: "Invalid user id" });
  if (!Number.isInteger(xpAmount) || xpAmount === 0) {
    return res.status(400).json({ message: "xp_amount must be a non-zero integer" });
  }
  if (!reason) return res.status(400).json({ message: "Adjustment reason is required" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    const result = await adjustUserXp(conn, {
      userId,
      sourceId: `admin:${req.user.userId}:${Date.now()}`,
      xpAmount,
      createdBy: req.user.userId,
      metadata: { reason },
    });
    await auditAdminAction(conn, {
      adminUserId: req.user.userId,
      targetUserId: userId,
      action: "adjust_xp",
      metadata: { xp_amount: xpAmount, reason, result },
    });
    await conn.commit();
    return res.json({ message: "XP adjusted", result });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin xp adjust error:", err);
    return res.status(500).json({ message: "Error adjusting XP" });
  } finally {
    if (conn) conn.release();
  }
});

router.get("/rewards", async (req, res) => {
  try {
    const status = req.query.status ? String(req.query.status).trim().toLowerCase() : null;
    const params = [];
    let where = "";
    if (status) {
      where = "WHERE r.status = ?";
      params.push(status);
    }
    const [rewards] = await pool.query(
      `SELECT r.id, r.user_id, u.username, u.email, r.code, r.copup_jr_amount,
              r.status, r.earned_at, r.claimed_at, r.redeemed_at, r.expires_at,
              ld.level_order, ld.roman_label, b.name AS badge_name
       FROM user_level_rewards r
       JOIN users u ON u.id = r.user_id
       JOIN level_definitions ld ON ld.id = r.level_definition_id
       JOIN level_badges b ON b.id = ld.badge_id
       ${where}
       ORDER BY r.earned_at DESC
       LIMIT 500`,
      params
    );
    return res.json({ rewards });
  } catch (err) {
    console.error("admin rewards error:", err);
    return res.status(500).json({ message: "Error fetching rewards" });
  }
});

router.patch("/rewards/:id", async (req, res) => {
  const rewardId = Number(req.params.id);
  const status = String(req.body?.status || "").trim().toLowerCase();
  const allowed = new Set(["earned", "claimed", "redeemed", "expired"]);
  if (!rewardId) return res.status(400).json({ message: "Invalid reward id" });
  if (!allowed.has(status)) return res.status(400).json({ message: "Invalid reward status" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    const [[reward]] = await conn.query(
      "SELECT id, user_id, status FROM user_level_rewards WHERE id = ? LIMIT 1 FOR UPDATE",
      [rewardId]
    );
    if (!reward) {
      await conn.rollback();
      return res.status(404).json({ message: "Reward not found" });
    }
    await conn.query("UPDATE user_level_rewards SET status = ? WHERE id = ?", [status, rewardId]);
    await auditAdminAction(conn, {
      adminUserId: req.user.userId,
      targetUserId: reward.user_id,
      action: "update_reward_status",
      metadata: { reward_id: rewardId, previous_status: reward.status, next_status: status },
    });
    await conn.commit();
    return res.json({ message: "Reward updated" });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin reward update error:", err);
    return res.status(500).json({ message: "Error updating reward" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
