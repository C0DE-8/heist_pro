function normalizeAnswer(value) {
  const answer = String(value || "").trim().toLowerCase();
  return answer === "true" || answer === "false" ? answer : null;
}

function makeReferralCode() {
  return `H${Math.random().toString(36).slice(2, 10).toUpperCase()}`;
}

function getBaseUrl(req) {
  return process.env.FRONTEND_BASE_URL || `${req.protocol}://${req.get("host")}`;
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

module.exports = {
  normalizeAnswer,
  makeReferralCode,
  makeReferralLink,
  getRankPreview,
  isDuplicateError,
  maybeStartCountdown,
  finalizeHeist,
};
