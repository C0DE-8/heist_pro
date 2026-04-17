function normalizeAnswer(value) {
  const answer = String(value || "").trim().toLowerCase();
  return answer === "true" || answer === "false" ? answer : null;
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
    `SELECT id, prize_cop_points, status, submissions_locked, winner_user_id
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
      winner: heist.winner_user_id ? { user_id: heist.winner_user_id } : null,
      awarded_points: 0,
    };
  }

  const [[winner]] = await db.query(
    `SELECT hs.id AS submission_id, hs.user_id, u.username,
            hs.correct_count, hs.total_time_seconds, hs.submitted_at
     FROM heist_submissions hs
     JOIN users u ON u.id = hs.user_id
     WHERE hs.heist_id = ? AND hs.status = 'submitted'
     ORDER BY hs.correct_count DESC, hs.total_time_seconds ASC, hs.submitted_at ASC
     LIMIT 1`,
    [heistId]
  );

  if (!winner) {
    await db.query(
      "UPDATE heist SET status = 'completed', submissions_locked = 1 WHERE id = ?",
      [heistId]
    );
    return { found: true, winner: null, awarded_points: 0 };
  }

  await db.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
    heist.prize_cop_points,
    winner.user_id,
  ]);

  await db.query(
    `UPDATE heist
     SET winner_user_id = ?, status = 'completed', submissions_locked = 1
     WHERE id = ?`,
    [winner.user_id, heistId]
  );

  return {
    found: true,
    winner: {
      user_id: winner.user_id,
      username: winner.username,
      submission_id: winner.submission_id,
      correct_count: winner.correct_count,
      total_time_seconds: winner.total_time_seconds,
      submitted_at: winner.submitted_at,
    },
    awarded_points: heist.prize_cop_points,
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
  normalizeAnswer,
  makeReferralCode,
  makeReferralLink,
  getRankPreview,
  isDuplicateError,
  maybeStartCountdown,
  finalizeHeist,
  recordAffiliateTaskProgress,
};
