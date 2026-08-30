const { noticePayload, sendPushToUser } = require("./push.service");
const {
  ensureLevelProgressTables,
  awardConfiguredXp,
} = require("./levelProgress.service");

let heistMaxUsersColumnReady = false;
let heistDemoSubmissionsTableReady = false;
let heistWinnerDemoColumnReady = false;
let heistDemoUsersTableReady = false;

function normalizeAnswer(value) {
  const answer = String(value || "").trim().toLowerCase();
  return answer === "true" || answer === "false" ? answer : null;
}

async function ensureHeistMaxUsersColumn(db) {
  if (heistMaxUsersColumnReady) return;

  const [[databaseRow]] = await db.query("SELECT DATABASE() AS db_name");
  const dbName = databaseRow?.db_name;
  if (!dbName) throw new Error("Unable to detect database for heist schema check");

  const [[column]] = await db.query(
    `SELECT COLUMN_NAME
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = ?
       AND TABLE_NAME = 'heist'
       AND COLUMN_NAME = 'max_users'
     LIMIT 1`,
    [dbName]
  );

  if (!column) {
    try {
      await db.query("ALTER TABLE heist ADD COLUMN max_users int(11) DEFAULT NULL AFTER min_users");
    } catch (err) {
      if (err?.code !== "ER_DUP_FIELDNAME" && err?.errno !== 1060) throw err;
    }
  }

  heistMaxUsersColumnReady = true;
}

async function ensureHeistDemoSubmissionsTable(db) {
  if (heistDemoSubmissionsTableReady) return;

  await db.query(
    `CREATE TABLE IF NOT EXISTS heist_demo_submissions (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      heist_id int(11) NOT NULL,
      demo_user_id bigint(20) UNSIGNED DEFAULT NULL,
      display_name varchar(120) NOT NULL,
      correct_count int(11) NOT NULL DEFAULT 0,
      wrong_count int(11) NOT NULL DEFAULT 0,
      unanswered_count int(11) NOT NULL DEFAULT 0,
      score_percent decimal(5,2) NOT NULL DEFAULT 0.00,
      total_time_seconds int(11) NOT NULL DEFAULT 0,
      submitted_at datetime NOT NULL DEFAULT current_timestamp(),
      created_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_heist_demo_submissions_rank (heist_id, correct_count, total_time_seconds, submitted_at),
      KEY idx_heist_demo_submissions_demo_user (demo_user_id),
      KEY idx_heist_demo_submissions_created_by (created_by)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  const [[databaseRow]] = await db.query("SELECT DATABASE() AS db_name");
  const dbName = databaseRow?.db_name;
  if (!dbName) throw new Error("Unable to detect database for heist schema check");

  const [[column]] = await db.query(
    `SELECT COLUMN_NAME
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = ?
       AND TABLE_NAME = 'heist_demo_submissions'
       AND COLUMN_NAME = 'demo_user_id'
     LIMIT 1`,
    [dbName]
  );

  if (!column) {
    try {
      await db.query(
        "ALTER TABLE heist_demo_submissions ADD COLUMN demo_user_id bigint(20) UNSIGNED DEFAULT NULL AFTER heist_id"
      );
    } catch (err) {
      if (err?.code !== "ER_DUP_FIELDNAME" && err?.errno !== 1060) throw err;
    }
  }

  const [[index]] = await db.query(
    `SELECT INDEX_NAME
     FROM INFORMATION_SCHEMA.STATISTICS
     WHERE TABLE_SCHEMA = ?
       AND TABLE_NAME = 'heist_demo_submissions'
       AND INDEX_NAME = 'idx_heist_demo_submissions_demo_user'
     LIMIT 1`,
    [dbName]
  );

  if (!index) {
    try {
      await db.query("ALTER TABLE heist_demo_submissions ADD KEY idx_heist_demo_submissions_demo_user (demo_user_id)");
    } catch (err) {
      if (err?.code !== "ER_DUP_KEYNAME" && err?.errno !== 1061) throw err;
    }
  }

  heistDemoSubmissionsTableReady = true;
}

async function ensureHeistDemoUsersTable(db) {
  if (heistDemoUsersTableReady) return;

  await db.query(
    `CREATE TABLE IF NOT EXISTS heist_demo_users (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      display_name varchar(120) NOT NULL,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      created_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_heist_demo_users_display_name (display_name),
      KEY idx_heist_demo_users_active_created (is_active, created_at),
      KEY idx_heist_demo_users_created_by (created_by)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  heistDemoUsersTableReady = true;
}

async function ensureHeistWinnerDemoColumn(db) {
  if (heistWinnerDemoColumnReady) return;

  const [[databaseRow]] = await db.query("SELECT DATABASE() AS db_name");
  const dbName = databaseRow?.db_name;
  if (!dbName) throw new Error("Unable to detect database for heist schema check");

  const [[column]] = await db.query(
    `SELECT COLUMN_NAME
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = ?
       AND TABLE_NAME = 'heist'
       AND COLUMN_NAME = 'winner_demo_submission_id'
     LIMIT 1`,
    [dbName]
  );

  if (!column) {
    try {
      await db.query(
        "ALTER TABLE heist ADD COLUMN winner_demo_submission_id bigint(20) UNSIGNED DEFAULT NULL AFTER winner_user_id"
      );
    } catch (err) {
      if (err?.code !== "ER_DUP_FIELDNAME" && err?.errno !== 1060) throw err;
    }
  }

  const [[index]] = await db.query(
    `SELECT INDEX_NAME
     FROM INFORMATION_SCHEMA.STATISTICS
     WHERE TABLE_SCHEMA = ?
       AND TABLE_NAME = 'heist'
       AND INDEX_NAME = 'idx_heist_winner_demo'
     LIMIT 1`,
    [dbName]
  );

  if (!index) {
    try {
      await db.query("ALTER TABLE heist ADD KEY idx_heist_winner_demo (winner_demo_submission_id)");
    } catch (err) {
      if (err?.code !== "ER_DUP_KEYNAME" && err?.errno !== 1061) throw err;
    }
  }

  heistWinnerDemoColumnReady = true;
}

function makeReferralCode() {
  return `H${Math.random().toString(36).slice(2, 10).toUpperCase()}`;
}

function getBaseUrl(req) {
  return process.env.FRONTEND_BASE_URL || "http://localhost:5173";
}

function makeReferralLink(req, heistId, code) {
  return `${getBaseUrl(req)}/heists/${heistId}/ref/${code}`;
}

async function getRankPreview(db, heistId, submissionId) {
  const [rows] = await db.query(
    `SELECT ranked.rank
     FROM (
       SELECT
         hs.id,
         ROW_NUMBER() OVER (
           ORDER BY hs.correct_count DESC, hs.total_time_seconds ASC, hs.submitted_at ASC
         ) AS rank
       FROM heist_submissions hs
       WHERE hs.heist_id = ? AND hs.status = 'submitted'
     ) ranked
     WHERE ranked.id = ?
     LIMIT 1`,
    [heistId, submissionId]
  );
  return rows[0]?.rank || null;
}

function isDuplicateError(err) {
  return err && (err.code === "ER_DUP_ENTRY" || err.errno === 1062);
}

async function maybeStartCountdown(db, heistId) {
  const [[heist]] = await db.query(
    `SELECT id, min_users, status
     FROM heist
     WHERE id = ?
     LIMIT 1 FOR UPDATE`,
    [heistId]
  );
  if (!heist || heist.status !== "pending") return false;

  const [[countRow]] = await db.query(
    `SELECT COUNT(*) AS total
     FROM heist_participants
     WHERE heist_id = ? AND status IN ('joined', 'submitted')`,
    [heistId]
  );

  if (Number(countRow.total) < Number(heist.min_users)) return false;

  await db.query(
    `UPDATE heist
     SET status = 'started',
         countdown_started_at = COALESCE(countdown_started_at, NOW()),
         countdown_ends_at = COALESCE(
           countdown_ends_at,
           ends_at,
           DATE_ADD(NOW(), INTERVAL countdown_duration_minutes MINUTE)
         )
     WHERE id = ? AND status = 'pending'`,
    [heistId]
  );

  return true;
}

async function finalizeHeist(db, heistId) {
  const [[heist]] = await db.query(
    `SELECT id, prize_cop_points, status, submissions_locked, winner_user_id, winner_demo_submission_id
     FROM heist
     WHERE id = ?
     LIMIT 1 FOR UPDATE`,
    [heistId]
  );

  if (!heist) {
    return { found: false };
  }

  if (heist.status === "completed") {
    return {
      found: true,
      already_completed: true,
      winner: heist.winner_user_id
        ? { user_id: heist.winner_user_id }
        : heist.winner_demo_submission_id
          ? { demo_submission_id: heist.winner_demo_submission_id, is_demo: true }
          : null,
      awarded_points: 0,
    };
  }

  const [[winner]] = await db.query(
    `SELECT ranked.*
     FROM (
       SELECT
         hs.id AS submission_id,
         NULL AS demo_submission_id,
         hs.user_id,
         u.username,
         0 AS is_demo,
         hs.correct_count,
         hs.total_time_seconds,
         hs.submitted_at,
         0 AS source_order
       FROM heist_submissions hs
       JOIN users u ON u.id = hs.user_id
       WHERE hs.heist_id = ? AND hs.status = 'submitted'
       UNION ALL
       SELECT
         NULL AS submission_id,
         hds.id AS demo_submission_id,
         NULL AS user_id,
         hds.display_name AS username,
         1 AS is_demo,
         hds.correct_count,
         hds.total_time_seconds,
         hds.submitted_at,
         1 AS source_order
       FROM heist_demo_submissions hds
       WHERE hds.heist_id = ?
     ) ranked
     ORDER BY ranked.correct_count DESC, ranked.total_time_seconds ASC, ranked.submitted_at ASC, ranked.source_order ASC
     LIMIT 1`,
    [heistId, heistId]
  );

  if (!winner) {
    await db.query(
      "UPDATE heist SET status = 'completed', submissions_locked = 1 WHERE id = ?",
      [heistId]
    );
    return { found: true, winner: null, awarded_points: 0 };
  }

  if (Number(winner.is_demo)) {
    await db.query(
      `UPDATE heist
       SET winner_user_id = NULL, winner_demo_submission_id = ?, status = 'completed', submissions_locked = 1
       WHERE id = ?`,
      [winner.demo_submission_id, heistId]
    );
  } else {
    await db.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
      heist.prize_cop_points,
      winner.user_id,
    ]);
    await ensureLevelProgressTables(db);
    await awardConfiguredXp(db, {
      userId: winner.user_id,
      source: "heist_win",
      sourceId: `heist:${heistId}`,
      metadata: {
        heist_id: heistId,
        prize_cop_points: heist.prize_cop_points,
        submission_id: winner.submission_id,
      },
    });

    await db.query(
      `UPDATE heist
       SET winner_user_id = ?, winner_demo_submission_id = NULL, status = 'completed', submissions_locked = 1
       WHERE id = ?`,
      [winner.user_id, heistId]
    );

    sendPushToUser(
      winner.user_id,
      noticePayload({
        alertId: `heist:${heistId}:winner`,
        type: "winner",
        title: "You won a heist",
        body: `You won ${Number(heist.prize_cop_points || 0).toLocaleString()} CopUpCoin.`,
        path: `/heist/${heistId}/result`,
      })
    ).catch((pushErr) => console.error("heist winner push error:", pushErr.message));
  }

  return {
    found: true,
    winner: {
      user_id: winner.user_id,
      demo_submission_id: winner.demo_submission_id,
      username: winner.username,
      is_demo: Boolean(Number(winner.is_demo)),
      submission_id: winner.submission_id,
      correct_count: winner.correct_count,
      total_time_seconds: winner.total_time_seconds,
      submitted_at: winner.submitted_at,
    },
    awarded_points: Number(winner.is_demo) ? 0 : heist.prize_cop_points,
  };
}

async function recordAffiliateTaskProgress(db, heistId, affiliateUserId) {
  const [[heist]] = await db.query(
    "SELECT id, status FROM heist WHERE id = ? LIMIT 1 FOR UPDATE",
    [heistId]
  );
  if (!heist || heist.status === "completed" || heist.status === "cancelled") {
    return [];
  }

  const [tasks] = await db.query(
    `SELECT id, required_joins, reward_cop_points
     FROM affiliate_tasks
     WHERE heist_id = ? AND is_active = 1
     ORDER BY required_joins ASC, id ASC`,
    [heistId]
  );

  const updates = [];
  for (const task of tasks) {
    await db.query(
      `INSERT INTO affiliate_task_progress
        (task_id, user_id, current_joins, is_completed, rewarded_at)
       VALUES (?, ?, 1, 0, NULL)
       ON DUPLICATE KEY UPDATE
         current_joins = IF(is_completed = 1, current_joins, current_joins + 1)`,
      [task.id, affiliateUserId]
    );

    const [[progress]] = await db.query(
      `SELECT id, task_id, user_id, current_joins, is_completed, rewarded_at
       FROM affiliate_task_progress
       WHERE task_id = ? AND user_id = ?
       LIMIT 1 FOR UPDATE`,
      [task.id, affiliateUserId]
    );

    if (
      progress &&
      !Number(progress.is_completed) &&
      Number(progress.current_joins) >= Number(task.required_joins)
    ) {
      await db.query(
        `UPDATE affiliate_task_progress
         SET is_completed = 1, rewarded_at = NOW()
         WHERE id = ? AND is_completed = 0`,
        [progress.id]
      );
      await db.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
        task.reward_cop_points,
        affiliateUserId,
      ]);
      progress.is_completed = 1;
      progress.rewarded_at = new Date();
      progress.reward_cop_points = task.reward_cop_points;
      updates.push({
        task_id: task.id,
        current_joins: progress.current_joins,
        is_completed: true,
        rewarded: true,
        reward_cop_points: task.reward_cop_points,
      });
    } else if (progress) {
      updates.push({
        task_id: task.id,
        current_joins: progress.current_joins,
        is_completed: Boolean(Number(progress.is_completed)),
        rewarded: false,
        reward_cop_points: task.reward_cop_points,
      });
    }
  }

  return updates;
}

module.exports = {
  ensureHeistMaxUsersColumn,
  ensureHeistDemoSubmissionsTable,
  ensureHeistDemoUsersTable,
  ensureHeistWinnerDemoColumn,
  normalizeAnswer,
  makeReferralCode,
  makeReferralLink,
  getRankPreview,
  isDuplicateError,
  maybeStartCountdown,
  finalizeHeist,
  recordAffiliateTaskProgress,
};
