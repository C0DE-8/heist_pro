const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken } = require("../middleware/auth");
const {
  normalizeAnswer,
  makeReferralCode,
  makeReferralLink,
  getRankPreview,
  isDuplicateError,
  maybeStartCountdown,
  recordAffiliateTaskProgress,
} = require("../services/heist.service");

const router = express.Router();

const PUBLIC_HEIST_FIELDS = `
  id, name, description, min_users, ticket_price,
  total_questions, prize_cop_points, status,
  countdown_duration_minutes, countdown_started_at, countdown_ends_at,
  starts_at, ends_at
`;

function countdownHasEnded(heist) {
  return heist?.countdown_ends_at && new Date(heist.countdown_ends_at).getTime() <= Date.now();
}

function heistClosedReason(heist) {
  if (!heist) return "Heist not found";
  if (heist.status === "completed" || heist.status === "cancelled" || heist.winner_user_id) {
    return "Heist is closed";
  }
  if (countdownHasEnded(heist)) {
    return "Heist has ended";
  }
  return null;
}

async function createHeistSubmission(conn, { heistId, userId }) {
  const [[heist]] = await conn.query(
    `SELECT id, status, countdown_ends_at, winner_user_id
     FROM heist
     WHERE id = ?
     LIMIT 1 FOR UPDATE`,
    [heistId]
  );
  if (!heist) return { status: 404, body: { message: "Heist not found" } };

  const closedReason = heistClosedReason(heist);
  if (closedReason) return { status: 400, body: { message: closedReason } };

  const [[participant]] = await conn.query(
    `SELECT id, affiliate_user_id
     FROM heist_participants
     WHERE heist_id = ? AND user_id = ? AND status IN ('joined', 'submitted')
     LIMIT 1 FOR UPDATE`,
    [heistId, userId]
  );
  if (!participant) return { status: 403, body: { message: "Join heist first" } };

  const [[activeSubmission]] = await conn.query(
    `SELECT id
     FROM heist_submissions
     WHERE heist_id = ? AND user_id = ? AND status = 'started'
     LIMIT 1 FOR UPDATE`,
    [heistId, userId]
  );
  if (activeSubmission) {
    return {
      status: 400,
      body: {
        message: "Submission already started",
        submission_id: activeSubmission.id,
      },
    };
  }

  const [[attemptRow]] = await conn.query(
    `SELECT COUNT(*) AS submitted_attempts
     FROM heist_submissions
     WHERE heist_id = ? AND user_id = ? AND status = 'submitted'`,
    [heistId, userId]
  );

  const submittedAttempts = Number(attemptRow.submitted_attempts || 0);
  if (submittedAttempts > 0) {
    return { status: 400, body: { message: "Already submitted" } };
  }

  const [result] = await conn.query(
    `INSERT INTO heist_submissions
      (heist_id, user_id, participant_id, affiliate_user_id, started_at, status)
     VALUES (?, ?, ?, ?, NOW(), 'started')`,
    [heistId, userId, participant.id, participant.affiliate_user_id]
  );

  return {
    status: 201,
    body: {
      submission_id: result.insertId,
      submitted_attempts: submittedAttempts,
    },
  };
}
// api/heists/available - list of pending/hold/started heists
router.get("/available", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT ${PUBLIC_HEIST_FIELDS}
       FROM heist
       WHERE status IN ('pending', 'hold', 'started')
       ORDER BY created_at DESC`
    );
    return res.json({ heists: rows });
  } catch (err) {
    console.error("available heists error:", err);
    return res.status(500).json({ message: "Error fetching heists" });
  }
});

router.get("/completed", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT id, name, prize_cop_points, winner_user_id, status
       FROM heist
       WHERE status = 'completed'
       ORDER BY updated_at DESC`
    );
    return res.json({ heists: rows });
  } catch (err) {
    console.error("completed heists error:", err);
    return res.status(500).json({ message: "Error fetching completed heists" });
  }
});

// api/heists/:id - get single heist by id
router.get("/:id", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [rows] = await pool.query(
      `SELECT ${PUBLIC_HEIST_FIELDS}
       FROM heist
       WHERE id = ?
       LIMIT 1`,
      [heistId]
    );

    if (!rows.length) {
      return res.status(404).json({ message: "Heist not found" });
    }

    return res.json({ heist: rows[0] });
  } catch (err) {
    console.error("get heist by id error:", err);
    return res.status(500).json({ message: "Error fetching heist" });
  }
});

// api/heists/:id/join - join a heist with optional referral code
router.post("/:id/join", authenticateToken, async (req, res) => {
  const heistId = Number(req.params.id);
  const userId = req.user.userId;
  const referralCode = req.body?.referral_code || null;
  if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[heist]] = await conn.query(
      `SELECT id, status, ticket_price, winner_user_id, countdown_ends_at
       FROM heist
       WHERE id = ?
       LIMIT 1 FOR UPDATE`,
      [heistId]
    );
    if (!heist) {
      await conn.rollback();
      return res.status(404).json({ message: "Heist not found" });
    }
    const closedReason = heistClosedReason(heist);
    if (closedReason) {
      await conn.rollback();
      return res.status(400).json({ message: closedReason });
    }

    const [existing] = await conn.query(
      "SELECT id FROM heist_participants WHERE heist_id = ? AND user_id = ? LIMIT 1",
      [heistId, userId]
    );
    if (existing.length) {
      await conn.rollback();
      return res.status(400).json({ message: "Already joined" });
    }

    const [[user]] = await conn.query(
      "SELECT id, cop_point FROM users WHERE id = ? LIMIT 1 FOR UPDATE",
      [userId]
    );
    if (!user) {
      await conn.rollback();
      return res.status(404).json({ message: "User not found" });
    }
    if (Number(user.cop_point) < Number(heist.ticket_price)) {
      await conn.rollback();
      return res.status(400).json({ message: "Insufficient cop_point" });
    }

    let affiliateUserId = null;
    let trackedReferralCode = null;
    if (referralCode) {
      const [[link]] = await conn.query(
        `SELECT id, affiliate_user_id, referral_code
         FROM affiliate_user_links
         WHERE heist_id = ? AND referral_code = ?
         LIMIT 1`,
        [heistId, referralCode]
      );
      if (link && Number(link.affiliate_user_id) === Number(userId)) {
        await conn.rollback();
        return res.status(400).json({ message: "You cannot use your own referral link" });
      }
      if (link) {
        affiliateUserId = link.affiliate_user_id;
        trackedReferralCode = link.referral_code;
      }
    }

    const [result] = await conn.query(
      `INSERT INTO heist_participants
        (heist_id, user_id, affiliate_user_id, referral_code, status)
       VALUES (?, ?, ?, ?, 'joined')`,
      [heistId, userId, affiliateUserId, trackedReferralCode]
    );

    await conn.query("UPDATE users SET cop_point = cop_point - ? WHERE id = ?", [
      heist.ticket_price,
      userId,
    ]);

    let affiliate_task_progress = [];
    if (affiliateUserId) {
      let referralInserted = false;
      try {
        await conn.query(
          `INSERT INTO affiliate_user_referrals
            (affiliate_user_id, referred_user_id, heist_id, referral_code)
           VALUES (?, ?, ?, ?)`,
          [affiliateUserId, userId, heistId, trackedReferralCode]
        );
        referralInserted = true;
        await conn.query(
          `UPDATE affiliate_user_links
           SET total_heist_joins = total_heist_joins + 1
           WHERE affiliate_user_id = ? AND heist_id = ?`,
          [affiliateUserId, heistId]
        );
      } catch (err) {
        if (!isDuplicateError(err)) throw err;
      }

      if (referralInserted) {
        affiliate_task_progress = await recordAffiliateTaskProgress(conn, heistId, affiliateUserId);
      }
    }

    const countdown_started = await maybeStartCountdown(conn, heistId);

    await conn.commit();
    return res.status(201).json({
      message: "Joined heist",
      participant_id: result.insertId,
      affiliate_user_id: affiliateUserId,
      referral_code: trackedReferralCode,
      charged_cop_point: heist.ticket_price,
      countdown_started,
      affiliate_task_progress,
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("join heist error:", err);
    if (isDuplicateError(err)) return res.status(400).json({ message: "Already joined" });
    return res.status(500).json({ message: "Error joining heist" });
  } finally {
    if (conn) conn.release();
  }
});

// api/heists/:id/play - get heist details and questions for playing (must be participant)
router.get("/:id/play", authenticateToken, async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const userId = req.user.userId;
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [[participant]] = await pool.query(
      "SELECT id FROM heist_participants WHERE heist_id = ? AND user_id = ? LIMIT 1",
      [heistId, userId]
    );
    if (!participant) return res.status(403).json({ message: "Join heist first" });

    const [[heist]] = await pool.query(
      `SELECT ${PUBLIC_HEIST_FIELDS}, winner_user_id
       FROM heist
       WHERE id = ?
       LIMIT 1`,
      [heistId]
    );
    if (!heist) return res.status(404).json({ message: "Heist not found" });
    const closedReason = heistClosedReason(heist);
    if (closedReason) return res.status(400).json({ message: closedReason });
    const { winner_user_id, ...publicHeist } = heist;

    const [questions] = await pool.query(
      `SELECT id, question_text, sort_order
       FROM heist_questions
       WHERE heist_id = ? AND is_active = 1
       ORDER BY sort_order ASC, id ASC`,
      [heistId]
    );

    return res.json({ heist: publicHeist, questions });
  } catch (err) {
    console.error("play heist error:", err);
    return res.status(500).json({ message: "Error loading heist" });
  }
});

// api/heists/:id/start - start a heist attempt (create submission)
router.post("/:id/start", authenticateToken, async (req, res) => {
  const heistId = Number(req.params.id);
  const userId = req.user.userId;
  if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const result = await createHeistSubmission(conn, { heistId, userId });
    if (result.status !== 201) {
      await conn.rollback();
      return res.status(result.status).json(result.body);
    }
    await conn.commit();
    return res.status(201).json(result.body);
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("start heist error:", err);
    return res.status(500).json({ message: "Error starting heist" });
  } finally {
    if (conn) conn.release();
  }
});

router.post("/:id/submit", authenticateToken, async (req, res) => {
  const heistId = Number(req.params.id);
  const userId = req.user.userId;
  const submissionId = Number(req.body?.submission_id);
  const answers = Array.isArray(req.body?.answers) ? req.body.answers : null;
  if (!heistId || !submissionId) {
    return res.status(400).json({ message: "Invalid submission" });
  }
  if (!answers) return res.status(400).json({ message: "Answers are required" });

  const answerMap = new Map();
  let totalTimeSeconds = 0;
  for (const item of answers) {
    const questionId = Number(item?.question_id);
    const answer = normalizeAnswer(item?.answer);
    const timeSpent = Number(item?.time_spent_seconds || 0);
    if (!questionId || !answer) {
      return res.status(400).json({ message: "Only true or false answers are allowed" });
    }
    if (!Number.isFinite(timeSpent) || timeSpent < 0) {
      return res.status(400).json({ message: "Invalid time spent" });
    }
    if (answerMap.has(questionId)) {
      return res.status(400).json({ message: "Duplicate question answer" });
    }
    const seconds = Math.floor(timeSpent);
    totalTimeSeconds += seconds;
    answerMap.set(questionId, { answer, timeSpentSeconds: seconds });
  }

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[submission]] = await conn.query(
      `SELECT id, heist_id, user_id, participant_id, status
       FROM heist_submissions
       WHERE id = ? AND heist_id = ? AND user_id = ?
       LIMIT 1 FOR UPDATE`,
      [submissionId, heistId, userId]
    );
    if (!submission) {
      await conn.rollback();
      return res.status(404).json({ message: "Submission not found" });
    }
    if (submission.status !== "started") {
      await conn.rollback();
      return res.status(400).json({ message: "Submission already closed" });
    }

    const [[heist]] = await conn.query(
      `SELECT id, status, countdown_ends_at, winner_user_id
       FROM heist
       WHERE id = ?
       LIMIT 1 FOR UPDATE`,
      [heistId]
    );
    if (!heist) {
      await conn.rollback();
      return res.status(404).json({ message: "Heist not found" });
    }
    const closedReason = heistClosedReason(heist);
    if (closedReason) {
      await conn.rollback();
      return res.status(400).json({ message: closedReason });
    }

    const [questions] = await conn.query(
      `SELECT id, correct_answer
       FROM heist_questions
       WHERE heist_id = ? AND is_active = 1
       ORDER BY sort_order ASC, id ASC`,
      [heistId]
    );
    if (!questions.length) {
      await conn.rollback();
      return res.status(400).json({ message: "No active questions" });
    }

    const validQuestionIds = new Set(questions.map((q) => Number(q.id)));
    for (const questionId of answerMap.keys()) {
      if (!validQuestionIds.has(questionId)) {
        await conn.rollback();
        return res.status(400).json({ message: "Invalid question answer" });
      }
    }

    let correctCount = 0;
    let wrongCount = 0;
    const answerRows = [];
    for (const question of questions) {
      const submitted = answerMap.get(Number(question.id));
      if (!submitted) continue;
      const isCorrect = submitted.answer === question.correct_answer ? 1 : 0;
      if (isCorrect) correctCount += 1;
      else wrongCount += 1;
      answerRows.push([
        submissionId,
        heistId,
        question.id,
        userId,
        submitted.answer,
        isCorrect,
        submitted.timeSpentSeconds,
      ]);
    }

    if (answerRows.length) {
      await conn.query(
        `INSERT INTO heist_submission_answers
          (submission_id, heist_id, question_id, user_id, submitted_answer, is_correct, answered_at, time_spent_seconds)
         VALUES ?`,
        [answerRows.map((row) => [...row.slice(0, 6), new Date(), row[6]])]
      );
    }

    const unansweredCount = questions.length - answerRows.length;
    const scorePercent = Number(((correctCount / questions.length) * 100).toFixed(2));

    await conn.query(
      `UPDATE heist_submissions
       SET submitted_at = NOW(),
           total_time_seconds = ?,
           correct_count = ?,
           wrong_count = ?,
           unanswered_count = ?,
           score_percent = ?,
           status = 'submitted'
       WHERE id = ?`,
      [totalTimeSeconds, correctCount, wrongCount, unansweredCount, scorePercent, submissionId]
    );

    await conn.query(
      "UPDATE heist_participants SET status = 'submitted' WHERE id = ?",
      [submission.participant_id]
    );

    const rank = await getRankPreview(conn, heistId, submissionId);
    await conn.commit();

    return res.json({
      submission: {
        id: submissionId,
        correct_count: correctCount,
        wrong_count: wrongCount,
        unanswered_count: unansweredCount,
        score_percent: scorePercent,
        total_time_seconds: totalTimeSeconds,
        status: "submitted",
      },
      rank,
    });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("submit heist error:", err);
    if (isDuplicateError(err)) return res.status(400).json({ message: "Answers already submitted" });
    return res.status(500).json({ message: "Error submitting answers" });
  } finally {
    if (conn) conn.release();
  }
});

// api/heists/:id/leaderboard - get leaderboard for a heist
router.get("/:id/leaderboard", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [rows] = await pool.query(
      `SELECT
         ROW_NUMBER() OVER (
           ORDER BY hs.correct_count DESC, hs.total_time_seconds ASC, hs.submitted_at ASC
         ) AS rank,
         u.username,
         hs.correct_count,
         hs.wrong_count,
         hs.unanswered_count,
         hs.score_percent,
         hs.total_time_seconds,
         hs.submitted_at
       FROM heist_submissions hs
       JOIN users u ON u.id = hs.user_id
       WHERE hs.heist_id = ? AND hs.status = 'submitted'
       ORDER BY hs.correct_count DESC, hs.total_time_seconds ASC, hs.submitted_at ASC`,
      [heistId]
    );

    return res.json({ leaderboard: rows });
  } catch (err) {
    console.error("leaderboard error:", err);
    return res.status(500).json({ message: "Error fetching leaderboard" });
  }
});

router.get("/:id/result", authenticateToken, async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const userId = req.user.userId;
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [[result]] = await pool.query(
      `SELECT id, correct_count, wrong_count, unanswered_count, score_percent,
              total_time_seconds, submitted_at, status
       FROM heist_submissions
       WHERE heist_id = ? AND user_id = ? AND status = 'submitted'
       ORDER BY submitted_at DESC
       LIMIT 1`,
      [heistId, userId]
    );
    if (!result) return res.status(404).json({ message: "Result not found" });

    const [[heist]] = await pool.query(
      `SELECT h.status, h.winner_user_id, h.prize_cop_points, u.username AS winner_username
       FROM heist h
       LEFT JOIN users u ON u.id = h.winner_user_id
       WHERE h.id = ?
       LIMIT 1`,
      [heistId]
    );

    const response = { result };
    if (heist?.status === "completed" && heist.winner_user_id) {
      response.winner = {
        user_id: heist.winner_user_id,
        username: heist.winner_username,
        prize_cop_points: heist.prize_cop_points,
      };
    }
    return res.json(response);
  } catch (err) {
    console.error("result error:", err);
    return res.status(500).json({ message: "Error fetching result" });
  }
});

// api/heists/:id/affiliate-link - create or get affiliate link for user and heist
router.post("/:id/affiliate-link", authenticateToken, async (req, res) => {
  const heistId = Number(req.params.id);
  const userId = req.user.userId;
  if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

  let conn;
  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[heist]] = await conn.query(
      "SELECT id, status FROM heist WHERE id = ? LIMIT 1",
      [heistId]
    );
    if (!heist) {
      await conn.rollback();
      return res.status(404).json({ message: "Heist not found" });
    }

    const [[existing]] = await conn.query(
      `SELECT id, referral_code, referral_link
       FROM affiliate_user_links
       WHERE affiliate_user_id = ? AND heist_id = ?
       LIMIT 1`,
      [userId, heistId]
    );

    if (existing) {
      const referralLink = makeReferralLink(req, heistId, existing.referral_code);
      if (existing.referral_link !== referralLink) {
        await conn.query("UPDATE affiliate_user_links SET referral_link = ? WHERE id = ?", [
          referralLink,
          existing.id,
        ]);
      }
      await conn.commit();
      return res.json({ referral_code: existing.referral_code, referral_link: referralLink });
    }

    const referralCode = makeReferralCode();
    const referralLink = makeReferralLink(req, heistId, referralCode);
    await conn.query(
      `INSERT INTO affiliate_user_links
        (affiliate_user_id, heist_id, referral_code, referral_link)
       VALUES (?, ?, ?, ?)`,
      [userId, heistId, referralCode, referralLink]
    );

    await conn.commit();
    return res.status(201).json({ referral_code: referralCode, referral_link: referralLink });
  } catch (err) {
    if (conn) await conn.rollback();
    console.error("affiliate link error:", err);
    return res.status(500).json({ message: "Error creating affiliate link" });
  } finally {
    if (conn) conn.release();
  }
});

// api/heists/:id/ref/:code - landing endpoint for referral links (no auth required)
router.get("/:id/ref/:code", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const code = req.params.code;
    if (!heistId || !code) return res.status(400).json({ message: "Invalid referral code" });

    const [[row]] = await pool.query(
      `SELECT
         a.id AS link_id,
         a.affiliate_user_id,
         a.referral_code,
         u.username AS affiliate_username,
         h.id AS heist_id,
         h.name,
         h.description,
         h.ticket_price,
         h.prize_cop_points,
         h.status,
         h.starts_at,
         h.ends_at
       FROM affiliate_user_links a
       JOIN heist h ON h.id = a.heist_id
       JOIN users u ON u.id = a.affiliate_user_id
       WHERE a.heist_id = ? AND a.referral_code = ?
       LIMIT 1`,
      [heistId, code]
    );
    if (!row) return res.status(404).json({ message: "Referral not found" });
    if (row.status === "completed" || row.status === "cancelled") {
      return res.status(400).json({ message: "Heist is not joinable" });
    }

    await pool.query(
      "UPDATE affiliate_user_links SET total_clicks = total_clicks + 1 WHERE id = ?",
      [row.link_id]
    );

    return res.json({
      heist: {
        id: row.heist_id,
        name: row.name,
        description: row.description,
        ticket_price: row.ticket_price,
        prize_cop_points: row.prize_cop_points,
        status: row.status,
        starts_at: row.starts_at,
        ends_at: row.ends_at,
      },
      affiliate: {
        user_id: row.affiliate_user_id,
        username: row.affiliate_username,
        referral_code: row.referral_code,
      },
    });
  } catch (err) {
    console.error("referral landing error:", err);
    return res.status(500).json({ message: "Error loading referral" });
  }
});

module.exports = router;
