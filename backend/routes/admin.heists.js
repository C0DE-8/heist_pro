const express = require("express");
const { pool } = require("../conf/db");
const { authenticateToken, authenticateAdmin } = require("../middleware/auth");
const {
  ensureHeistMaxUsersColumn,
  ensureHeistDemoSubmissionsTable,
  ensureHeistDemoUsersTable,
  ensureHeistWinnerDemoColumn,
  normalizeAnswer,
  finalizeHeist,
} = require("../services/heist.service");
const {
  ensureAutoHeistTables,
  getAutoHeistSettings,
  updateAutoHeistSettings,
  maybeCreateAutoHeist,
} = require("../services/autoHeist.service");
const {
  ensurePromoTables,
  normalizePromoCode,
  parsePositiveInt,
} = require("../services/promo.service");

const router = express.Router();

router.use(authenticateToken, authenticateAdmin);
router.use(async (req, res, next) => {
  try {
    await ensureHeistMaxUsersColumn(pool);
    await ensureHeistDemoUsersTable(pool);
    await ensureHeistDemoSubmissionsTable(pool);
    await ensureHeistWinnerDemoColumn(pool);
    await ensureAutoHeistTables(pool);
    await ensurePromoTables(pool);
    next();
  } catch (err) {
    console.error("admin heist schema check error:", err);
    res.status(500).json({ message: "Error preparing heist schema" });
  }
});

function boolToTinyInt(value) {
  return value === true || value === 1 || value === "1" || value === "true" ? 1 : 0;
}

function normalizeDateTimeInput(value) {
  if (value === undefined) return undefined;
  if (value === null || value === "") return null;

  const raw = String(value).trim();
  if (!raw) return null;

  const parsed = new Date(raw);
  if (Number.isNaN(parsed.getTime())) return false;

  const normalized = raw.replace("T", " ");
  return normalized.length === 16 ? `${normalized}:00` : normalized;
}

function parseMinUsers(value) {
  const minUsers = Number(value || 1);
  if (!Number.isInteger(minUsers) || minUsers < 1) {
    return { ok: false, message: "min_users must be 1 or greater" };
  }
  return { ok: true, value: minUsers };
}

function parseMaxUsers(value, minUsers) {
  if (value === undefined || value === null || value === "") {
    return { ok: true, value: null };
  }

  const maxUsers = Number(value);
  if (!Number.isInteger(maxUsers) || maxUsers < 0) {
    return { ok: false, message: "max_users must be 0 or greater" };
  }
  if (maxUsers === 0) return { ok: true, value: null };
  if (maxUsers < minUsers) {
    return { ok: false, message: "max_users must be greater than or equal to min_users" };
  }
  return { ok: true, value: maxUsers };
}

function parseNonNegativeInt(value, field) {
  const number = Number(value || 0);
  if (!Number.isInteger(number) || number < 0) {
    return { ok: false, message: `${field} must be 0 or greater` };
  }
  return { ok: true, value: number };
}

function normalizeDemoSubmittedAt(value) {
  const normalized = normalizeDateTimeInput(value);
  if (normalized === undefined || normalized === null) return new Date();
  return normalized;
}

function calculateDemoScore({ correctCount, wrongCount, unansweredCount, fallbackTotal }) {
  const total = Number(fallbackTotal || 0) || correctCount + wrongCount + unansweredCount;
  if (!total) return 0;
  return Number(((correctCount / total) * 100).toFixed(2));
}

function cleanDemoDisplayName(value) {
  return String(value || "").trim().slice(0, 120);
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

// Create heist
router.post("/", async (req, res) => {
  let conn;
  try {
    const {
      name,
      description,
      min_users,
      max_users,
      ticket_price,
      prize_cop_points,
      questions_per_session,
      question_count,
      countdown_duration_minutes,
      starts_at,
      ends_at,
    } = req.body || {};

    if (!name) return res.status(400).json({ message: "Name is required" });

    const minUsersParsed = parseMinUsers(min_users);
    if (!minUsersParsed.ok) return res.status(400).json({ message: minUsersParsed.message });
    const maxUsersParsed = parseMaxUsers(max_users, minUsersParsed.value);
    if (!maxUsersParsed.ok) return res.status(400).json({ message: maxUsersParsed.message });

    const countToUse = Number(question_count ?? questions_per_session ?? 0);
    if (!Number.isInteger(countToUse) || countToUse < 0) {
      return res.status(400).json({ message: "Question count must be 0 or greater" });
    }

    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [result] = await conn.query(
      `INSERT INTO heist
        (name, description, min_users, max_users, ticket_price,
         prize_cop_points, questions_per_session, countdown_duration_minutes,
         starts_at, ends_at, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name,
        description || null,
        minUsersParsed.value,
        maxUsersParsed.value,
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

// List heists
router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT
         h.id,
         h.name,
         h.description,
         h.status,
         h.min_users,
         h.max_users,
         h.ticket_price,
         h.prize_cop_points,
         h.total_questions,
         h.questions_per_session,
         h.submissions_locked,
         h.countdown_started_at,
         h.countdown_duration_minutes,
         h.countdown_ends_at,
         h.starts_at,
         h.ends_at,
         h.winner_user_id,
         h.winner_demo_submission_id,
         h.created_at,
         COALESCE(winner.username, demoWinner.display_name) AS winner_username,
         COALESCE(winner.full_name, demoWinner.display_name) AS winner_full_name,
         CASE WHEN h.winner_demo_submission_id IS NULL THEN 0 ELSE 1 END AS winner_is_demo,
         COUNT(DISTINCT hp.id) AS total_participants,
         COUNT(DISTINCT hs.id) AS total_submissions,
         COUNT(DISTINCT hds.id) AS total_demo_submissions,
         COUNT(DISTINCT CASE WHEN hp.status = 'joined' THEN hp.id END) AS joined_participants,
         COUNT(DISTINCT CASE WHEN hp.status = 'submitted' THEN hp.id END) AS submitted_participants
       FROM heist h
       LEFT JOIN users winner ON winner.id = h.winner_user_id
       LEFT JOIN heist_demo_submissions demoWinner ON demoWinner.id = h.winner_demo_submission_id
       LEFT JOIN heist_participants hp ON hp.heist_id = h.id
       LEFT JOIN heist_submissions hs ON hs.heist_id = h.id AND hs.status = 'submitted'
       LEFT JOIN heist_demo_submissions hds ON hds.heist_id = h.id
       GROUP BY h.id
       ORDER BY h.created_at DESC`
    );
    return res.json({ heists: rows });
  } catch (err) {
    console.error("admin heists list error:", err);
    return res.status(500).json({ message: "Error fetching heists" });
  }
});

// Auto heist settings
router.get("/auto-settings", async (req, res) => {
  try {
    const settings = await getAutoHeistSettings(pool);
    return res.json({ settings });
  } catch (err) {
    console.error("admin auto heist settings error:", err);
    return res.status(500).json({ message: "Error fetching auto heist settings" });
  }
});

router.patch("/auto-settings", async (req, res) => {
  try {
    const result = await updateAutoHeistSettings(pool, req.body || {}, req.user.userId);
    if (!result.ok) return res.status(400).json({ message: result.message });
    return res.json({ message: "Auto heist settings updated", settings: result.value });
  } catch (err) {
    console.error("admin auto heist settings update error:", err);
    return res.status(500).json({ message: "Error updating auto heist settings" });
  }
});

// Reusable marketing demo users
router.get("/demo-users", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT
         du.id,
         du.display_name,
         du.is_active,
         du.created_by,
         du.created_at,
         du.updated_at,
         COUNT(hds.id) AS heist_count
       FROM heist_demo_users du
       LEFT JOIN heist_demo_submissions hds ON hds.demo_user_id = du.id
       GROUP BY du.id
       ORDER BY du.is_active DESC, du.display_name ASC`
    );

    return res.json({ demo_users: rows });
  } catch (err) {
    console.error("admin demo user bank list error:", err);
    return res.status(500).json({ message: "Error fetching demo users" });
  }
});

router.post("/demo-users", async (req, res) => {
  try {
    const displayName = cleanDemoDisplayName(req.body?.display_name || req.body?.name);
    if (!displayName) return res.status(400).json({ message: "display_name is required" });

    const [result] = await pool.query(
      `INSERT INTO heist_demo_users (display_name, is_active, created_by)
       VALUES (?, ?, ?)`,
      [displayName, boolToTinyInt(req.body?.is_active !== false), req.user.userId]
    );

    const [[demoUser]] = await pool.query(
      `SELECT id, display_name, is_active, created_by, created_at, updated_at
       FROM heist_demo_users
       WHERE id = ?
       LIMIT 1`,
      [result.insertId]
    );

    return res.status(201).json({ message: "Demo user saved", demo_user: demoUser });
  } catch (err) {
    if (err?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ message: "A demo user with this name already exists" });
    }
    console.error("admin demo user bank create error:", err);
    return res.status(500).json({ message: "Error saving demo user" });
  }
});

router.get("/promo-codes", async (req, res) => {
  try {
    const [codes] = await pool.query(
      `SELECT
         pc.id,
         pc.code,
         pc.copup_jr_amount,
         pc.max_redemptions,
         pc.redemption_count,
         pc.is_active,
         pc.expires_at,
         pc.created_by,
         pc.updated_by,
         pc.created_at,
         pc.updated_at,
         creator.username AS created_by_username,
         creator.full_name AS created_by_full_name
       FROM promo_codes pc
       LEFT JOIN users creator ON creator.id = pc.created_by
       WHERE pc.deleted_at IS NULL
       ORDER BY pc.created_at DESC, pc.id DESC`
    );

    const [[summary]] = await pool.query(
      `SELECT
         COUNT(*) AS total,
         COUNT(CASE WHEN is_active = 1 AND deleted_at IS NULL THEN 1 END) AS active,
         COALESCE(SUM(redemption_count), 0) AS redemptions
       FROM promo_codes
       WHERE deleted_at IS NULL`
    );

    return res.json({ codes, summary });
  } catch (err) {
    console.error("admin promo code list error:", err);
    return res.status(500).json({ message: "Error fetching promo codes" });
  }
});

router.post("/promo-codes", async (req, res) => {
  try {
    const code = normalizePromoCode(req.body?.code);
    if (!code) return res.status(400).json({ message: "Code is required" });

    const amount = parsePositiveInt(req.body?.copup_jr_amount, "copup_jr_amount");
    if (!amount.ok) return res.status(400).json({ message: amount.message });

    let maxRedemptions = null;
    if (req.body?.max_redemptions !== undefined && req.body.max_redemptions !== null && req.body.max_redemptions !== "") {
      const parsedMax = parsePositiveInt(req.body.max_redemptions, "max_redemptions");
      if (!parsedMax.ok) return res.status(400).json({ message: parsedMax.message });
      maxRedemptions = parsedMax.value;
    }

    const expiresAt = normalizeDateTimeInput(req.body?.expires_at);
    if (expiresAt === false) return res.status(400).json({ message: "expires_at must be a valid date" });

    const [result] = await pool.query(
      `INSERT INTO promo_codes
        (code, copup_jr_amount, max_redemptions, is_active, expires_at, created_by, updated_by)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        code,
        amount.value,
        maxRedemptions,
        boolToTinyInt(req.body?.is_active !== false),
        expiresAt === undefined ? null : expiresAt,
        req.user.userId,
        req.user.userId,
      ]
    );

    const [[promoCode]] = await pool.query(
      `SELECT id, code, copup_jr_amount, max_redemptions, redemption_count, is_active, expires_at, created_at, updated_at
       FROM promo_codes
       WHERE id = ?
       LIMIT 1`,
      [result.insertId]
    );

    return res.status(201).json({ message: "Promo code created", promo_code: promoCode });
  } catch (err) {
    if (err?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ message: "Promo code already exists" });
    }
    console.error("admin promo code create error:", err);
    return res.status(500).json({ message: "Error creating promo code" });
  }
});

router.patch("/promo-codes/:promoCodeId", async (req, res) => {
  try {
    const promoCodeId = Number(req.params.promoCodeId);
    if (!promoCodeId) return res.status(400).json({ message: "Invalid promo code" });

    const updates = [];
    const params = [];

    if (req.body?.code !== undefined) {
      const code = normalizePromoCode(req.body.code);
      if (!code) return res.status(400).json({ message: "Code is required" });
      updates.push("code = ?");
      params.push(code);
    }

    if (req.body?.copup_jr_amount !== undefined) {
      const amount = parsePositiveInt(req.body.copup_jr_amount, "copup_jr_amount");
      if (!amount.ok) return res.status(400).json({ message: amount.message });
      updates.push("copup_jr_amount = ?");
      params.push(amount.value);
    }

    if (req.body?.max_redemptions !== undefined) {
      if (req.body.max_redemptions === null || req.body.max_redemptions === "") {
        updates.push("max_redemptions = ?");
        params.push(null);
      } else {
        const maxRedemptions = parsePositiveInt(req.body.max_redemptions, "max_redemptions");
        if (!maxRedemptions.ok) return res.status(400).json({ message: maxRedemptions.message });
        updates.push("max_redemptions = ?");
        params.push(maxRedemptions.value);
      }
    }

    if (req.body?.is_active !== undefined) {
      updates.push("is_active = ?");
      params.push(boolToTinyInt(req.body.is_active));
    }

    if (req.body?.expires_at !== undefined) {
      const expiresAt = normalizeDateTimeInput(req.body.expires_at);
      if (expiresAt === false) return res.status(400).json({ message: "expires_at must be a valid date" });
      updates.push("expires_at = ?");
      params.push(expiresAt);
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });
    updates.push("updated_by = ?");
    params.push(req.user.userId, promoCodeId);

    const [result] = await pool.query(
      `UPDATE promo_codes
       SET ${updates.join(", ")}
       WHERE id = ? AND deleted_at IS NULL`,
      params
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Promo code not found" });

    const [[promoCode]] = await pool.query(
      `SELECT id, code, copup_jr_amount, max_redemptions, redemption_count, is_active, expires_at, created_at, updated_at
       FROM promo_codes
       WHERE id = ?
       LIMIT 1`,
      [promoCodeId]
    );

    return res.json({ message: "Promo code updated", promo_code: promoCode });
  } catch (err) {
    if (err?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ message: "Promo code already exists" });
    }
    console.error("admin promo code update error:", err);
    return res.status(500).json({ message: "Error updating promo code" });
  }
});

router.patch("/promo-codes/:promoCodeId/expire", async (req, res) => {
  try {
    const promoCodeId = Number(req.params.promoCodeId);
    if (!promoCodeId) return res.status(400).json({ message: "Invalid promo code" });

    const [result] = await pool.query(
      `UPDATE promo_codes
       SET is_active = 0, expires_at = COALESCE(expires_at, NOW()), updated_by = ?
       WHERE id = ? AND deleted_at IS NULL`,
      [req.user.userId, promoCodeId]
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Promo code not found" });

    return res.json({ message: "Promo code expired" });
  } catch (err) {
    console.error("admin promo code expire error:", err);
    return res.status(500).json({ message: "Error expiring promo code" });
  }
});

router.delete("/promo-codes/:promoCodeId", async (req, res) => {
  try {
    const promoCodeId = Number(req.params.promoCodeId);
    if (!promoCodeId) return res.status(400).json({ message: "Invalid promo code" });

    const [result] = await pool.query(
      `UPDATE promo_codes
       SET deleted_at = NOW(), is_active = 0, updated_by = ?
       WHERE id = ? AND deleted_at IS NULL`,
      [req.user.userId, promoCodeId]
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Promo code not found" });

    return res.json({ message: "Promo code deleted" });
  } catch (err) {
    console.error("admin promo code delete error:", err);
    return res.status(500).json({ message: "Error deleting promo code" });
  }
});

router.patch("/demo-users/:demoUserId", async (req, res) => {
  try {
    const demoUserId = Number(req.params.demoUserId);
    if (!demoUserId) return res.status(400).json({ message: "Invalid demo user" });

    const updates = [];
    const params = [];

    if (req.body?.display_name !== undefined || req.body?.name !== undefined) {
      const displayName = cleanDemoDisplayName(req.body?.display_name || req.body?.name);
      if (!displayName) return res.status(400).json({ message: "display_name is required" });
      updates.push("display_name = ?");
      params.push(displayName);
    }

    if (req.body?.is_active !== undefined) {
      updates.push("is_active = ?");
      params.push(boolToTinyInt(req.body.is_active));
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(demoUserId);
    const [result] = await pool.query(
      `UPDATE heist_demo_users SET ${updates.join(", ")} WHERE id = ?`,
      params
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Demo user not found" });

    const [[demoUser]] = await pool.query(
      `SELECT id, display_name, is_active, created_by, created_at, updated_at
       FROM heist_demo_users
       WHERE id = ?
       LIMIT 1`,
      [demoUserId]
    );

    return res.json({ message: "Demo user updated", demo_user: demoUser });
  } catch (err) {
    if (err?.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ message: "A demo user with this name already exists" });
    }
    console.error("admin demo user bank update error:", err);
    return res.status(500).json({ message: "Error updating demo user" });
  }
});

router.post("/auto-settings/run", async (req, res) => {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const result = await maybeCreateAutoHeist(conn, {
      forced: true,
      adminId: req.user.userId,
    });
    await conn.commit();

    if (!result.created) {
      return res.status(400).json({ message: "Auto heist not created", reason: result.reason });
    }

    return res.status(201).json({ message: "Auto heist created", ...result });
  } catch (err) {
    await conn.rollback();
    console.error("admin auto heist run error:", err);
    return res.status(500).json({ message: "Error creating auto heist" });
  } finally {
    conn.release();
  }
});

// Update heist
router.patch("/:id", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [[existingHeist]] = await pool.query(
      "SELECT id, min_users, max_users FROM heist WHERE id = ? LIMIT 1",
      [heistId]
    );
    if (!existingHeist) return res.status(404).json({ message: "Heist not found" });

    const updates = [];
    const params = [];
    let nextMinUsers = Number(existingHeist.min_users || 1);
    let nextMaxUsers = existingHeist.max_users === null ? null : Number(existingHeist.max_users || 0);

    if (req.body?.name !== undefined) {
      const name = String(req.body.name || "").trim();
      if (!name) return res.status(400).json({ message: "Name is required" });
      updates.push("name = ?");
      params.push(name);
    }

    if (req.body?.description !== undefined) {
      const description = String(req.body.description || "").trim();
      updates.push("description = ?");
      params.push(description || null);
    }

    if (req.body?.min_users !== undefined) {
      const minUsersParsed = parseMinUsers(req.body.min_users);
      if (!minUsersParsed.ok) return res.status(400).json({ message: minUsersParsed.message });
      nextMinUsers = minUsersParsed.value;
      updates.push("min_users = ?");
      params.push(nextMinUsers);
    }

    if (req.body?.max_users !== undefined) {
      const maxUsersParsed = parseMaxUsers(req.body.max_users, nextMinUsers);
      if (!maxUsersParsed.ok) return res.status(400).json({ message: maxUsersParsed.message });
      nextMaxUsers = maxUsersParsed.value;
      updates.push("max_users = ?");
      params.push(nextMaxUsers);
    }

    if (nextMaxUsers !== null && nextMaxUsers < nextMinUsers) {
      return res.status(400).json({ message: "max_users must be greater than or equal to min_users" });
    }

    if (req.body?.ticket_price !== undefined) {
      const ticketPrice = Number(req.body.ticket_price);
      if (!Number.isInteger(ticketPrice) || ticketPrice < 0) {
        return res.status(400).json({ message: "ticket_price must be 0 or greater" });
      }
      updates.push("ticket_price = ?");
      params.push(ticketPrice);
    }

    if (req.body?.prize_cop_points !== undefined) {
      const prizeCopPoints = Number(req.body.prize_cop_points);
      if (!Number.isInteger(prizeCopPoints) || prizeCopPoints < 0) {
        return res.status(400).json({ message: "prize_cop_points must be 0 or greater" });
      }
      updates.push("prize_cop_points = ?");
      params.push(prizeCopPoints);
    }

    if (req.body?.questions_per_session !== undefined) {
      const questionsPerSession = Number(req.body.questions_per_session);
      if (!Number.isInteger(questionsPerSession) || questionsPerSession < 0) {
        return res.status(400).json({ message: "questions_per_session must be 0 or greater" });
      }
      updates.push("questions_per_session = ?");
      params.push(questionsPerSession);
    }

    if (req.body?.countdown_duration_minutes !== undefined) {
      const countdownDuration = Number(req.body.countdown_duration_minutes);
      if (!Number.isInteger(countdownDuration) || countdownDuration < 1) {
        return res.status(400).json({ message: "countdown_duration_minutes must be 1 or greater" });
      }
      updates.push("countdown_duration_minutes = ?");
      params.push(countdownDuration);
    }

    for (const field of ["starts_at", "ends_at"]) {
      if (req.body?.[field] !== undefined) {
        const value = normalizeDateTimeInput(req.body[field]);
        if (value === false) {
          return res.status(400).json({ message: `${field} must be a valid date` });
        }
        updates.push(`${field} = ?`);
        params.push(value);
      }
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(heistId);
    const [result] = await pool.query(
      `UPDATE heist SET ${updates.join(", ")} WHERE id = ?`,
      params
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Heist not found" });

    const [[heist]] = await pool.query(
      `SELECT
         id,
         name,
         description,
         status,
         min_users,
         max_users,
         ticket_price,
         prize_cop_points,
         total_questions,
         questions_per_session,
         countdown_duration_minutes,
         starts_at,
         ends_at,
         updated_at
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

// List heist name/description bank
router.get("/content-bank", async (req, res) => {
  try {
    const [items] = await pool.query(
      `SELECT
         cb.id,
         cb.name,
         cb.description,
         cb.is_active,
         cb.created_by,
         cb.created_at,
         cb.updated_at,
         u.username AS created_by_username,
         u.full_name AS created_by_full_name
       FROM heist_content_bank cb
       LEFT JOIN users u ON u.id = cb.created_by
       ORDER BY cb.is_active DESC, cb.created_at DESC, cb.id DESC`
    );

    const [[summary]] = await pool.query(
      `SELECT
         COUNT(*) AS total,
         COUNT(CASE WHEN is_active = 1 THEN 1 END) AS active,
         COUNT(CASE WHEN is_active = 0 THEN 1 END) AS inactive
       FROM heist_content_bank`
    );

    return res.json({ items, summary });
  } catch (err) {
    console.error("admin heist content bank list error:", err);
    return res.status(500).json({ message: "Error fetching heist content bank" });
  }
});

// Add heist name/description bank item
router.post("/content-bank", async (req, res) => {
  try {
    const name = String(req.body?.name || "").trim();
    const description = String(req.body?.description || "").trim();
    if (!name) return res.status(400).json({ message: "Name is required" });
    if (!description) return res.status(400).json({ message: "Description is required" });

    const [result] = await pool.query(
      `INSERT INTO heist_content_bank
        (name, description, is_active, created_by)
       VALUES (?, ?, ?, ?)`,
      [name, description, boolToTinyInt(req.body?.is_active !== false), req.user.userId]
    );

    return res.status(201).json({
      message: "Heist content saved",
      item_id: result.insertId,
    });
  } catch (err) {
    console.error("admin add heist content bank error:", err);
    return res.status(500).json({ message: "Error saving heist content" });
  }
});

// Update heist name/description bank item
router.patch("/content-bank/:contentId", async (req, res) => {
  try {
    const contentId = Number(req.params.contentId);
    if (!contentId) return res.status(400).json({ message: "Invalid content item" });

    const updates = [];
    const params = [];

    if (req.body?.name !== undefined) {
      const name = String(req.body.name || "").trim();
      if (!name) return res.status(400).json({ message: "Name is required" });
      updates.push("name = ?");
      params.push(name);
    }

    if (req.body?.description !== undefined) {
      const description = String(req.body.description || "").trim();
      if (!description) return res.status(400).json({ message: "Description is required" });
      updates.push("description = ?");
      params.push(description);
    }

    if (req.body?.is_active !== undefined) {
      updates.push("is_active = ?");
      params.push(boolToTinyInt(req.body.is_active));
    }

    if (!updates.length) return res.status(400).json({ message: "No updates provided" });

    params.push(contentId);
    const [result] = await pool.query(
      `UPDATE heist_content_bank SET ${updates.join(", ")} WHERE id = ?`,
      params
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Content item not found" });

    const [[item]] = await pool.query(
      `SELECT id, name, description, is_active, created_by, created_at, updated_at
       FROM heist_content_bank
       WHERE id = ?
       LIMIT 1`,
      [contentId]
    );

    return res.json({ message: "Heist content updated", item });
  } catch (err) {
    console.error("admin update heist content bank error:", err);
    return res.status(500).json({ message: "Error updating heist content" });
  }
});

// Delete heist name/description bank item
router.delete("/content-bank/:contentId", async (req, res) => {
  try {
    const contentId = Number(req.params.contentId);
    if (!contentId) return res.status(400).json({ message: "Invalid content item" });

    const [result] = await pool.query("DELETE FROM heist_content_bank WHERE id = ?", [
      contentId,
    ]);
    if (!result.affectedRows) return res.status(404).json({ message: "Content item not found" });

    return res.json({ message: "Heist content deleted" });
  } catch (err) {
    console.error("admin delete heist content bank error:", err);
    return res.status(500).json({ message: "Error deleting heist content" });
  }
});

// List question bank
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

// Add bank questions
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

// Update bank question
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

// Delete bank question
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

// Assign heist questions
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

// Add heist questions
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

// List heist questions
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

// Get heist details
router.get("/:id", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [[heist]] = await pool.query(
      `SELECT
         h.id,
         h.name,
         h.description,
         h.status,
         h.min_users,
         h.max_users,
         h.ticket_price,
         h.prize_cop_points,
         h.total_questions,
         h.questions_per_session,
         h.submissions_locked,
         h.countdown_started_at,
         h.countdown_duration_minutes,
         h.countdown_ends_at,
         h.starts_at,
         h.ends_at,
         h.created_at,
         h.updated_at,
         h.winner_user_id,
         h.winner_demo_submission_id,
         creator.username AS created_by_username,
         creator.full_name AS created_by_full_name,
         COALESCE(winner.username, demoWinner.display_name) AS winner_username,
         COALESCE(winner.full_name, demoWinner.display_name) AS winner_full_name,
         CASE WHEN h.winner_demo_submission_id IS NULL THEN 0 ELSE 1 END AS winner_is_demo,
         COUNT(DISTINCT hp.id) AS total_participants,
         COUNT(DISTINCT hs.id) AS total_submissions,
         COUNT(DISTINCT hds.id) AS total_demo_submissions,
         COUNT(DISTINCT CASE WHEN hp.status = 'joined' THEN hp.id END) AS joined_participants,
         COUNT(DISTINCT CASE WHEN hp.status = 'submitted' THEN hp.id END) AS submitted_participants
       FROM heist h
       LEFT JOIN users creator ON creator.id = h.created_by
       LEFT JOIN users winner ON winner.id = h.winner_user_id
       LEFT JOIN heist_demo_submissions demoWinner ON demoWinner.id = h.winner_demo_submission_id
       LEFT JOIN heist_participants hp ON hp.heist_id = h.id
       LEFT JOIN heist_submissions hs ON hs.heist_id = h.id AND hs.status = 'submitted'
       LEFT JOIN heist_demo_submissions hds ON hds.heist_id = h.id
       WHERE h.id = ?
       GROUP BY h.id
       LIMIT 1`,
      [heistId]
    );

    if (!heist) return res.status(404).json({ message: "Heist not found" });

    const [participants] = await pool.query(
      `SELECT
         hp.id,
         hp.heist_id,
         hp.user_id,
         hp.affiliate_user_id,
         hp.referral_code,
         hp.joined_at,
         hp.status,
         u.username,
         u.full_name,
         u.email,
         affiliate.username AS affiliate_username,
         affiliate.full_name AS affiliate_full_name,
         hs.id AS submission_id,
         hs.started_at,
         hs.submitted_at,
         hs.total_time_seconds,
         hs.correct_count,
         hs.wrong_count,
         hs.unanswered_count,
         hs.score_percent,
         hs.status AS submission_status
       FROM heist_participants hp
       JOIN users u ON u.id = hp.user_id
       LEFT JOIN users affiliate ON affiliate.id = hp.affiliate_user_id
       LEFT JOIN heist_submissions hs
         ON hs.participant_id = hp.id
        AND hs.heist_id = hp.heist_id
        AND hs.user_id = hp.user_id
       WHERE hp.heist_id = ?
       ORDER BY hp.joined_at DESC, hp.id DESC`,
      [heistId]
    );

    const [demoSubmissions] = await pool.query(
      `SELECT id, heist_id, demo_user_id, display_name, correct_count, wrong_count, unanswered_count,
              score_percent, total_time_seconds, submitted_at, created_at, updated_at
       FROM heist_demo_submissions
       WHERE heist_id = ?
       ORDER BY correct_count DESC, total_time_seconds ASC, submitted_at ASC, id ASC`,
      [heistId]
    );

    return res.json({ heist, participants, demo_submissions: demoSubmissions });
  } catch (err) {
    console.error("admin heist detail error:", err);
    return res.status(500).json({ message: "Error fetching heist details" });
  }
});

// Delete heist question
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

// List demo leaderboard users
router.get("/:id/demo-users", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const [rows] = await pool.query(
      `SELECT id, heist_id, demo_user_id, display_name, correct_count, wrong_count, unanswered_count,
              score_percent, total_time_seconds, submitted_at, created_at, updated_at
       FROM heist_demo_submissions
       WHERE heist_id = ?
       ORDER BY correct_count DESC, total_time_seconds ASC, submitted_at ASC, id ASC`,
      [heistId]
    );

    return res.json({ demo_users: rows });
  } catch (err) {
    console.error("admin demo users list error:", err);
    return res.status(500).json({ message: "Error fetching demo users" });
  }
});

// Add demo leaderboard user
router.post("/:id/demo-users", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    if (!heistId) return res.status(400).json({ message: "Invalid heist id" });

    const demoUserId = Number(req.body?.demo_user_id || 0);
    let displayName = cleanDemoDisplayName(req.body?.display_name || req.body?.name);

    if (demoUserId) {
      const [[demoUser]] = await pool.query(
        "SELECT id, display_name, is_active FROM heist_demo_users WHERE id = ? LIMIT 1",
        [demoUserId]
      );
      if (!demoUser) return res.status(404).json({ message: "Demo user not found" });
      if (!Number(demoUser.is_active)) return res.status(400).json({ message: "Demo user is inactive" });
      displayName = demoUser.display_name;
    }

    if (!displayName) return res.status(400).json({ message: "Select or create a demo user first" });

    const correctParsed = parseNonNegativeInt(req.body?.correct_count, "correct_count");
    if (!correctParsed.ok) return res.status(400).json({ message: correctParsed.message });
    const wrongParsed = parseNonNegativeInt(req.body?.wrong_count, "wrong_count");
    if (!wrongParsed.ok) return res.status(400).json({ message: wrongParsed.message });
    const unansweredParsed = parseNonNegativeInt(req.body?.unanswered_count, "unanswered_count");
    if (!unansweredParsed.ok) return res.status(400).json({ message: unansweredParsed.message });
    const timeParsed = parseNonNegativeInt(req.body?.total_time_seconds, "total_time_seconds");
    if (!timeParsed.ok) return res.status(400).json({ message: timeParsed.message });

    const submittedAt = normalizeDemoSubmittedAt(req.body?.submitted_at);
    if (submittedAt === false) return res.status(400).json({ message: "submitted_at must be a valid date" });

    const [[heist]] = await pool.query(
      `SELECT h.id, h.total_questions, COUNT(hq.id) AS assigned_questions
       FROM heist h
       LEFT JOIN heist_questions hq ON hq.heist_id = h.id AND hq.is_active = 1
       WHERE h.id = ?
       GROUP BY h.id
       LIMIT 1`,
      [heistId]
    );
    if (!heist) return res.status(404).json({ message: "Heist not found" });

    const questionLimit = Number(heist.assigned_questions || heist.total_questions || 0);
    if (questionLimit <= 0) {
      return res.status(400).json({ message: "Assign questions to this heist before adding demo users" });
    }

    const answerTotal = correctParsed.value + wrongParsed.value + unansweredParsed.value;
    if (answerTotal > questionLimit) {
      return res.status(400).json({
        message: `Demo answers cannot be more than the ${questionLimit} question(s) assigned to this heist`,
      });
    }

    const scorePercent = calculateDemoScore({
      correctCount: correctParsed.value,
      wrongCount: wrongParsed.value,
      unansweredCount: unansweredParsed.value,
      fallbackTotal: questionLimit,
    });

    const [result] = await pool.query(
      `INSERT INTO heist_demo_submissions
        (heist_id, demo_user_id, display_name, correct_count, wrong_count, unanswered_count,
         score_percent, total_time_seconds, submitted_at, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        heistId,
        demoUserId || null,
        displayName,
        correctParsed.value,
        wrongParsed.value,
        unansweredParsed.value,
        scorePercent,
        timeParsed.value,
        submittedAt,
        req.user.userId,
      ]
    );

    const [[demoUser]] = await pool.query(
      `SELECT id, heist_id, demo_user_id, display_name, correct_count, wrong_count, unanswered_count,
              score_percent, total_time_seconds, submitted_at, created_at, updated_at
       FROM heist_demo_submissions
       WHERE id = ?
       LIMIT 1`,
      [result.insertId]
    );

    return res.status(201).json({ message: "Demo user added", demo_user: demoUser });
  } catch (err) {
    console.error("admin demo user add error:", err);
    return res.status(500).json({ message: "Error adding demo user" });
  }
});

// Delete demo leaderboard user
router.delete("/:id/demo-users/:demoId", async (req, res) => {
  try {
    const heistId = Number(req.params.id);
    const demoId = Number(req.params.demoId);
    if (!heistId || !demoId) return res.status(400).json({ message: "Invalid demo user" });

    const [result] = await pool.query(
      "DELETE FROM heist_demo_submissions WHERE id = ? AND heist_id = ?",
      [demoId, heistId]
    );
    if (!result.affectedRows) return res.status(404).json({ message: "Demo user not found" });

    return res.json({ message: "Demo user deleted" });
  } catch (err) {
    console.error("admin demo user delete error:", err);
    return res.status(500).json({ message: "Error deleting demo user" });
  }
});

// List affiliate tasks
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

// Create affiliate task
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

// Update affiliate task
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

// Delete affiliate task
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

// List affiliate progress
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

// Update heist status
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

// Finalize heist
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
