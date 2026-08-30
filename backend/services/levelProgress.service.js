let levelProgressTablesReady = false;

const ROMAN_LEVELS = ["I", "II", "III", "IV", "V"];

const DEFAULT_BADGES = [
  "Beginner",
  "Rookie",
  "Hustler",
  "Raider",
  "Specialist",
  "Elite",
  "Mastermind",
  "Legend",
];

const DEFAULT_XP_RULES = [
  ["daily_login", 10, "Daily login", 1],
  ["heist_play", 15, "Play a heist", 1],
  ["heist_win", 100, "Win a heist", 1],
  ["referral_signup", 50, "Referral signup", 1],
  ["deposit", 1, "Completed deposit", 1],
  ["withdrawal", 1, "Completed withdrawal", 1],
  ["admin_adjustment", 0, "Admin adjustment", 1],
];

function parsePositiveInt(value, field) {
  const number = Number(value);
  if (!Number.isInteger(number) || number < 1) {
    return { ok: false, message: `${field} must be 1 or greater` };
  }
  return { ok: true, value: number };
}

function parseNonNegativeInt(value, field) {
  const number = Number(value);
  if (!Number.isInteger(number) || number < 0) {
    return { ok: false, message: `${field} must be 0 or greater` };
  }
  return { ok: true, value: number };
}

function normalizeSource(value) {
  return String(value || "").trim().toLowerCase();
}

function makeJson(value) {
  if (value === undefined || value === null) return null;
  return JSON.stringify(value);
}

function makeLevelCouponCode(userId, levelOrder) {
  const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const random = Array.from({ length: 8 }, () =>
    alphabet[Math.floor(Math.random() * alphabet.length)]
  ).join("");
  return `LVL${levelOrder}-${userId}-${random}`;
}

async function ensureLevelProgressTables(db) {
  if (levelProgressTablesReady) return;

  await db.query(
    `CREATE TABLE IF NOT EXISTS level_badges (
      id int(11) NOT NULL AUTO_INCREMENT,
      name varchar(80) NOT NULL,
      badge_order int(11) NOT NULL,
      image_path varchar(255) DEFAULT NULL,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_level_badges_order (badge_order),
      UNIQUE KEY uniq_level_badges_name (name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS level_definitions (
      id int(11) NOT NULL AUTO_INCREMENT,
      badge_id int(11) NOT NULL,
      level_order int(11) NOT NULL,
      badge_level int(11) NOT NULL,
      roman_label varchar(8) NOT NULL,
      xp_required int(11) NOT NULL,
      coupon_copup_jr_amount int(11) NOT NULL DEFAULT 0,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_level_definitions_order (level_order),
      UNIQUE KEY uniq_level_definitions_badge_level (badge_id, badge_level),
      KEY idx_level_definitions_xp (xp_required),
      CONSTRAINT fk_level_definitions_badge
        FOREIGN KEY (badge_id) REFERENCES level_badges (id)
        ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS xp_source_rules (
      source varchar(40) NOT NULL,
      xp_amount int(11) NOT NULL DEFAULT 0,
      label varchar(120) NOT NULL,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      updated_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (source)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS user_xp_totals (
      user_id int(11) NOT NULL,
      total_xp int(11) NOT NULL DEFAULT 0,
      current_level_definition_id int(11) DEFAULT NULL,
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (user_id),
      KEY idx_user_xp_totals_level (current_level_definition_id),
      CONSTRAINT fk_user_xp_totals_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
      CONSTRAINT fk_user_xp_totals_level
        FOREIGN KEY (current_level_definition_id) REFERENCES level_definitions (id)
        ON DELETE SET NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS user_xp_events (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id int(11) NOT NULL,
      source varchar(40) NOT NULL,
      source_id varchar(120) NOT NULL,
      xp_amount int(11) NOT NULL,
      metadata json DEFAULT NULL,
      created_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_user_xp_event_source (user_id, source, source_id),
      KEY idx_user_xp_events_user_created (user_id, created_at),
      KEY idx_user_xp_events_source (source),
      CONSTRAINT fk_user_xp_events_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS user_level_rewards (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id int(11) NOT NULL,
      level_definition_id int(11) NOT NULL,
      code varchar(80) NOT NULL,
      copup_jr_amount int(11) NOT NULL DEFAULT 0,
      status enum('earned','claimed','redeemed','expired') NOT NULL DEFAULT 'earned',
      earned_at timestamp NOT NULL DEFAULT current_timestamp(),
      claimed_at datetime DEFAULT NULL,
      redeemed_at datetime DEFAULT NULL,
      expires_at datetime DEFAULT NULL,
      metadata json DEFAULT NULL,
      PRIMARY KEY (id),
      UNIQUE KEY uniq_user_level_reward (user_id, level_definition_id),
      UNIQUE KEY uniq_user_level_reward_code (code),
      KEY idx_user_level_rewards_user_status (user_id, status),
      KEY idx_user_level_rewards_level (level_definition_id),
      CONSTRAINT fk_user_level_rewards_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
      CONSTRAINT fk_user_level_rewards_level
        FOREIGN KEY (level_definition_id) REFERENCES level_definitions (id)
        ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS level_admin_audit_logs (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      admin_user_id int(11) DEFAULT NULL,
      target_user_id int(11) DEFAULT NULL,
      action varchar(80) NOT NULL,
      metadata json DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_level_admin_audit_admin (admin_user_id, created_at),
      KEY idx_level_admin_audit_target (target_user_id, created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );

  await seedDefaultLevelProgressData(db);
  levelProgressTablesReady = true;
}

async function seedDefaultLevelProgressData(db) {
  for (let index = 0; index < DEFAULT_BADGES.length; index += 1) {
    await db.query(
      `INSERT INTO level_badges (name, badge_order, is_active)
       VALUES (?, ?, 1)
       ON DUPLICATE KEY UPDATE name = VALUES(name), is_active = level_badges.is_active`,
      [DEFAULT_BADGES[index], index + 1]
    );
  }

  const [badges] = await db.query("SELECT id, name, badge_order FROM level_badges");
  const badgeByOrder = new Map(badges.map((badge) => [Number(badge.badge_order), badge]));

  for (let badgeOrder = 1; badgeOrder <= DEFAULT_BADGES.length; badgeOrder += 1) {
    const badge = badgeByOrder.get(badgeOrder);
    if (!badge) continue;
    for (let badgeLevel = 1; badgeLevel <= 5; badgeLevel += 1) {
      const levelOrder = (badgeOrder - 1) * 5 + badgeLevel;
      const xpRequired = levelOrder === 1 ? 0 : (levelOrder - 1) * 100;
      const couponAmount = levelOrder * 5;
      await db.query(
        `INSERT INTO level_definitions
          (badge_id, level_order, badge_level, roman_label, xp_required, coupon_copup_jr_amount, is_active)
         VALUES (?, ?, ?, ?, ?, ?, 1)
         ON DUPLICATE KEY UPDATE
           badge_id = VALUES(badge_id),
           badge_level = VALUES(badge_level),
           roman_label = VALUES(roman_label),
           xp_required = level_definitions.xp_required,
           coupon_copup_jr_amount = level_definitions.coupon_copup_jr_amount,
           is_active = level_definitions.is_active`,
        [badge.id, levelOrder, badgeLevel, ROMAN_LEVELS[badgeLevel - 1], xpRequired, couponAmount]
      );
    }
  }

  for (const [source, xpAmount, label, isActive] of DEFAULT_XP_RULES) {
    await db.query(
      `INSERT INTO xp_source_rules (source, xp_amount, label, is_active)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE source = source`,
      [source, xpAmount, label, isActive]
    );
  }
}

async function getXpRule(db, source) {
  const normalizedSource = normalizeSource(source);
  const [[rule]] = await db.query(
    "SELECT source, xp_amount, label, is_active FROM xp_source_rules WHERE source = ? LIMIT 1",
    [normalizedSource]
  );
  if (!rule || !Number(rule.is_active)) return null;
  return {
    ...rule,
    xp_amount: Number(rule.xp_amount || 0),
  };
}

async function lockUserXpTotal(conn, userId) {
  await conn.query(
    `INSERT INTO user_xp_totals (user_id, total_xp)
     VALUES (?, 0)
     ON DUPLICATE KEY UPDATE user_id = user_id`,
    [userId]
  );

  const [[row]] = await conn.query(
    `SELECT user_id, total_xp, current_level_definition_id
     FROM user_xp_totals
     WHERE user_id = ?
     LIMIT 1 FOR UPDATE`,
    [userId]
  );
  return row || { user_id: userId, total_xp: 0, current_level_definition_id: null };
}

async function getLevelForXp(db, totalXp) {
  const [[level]] = await db.query(
    `SELECT ld.id, ld.badge_id, ld.level_order, ld.badge_level, ld.roman_label,
            ld.xp_required, ld.coupon_copup_jr_amount, b.name AS badge_name, b.image_path
     FROM level_definitions ld
     JOIN level_badges b ON b.id = ld.badge_id
     WHERE ld.is_active = 1
       AND b.is_active = 1
       AND ld.xp_required <= ?
     ORDER BY ld.xp_required DESC, ld.level_order DESC
     LIMIT 1`,
    [Number(totalXp || 0)]
  );
  return level || null;
}

async function getNextLevel(db, currentLevelOrder) {
  const [[level]] = await db.query(
    `SELECT ld.id, ld.badge_id, ld.level_order, ld.badge_level, ld.roman_label,
            ld.xp_required, ld.coupon_copup_jr_amount, b.name AS badge_name, b.image_path
     FROM level_definitions ld
     JOIN level_badges b ON b.id = ld.badge_id
     WHERE ld.is_active = 1
       AND b.is_active = 1
       AND ld.level_order > ?
     ORDER BY ld.level_order ASC
     LIMIT 1`,
    [Number(currentLevelOrder || 0)]
  );
  return level || null;
}

async function createRewardsForReachedLevels(conn, userId, previousLevelOrder, currentLevelOrder) {
  if (Number(currentLevelOrder || 0) <= Number(previousLevelOrder || 0)) return [];

  const [levels] = await conn.query(
    `SELECT id, level_order, coupon_copup_jr_amount
     FROM level_definitions
     WHERE is_active = 1
       AND level_order > ?
       AND level_order <= ?
       AND coupon_copup_jr_amount > 0
     ORDER BY level_order ASC`,
    [Number(previousLevelOrder || 0), Number(currentLevelOrder || 0)]
  );

  const rewards = [];
  for (const level of levels) {
    let code = makeLevelCouponCode(userId, level.level_order);
    for (let attempt = 0; attempt < 4; attempt += 1) {
      try {
        const [result] = await conn.query(
          `INSERT INTO user_level_rewards
            (user_id, level_definition_id, code, copup_jr_amount, metadata)
           VALUES (?, ?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)`,
          [
            userId,
            level.id,
            code,
            Number(level.coupon_copup_jr_amount || 0),
            makeJson({ reason: "level_up" }),
          ]
        );
        rewards.push({
          id: Number(result.insertId),
          level_definition_id: Number(level.id),
          level_order: Number(level.level_order),
          code,
          copup_jr_amount: Number(level.coupon_copup_jr_amount || 0),
        });
        break;
      } catch (err) {
        if (err?.code !== "ER_DUP_ENTRY" || attempt === 3) throw err;
        code = makeLevelCouponCode(userId, level.level_order);
      }
    }
  }
  return rewards;
}

async function awardXp(conn, { userId, source, sourceId, amount, metadata, createdBy }) {
  const normalizedSource = normalizeSource(source);
  const normalizedSourceId = String(sourceId || "").trim();
  if (!userId || !normalizedSource || !normalizedSourceId) {
    return { awarded: false, reason: "missing_required_fields" };
  }

  await ensureLevelProgressTables(conn);

  let xpAmount = Number(amount);
  if (!Number.isInteger(xpAmount)) {
    const rule = await getXpRule(conn, normalizedSource);
    xpAmount = Number(rule?.xp_amount || 0);
  }
  if (xpAmount <= 0) return { awarded: false, reason: "no_xp" };

  const totalBefore = await lockUserXpTotal(conn, userId);
  const previousLevel = await getLevelForXp(conn, totalBefore.total_xp);

  const [eventResult] = await conn.query(
    `INSERT IGNORE INTO user_xp_events
      (user_id, source, source_id, xp_amount, metadata, created_by)
     VALUES (?, ?, ?, ?, ?, ?)`,
    [userId, normalizedSource, normalizedSourceId, xpAmount, makeJson(metadata), createdBy || null]
  );

  if (!eventResult.affectedRows) {
    return { awarded: false, reason: "duplicate", total_xp: Number(totalBefore.total_xp || 0) };
  }

  const nextTotalXp = Number(totalBefore.total_xp || 0) + xpAmount;
  const currentLevel = await getLevelForXp(conn, nextTotalXp);

  await conn.query(
    `UPDATE user_xp_totals
     SET total_xp = ?, current_level_definition_id = ?
     WHERE user_id = ?`,
    [nextTotalXp, currentLevel?.id || null, userId]
  );

  const rewards = await createRewardsForReachedLevels(
    conn,
    userId,
    previousLevel?.level_order || 0,
    currentLevel?.level_order || 0
  );

  return {
    awarded: true,
    xp_awarded: xpAmount,
    total_xp: nextTotalXp,
    previous_level: previousLevel,
    current_level: currentLevel,
    level_up: Number(currentLevel?.level_order || 0) > Number(previousLevel?.level_order || 0),
    rewards,
  };
}

async function awardConfiguredXp(conn, { userId, source, sourceId, metadata, createdBy }) {
  await ensureLevelProgressTables(conn);
  const rule = await getXpRule(conn, source);
  if (!rule) return { awarded: false, reason: "xp_rule_inactive" };
  return awardXp(conn, {
    userId,
    source,
    sourceId,
    amount: rule.xp_amount,
    metadata: { ...(metadata || {}), rule_label: rule.label },
    createdBy,
  });
}

async function adjustUserXp(conn, { userId, xpAmount, sourceId, metadata, createdBy }) {
  const amount = Number(xpAmount);
  if (!Number.isInteger(amount) || amount === 0) {
    return { awarded: false, reason: "invalid_adjustment" };
  }

  await ensureLevelProgressTables(conn);
  const totalBefore = await lockUserXpTotal(conn, userId);
  const previousLevel = await getLevelForXp(conn, totalBefore.total_xp);

  const [eventResult] = await conn.query(
    `INSERT IGNORE INTO user_xp_events
      (user_id, source, source_id, xp_amount, metadata, created_by)
     VALUES (?, 'admin_adjustment', ?, ?, ?, ?)`,
    [
      userId,
      String(sourceId || `admin:${createdBy || "system"}:${Date.now()}`),
      amount,
      makeJson(metadata),
      createdBy || null,
    ]
  );

  if (!eventResult.affectedRows) {
    return { awarded: false, reason: "duplicate", total_xp: Number(totalBefore.total_xp || 0) };
  }

  const nextTotalXp = Math.max(0, Number(totalBefore.total_xp || 0) + amount);
  const currentLevel = await getLevelForXp(conn, nextTotalXp);
  await conn.query(
    `UPDATE user_xp_totals
     SET total_xp = ?, current_level_definition_id = ?
     WHERE user_id = ?`,
    [nextTotalXp, currentLevel?.id || null, userId]
  );

  const rewards = amount > 0
    ? await createRewardsForReachedLevels(
        conn,
        userId,
        previousLevel?.level_order || 0,
        currentLevel?.level_order || 0
      )
    : [];

  return {
    awarded: true,
    xp_awarded: amount,
    total_xp: nextTotalXp,
    previous_level: previousLevel,
    current_level: currentLevel,
    level_up: Number(currentLevel?.level_order || 0) > Number(previousLevel?.level_order || 0),
    rewards,
  };
}

async function getUserProgress(db, userId) {
  await ensureLevelProgressTables(db);
  const total = await lockUserXpTotal(db, userId);
  const currentLevel = await getLevelForXp(db, total.total_xp);
  const nextLevel = await getNextLevel(db, currentLevel?.level_order || 0);
  const currentXp = Number(total.total_xp || 0);
  const currentRequired = Number(currentLevel?.xp_required || 0);
  const nextRequired = Number(nextLevel?.xp_required || currentRequired);
  const span = Math.max(1, nextRequired - currentRequired);
  const progressPercent = nextLevel
    ? Math.max(0, Math.min(100, Math.round(((currentXp - currentRequired) / span) * 100)))
    : 100;

  const [recentEvents] = await db.query(
    `SELECT id, source, source_id, xp_amount, metadata, created_at
     FROM user_xp_events
     WHERE user_id = ?
     ORDER BY created_at DESC
     LIMIT 20`,
    [userId]
  );

  const [rewards] = await db.query(
    `SELECT r.id, r.code, r.copup_jr_amount, r.status, r.earned_at, r.claimed_at,
            r.redeemed_at, r.expires_at, ld.level_order, ld.roman_label, b.name AS badge_name
     FROM user_level_rewards r
     JOIN level_definitions ld ON ld.id = r.level_definition_id
     JOIN level_badges b ON b.id = ld.badge_id
     WHERE r.user_id = ?
     ORDER BY r.earned_at DESC, r.id DESC
     LIMIT 20`,
    [userId]
  );

  return {
    total_xp: currentXp,
    current_level: currentLevel,
    next_level: nextLevel,
    progress_percent: progressPercent,
    xp_to_next_level: nextLevel ? Math.max(0, nextRequired - currentXp) : 0,
    recent_events: recentEvents,
    rewards,
    unclaimed_reward_count: rewards.filter((reward) => reward.status === "earned").length,
  };
}

async function getUserRewards(db, userId) {
  await ensureLevelProgressTables(db);
  const [rows] = await db.query(
    `SELECT r.id, r.code, r.copup_jr_amount, r.status, r.earned_at, r.claimed_at,
            r.redeemed_at, r.expires_at, ld.level_order, ld.roman_label,
            b.name AS badge_name, b.image_path
     FROM user_level_rewards r
     JOIN level_definitions ld ON ld.id = r.level_definition_id
     JOIN level_badges b ON b.id = ld.badge_id
     WHERE r.user_id = ?
     ORDER BY ld.level_order DESC, r.earned_at DESC`,
    [userId]
  );
  return rows;
}

async function claimLevelReward(conn, { userId, rewardId }) {
  await ensureLevelProgressTables(conn);
  const [[reward]] = await conn.query(
    `SELECT id, user_id, code, copup_jr_amount, status, expires_at
     FROM user_level_rewards
     WHERE id = ?
     LIMIT 1 FOR UPDATE`,
    [rewardId]
  );

  if (!reward) return { status: 404, body: { message: "Reward not found" } };
  if (Number(reward.user_id) !== Number(userId)) {
    return { status: 403, body: { message: "Reward does not belong to this user" } };
  }
  if (reward.expires_at && new Date(reward.expires_at).getTime() <= Date.now()) {
    await conn.query("UPDATE user_level_rewards SET status = 'expired' WHERE id = ?", [rewardId]);
    return { status: 400, body: { message: "Reward has expired" } };
  }
  if (reward.status !== "earned") {
    return { status: 400, body: { message: "Reward already claimed or redeemed" } };
  }

  await conn.query(
    "UPDATE user_level_rewards SET status = 'claimed', claimed_at = NOW() WHERE id = ?",
    [rewardId]
  );

  return {
    status: 200,
    body: {
      message: "Reward claimed",
      reward: {
        id: reward.id,
        code: reward.code,
        copup_jr_amount: Number(reward.copup_jr_amount || 0),
        status: "claimed",
      },
    },
  };
}

async function redeemLevelRewardCode(conn, { userId, rawCode, lockCopupJrBalance }) {
  await ensureLevelProgressTables(conn);
  const code = String(rawCode || "").trim().toUpperCase();
  if (!code) return { status: 400, body: { message: "Reward code is required" } };

  const [[reward]] = await conn.query(
    `SELECT id, user_id, code, copup_jr_amount, status, expires_at
     FROM user_level_rewards
     WHERE code = ?
     LIMIT 1 FOR UPDATE`,
    [code]
  );

  if (!reward) return { status: 404, body: { message: "Reward code not found" } };
  if (Number(reward.user_id) !== Number(userId)) {
    return { status: 403, body: { message: "Reward code does not belong to this user" } };
  }
  if (reward.expires_at && new Date(reward.expires_at).getTime() <= Date.now()) {
    await conn.query("UPDATE user_level_rewards SET status = 'expired' WHERE id = ?", [reward.id]);
    return { status: 400, body: { message: "Reward code has expired" } };
  }
  if (reward.status === "redeemed") {
    return { status: 400, body: { message: "Reward code already redeemed" } };
  }
  if (!["earned", "claimed"].includes(reward.status)) {
    return { status: 400, body: { message: "Reward code cannot be redeemed" } };
  }

  const balance = await lockCopupJrBalance(conn, userId);
  const amount = Number(reward.copup_jr_amount || 0);
  const nextBalance = Number(balance.balance || 0) + amount;

  await conn.query(
    "UPDATE user_copup_jr_balances SET balance = ? WHERE user_id = ?",
    [nextBalance, userId]
  );
  await conn.query(
    `INSERT INTO user_copup_jr_ledger
      (user_id, direction, amount, balance_after, reason)
     VALUES (?, 'credit', ?, ?, 'level_reward_redeem')`,
    [userId, amount, nextBalance]
  );
  await conn.query(
    "UPDATE user_level_rewards SET status = 'redeemed', claimed_at = COALESCE(claimed_at, NOW()), redeemed_at = NOW() WHERE id = ?",
    [reward.id]
  );

  return {
    status: 200,
    body: {
      message: "Reward code redeemed",
      code: reward.code,
      credited_copup_jr: amount,
      copup_jr_balance: nextBalance,
    },
  };
}

async function listLevels(db) {
  await ensureLevelProgressTables(db);
  const [rows] = await db.query(
    `SELECT ld.id, ld.level_order, ld.badge_level, ld.roman_label, ld.xp_required,
            ld.coupon_copup_jr_amount, ld.is_active, b.id AS badge_id,
            b.name AS badge_name, b.badge_order, b.image_path
     FROM level_definitions ld
     JOIN level_badges b ON b.id = ld.badge_id
     ORDER BY ld.level_order ASC`
  );
  return rows;
}

async function auditAdminAction(conn, { adminUserId, targetUserId, action, metadata }) {
  await conn.query(
    `INSERT INTO level_admin_audit_logs (admin_user_id, target_user_id, action, metadata)
     VALUES (?, ?, ?, ?)`,
    [adminUserId || null, targetUserId || null, action, makeJson(metadata)]
  );
}

module.exports = {
  ensureLevelProgressTables,
  parsePositiveInt,
  parseNonNegativeInt,
  awardXp,
  awardConfiguredXp,
  adjustUserXp,
  getUserProgress,
  getUserRewards,
  claimLevelReward,
  redeemLevelRewardCode,
  listLevels,
  auditAdminAction,
};
