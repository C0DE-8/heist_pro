const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const { noticePayload, sendPushToUser } = require("../services/push.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

async function ensureUserNoticesTable(db = pool) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS user_notices (
      id int(11) NOT NULL AUTO_INCREMENT,
      user_id int(11) DEFAULT NULL,
      type varchar(64) NOT NULL DEFAULT 'admin_notice',
      title varchar(160) NOT NULL,
      message text NOT NULL,
      path varchar(255) DEFAULT '/dashboard',
      priority enum('normal','important') NOT NULL DEFAULT 'important',
      created_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_user_notices_user_created (user_id, created_at),
      KEY idx_user_notices_created_by (created_by)
    )`
  );
}

function cleanString(value, maxLength) {
  const text = String(value || "").trim();
  return maxLength ? text.slice(0, maxLength) : text;
}

function cleanPath(value) {
  const path = cleanString(value || "/dashboard", 255);
  return path.startsWith("/") ? path : "/dashboard";
}

async function getTargetUserIds({ userId, allUsers }) {
  if (allUsers) {
    const [rows] = await pool.query(
      "SELECT id FROM users WHERE role = 'user' AND is_verified = 1 AND is_blocked = 0"
    );
    return rows.map((row) => Number(row.id)).filter(Boolean);
  }

  const id = Number(userId);
  if (!id) return [];

  const [[user]] = await pool.query(
    "SELECT id FROM users WHERE id = ? AND role = 'user' LIMIT 1",
    [id]
  );
  return user ? [Number(user.id)] : [];
}

router.post("/notice", async (req, res) => {
  try {
    await ensureUserNoticesTable();

    const title = cleanString(req.body?.title, 160);
    const message = cleanString(req.body?.message);
    const type = cleanString(req.body?.type || "admin_notice", 64) || "admin_notice";
    const path = cleanPath(req.body?.path);
    const priority = req.body?.priority === "normal" ? "normal" : "important";
    const allUsers = Boolean(req.body?.all_users);
    const targetUserIds = await getTargetUserIds({
      userId: req.body?.user_id,
      allUsers,
    });

    if (!title) return res.status(400).json({ message: "title is required" });
    if (!message) return res.status(400).json({ message: "message is required" });
    if (!targetUserIds.length) return res.status(404).json({ message: "No target users found" });

    const rows = targetUserIds.map((userId) => [
      userId,
      type,
      title,
      message,
      path,
      priority,
      req.user.userId,
    ]);

    const [result] = await pool.query(
      `INSERT INTO user_notices
        (user_id, type, title, message, path, priority, created_by)
       VALUES ?`,
      [rows]
    );

    const noticeIds = targetUserIds.map((userId, index) => ({
      userId,
      noticeId: Number(result.insertId) + index,
    }));

    await Promise.allSettled(
      noticeIds.map(({ userId, noticeId }) =>
        sendPushToUser(
          userId,
          noticePayload({
            alertId: `notice:${noticeId}`,
            type,
            title,
            body: message,
            path,
          })
        )
      )
    );

    return res.status(201).json({
      message: "Notice sent",
      target_count: targetUserIds.length,
      notice_ids: noticeIds.map((item) => item.noticeId),
    });
  } catch (err) {
    console.error("admin notice send error:", err);
    return res.status(500).json({ message: "Error sending notice" });
  }
});

module.exports = router;
