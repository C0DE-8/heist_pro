const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const { normalizeAnswer, finalizeHeist } = require("../services/heist.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);

function boolToTinyInt(value) {
  return value === true || value === 1 || value === "1" || value === "true" ? 1 : 0;
}

async function getAssignedQuestionCount(conn, heistId) {
  const [[countRow]] = await conn.query(
    "SELECT COUNT(*) AS total FROM heist_questions WHERE heist_id = ? AND is_active = 1",
    [heistId]
  );
  return Number(countRow?.total || 0);
}

async function syncHeistQuestionCount(conn, heistId) {
  const total = await getAssignedQuestionCount(conn, heistId);
  await conn.query("UPDATE heist SET total_questions = ? WHERE id = ?", [total, heistId]);
  return total;
}

async function assignQuestionBankToHeist(conn, { heistId, questionCount, adminId }) {
  const desiredCount = Number(questionCount || 0);
  if (!Number.isInteger(desiredCount) || desiredCount < 0) {
    return { status: 400, body: { message: "Question count must be 0 or greater" } };
  }
  if (desiredCount === 0) {
    const total = await syncHeistQuestionCount(conn, heistId);
    return { status: 200, body: { message: "No questions assigned", total_questions: total } };
  }

  const currentCount = await getAssignedQuestionCount(conn, heistId);
  if (currentCount > desiredCount) {
    return {
      status: 400,
      body: {
        message: `This heist already has ${currentCount} assigned questions. Assigned bank questions are not returned to unused automatically.`,
      },
    };
  }

  const needed = desiredCount - currentCount;
  if (needed <= 0) {
    await conn.query("UPDATE heist SET questions_per_session = ? WHERE id = ?", [
      desiredCount,
      heistId,
    ]);
    return { status: 200, body: { message: "Question count already assigned", total_questions: currentCount } };
  }

  const [[availableRow]] = await conn.query(
    "SELECT COUNT(*) AS total FROM heist_questions WHERE heist_id IS NULL AND is_active = 1"
  );
  if (Number(availableRow?.total || 0) < needed) {
    return {
      status: 400,
      body: {
        message: `Not enough unused bank questions. Needed ${needed}, available ${Number(availableRow?.total || 0)}.`,
      },
    };
  }

  const [questions] = await conn.query(
    `SELECT id
     FROM heist_questions
     WHERE heist_id IS NULL AND is_active = 1
     ORDER BY RAND()
     LIMIT ? FOR UPDATE`,
    [needed]
  );
  if (questions.length < needed) {
    return { status: 400, body: { message: "Not enough unused bank questions" } };
  }

  await conn.query(
    `UPDATE heist_questions
     SET heist_id = ?, assigned_at = NOW(), assigned_by = ?
     WHERE id IN (${questions.map(() => "?").join(", ")})`,
    [heistId, adminId, ...questions.map((question) => question.id)]
  );

  const total = await syncHeistQuestionCount(conn, heistId);
  await conn.query("UPDATE heist SET questions_per_session = ? WHERE id = ?", [total, heistId]);
  return { status: 200, body: { message: "Questions assigned", total_questions: total } };
}

router.post("/", async (req, res) => {
  let conn;
  try {
    const {
      name,
      description,
      min_users,
      ticket_price,
      prize_cop_points,
      questions_per_session,
      question_count,
      countdown_duration_minutes,
      starts_at,
      ends_at,
    } = req.body || {};

    if (!name) return res.status(400).json({ message: "Name is required" });

    const countToUse = Number(question_count ?? questions_per_session ?? 0);
    if (!Number.isInteger(countToUse) || countToUse < 0) {
      return res.status(400).json({ message: "Question count must be 0 or greater" });
    }

    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [result] = await conn.query(
      `INSERT INTO heist
        (name, description, min_users, ticket_price,
         prize_cop_points, questions_per_session, countdown_duration_minutes,
         starts_at, ends_at, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name,
        description || null,
        Number(min_users || 1),
        Number(ticket_price || 0),
        Number(prize_cop_points || 0),
        countToUse,
        Number(countdown_duration_minutes || 10),
        starts_at || null,
        ends_at || null,
        req.user.userId,
      ]
    );

    if (countToUse > 0) {
      const assignment = await assignQuestionBankToHeist(conn, {
        heistId: result.insertId,
        questionCount: countToUse,
        adminId: req.user.userId,
      });
      if (assignment.status >= 400) {
        await conn.rollback();
        return res.status(assignment.status).json(assignment.body);
      }
    }

    await conn.commit();
    return res.status(201).json({ message: "Heist created", heist_id: result.insertId });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin create heist error:", err);
    return res.status(500).json({ message: "Error creating heist" });
  } finally {
    if (conn) conn.release();
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
         h.questions_per_session,
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

router.patch("/:id", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const updates = [];
    const params = [];

    if (req.body?.questions_per_session !== undefined) {
      const questionsPerSession = Number(req.body.questions_per_session);
      if (!Number.isInteger(questionsPerSession) || questionsPerSession < 0) {
        return res.status(400).json({ message: "questions_per_session must be 0 or greater" });
      }
      updates.push("questions_per_session = ?");
      params.push(questionsPerSession);
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(heistId);
    const [result] = await pool.query(
      `UPDATE heist SET ${updates.join(", ")} WHERE id = ?`,
      params
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Heist not found" });

    const [[heist]] = await pool.query(
      `SELECT id, total_questions, questions_per_session
       FROM heist
       WHERE id = ?
       LIMIT 1`,
      [heistId]
    );

    return res.json({ message: "Heist updated", heist });
  } catch (err) {
    console.error("admin update heist error:", err);
    return res.status(500).json({ message: "Error updating heist" });
  }
});

router.get("/question-bank", async (req, res) => {
  try {
    const status = String(req.query.status || "all").toLowerCase();
    const where = [];
    if (status === "unused" || status === "available") where.push("q.heist_id IS NULL");
    if (status === "assigned" || status === "used") where.push("q.heist_id IS NOT NULL");
    const whereSql = where.length ? `WHERE ${where.join(" AND ")}` : "";

    const [questions] = await pool.query(
      `SELECT
         q.id,
         q.heist_id,
         h.name AS heist_name,
         q.question_text,
         q.correct_answer,
         q.sort_order,
         q.is_active,
         q.assigned_at,
         q.created_at,
         CASE WHEN q.heist_id IS NULL THEN 'unused' ELSE 'assigned' END AS usage_status
       FROM heist_questions q
       LEFT JOIN heist h ON h.id = q.heist_id
       ${whereSql}
       ORDER BY q.heist_id IS NOT NULL ASC, q.created_at DESC, q.id DESC`
    );

    const [[summary]] = await pool.query(
      `SELECT
         COUNT(*) AS total,
         COUNT(CASE WHEN heist_id IS NULL THEN 1 END) AS unused,
         COUNT(CASE WHEN heist_id IS NOT NULL THEN 1 END) AS assigned,
         COUNT(CASE WHEN is_active = 1 THEN 1 END) AS active
       FROM heist_questions`
    );

    return res.json({ questions, summary });
  } catch (err) {
    console.error("admin question bank list error:", err);
    return res.status(500).json({ message: "Error fetching question bank" });
  }
});

router.post("/question-bank/questions", async (req, res) => {
  try {
    const questions = Array.isArray(req.body) ? req.body : req.body?.questions;
    if (!Array.isArray(questions) || !questions.length) {
      return res.status(400).json({ message: "Questions are required" });
    }

    const rows = [];
    for (const item of questions) {
      const answer = normalizeAnswer(item?.correct_answer);
      const text = String(item?.question_text || "").trim();
      if (!text || !answer) {
        return res.status(400).json({ message: "Only true or false answers are allowed" });
      }
      rows.push([null, text, answer, Number(item.sort_order || 1), 1]);
    }

    const [result] = await pool.query(
      `INSERT INTO heist_questions
        (heist_id, question_text, correct_answer, sort_order, is_active)
       VALUES ?`,
      [rows]
    );

    return res.status(201).json({
      message: "Bank questions added",
      inserted_count: result.affectedRows,
    });
  } catch (err) {
    console.error("admin add bank questions error:", err);
    return res.status(500).json({ message: "Error adding bank questions" });
  }
});

router.patch("/question-bank/questions/:questionId", async (req, res) => {
  try {
    const questionId = Number(req.params.questionId);
    if (!questionId) return res.status(400).json({ message: "Invalid question" });

    const updates = [];
    const params = [];

    if (req.body?.question_text !== undefined) {
      const text = String(req.body.question_text || "").trim();
      if (!text) return res.status(400).json({ message: "Question text is required" });
      updates.push("question_text = ?");
      params.push(text);
    }

    if (req.body?.correct_answer !== undefined) {
      const answer = normalizeAnswer(req.body.correct_answer);
      if (!answer) return res.status(400).json({ message: "Only true or false answers are allowed" });
      updates.push("correct_answer = ?");
      params.push(answer);
    }

    if (req.body?.is_active !== undefined) {
      updates.push("is_active = ?");
      params.push(boolToTinyInt(req.body.is_active));
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(questionId);
    const [result] = await pool.query(
      `UPDATE heist_questions SET ${updates.join(", ")} WHERE id = ?`,
      params
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Question not found" });

    const [[question]] = await pool.query(
      `SELECT id, heist_id, question_text, correct_answer, sort_order, is_active, assigned_at, created_at
       FROM heist_questions
       WHERE id = ?
       LIMIT 1`,
      [questionId]
    );
    if (question?.heist_id) await syncHeistQuestionCount(pool, question.heist_id);

    return res.json({ message: "Question updated", question });
  } catch (err) {
    console.error("admin update bank question error:", err);
    return res.status(500).json({ message: "Error updating bank question" });
  }
});

router.delete("/question-bank/questions/:questionId", async (req, res) => {
  try {
    const questionId = Number(req.params.questionId);
    if (!questionId) return res.status(400).json({ message: "Invalid question" });

    const [[question]] = await pool.query(
      "SELECT id, heist_id FROM heist_questions WHERE id = ? LIMIT 1",
      [questionId]
    );
    if (!question) return res.status(404).json({ message: "Question not found" });
    if (question.heist_id) {
      return res.status(400).json({
        message: "Assigned questions are already used by a heist and cannot be deleted from the bank",
      });
    }

    await pool.query("DELETE FROM heist_questions WHERE id = ?", [questionId]);
    return res.json({ message: "Bank question deleted" });
  } catch (err) {
    console.error("admin delete bank question error:", err);
    return res.status(500).json({ message: "Error deleting bank question" });
  }
});

router.post("/:id/questions/assign", async (req, res) => {
  const heistId = Number(req.params.id);
  const questionCount = Number(req.body?.question_count ?? req.body?.questions_per_session ?? 0);
  if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[heist]] = await conn.query(
      "SELECT id FROM heist WHERE id = ? LIMIT 1 FOR UPDATE",
      [heistId]
    );
    if (!heist) {
      await conn.rollback();
      return res.status(404).json({ message: "Heist not found" });
    }

    const assignment = await assignQuestionBankToHeist(conn, {
      heistId,
      questionCount,
      adminId: req.user.userId,
    });
    if (assignment.status >= 400) {
      await conn.rollback();
      return res.status(assignment.status).json(assignment.body);
    }

    await conn.commit();
    return res.json(assignment.body);
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("admin assign heist questions error:", err);
    return res.status(500).json({ message: "Error assigning heist questions" });
  } finally {
    if (conn) conn.release();
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
