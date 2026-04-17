const { pool } = require("../conf/db");
const { maybeStartCountdown, finalizeHeist } = require("../services/heist.service");

let timer = null;
let running = false;

async function runHeistCronOnce() {
  if (running) return;
  running = true;

  try {
    await startEligibleCountdowns();
    await finalizeExpiredHeists();
  } catch (err) {
    console.error("heist cron error:", err);
  } finally {
    running = false;
  }
}

async function startEligibleCountdowns() {
  const [rows] = await pool.query(
    `SELECT h.id
     FROM heist h
     JOIN heist_participants hp ON hp.heist_id = h.id
     WHERE h.status = 'pending'
       AND hp.status IN ('joined', 'submitted')
     GROUP BY h.id, h.min_users
     HAVING COUNT(hp.id) >= h.min_users`
  );

  for (const row of rows) {
    const conn = await pool.getConnection();
    try {
      await conn.beginTransaction();
      const started = await maybeStartCountdown(conn, row.id);
      await conn.commit();
      if (started) console.log(`Heist countdown started: ${row.id}`);
    } catch (err) {
      await conn.rollback();
      console.error(`heist countdown error (${row.id}):`, err);
    } finally {
      conn.release();
    }
  }
}

async function finalizeExpiredHeists() {
  const [rows] = await pool.query(
    `SELECT id
     FROM heist
     WHERE status = 'started'
       AND submissions_locked = 0
       AND (
         (countdown_ends_at IS NOT NULL AND countdown_ends_at <= NOW())
         OR (countdown_ends_at IS NULL AND ends_at IS NOT NULL AND ends_at <= NOW())
       )`
  );

  for (const row of rows) {
    const conn = await pool.getConnection();
    try {
      await conn.beginTransaction();
      const result = await finalizeHeist(conn, row.id);
      await conn.commit();
      if (result.found && !result.already_completed) {
        console.log(`Heist finalized: ${row.id}`);
      }
    } catch (err) {
      await conn.rollback();
      console.error(`heist finalize error (${row.id}):`, err);
    } finally {
      conn.release();
    }
  }
}

function startHeistCron() {
  if (timer) return timer;

  const intervalMs = Number(process.env.HEIST_CRON_INTERVAL_MS || 30000);
  timer = setInterval(runHeistCronOnce, intervalMs);
  timer.unref?.();
  runHeistCronOnce();
  return timer;
}

function stopHeistCron() {
  if (!timer) return;
  clearInterval(timer);
  timer = null;
}

module.exports = {
  startHeistCron,
  stopHeistCron,
  runHeistCronOnce,
};
