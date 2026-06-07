const { pool } = require("../conf/db");

let schemaReady = false;

function getClientIp(req) {
  const forwarded = String(req.headers["x-forwarded-for"] || "")
    .split(",")
    .map((item) => item.trim())
    .filter(Boolean);
  return forwarded[0] || req.ip || req.socket?.remoteAddress || null;
}

function getDeviceKey(req) {
  return (
    String(req.headers["x-copup-device-key"] || "").trim() ||
    String(req.body?.device_key || req.body?.deviceKey || "").trim() ||
    null
  );
}

function cleanUserAgent(req) {
  const agent = String(req.headers["user-agent"] || "").trim();
  return agent ? agent.slice(0, 500) : null;
}

async function ensureGodEyesSchema(conn = pool) {
  if (schemaReady) return;

  const addColumn = async (name, definition) => {
    const [[existing]] = await conn.query(
      `SELECT COLUMN_NAME
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = DATABASE()
         AND TABLE_NAME = 'users'
         AND COLUMN_NAME = ?
       LIMIT 1`,
      [name]
    );
    if (!existing) await conn.query(`ALTER TABLE users ADD COLUMN ${definition}`);
  };

  const addIndex = async (name, definition) => {
    const [[existing]] = await conn.query(
      `SELECT INDEX_NAME
       FROM INFORMATION_SCHEMA.STATISTICS
       WHERE TABLE_SCHEMA = DATABASE()
         AND TABLE_NAME = 'users'
         AND INDEX_NAME = ?
       LIMIT 1`,
      [name]
    );
    if (!existing) await conn.query(`ALTER TABLE users ADD KEY ${definition}`);
  };

  await addColumn("registration_ip", "registration_ip varchar(64) DEFAULT NULL AFTER game_id");
  await addColumn(
    "registration_device_key",
    "registration_device_key varchar(128) DEFAULT NULL AFTER registration_ip"
  );
  await addColumn(
    "last_login_at",
    "last_login_at timestamp NULL DEFAULT NULL AFTER registration_device_key"
  );
  await addColumn("last_seen_at", "last_seen_at timestamp NULL DEFAULT NULL AFTER last_login_at");
  await addIndex("idx_users_registration_device", "idx_users_registration_device (registration_device_key)");
  await addIndex("idx_users_registration_ip", "idx_users_registration_ip (registration_ip)");

  await conn.query(
    `CREATE TABLE IF NOT EXISTS user_activity_events (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id int(11) DEFAULT NULL,
      event_type varchar(32) NOT NULL,
      path varchar(255) DEFAULT NULL,
      method varchar(16) DEFAULT NULL,
      ip_address varchar(64) DEFAULT NULL,
      user_agent varchar(500) DEFAULT NULL,
      device_key varchar(128) DEFAULT NULL,
      metadata text DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_user_activity_user_created (user_id, created_at),
      KEY idx_user_activity_event_created (event_type, created_at),
      KEY idx_user_activity_ip_created (ip_address, created_at),
      KEY idx_user_activity_device_created (device_key, created_at),
      CONSTRAINT fk_user_activity_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE SET NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  schemaReady = true;
}

async function countAccountsForDevice(deviceKey, conn = pool) {
  if (!deviceKey) return 0;
  await ensureGodEyesSchema(conn);
  const [[row]] = await conn.query(
    "SELECT COUNT(*) AS total FROM users WHERE registration_device_key = ?",
    [deviceKey]
  );
  return Number(row?.total || 0);
}

async function recordActivity({
  userId = null,
  eventType,
  path = null,
  method = null,
  ipAddress = null,
  userAgent = null,
  deviceKey = null,
  metadata = null,
} = {}) {
  if (!eventType) return;
  try {
    await ensureGodEyesSchema();
    await pool.query(
      `INSERT INTO user_activity_events
        (user_id, event_type, path, method, ip_address, user_agent, device_key, metadata)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        userId || null,
        String(eventType).slice(0, 32),
        path ? String(path).slice(0, 255) : null,
        method ? String(method).slice(0, 16) : null,
        ipAddress ? String(ipAddress).slice(0, 64) : null,
        userAgent ? String(userAgent).slice(0, 500) : null,
        deviceKey ? String(deviceKey).slice(0, 128) : null,
        metadata ? JSON.stringify(metadata).slice(0, 5000) : null,
      ]
    );
  } catch (err) {
    console.warn("god eyes activity log skipped:", err?.message || err);
  }
}

async function recordRequestActivity(req, eventType, options = {}) {
  return recordActivity({
    userId: options.userId || req.user?.userId || req.user?.id || null,
    eventType,
    path: options.path || req.body?.path || req.originalUrl || req.path || null,
    method: options.method || req.method,
    ipAddress: getClientIp(req),
    userAgent: cleanUserAgent(req),
    deviceKey: getDeviceKey(req),
    metadata: options.metadata || null,
  });
}

module.exports = {
  ensureGodEyesSchema,
  getClientIp,
  getDeviceKey,
  cleanUserAgent,
  countAccountsForDevice,
  recordActivity,
  recordRequestActivity,
};
