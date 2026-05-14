const { noticePayload, sendPushToUser } = require("./push.service");

async function ensureAffiliateTilesTable(db) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS affiliate_tiles (
      id int(11) NOT NULL AUTO_INCREMENT,
      tile_level int(11) NOT NULL DEFAULT 1,
      name varchar(120) NOT NULL,
      target_tickets int(11) NOT NULL,
      reward_cop_points int(11) NOT NULL,
      required_affiliates int(11) NOT NULL DEFAULT 0,
      plan_price_cop_points int(11) NOT NULL DEFAULT 0,
      is_active tinyint(1) NOT NULL DEFAULT 1,
      created_by int(11) DEFAULT NULL,
      updated_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_affiliate_tiles_active (is_active, tile_level, required_affiliates, target_tickets),
      KEY idx_affiliate_tiles_created_by (created_by),
      KEY idx_affiliate_tiles_updated_by (updated_by)
    )`
  );

  const [columns] = await db.query(
    `SELECT COLUMN_NAME
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE()
       AND TABLE_NAME = 'affiliate_tiles'
       AND COLUMN_NAME IN ('tile_level', 'plan_price_cop_points')`
  );
  const columnNames = new Set(columns.map((row) => row.COLUMN_NAME));

  if (!columnNames.has("tile_level")) {
    await db.query(
      "ALTER TABLE affiliate_tiles ADD COLUMN tile_level int(11) NOT NULL DEFAULT 1 AFTER id"
    );
  }
  if (!columnNames.has("plan_price_cop_points")) {
    await db.query(
      "ALTER TABLE affiliate_tiles ADD COLUMN plan_price_cop_points int(11) NOT NULL DEFAULT 0 AFTER required_affiliates"
    );
  }

  await db.query(
    `CREATE TABLE IF NOT EXISTS affiliate_tile_memberships (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id int(11) NOT NULL,
      tile_id int(11) NOT NULL,
      paid_cop_points int(11) NOT NULL DEFAULT 0,
      joined_at timestamp NOT NULL DEFAULT current_timestamp(),
      status enum('active','cancelled') NOT NULL DEFAULT 'active',
      PRIMARY KEY (id),
      UNIQUE KEY uniq_affiliate_tile_user_tile (user_id, tile_id),
      KEY idx_affiliate_tile_memberships_user (user_id, status),
      KEY idx_affiliate_tile_memberships_tile (tile_id, status)
    )`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS affiliate_tile_payouts (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id int(11) NOT NULL,
      tile_id int(11) NOT NULL,
      period_start date NOT NULL,
      period_end date NOT NULL,
      earned_cop_points int(11) NOT NULL DEFAULT 0,
      status enum('paid') NOT NULL DEFAULT 'paid',
      paid_by int(11) DEFAULT NULL,
      paid_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      UNIQUE KEY uniq_affiliate_tile_payout_period (user_id, tile_id, period_start),
      KEY idx_affiliate_tile_payout_period (period_start, period_end),
      KEY idx_affiliate_tile_payout_user (user_id, paid_at)
    )`
  );

  const [[countRow]] = await db.query("SELECT COUNT(*) AS total FROM affiliate_tiles");
  if (!Number(countRow?.total || 0)) {
    await db.query(
      `INSERT INTO affiliate_tiles
        (tile_level, name, target_tickets, reward_cop_points, required_affiliates, plan_price_cop_points, is_active)
       VALUES (1, 'Street Scout', 150, 65, 10, 25, 1)`
    );
  }
}

async function ensureUserNoticesTable(db) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS user_notices (
      id int(11) NOT NULL AUTO_INCREMENT,
      user_id int(11) DEFAULT NULL,
      type varchar(64) NOT NULL DEFAULT 'admin_notice',
      title varchar(160) NOT NULL,
      message text NOT NULL,
      path varchar(255) DEFAULT '/dashboard',
      priority enum('normal','important') NOT NULL DEFAULT 'important',
      created_by int(11) DEFAULT NULL,
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_user_notices_user_created (user_id, created_at),
      KEY idx_user_notices_created_by (created_by)
    )`
  );
}

function currentMonthRange(now = new Date()) {
  const start = new Date(now.getFullYear(), now.getMonth(), 1);
  const end = new Date(now.getFullYear(), now.getMonth() + 1, 1);
  return {
    start,
    end,
    month_end_at: new Date(end.getTime() - 1),
    payout_opens_at: end,
    label: start.toLocaleString("en", { month: "long", year: "numeric" }),
  };
}

function previousMonthRange(now = new Date()) {
  const start = new Date(now.getFullYear(), now.getMonth() - 1, 1);
  const end = new Date(now.getFullYear(), now.getMonth(), 1);
  return {
    start,
    end,
    month_end_at: new Date(end.getTime() - 1),
    payout_opens_at: end,
    label: start.toLocaleString("en", { month: "long", year: "numeric" }),
  };
}

function dbDate(value) {
  return value.toISOString().slice(0, 10);
}

function serializePeriod(range) {
  return {
    label: range.label,
    start: range.start.toISOString(),
    end: range.end.toISOString(),
    month_end_at: range.month_end_at.toISOString(),
    payout_opens_at: range.payout_opens_at.toISOString(),
  };
}

function normalizeTile(tile) {
  if (!tile) return null;
  return {
    ...tile,
    tile_level: Number(tile.tile_level || 1),
    target_tickets: Number(tile.target_tickets || 0),
    reward_cop_points: Number(tile.reward_cop_points || 0),
    required_affiliates: Number(tile.required_affiliates || 0),
    plan_price_cop_points: Number(tile.plan_price_cop_points || 0),
    is_active: Boolean(Number(tile.is_active)),
  };
}

function parseTilePayload(body = {}, { partial = false } = {}) {
  const payload = {};

  if (!partial || body.name !== undefined) {
    const name = String(body.name || "").trim().slice(0, 120);
    if (!name) throw new Error("Tile name is required");
    payload.name = name;
  }

  if (!partial || body.tile_level !== undefined) {
    const tileLevel = Number(body.tile_level || 1);
    if (!Number.isInteger(tileLevel) || tileLevel <= 0) {
      throw new Error("tile_level must be greater than 0");
    }
    payload.tile_level = tileLevel;
  }

  if (!partial || body.target_tickets !== undefined) {
    const targetTickets = Number(body.target_tickets);
    if (!Number.isInteger(targetTickets) || targetTickets <= 0) {
      throw new Error("target_tickets must be greater than 0");
    }
    payload.target_tickets = targetTickets;
  }

  if (!partial || body.reward_cop_points !== undefined) {
    const rewardCopPoints = Number(body.reward_cop_points);
    if (!Number.isInteger(rewardCopPoints) || rewardCopPoints <= 0) {
      throw new Error("reward_cop_points must be greater than 0");
    }
    payload.reward_cop_points = rewardCopPoints;
  }

  if (!partial || body.required_affiliates !== undefined) {
    const requiredAffiliates = Number(body.required_affiliates || 0);
    if (!Number.isInteger(requiredAffiliates) || requiredAffiliates < 0) {
      throw new Error("required_affiliates must be 0 or greater");
    }
    payload.required_affiliates = requiredAffiliates;
  }

  if (!partial || body.plan_price_cop_points !== undefined) {
    const planPrice = Number(body.plan_price_cop_points || 0);
    if (!Number.isInteger(planPrice) || planPrice < 0) {
      throw new Error("plan_price_cop_points must be 0 or greater");
    }
    payload.plan_price_cop_points = planPrice;
  }

  if (body.is_active !== undefined) {
    payload.is_active = body.is_active === true || body.is_active === 1 || body.is_active === "1" ? 1 : 0;
  } else if (!partial) {
    payload.is_active = 1;
  }

  return payload;
}

async function listAffiliateTiles(db, { activeOnly = false } = {}) {
  await ensureAffiliateTilesTable(db);
  const [tiles] = await db.query(
    `SELECT id, tile_level, name, target_tickets, reward_cop_points, required_affiliates,
            plan_price_cop_points,
            is_active, created_by, updated_by, created_at, updated_at
     FROM affiliate_tiles
     ${activeOnly ? "WHERE is_active = 1" : ""}
     ORDER BY tile_level ASC, required_affiliates ASC, target_tickets ASC, id ASC`
  );
  return tiles.map(normalizeTile);
}

async function getAffiliateNetworkStats(db, userId, range = currentMonthRange()) {
  const [[directRow]] = await db.query(
    "SELECT COUNT(*) AS direct_affiliates FROM referrals WHERE referrer_id = ?",
    [userId]
  );

  const [[activity]] = await db.query(
    `SELECT
       COUNT(hp.id) AS network_tickets,
       COALESCE(SUM(h.ticket_price), 0) AS network_ticket_value
     FROM heist_participants hp
     JOIN heist h ON h.id = hp.heist_id
     WHERE hp.joined_at >= ?
       AND hp.joined_at < ?
       AND hp.user_id IN (
         SELECT r1.referred_id
         FROM referrals r1
         WHERE r1.referrer_id = ?
         UNION
         SELECT r2.referred_id
         FROM referrals r1
         JOIN referrals r2 ON r2.referrer_id = r1.referred_id
         WHERE r1.referrer_id = ?
       )`,
    [range.start, range.end, userId, userId]
  );

  return {
    direct_affiliates: Number(directRow?.direct_affiliates || 0),
    network_tickets: Number(activity?.network_tickets || 0),
    network_ticket_value: Number(activity?.network_ticket_value || 0),
  };
}

async function getUserTileMemberships(db, userId) {
  await ensureAffiliateTilesTable(db);
  const [rows] = await db.query(
    `SELECT tile_id, paid_cop_points, joined_at, status
     FROM affiliate_tile_memberships
     WHERE user_id = ? AND status = 'active'`,
    [userId]
  );
  return new Map(rows.map((row) => [Number(row.tile_id), row]));
}

function buildTilePerformance(tiles, stats, memberships = new Map()) {
  const activeTiles = tiles.filter((tile) => tile.is_active);
  const joinedTileIds = new Set(memberships.keys());
  const hasJoinedPlan = joinedTileIds.size > 0;
  const performance = activeTiles.map((tile) => {
    const qualifiesByAffiliates = stats.direct_affiliates >= tile.required_affiliates;
    const membership = memberships.get(Number(tile.id)) || null;
    const isJoined = Boolean(membership);
    const isEligible = hasJoinedPlan ? isJoined : qualifiesByAffiliates;
    const ticketPercent = tile.target_tickets
      ? Math.min(100, Math.round((stats.network_tickets / tile.target_tickets) * 100))
      : 0;
    const earningCopPoints = isEligible
      ? Math.floor((Math.min(ticketPercent, 100) / 100) * tile.reward_cop_points)
      : 0;

    return {
      ...tile,
      is_assigned_tile: false,
      is_joined: isJoined,
      joined_at: membership?.joined_at || null,
      paid_cop_points: Number(membership?.paid_cop_points || 0),
      is_eligible: isEligible,
      qualifies_by_affiliates: qualifiesByAffiliates,
      earning_locked_by_joined_plan: hasJoinedPlan && !isJoined && qualifiesByAffiliates,
      ticket_percent: ticketPercent,
      earning_cop_points: earningCopPoints,
      remaining_tickets: Math.max(tile.target_tickets - stats.network_tickets, 0),
      remaining_affiliates: Math.max(tile.required_affiliates - stats.direct_affiliates, 0),
    };
  });

  const assignedTile =
    performance
      .filter((tile) => tile.is_eligible)
      .sort((a, b) => {
        if (hasJoinedPlan) {
          return new Date(b.joined_at || 0) - new Date(a.joined_at || 0);
        }
        return b.tile_level - a.tile_level || b.required_affiliates - a.required_affiliates;
      })[0] ||
    null;

  if (assignedTile) {
    const match = performance.find((tile) => Number(tile.id) === Number(assignedTile.id));
    if (match) match.is_assigned_tile = true;
  }

  return {
    tiles: performance,
    assigned_tile: assignedTile,
    estimated_earning_cop_points: assignedTile ? assignedTile.earning_cop_points : 0,
  };
}

async function buildUserAffiliateTileDashboard(db, userId) {
  const period = currentMonthRange();
  const [tiles, stats, memberships] = await Promise.all([
    listAffiliateTiles(db, { activeOnly: true }),
    getAffiliateNetworkStats(db, userId, period),
    getUserTileMemberships(db, userId),
  ]);
  const performance = buildTilePerformance(tiles, stats, memberships);

  return {
    period: serializePeriod(period),
    stats,
    ...performance,
  };
}

async function buildAdminAffiliateTileDashboard(db, period = currentMonthRange()) {
  const tiles = await listAffiliateTiles(db);
  const [affiliateRows] = await db.query(
    `SELECT DISTINCT
       u.id AS user_id,
       u.username,
       u.full_name,
       u.email
     FROM users u
     WHERE u.role = 'affiliate'
     ORDER BY u.id ASC`
  );

  const affiliatePerformance = [];
  for (const row of affiliateRows) {
    const userId = Number(row.user_id);
    const [stats, memberships] = await Promise.all([
      getAffiliateNetworkStats(db, userId, period),
      getUserTileMemberships(db, userId),
    ]);
    const performance = buildTilePerformance(tiles, stats, memberships);
    affiliatePerformance.push({
      user_id: userId,
      username: row.username,
      full_name: row.full_name,
      email: row.email,
      stats,
      assigned_tile: performance.assigned_tile,
      estimated_earning_cop_points: performance.estimated_earning_cop_points,
    });
  }

  return {
    period: serializePeriod(period),
    tiles,
    affiliate_performance: affiliatePerformance,
  };
}

async function processDueAffiliateTilePayouts(db, { paidBy = null } = {}) {
  await ensureAffiliateTilesTable(db);
  const period = previousMonthRange();
  if (Date.now() < period.payout_opens_at.getTime()) {
    return {
      processed: false,
      reason: "not_open",
      period: serializePeriod(period),
      paid_count: 0,
      paid_cop_points: 0,
    };
  }

  if (typeof db.getConnection !== "function") {
    throw new Error("processDueAffiliateTilePayouts requires a pool connection manager");
  }

  const preview = await buildAffiliatePayoutPreview(db, period);
  if (!preview.pending_affiliates.length) {
    return {
      processed: true,
      reason: "no_pending",
      period: preview.period,
      paid_count: 0,
      paid_cop_points: 0,
    };
  }

  const conn = await db.getConnection();
  const paid = [];
  try {
    await conn.beginTransaction();
    await ensureAffiliateTilesTable(conn);
    await ensureUserNoticesTable(conn);

    for (const item of preview.pending_affiliates) {
      const amount = Number(item.earned_cop_points || 0);
      if (!amount) continue;

      const [insertResult] = await conn.query(
        `INSERT IGNORE INTO affiliate_tile_payouts
          (user_id, tile_id, period_start, period_end, earned_cop_points, paid_by)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [
          item.user_id,
          item.tile_id,
          dbDate(period.start),
          dbDate(period.end),
          amount,
          paidBy,
        ]
      );

      if (!insertResult.affectedRows) continue;

      await conn.query("UPDATE users SET cop_point = cop_point + ? WHERE id = ?", [
        amount,
        item.user_id,
      ]);

      const title = "Affiliate payout paid";
      const message = `${amount.toLocaleString()} CopUpCoin was added for ${period.label} Tile earnings.`;
      const [noticeResult] = await conn.query(
        `INSERT INTO user_notices
          (user_id, type, title, message, path, priority, created_by)
         VALUES (?, 'affiliate_payout', ?, ?, '/affiliate-dashboard', 'important', ?)`,
        [item.user_id, title, message, paidBy]
      );

      paid.push({
        ...item,
        notice_id: Number(noticeResult.insertId),
      });
    }

    await conn.commit();
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }

  await Promise.allSettled(
    paid.map((item) =>
      sendPushToUser(
        item.user_id,
        noticePayload({
          alertId: `affiliate-payout:${item.notice_id}`,
          type: "affiliate_payout",
          title: "Affiliate payout paid",
          body: `${Number(item.earned_cop_points || 0).toLocaleString()} CopUpCoin was added to your balance.`,
          path: "/affiliate-dashboard",
        })
      )
    )
  );

  return {
    processed: true,
    reason: "paid",
    period: serializePeriod(period),
    paid_count: paid.length,
    paid_cop_points: paid.reduce((sum, item) => sum + Number(item.earned_cop_points || 0), 0),
  };
}

async function buildAffiliatePayoutPreview(db, period = previousMonthRange()) {
  await ensureAffiliateTilesTable(db);
  const dashboard = await buildAdminAffiliateTileDashboard(db, period);
  const payable = dashboard.affiliate_performance.filter(
    (item) => item.assigned_tile && Number(item.estimated_earning_cop_points || 0) > 0
  );
  const [paidRows] = await db.query(
    `SELECT user_id, tile_id, earned_cop_points, paid_at
     FROM affiliate_tile_payouts
     WHERE period_start = ? AND period_end = ?`,
    [dbDate(period.start), dbDate(period.end)]
  );
  const paidKeys = new Set(
    paidRows.map((row) => `${Number(row.user_id)}:${Number(row.tile_id)}`)
  );
  const pending = payable.filter(
    (item) => !paidKeys.has(`${Number(item.user_id)}:${Number(item.assigned_tile?.id)}`)
  );

  return {
    period: serializePeriod(period),
    is_open: Date.now() >= period.payout_opens_at.getTime(),
    payable_count: payable.length,
    pending_count: pending.length,
    paid_count: paidRows.length,
    payable_cop_points: payable.reduce(
      (sum, item) => sum + Number(item.estimated_earning_cop_points || 0),
      0
    ),
    pending_cop_points: pending.reduce(
      (sum, item) => sum + Number(item.estimated_earning_cop_points || 0),
      0
    ),
    paid_cop_points: paidRows.reduce((sum, row) => sum + Number(row.earned_cop_points || 0), 0),
    pending_affiliates: pending.map((item) => ({
      user_id: Number(item.user_id),
      username: item.username,
      full_name: item.full_name,
      email: item.email,
      tile_id: Number(item.assigned_tile.id),
      tile_name: item.assigned_tile.name,
      tile_level: Number(item.assigned_tile.tile_level || 1),
      earned_cop_points: Number(item.estimated_earning_cop_points || 0),
      stats: item.stats,
    })),
  };
}

async function joinAffiliateTile(db, userId, tileId) {
  await ensureAffiliateTilesTable(db);

  const [[tile]] = await db.query(
    `SELECT id, tile_level, name, plan_price_cop_points, is_active
     FROM affiliate_tiles
     WHERE id = ?
     LIMIT 1 FOR UPDATE`,
    [tileId]
  );

  if (!tile || !Number(tile.is_active)) {
    throw new Error("Tile is not available");
  }

  const [[existing]] = await db.query(
    `SELECT id
     FROM affiliate_tile_memberships
     WHERE user_id = ? AND tile_id = ? AND status = 'active'
     LIMIT 1`,
    [userId, tileId]
  );
  if (existing) throw new Error("You already joined this Tile");

  const [[activeMembership]] = await db.query(
    `SELECT m.id, m.tile_id, m.paid_cop_points, t.name
     FROM affiliate_tile_memberships m
     JOIN affiliate_tiles t ON t.id = m.tile_id
     WHERE m.user_id = ? AND m.status = 'active'
     LIMIT 1`,
    [userId]
  );
  const price = Number(tile.plan_price_cop_points || 0);
  const currentPaid = Number(activeMembership?.paid_cop_points || 0);
  const charge = activeMembership ? Math.max(price - currentPaid, 0) : price;
  const [[user]] = await db.query(
    "SELECT id, cop_point FROM users WHERE id = ? LIMIT 1 FOR UPDATE",
    [userId]
  );
  if (!user) throw new Error("User not found");
  if (Number(user.cop_point || 0) < charge) throw new Error("Insufficient cop_point");

  if (charge > 0) {
    await db.query("UPDATE users SET cop_point = cop_point - ? WHERE id = ?", [charge, userId]);
  }

  if (activeMembership) {
    await db.query(
      `UPDATE affiliate_tile_memberships
       SET status = 'cancelled'
       WHERE user_id = ? AND status = 'active'`,
      [userId]
    );
  }

  await db.query(
    `INSERT INTO affiliate_tile_memberships
      (user_id, tile_id, paid_cop_points, status)
     VALUES (?, ?, ?, 'active')
     ON DUPLICATE KEY UPDATE
       paid_cop_points = VALUES(paid_cop_points),
       joined_at = NOW(),
       status = 'active'`,
    [userId, tileId, price]
  );

  return {
    action: activeMembership ? "switched" : "joined",
    previous_tile_id: activeMembership ? Number(activeMembership.tile_id) : null,
    tile_id: Number(tile.id),
    tile_level: Number(tile.tile_level || 1),
    tile_name: tile.name,
    paid_cop_points: price,
    charged_cop_points: charge,
  };
}

module.exports = {
  ensureAffiliateTilesTable,
  parseTilePayload,
  listAffiliateTiles,
  currentMonthRange,
  previousMonthRange,
  serializePeriod,
  dbDate,
  buildUserAffiliateTileDashboard,
  buildAdminAffiliateTileDashboard,
  buildAffiliatePayoutPreview,
  processDueAffiliateTilePayouts,
  joinAffiliateTile,
};
