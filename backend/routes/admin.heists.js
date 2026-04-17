const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const { normalizeAnswer, finalizeHeist } = require("../services/heist.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function boolToTinyInt(value) {
  return value === true || value === 1 || value === "1" || value === "true" ? 1 : 0;
}

router.post("/", async (req, res) => {
  try {
    const {
      name,
      description,
      min_users,
      ticket_price,
      retry_ticket_price,
      allow_retry,
      prize_cop_points,
      countdown_duration_minutes,
      starts_at,
      ends_at,
    } = req.body || {};

    if (!name) return res.status(400).json({ message: "Name is required" });

    const [result] = await pool.query(
      `INSERT INTO heist
        (name, description, min_users, ticket_price, retry_ticket_price, allow_retry,
         prize_cop_points, countdown_duration_minutes, starts_at, ends_at, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name,
        description || null,
        Number(min_users || 1),
        Number(ticket_price || 0),
        Number(retry_ticket_price || 0),
        boolToTinyInt(allow_retry),
        Number(prize_cop_points || 0),
        Number(countdown_duration_minutes || 10),
        starts_at || null,
        ends_at || null,
        req.user.userId,
      ]
    );

    return res.status(201).json({ message: "Heist created", heist_id: result.insertId });
  } catch (err) {
    console.error("admin create heist error:", err);
    return res.status(500).json({ message: "Error creating heist" });
  }
});

router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT
         h.id,
         h.name,
         h.status,
         h.prize_cop_points,
         h.total_questions,
         h.created_at,
         COUNT(DISTINCT hp.id) AS total_participants,
         COUNT(DISTINCT hs.id) AS total_submissions
       FROM heist h
       LEFT JOIN heist_participants hp ON hp.heist_id = h.id
       LEFT JOIN heist_submissions hs ON hs.heist_id = h.id AND hs.status = 'submitted'
       GROUP BY h.id
       ORDER BY h.created_at DESC`
    );
    return res.json({ heists: rows });
  } catch (err) {
    console.error("admin heists list error:", err);
    return res.status(500).json({ message: "Error fetching heists" });
  }
});

router.post("/:id/questions", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const questions = Array.isArray(req.body) ? req.body : req.body?.questions;
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });
    if (!Array.isArray(questions) || !questions.length) {
      return res.status(400).json({ message: "Questions are required" });
    }

    const [heists] = await pool.query("SELECT id FROM heist WHERE id = ? LIMIT 1", [heistId]);
    if (!heists.length) return res.status(404).json({ message: "Heist not found" });

    const rows = [];
    for (const item of questions) {
      const answer = normalizeAnswer(item?.correct_answer);
      if (!item?.question_text || !answer) {
        return res.status(400).json({ message: "Only true or false answers are allowed" });
      }
      rows.push([heistId, item.question_text, answer, Number(item.sort_order || 1), 1]);
    }

    await pool.query(
      `INSERT INTO heist_questions
        (heist_id, question_text, correct_answer, sort_order, is_active)
       VALUES ?`,
      [rows]
    );

    const [[countRow]] = await pool.query(
      "SELECT COUNT(*) AS total FROM heist_questions WHERE heist_id = ? AND is_active = 1",
      [heistId]
    );
    await pool.query("UPDATE heist SET total_questions = ? WHERE id = ?", [
      countRow.total,
      heistId,
    ]);

    return res.status(201).json({ message: "Questions added", total_questions: countRow.total });
  } catch (err) {
    console.error("admin add questions error:", err);
    return res.status(500).json({ message: "Error adding questions" });
  }
});

router.get("/:id/questions", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [rows] = await pool.query(
      `SELECT id, heist_id, question_text, correct_answer, sort_order, is_active, created_at
       FROM heist_questions
       WHERE heist_id = ?
       ORDER BY sort_order ASC, id ASC`,
      [heistId]
    );
    return res.json({ questions: rows });
  } catch (err) {
    console.error("admin get questions error:", err);
    return res.status(500).json({ message: "Error fetching questions" });
  }
});

router.patch("/:id/status", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const status = String(req.body?.status || "").trim().toLowerCase();
    const allowed = new Set(["pending", "hold", "started", "completed", "cancelled"]);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });
    if (!allowed.has(status)) return res.status(400).json({ message: "Invalid status" });

    if (status === "started") {
      const [result] = await pool.query(
        `UPDATE heist
         SET status = 'started',
             countdown_started_at = COALESCE(countdown_started_at, NOW()),
             countdown_ends_at = COALESCE(
               countdown_ends_at,
               ends_at,
               DATE_ADD(NOW(), INTERVAL countdown_duration_minutes MINUTE)
             )
         WHERE id = ?`,
        [heistId]
      );
      if (!result.affectedRows) return res.status(404).json({ message: "Heist not found" });
    } else {
      const [result] = await pool.query("UPDATE heist SET status = ? WHERE id = ?", [
        status,
        heistId,
      ]);
      if (!result.affectedRows) return res.status(404).json({ message: "Heist not found" });
    }

    return res.json({ message: "Status updated", status });
  } catch (err) {
    console.error("admin status error:", err);
    return res.status(500).json({ message: "Error updating status" });
  }
});

router.post("/:id/finalize", async (req, res) => {
  const heistId = Number(req.params.id);
  if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const result = await finalizeHeist(conn, heistId);
    if (!result.found) {
      await conn.rollback();
      return res.status(404).json({ message: "Heist not found" });
    }
    if (result.already_completed) {
      await conn.rollback();
      return res.status(400).json({ message: "Heist already completed" });
    }

    await conn.commit();
    return res.json({
      message: "Heist finalized",
      winner: result.winner,
      awarded_points: result.awarded_points,
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin finalize error:", err);
    return res.status(500).json({ message: "Error finalizing heist" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
