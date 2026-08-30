const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");
const { ensurePromoTables, lockCopupJrBalance } = require("../services/promo.service");
const {
  ensureLevelProgressTables,
  getUserProgress,
  getUserRewards,
  claimDailyCheckIn,
  claimLevelReward,
  redeemLevelRewardCode,
  listLevels,
} = require("../services/levelProgress.service");

const router = express.Router();

router.use(authenticateToken);

router.use(async (req, res, next) => {
  try {
    await ensurePromoTables(pool);
    await ensureLevelProgressTables(pool);
    next();
  } catch (err) {
    console.error("level progress schema check error:", err);
    res.status(500).json({ message: "Error preparing level progress schema" });
  }
});

router.get("/", async (req, res) => {
  try {
    const progress = await getUserProgress(pool, req.user.userId);
    return res.json({ progress });
  } catch (err) {
    console.error("user progress error:", err);
    return res.status(500).json({ message: "Error fetching progress" });
  }
});

router.get("/levels", async (req, res) => {
  try {
    const progress = await getUserProgress(pool, req.user.userId);
    const levels = await listLevels(pool);
    return res.json({ progress, levels });
  } catch (err) {
    console.error("user levels error:", err);
    return res.status(500).json({ message: "Error fetching levels" });
  }
});

router.post("/daily-check-in", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    const result = await claimDailyCheckIn(conn, req.user.userId);
    if (result.status >= 400) {
      await conn.rollback();
      return res.status(result.status).json(result.body);
    }
    await conn.commit();
    return res.status(result.status).json(result.body);
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("daily check-in error:", err);
    return res.status(500).json({ message: "Error claiming daily check-in" });
  } finally {
    if (conn) conn.release();
  }
});

router.get("/rewards", async (req, res) => {
  try {
    const rewards = await getUserRewards(pool, req.user.userId);
    return res.json({ rewards });
  } catch (err) {
    console.error("user level rewards error:", err);
    return res.status(500).json({ message: "Error fetching level rewards" });
  }
});

router.post("/rewards/:id/claim", async (req, res) => {
  const rewardId = Number(req.params.id);
  if (!rewardId) return res.status(400).json({ message: "Invalid reward id" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    const result = await claimLevelReward(conn, {
      userId: req.user.userId,
      rewardId,
    });
    if (result.status >= 400) {
      await conn.rollback();
      return res.status(result.status).json(result.body);
    }
    await conn.commit();
    return res.status(result.status).json(result.body);
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("claim level reward error:", err);
    return res.status(500).json({ message: "Error claiming level reward" });
  } finally {
    if (conn) conn.release();
  }
});

router.post("/rewards/redeem-code", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();
    await ensurePromoTables(conn);
    const result = await redeemLevelRewardCode(conn, {
      userId: req.user.userId,
      rawCode: req.body?.code,
      lockCopupJrBalance,
    });
    if (result.status >= 400) {
      await conn.rollback();
      return res.status(result.status).json(result.body);
    }
    await conn.commit();
    return res.status(result.status).json(result.body);
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("redeem level reward code error:", err);
    return res.status(500).json({ message: "Error redeeming level reward code" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
