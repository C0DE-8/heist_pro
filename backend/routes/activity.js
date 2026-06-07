const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");
const { getClientIp, getDeviceKey, cleanUserAgent, recordActivity } = require("../services/godEyes.service");

const router = express.Router();

router.post("/visit", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const path = String(req.body?.path || "").trim().slice(0, 255) || "/dashboard";
    const deviceKey = getDeviceKey(req);

    await recordActivity({
      userId,
      eventType: "visit",
      path,
      method: "VIEW",
      ipAddress: getClientIp(req),
      userAgent: cleanUserAgent(req),
      deviceKey,
      metadata: {
        title: String(req.body?.title || "").trim().slice(0, 160) || null,
      },
    });

    await pool.query("UPDATE users SET last_seen_at = CURRENT_TIMESTAMP WHERE id = ?", [userId]);
    return res.json({ ok: true });
  } catch (err) {
    console.error("activity visit error:", err);
    return res.status(500).json({ message: "Error recording activity" });
  }
});

module.exports = router;
