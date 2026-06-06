let promoTablesReady = false;

function normalizePromoCode(value) {
  return String(value || "").trim().toUpperCase();
}

function parsePositiveInt(value, field) {
  const number = Number(value);
  if (!Number.isInteger(number) || number < 1) {
    return { ok: false, message: `${field} must be 1 or greater` };
  }
  return { ok: true, value: number };
}

async function ensurePromoTables(db) {
  if (promoTablesReady) return;

  await db.query(
    `CREATE TABLE IF NOT EXISTS promo_codes (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      code varchar(64) NOT NULL,
      copup_jr_amount int(11) NOT NULL,
      max_redemptions int(11) DEFAULT NULL,
      redemption_count int(11) NOT NULL DEFAULT 0,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      expires_at datetime DEFAULT NULL,
      created_by int(11) DEFAULT NULL,
      updated_by int(11) DEFAULT NULL,
      deleted_at datetime DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_promo_codes_code (code),
      KEY idx_promo_codes_status (is_active, expires_at, deleted_at),
      KEY idx_promo_codes_created_by (created_by)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS promo_code_redemptions (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      promo_code_id bigint(20) UNSIGNED NOT NULL,
      user_id int(11) NOT NULL,
      amount int(11) NOT NULL,
      redeemed_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_promo_redemptions_code_user (promo_code_id, user_id),
      KEY idx_promo_redemptions_user (user_id),
      CONSTRAINT fk_promo_redemptions_code
        FOREIGN KEY (promo_code_id) REFERENCES promo_codes (id)
        ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS user_copup_jr_balances (
      user_id int(11) NOT NULL,
      balance int(11) NOT NULL DEFAULT 0,
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (user_id),
      CONSTRAINT fk_user_copup_jr_balances_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS user_copup_jr_ledger (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id int(11) NOT NULL,
      promo_code_id bigint(20) UNSIGNED DEFAULT NULL,
      redemption_id bigint(20) UNSIGNED DEFAULT NULL,
      heist_id int(11) DEFAULT NULL,
      direction enum('credit','debit') NOT NULL,
      amount int(11) NOT NULL,
      balance_after int(11) NOT NULL,
      reason varchar(80) NOT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_copup_jr_ledger_user_created (user_id, created_at),
      KEY idx_copup_jr_ledger_heist (heist_id),
      KEY idx_copup_jr_ledger_promo (promo_code_id),
      CONSTRAINT fk_copup_jr_ledger_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
      CONSTRAINT fk_copup_jr_ledger_promo
        FOREIGN KEY (promo_code_id) REFERENCES promo_codes (id)
        ON DELETE SET NULL,
      CONSTRAINT fk_copup_jr_ledger_redemption
        FOREIGN KEY (redemption_id) REFERENCES promo_code_redemptions (id)
        ON DELETE SET NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  promoTablesReady = true;
}

async function lockCopupJrBalance(conn, userId) {
  await conn.query(
    `INSERT INTO user_copup_jr_balances (user_id, balance)
     VALUES (?, 0)
     ON DUPLICATE KEY UPDATE balance = balance`,
    [userId]
  );

  const [[row]] = await conn.query(
    `SELECT user_id, balance
     FROM user_copup_jr_balances
     WHERE user_id = ?
     LIMIT 1 FOR UPDATE`,
    [userId]
  );

  return row || { user_id: userId, balance: 0 };
}

async function getCopupJrBalance(db, userId) {
  const [[row]] = await db.query(
    "SELECT balance FROM user_copup_jr_balances WHERE user_id = ? LIMIT 1",
    [userId]
  );
  return Number(row?.balance || 0);
}

async function redeemPromoCode(conn, { userId, rawCode }) {
  const code = normalizePromoCode(rawCode);
  if (!code) return { status: 400, body: { message: "Promo code is required" } };

  const [[promo]] = await conn.query(
    `SELECT id, code, copup_jr_amount, max_redemptions, redemption_count, is_active, expires_at, deleted_at
     FROM promo_codes
     WHERE code = ?
     LIMIT 1 FOR UPDATE`,
    [code]
  );

  if (!promo || promo.deleted_at) {
    return { status: 404, body: { message: "Promo code not found" } };
  }
  if (!Number(promo.is_active)) {
    return { status: 400, body: { message: "Promo code is inactive" } };
  }
  if (promo.expires_at && new Date(promo.expires_at).getTime() <= Date.now()) {
    return { status: 400, body: { message: "Promo code has expired" } };
  }
  if (
    promo.max_redemptions !== null &&
    Number(promo.redemption_count || 0) >= Number(promo.max_redemptions)
  ) {
    return { status: 400, body: { message: "Promo code has reached its limit" } };
  }

  const [[existing]] = await conn.query(
    `SELECT id
     FROM promo_code_redemptions
     WHERE promo_code_id = ? AND user_id = ?
     LIMIT 1`,
    [promo.id, userId]
  );
  if (existing) {
    return { status: 400, body: { message: "You have already used this promo code" } };
  }

  const balance = await lockCopupJrBalance(conn, userId);
  const amount = Number(promo.copup_jr_amount || 0);
  const nextBalance = Number(balance.balance || 0) + amount;

  const [redemption] = await conn.query(
    `INSERT INTO promo_code_redemptions (promo_code_id, user_id, amount)
     VALUES (?, ?, ?)`,
    [promo.id, userId, amount]
  );
  await conn.query(
    `UPDATE promo_codes
     SET redemption_count = redemption_count + 1
     WHERE id = ?`,
    [promo.id]
  );
  await conn.query(
    `UPDATE user_copup_jr_balances
     SET balance = ?
     WHERE user_id = ?`,
    [nextBalance, userId]
  );
  await conn.query(
    `INSERT INTO user_copup_jr_ledger
      (user_id, promo_code_id, redemption_id, direction, amount, balance_after, reason)
     VALUES (?, ?, ?, 'credit', ?, ?, 'promo_redeem')`,
    [userId, promo.id, redemption.insertId, amount, nextBalance]
  );

  return {
    status: 201,
    body: {
      message: "Promo code redeemed",
      code: promo.code,
      credited_copup_jr: amount,
      copup_jr_balance: nextBalance,
    },
  };
}

module.exports = {
  ensurePromoTables,
  normalizePromoCode,
  parsePositiveInt,
  lockCopupJrBalance,
  getCopupJrBalance,
  redeemPromoCode,
};
