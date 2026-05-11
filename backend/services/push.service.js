const admin = require("firebase-admin");
const { pool } = require("../conf/db");

let firebaseReady = false;

function parseServiceAccount() {
  if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
    return JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
  }

  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n");

  if (projectId && clientEmail && privateKey) {
    return { projectId, clientEmail, privateKey };
  }

  return null;
}

function getMessaging() {
  if (!firebaseReady) {
    const serviceAccount = parseServiceAccount();
    if (!serviceAccount) return null;

    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
    }
    firebaseReady = true;
  }

  return admin.messaging();
}

async function ensurePushTokenTable(db = pool) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS push_device_tokens (
      id int(11) NOT NULL AUTO_INCREMENT,
      user_id int(11) NOT NULL,
      token varchar(512) NOT NULL,
      platform varchar(32) NOT NULL DEFAULT 'android',
      app_version varchar(64) DEFAULT NULL,
      last_seen_at timestamp NOT NULL DEFAULT current_timestamp(),
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_push_device_token (token),
      KEY idx_push_device_tokens_user (user_id)
    )`
  );
}

async function registerPushToken({ userId, token, platform = "android", appVersion = null }) {
  if (!userId || !token) return;
  await ensurePushTokenTable();
  await pool.query(
    `INSERT INTO push_device_tokens (user_id, token, platform, app_version, last_seen_at)
     VALUES (?, ?, ?, ?, NOW())
     ON DUPLICATE KEY UPDATE
       user_id = VALUES(user_id),
       platform = VALUES(platform),
       app_version = VALUES(app_version),
       last_seen_at = NOW()`,
    [userId, token, platform, appVersion]
  );
}

async function unregisterPushToken({ userId, token }) {
  if (!userId || !token) return;
  await ensurePushTokenTable();
  await pool.query("DELETE FROM push_device_tokens WHERE user_id = ? AND token = ?", [userId, token]);
}

async function getUserTokens(userId) {
  await ensurePushTokenTable();
  const [rows] = await pool.query(
    "SELECT token FROM push_device_tokens WHERE user_id = ? ORDER BY last_seen_at DESC",
    [userId]
  );
  return rows.map((row) => row.token).filter(Boolean);
}

async function removeInvalidTokens(tokens) {
  if (!tokens.length) return;
  await pool.query("DELETE FROM push_device_tokens WHERE token IN (?)", [tokens]);
}

function buildMessage(token, payload) {
  const data = {};
  Object.entries(payload.data || {}).forEach(([key, value]) => {
    if (value !== undefined && value !== null) data[key] = String(value);
  });

  return {
    token,
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data,
    android: {
      priority: "high",
      notification: {
        channelId: "copup_notices",
        icon: "ic_stat_copup",
        color: "#39D98A",
        sound: "default",
        clickAction: "OPEN_NOTICE",
      },
    },
  };
}

async function sendPushToUser(userId, payload) {
  const messaging = getMessaging();
  if (!messaging) {
    console.warn("FCM not configured; skipping push notification");
    return { sent: 0, skipped: true };
  }

  const tokens = await getUserTokens(userId);
  if (!tokens.length) return { sent: 0 };

  const results = await Promise.allSettled(
    tokens.map((token) => messaging.send(buildMessage(token, payload)))
  );

  const invalidTokens = [];
  let sent = 0;
  results.forEach((result, index) => {
    if (result.status === "fulfilled") {
      sent += 1;
      return;
    }

    const code = result.reason?.errorInfo?.code || result.reason?.code;
    if (
      code === "messaging/registration-token-not-registered" ||
      code === "messaging/invalid-registration-token"
    ) {
      invalidTokens.push(tokens[index]);
      return;
    }

    console.error("FCM send error:", result.reason?.message || result.reason);
  });

  await removeInvalidTokens(invalidTokens);
  return { sent };
}

function noticePayload({ alertId, type, title, body, path }) {
  return {
    title,
    body,
    data: {
      alertId,
      type,
      path: path || "/dashboard",
    },
  };
}

module.exports = {
  registerPushToken,
  unregisterPushToken,
  sendPushToUser,
  noticePayload,
};
