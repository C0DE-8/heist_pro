const DEFAULT_SETTINGS_ID = 1;

async function ensureAutoHeistTables(db) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS heist_content_bank (
      id int(11) NOT NULL AUTO_INCREMENT,
      name varchar(255) NOT NULL,
      description text DEFAULT NULL,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      created_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_heist_content_bank_active_created (is_active, created_at),
      KEY idx_heist_content_bank_created_by (created_by)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS auto_heist_settings (
      id tinyint(1) NOT NULL DEFAULT 1,
      is_enabled tinyint(1) NOT NULL DEFAULT 0,
      min_users int(11) NOT NULL DEFAULT 1,
      max_users int(11) DEFAULT NULL,
      ticket_price int(11) NOT NULL DEFAULT 0,
      prize_cop_points int(11) NOT NULL DEFAULT 0,
      questions_per_session int(11) NOT NULL DEFAULT 0,
      countdown_duration_minutes int(11) NOT NULL DEFAULT 10,
      created_by int(11) DEFAULT NULL,
      updated_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `INSERT IGNORE INTO auto_heist_settings
      (id, is_enabled, min_users, max_users, ticket_price, prize_cop_points, questions_per_session, countdown_duration_minutes)
     VALUES (?, 0, 1, NULL, 0, 0, 0, 10)`,
    [DEFAULT_SETTINGS_ID]
  );
}

function boolToTinyInt(value) {
  return value === true || value === 1 || value === "1" || value === "true" ? 1 : 0;
}

function normalizeAutoHeistPayload(body = {}) {
  const minUsers = Number(body.min_users || 1);
  if (!Number.isInteger(minUsers) || minUsers < 1) {
    return { ok: false, message: "min_users must be 1 or greater" };
  }

  let maxUsers = null;
  if (body.max_users !== undefined && body.max_users !== null && body.max_users !== "") {
    maxUsers = Number(body.max_users);
    if (!Number.isInteger(maxUsers) || maxUsers < 0) {
      return { ok: false, message: "max_users must be 0 or greater" };
    }
    if (maxUsers === 0) maxUsers = null;
    if (maxUsers !== null && maxUsers < minUsers) {
      return { ok: false, message: "max_users must be greater than or equal to min_users" };
    }
  }

  const ticketPrice = Number(body.ticket_price || 0);
  if (!Number.isInteger(ticketPrice) || ticketPrice < 0) {
    return { ok: false, message: "ticket_price must be 0 or greater" };
  }

  const prizeCopPoints = Number(body.prize_cop_points || 0);
  if (!Number.isInteger(prizeCopPoints) || prizeCopPoints < 0) {
    return { ok: false, message: "prize_cop_points must be 0 or greater" };
  }

  const questionsPerSession = Number(body.questions_per_session || 0);
  if (!Number.isInteger(questionsPerSession) || questionsPerSession < 0) {
    return { ok: false, message: "questions_per_session must be 0 or greater" };
  }
  if (boolToTinyInt(body.is_enabled) && questionsPerSession < 1) {
    return { ok: false, message: "questions_per_session must be 1 or greater when auto heist is enabled" };
  }

  const countdownDuration = Number(body.countdown_duration_minutes || 10);
  if (!Number.isInteger(countdownDuration) || countdownDuration < 1) {
    return { ok: false, message: "countdown_duration_minutes must be 1 or greater" };
  }

  return {
    ok: true,
    value: {
      is_enabled: boolToTinyInt(body.is_enabled),
      min_users: minUsers,
      max_users: maxUsers,
      ticket_price: ticketPrice,
      prize_cop_points: prizeCopPoints,
      questions_per_session: questionsPerSession,
      countdown_duration_minutes: countdownDuration,
    },
  };
}

async function getAutoHeistSettings(db) {
  await ensureAutoHeistTables(db);
  const [[settings]] = await db.query(
    `SELECT id, is_enabled, min_users, max_users, ticket_price, prize_cop_points,
            questions_per_session, countdown_duration_minutes, created_by, updated_by,
            created_at, updated_at
     FROM auto_heist_settings
     WHERE id = ?
     LIMIT 1`,
    [DEFAULT_SETTINGS_ID]
  );
  return settings || null;
}

async function updateAutoHeistSettings(db, body, adminId) {
  await ensureAutoHeistTables(db);
  const parsed = normalizeAutoHeistPayload(body);
  if (!parsed.ok) return parsed;

  const value = parsed.value;
  await db.query(
    `INSERT INTO auto_heist_settings
      (id, is_enabled, min_users, max_users, ticket_price, prize_cop_points,
       questions_per_session, countdown_duration_minutes, created_by, updated_by)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE
       is_enabled = VALUES(is_enabled),
       min_users = VALUES(min_users),
       max_users = VALUES(max_users),
       ticket_price = VALUES(ticket_price),
       prize_cop_points = VALUES(prize_cop_points),
       questions_per_session = VALUES(questions_per_session),
       countdown_duration_minutes = VALUES(countdown_duration_minutes),
       updated_by = VALUES(updated_by)`,
    [
      DEFAULT_SETTINGS_ID,
      value.is_enabled,
      value.min_users,
      value.max_users,
      value.ticket_price,
      value.prize_cop_points,
      value.questions_per_session,
      value.countdown_duration_minutes,
      adminId || null,
      adminId || null,
    ]
  );

  return { ok: true, value: await getAutoHeistSettings(db) };
}

async function assignUnusedQuestions(db, heistId, questionCount, adminId = null) {
  const desiredCount = Number(questionCount || 0);
  if (!desiredCount) return 0;

  const [questions] = await db.query(
    `SELECT id
     FROM heist_questions
     WHERE heist_id IS NULL AND is_active = 1
     ORDER BY RAND()
     LIMIT ? FOR UPDATE`,
    [desiredCount]
  );
  if (questions.length < desiredCount) {
    return null;
  }

  await db.query(
    `UPDATE heist_questions
     SET heist_id = ?, assigned_at = NOW(), assigned_by = ?
     WHERE id IN (${questions.map(() => "?").join(", ")})`,
    [heistId, adminId, ...questions.map((question) => question.id)]
  );

  await db.query("UPDATE heist SET total_questions = ?, questions_per_session = ? WHERE id = ?", [
    questions.length,
    questions.length,
    heistId,
  ]);

  return questions.length;
}

async function maybeCreateAutoHeist(db, { forced = false, adminId = null } = {}) {
  await ensureAutoHeistTables(db);

  const [[settings]] = await db.query(
    `SELECT *
     FROM auto_heist_settings
     WHERE id = ?
     LIMIT 1 FOR UPDATE`,
    [DEFAULT_SETTINGS_ID]
  );
  if (!settings || (!forced && !Number(settings.is_enabled))) {
    return { created: false, reason: "disabled" };
  }

  const [[pendingRow]] = await db.query(
    "SELECT COUNT(*) AS total FROM heist WHERE status = 'pending'"
  );
  if (!forced && Number(pendingRow?.total || 0) > 0) {
    return { created: false, reason: "pending_exists" };
  }

  const [[content]] = await db.query(
    `SELECT id, name, description
     FROM heist_content_bank
     WHERE is_active = 1
     ORDER BY RAND()
     LIMIT 1`
  );
  if (!content) return { created: false, reason: "missing_content" };

  const questionCount = Number(settings.questions_per_session || 0);
  if (questionCount > 0) {
    const [[availableQuestions]] = await db.query(
      "SELECT COUNT(*) AS total FROM heist_questions WHERE heist_id IS NULL AND is_active = 1"
    );
    if (Number(availableQuestions?.total || 0) < questionCount) {
      return { created: false, reason: "missing_questions" };
    }
  }

  const [result] = await db.query(
    `INSERT INTO heist
      (name, description, min_users, max_users, ticket_price, prize_cop_points,
       questions_per_session, countdown_duration_minutes, starts_at, ends_at, created_by)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, NULL, NULL, ?)`,
    [
      content.name,
      content.description || null,
      settings.min_users,
      settings.max_users,
      settings.ticket_price,
      settings.prize_cop_points,
      questionCount,
      settings.countdown_duration_minutes,
      adminId || settings.updated_by || settings.created_by || null,
    ]
  );

  const assignedCount = await assignUnusedQuestions(
    db,
    result.insertId,
    questionCount,
    adminId || settings.updated_by || settings.created_by || null
  );
  if (assignedCount === null) {
    throw new Error("Not enough unused bank questions");
  }

  return {
    created: true,
    heist_id: result.insertId,
    content_id: content.id,
    assigned_questions: assignedCount,
  };
}

module.exports = {
  ensureAutoHeistTables,
  getAutoHeistSettings,
  updateAutoHeistSettings,
  maybeCreateAutoHeist,
};
