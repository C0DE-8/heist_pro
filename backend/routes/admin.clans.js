const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const {
  calculateQuestScores,
  cleanText,
  distributeQuestReward,
  ensureClanSettings,
  getClanDetails,
  listClans,
  listQuests,
  toInt,
  updateClan,
} = require("../services/clan.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function sendError(res, err, fallback = "Admin clan request failed") {
  return res.status(400).json({ message: err?.message || fallback });
}

router.get("/", async (req, res) => {
  try {
    const [settings, clans, quests] = await Promise.all([
      ensureClanSettings(pool),
      listClans({ q: req.query.q, status: req.query.status || "" }),
      listQuests(),
    ]);
    const [[summary]] = await pool.query(
      `SELECT
         COUNT(*) AS total_clans,
         COUNT(CASE WHEN status = 'active' THEN 1 END) AS active_clans,
         COUNT(CASE WHEN status = 'suspended' THEN 1 END) AS suspended_clans
       FROM clans`
    );
    return res.json({
      settings,
      clans,
      quests,
      summary: {
        total_clans: toInt(summary.total_clans),
        active_clans: toInt(summary.active_clans),
        suspended_clans: toInt(summary.suspended_clans),
      },
    });
  } catch (err) {
    console.error("admin clans list error:", err);
    return res.status(500).json({ message: "Error fetching admin clan dashboard" });
  }
});

router.patch("/settings", async (req, res) => {
  try {
    const updates = [];
    const params = [];
    if (req.body?.creation_cost_cop_points !== undefined) {
      const value = toInt(req.body.creation_cost_cop_points);
      if (value < 0) throw new Error("creation_cost_cop_points must be 0 or greater");
      updates.push("creation_cost_cop_points = ?");
      params.push(value);
    }
    if (req.body?.max_members !== undefined) {
      const value = req.body.max_members === "" || req.body.max_members === null ? null : toInt(req.body.max_members);
      if (value !== null && value <= 0) throw new Error("max_members must be empty or greater than 0");
      updates.push("max_members = ?");
      params.push(value);
    }
    if (req.body?.is_enabled !== undefined) {
      updates.push("is_enabled = ?");
      params.push(req.body.is_enabled ? 1 : 0);
    }
    if (!updates.length) throw new Error("No updates provided");
    updates.push("updated_by = ?");
    params.push(req.user.userId);
    await ensureClanSettings(pool);
    await pool.query(`UPDATE clan_settings SET ${updates.join(", ")} WHERE id = 1`, params);
    const settings = await ensureClanSettings(pool);
    return res.json({ message: "Clan settings updated", settings });
  } catch (err) {
    console.error("admin clan settings error:", err);
    return sendError(res, err, "Error updating clan settings");
  }
});

router.get("/:clanId", async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await getClanDetails(clanId, req.user.userId);
    if (!data) return res.status(404).json({ message: "Clan not found" });
    const [activity] = await pool.query(
      `SELECT a.*, actor.username AS actor_username, target.username AS target_username
       FROM clan_activity_events a
       LEFT JOIN users actor ON actor.id = a.actor_user_id
       LEFT JOIN users target ON target.id = a.target_user_id
       WHERE a.clan_id = ?
       ORDER BY a.created_at DESC
       LIMIT 80`,
      [clanId]
    );
    return res.json({ ...data, activity });
  } catch (err) {
    console.error("admin clan details error:", err);
    return res.status(500).json({ message: "Error fetching clan" });
  }
});

router.patch("/:clanId", async (req, res) => {
  try {
    const clanId = Number(req.params.clanId);
    if (!clanId) return res.status(400).json({ message: "Invalid clan id" });
    const data = await updateClan(clanId, req.user.userId, req.body, true);
    return res.json({ message: "Clan updated", ...data });
  } catch (err) {
    console.error("admin clan update error:", err);
    return sendError(res, err, "Error updating clan");
  }
});

router.post("/quests", async (req, res) => {
  try {
    const title = cleanText(req.body?.title, 160);
    if (title.length < 3) throw new Error("Quest title is required");
    const startsAt = req.body?.starts_at;
    const endsAt = req.body?.ends_at;
    if (!startsAt || !endsAt) throw new Error("Quest start and end dates are required");
    const prizeAmount = toInt(req.body?.prize_amount);
    if (prizeAmount < 0) throw new Error("Prize amount must be 0 or greater");
    const questType = ["heist_wins", "custom"].includes(req.body?.quest_type) ? req.body.quest_type : "heist_wins";
    const status = ["draft", "scheduled", "active"].includes(req.body?.status) ? req.body.status : "scheduled";
    const policy = ["opt_in", "auto"].includes(req.body?.participation_policy) ? req.body.participation_policy : "opt_in";
    const [result] = await pool.query(
      `INSERT INTO clan_quests
        (title, description, quest_type, status, starts_at, ends_at, prize_type,
         prize_amount, participation_policy, min_members, created_by, updated_by)
       VALUES (?, ?, ?, ?, ?, ?, 'cop_points', ?, ?, ?, ?, ?)`,
      [
        title,
        cleanText(req.body?.description, 2000) || null,
        questType,
        status,
        startsAt,
        endsAt,
        prizeAmount,
        policy,
        Math.max(1, toInt(req.body?.min_members, 1)),
        req.user.userId,
        req.user.userId,
      ]
    );
    return res.status(201).json({ message: "Clan quest created", quest_id: result.insertId, quests: await listQuests() });
  } catch (err) {
    console.error("admin quest create error:", err);
    return sendError(res, err, "Error creating quest");
  }
});

router.patch("/quests/:questId", async (req, res) => {
  try {
    const questId = Number(req.params.questId);
    if (!questId) return res.status(400).json({ message: "Invalid quest id" });
    const fields = [];
    const params = [];
    ["title", "description", "quest_type", "status", "starts_at", "ends_at", "participation_policy"].forEach((field) => {
      if (req.body?.[field] !== undefined) {
        fields.push(`${field} = ?`);
        params.push(field === "title" ? cleanText(req.body[field], 160) : field === "description" ? cleanText(req.body[field], 2000) : req.body[field]);
      }
    });
    if (req.body?.prize_amount !== undefined) {
      fields.push("prize_amount = ?");
      params.push(toInt(req.body.prize_amount));
    }
    if (!fields.length) throw new Error("No updates provided");
    fields.push("updated_by = ?");
    params.push(req.user.userId, questId);
    const [result] = await pool.query(`UPDATE clan_quests SET ${fields.join(", ")} WHERE id = ?`, params);
    if (!result.affectedRows) return res.status(404).json({ message: "Quest not found" });
    return res.json({ message: "Quest updated", quests: await listQuests() });
  } catch (err) {
    console.error("admin quest update error:", err);
    return sendError(res, err, "Error updating quest");
  }
});

router.post("/quests/:questId/calculate", async (req, res) => {
  try {
    const questId = Number(req.params.questId);
    if (!questId) return res.status(400).json({ message: "Invalid quest id" });
    const result = await calculateQuestScores(questId);
    return res.json({ ...result, quests: await listQuests() });
  } catch (err) {
    console.error("admin quest calculate error:", err);
    return sendError(res, err, "Error calculating quest");
  }
});

router.post("/quests/:questId/distribute", async (req, res) => {
  try {
    const questId = Number(req.params.questId);
    if (!questId) return res.status(400).json({ message: "Invalid quest id" });
    const result = await distributeQuestReward(questId, req.user.userId);
    return res.json({ ...result, quests: await listQuests() });
  } catch (err) {
    console.error("admin quest distribute error:", err);
    return sendError(res, err, "Error distributing quest reward");
  }
});

module.exports = router;
