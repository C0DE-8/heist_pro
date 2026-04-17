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
      prize_cop_points,
      countdown_duration_minutes,
      starts_at,
      ends_at,
    } = req.body || {};

    if (!name) return res.status(400).json({ message: "Name is required" });

    const [result] = await pool.query(
      `INSERT INTO heist
        (name, description, min_users, ticket_price,
         prize_cop_points, countdown_duration_minutes, starts_at, ends_at, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name,
        description || null,
        Number(min_users || 1),
        Number(ticket_price || 0),
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

router.delete("/:id/questions/:questionId", async (req, res) => {
  const heistId = Number(req.params.id);
  const questionId = Number(req.params.questionId);
  if (!heistId || !questionId) {
    return res.status(400).json({ message: "Invalid question" });
  }

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [result] = await conn.query(
      "DELETE FROM heist_questions WHERE id = ? AND heist_id = ?",
      [questionId, heistId]
    );

    if (!result.affectedRows) {
      await conn.rollback();
      return res.status(404).json({ message: "Question not found" });
    }

    const [[countRow]] = await conn.query(
      "SELECT COUNT(*) AS total FROM heist_questions WHERE heist_id = ? AND is_active = 1",
      [heistId]
    );

    await conn.query("UPDATE heist SET total_questions = ? WHERE id = ?", [
      countRow.total,
      heistId,
    ]);

    await conn.commit();
    return res.json({ message: "Question deleted", total_questions: countRow.total });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin delete question error:", err);
    return res.status(500).json({ message: "Error deleting question" });
  } finally {
    if (conn) conn.release();
  }
});

router.get("/:id/affiliate-tasks", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [rows] = await pool.query(
      `SELECT id, heist_id, required_joins, reward_cop_points, is_active
       FROM affiliate_tasks
       WHERE heist_id = ?
       ORDER BY required_joins ASC, id ASC`,
      [heistId]
    );

    return res.json({ tasks: rows });
  } catch (err) {
    console.error("admin affiliate tasks list error:", err);
    return res.status(500).json({ message: "Error fetching affiliate tasks" });
  }
});

router.post("/:id/affiliate-tasks", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const requiredJoins = Number(req.body?.required_joins);
    const rewardCopPoints = Number(req.body?.reward_cop_points);
    const isActive = req.body?.is_active === undefined ? 1 : boolToTinyInt(req.body.is_active);

    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });
    if (!Number.isInteger(requiredJoins) || requiredJoins <= 0) {
      return res.status(400).json({ message: "required_joins must be greater than 0" });
    }
    if (!Number.isInteger(rewardCopPoints) || rewardCopPoints <= 0) {
      return res.status(400).json({ message: "reward_cop_points must be greater than 0" });
    }

    const [heists] = await pool.query("SELECT id FROM heist WHERE id = ? LIMIT 1", [heistId]);
    if (!heists.length) return res.status(404).json({ message: "Heist not found" });

    const [result] = await pool.query(
      `INSERT INTO affiliate_tasks
        (heist_id, required_joins, reward_cop_points, is_active)
       VALUES (?, ?, ?, ?)`,
      [heistId, requiredJoins, rewardCopPoints, isActive]
    );

    return res.status(201).json({
      message: "Affiliate task created",
      task_id: result.insertId,
    });
  } catch (err) {
    console.error("admin affiliate task create error:", err);
    return res.status(500).json({ message: "Error creating affiliate task" });
  }
});

router.patch("/:id/affiliate-tasks/:taskId", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const taskId = Number(req.params.taskId);
    if (!heistId || !taskId) return res.status(400).json({ message: "Invalid affiliate task" });

    const updates = [];
    const params = [];

    if (req.body?.required_joins !== undefined) {
      const requiredJoins = Number(req.body.required_joins);
      if (!Number.isInteger(requiredJoins) || requiredJoins <= 0) {
        return res.status(400).json({ message: "required_joins must be greater than 0" });
      }
      updates.push("required_joins = ?");
      params.push(requiredJoins);
    }

    if (req.body?.reward_cop_points !== undefined) {
      const rewardCopPoints = Number(req.body.reward_cop_points);
      if (!Number.isInteger(rewardCopPoints) || rewardCopPoints <= 0) {
        return res.status(400).json({ message: "reward_cop_points must be greater than 0" });
      }
      updates.push("reward_cop_points = ?");
      params.push(rewardCopPoints);
    }

    if (req.body?.is_active !== undefined) {
      updates.push("is_active = ?");
      params.push(boolToTinyInt(req.body.is_active));
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(taskId, heistId);
    const [result] = await pool.query(
      `UPDATE affiliate_tasks
       SET ${updates.join(", ")}
       WHERE id = ? AND heist_id = ?`,
      params
    );

    if (!result.affectedRows) return res.status(404).json({ message: "Affiliate task not found" });
    return res.json({ message: "Affiliate task updated" });
  } catch (err) {
    console.error("admin affiliate task update error:", err);
    return res.status(500).json({ message: "Error updating affiliate task" });
  }
});

router.delete("/:id/affiliate-tasks/:taskId", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const taskId = Number(req.params.taskId);
    if (!heistId || !taskId) return res.status(400).json({ message: "Invalid affiliate task" });

    const [result] = await pool.query(
      "DELETE FROM affiliate_tasks WHERE id = ? AND heist_id = ?",
      [taskId, heistId]
    );

    if (!result.affectedRows) return res.status(404).json({ message: "Affiliate task not found" });
    return res.json({ message: "Affiliate task deleted" });
  } catch (err) {
    console.error("admin affiliate task delete error:", err);
    return res.status(500).json({ message: "Error deleting affiliate task" });
  }
});

router.get("/:id/affiliate-tasks/progress", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const userId = req.query?.user_id ? Number(req.query.user_id) : null;
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });
    if (req.query?.user_id && !userId) return res.status(400).json({ message: "Invalid user id" });

    const params = [heistId];
    let userFilter = "";
    if (userId) {
      userFilter = " AND p.user_id = ?";
      params.push(userId);
    }

    const [rows] = await pool.query(
      `SELECT
         at.id AS task_id,
         at.required_joins,
         at.reward_cop_points,
         at.is_active,
         p.id AS progress_id,
         p.user_id,
         u.username,
         p.current_joins,
         p.is_completed,
         p.rewarded_at
       FROM affiliate_tasks at
       LEFT JOIN affiliate_task_progress p ON p.task_id = at.id
       LEFT JOIN users u ON u.id = p.user_id
       WHERE at.heist_id = ?
         ${userFilter}
       ORDER BY at.required_joins ASC, at.id ASC, p.current_joins DESC, p.id ASC`,
      params
    );

    return res.json({ progress: rows });
  } catch (err) {
    console.error("admin affiliate progress error:", err);
    return res.status(500).json({ message: "Error fetching affiliate progress" });
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
