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

module.exports = {
  normalizeAnswer,
  makeReferralCode,
  makeReferralLink,
  getRankPreview,
  isDuplicateError,
};
