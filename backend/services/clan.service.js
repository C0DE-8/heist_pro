const { pool } = require("../conf/db");

function toInt(value, fallback = 0) {
  const n = Number(value);
  return Number.isFinite(n) ? Math.trunc(n) : fallback;
}

function cleanText(value, max = 255) {
  const text = String(value || "").trim();
  return text ? text.slice(0, max) : "";
}

function slugify(value) {
  return cleanText(value, 120)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 140);
}

function isDuplicateError(err) {
  return err?.code === "ER_DUP_ENTRY" || err?.errno === 1062;
}

function memberName(row) {
  return row.full_name || row.username || row.email || `User #${row.user_id || row.id}`;
}

const PROFANITY_WORDS = [
  "fuck",
  "fucking",
  "fucker",
  "shit",
  "bullshit",
  "bitch",
  "asshole",
  "bastard",
  "damn",
  "dick",
  "pussy",
  "cunt",
  "motherfucker",
  "nigga",
  "nigger",
  "slut",
  "whore",
];

function maskProfanity(value) {
  let text = cleanText(value, 1000);
  for (const word of PROFANITY_WORDS) {
    const pattern = new RegExp(`\\b${word.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\b`, "gi");
    text = text.replace(pattern, "***");
  }
  return text;
}

async function ensureClanSettings(db = pool) {
  await db.query(
    `INSERT INTO clan_settings (id, creation_cost_cop_points, max_members, is_enabled)
     VALUES (1, 0, NULL, 1)
     ON DUPLICATE KEY UPDATE id = id`
  );
  const [[settings]] = await db.query("SELECT * FROM clan_settings WHERE id = 1 LIMIT 1");
  return {
    ...settings,
    is_enabled: Boolean(settings?.is_enabled),
    creation_cost_cop_points: toInt(settings?.creation_cost_cop_points),
    max_members: settings?.max_members === null ? null : toInt(settings?.max_members),
  };
}

async function ensureClanChatTable(db = pool) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS clan_chat_messages (
      id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
      clan_id bigint(20) UNSIGNED NOT NULL,
      user_id int(11) DEFAULT NULL,
      message text NOT NULL,
      original_message text DEFAULT NULL,
      status enum('active','deleted') NOT NULL DEFAULT 'active',
      created_at timestamp NOT NULL DEFAULT current_timestamp(),
      updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
      PRIMARY KEY (id),
      KEY idx_clan_chat_clan_created (clan_id, created_at),
      KEY idx_clan_chat_user_created (user_id, created_at),
      CONSTRAINT fk_clan_chat_clan
        FOREIGN KEY (clan_id) REFERENCES clans (id)
        ON DELETE CASCADE,
      CONSTRAINT fk_clan_chat_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE SET NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci`
  );
}

async function getCurrentMembership(db, userId) {
  const [[membership]] = await db.query(
    `SELECT cm.*, c.name AS clan_name, c.slug AS clan_slug, c.logo_url, c.banner_url
     FROM clan_members cm
     JOIN clans c ON c.id = cm.clan_id
     WHERE cm.user_id = ? AND cm.status = 'active' AND c.status = 'active'
     LIMIT 1`,
    [userId]
  );
  return membership || null;
}

async function getClanById(db, clanId) {
  const [[clan]] = await db.query(
    `SELECT c.*,
            leader.username AS leader_username,
            leader.full_name AS leader_full_name,
            COALESCE(m.member_count, 0) AS member_count
     FROM clans c
     JOIN users leader ON leader.id = c.leader_user_id
     LEFT JOIN (
       SELECT clan_id, COUNT(*) AS member_count
       FROM clan_members
       WHERE status = 'active'
       GROUP BY clan_id
     ) m ON m.clan_id = c.id
     WHERE c.id = ?
     LIMIT 1`,
    [clanId]
  );
  return clan || null;
}

async function listClans({ q = "", status = "active" } = {}) {
  const params = [];
  const where = [];
  if (status) {
    where.push("c.status = ?");
    params.push(status);
  }
  const query = cleanText(q, 120);
  if (query) {
    where.push("(c.name LIKE ? OR c.description LIKE ? OR leader.username LIKE ?)");
    params.push(`%${query}%`, `%${query}%`, `%${query}%`);
  }

  const [rows] = await pool.query(
    `SELECT c.id, c.name, c.slug, c.logo_url, c.banner_url, c.description, c.join_policy,
            c.status, c.creation_cost_cop_points, c.created_at,
            c.leader_user_id, leader.username AS leader_username, leader.full_name AS leader_full_name,
            COALESCE(m.member_count, 0) AS member_count
     FROM clans c
     JOIN users leader ON leader.id = c.leader_user_id
     LEFT JOIN (
       SELECT clan_id, COUNT(*) AS member_count
       FROM clan_members
       WHERE status = 'active'
       GROUP BY clan_id
     ) m ON m.clan_id = c.id
     ${where.length ? `WHERE ${where.join(" AND ")}` : ""}
     ORDER BY member_count DESC, c.created_at DESC
     LIMIT 200`,
    params
  );
  return rows.map((row) => ({ ...row, member_count: toInt(row.member_count) }));
}

async function getClanDetails(clanId, userId = null) {
  const clan = await getClanById(pool, clanId);
  if (!clan || clan.status === "deleted") return null;

  const [members] = await pool.query(
    `SELECT cm.id, cm.user_id, cm.role, cm.status, cm.joined_at, cm.left_at,
            u.username, u.full_name, u.email
     FROM clan_members cm
     JOIN users u ON u.id = cm.user_id
     WHERE cm.clan_id = ?
     ORDER BY FIELD(cm.role, 'leader', 'co_leader', 'elder', 'member'), cm.joined_at ASC`,
    [clanId]
  );

  const [quests] = await pool.query(
    `SELECT q.id, q.title, q.description, q.quest_type, q.status, q.starts_at, q.ends_at,
            q.prize_type, q.prize_amount, q.participation_policy,
            p.status AS participation_status,
            s.score, s.rank_position, s.is_winner
     FROM clan_quests q
     LEFT JOIN clan_quest_participants p ON p.quest_id = q.id AND p.clan_id = ?
     LEFT JOIN clan_quest_scores s ON s.quest_id = q.id AND s.clan_id = ?
     WHERE q.status IN ('scheduled', 'active', 'completed')
     ORDER BY q.starts_at DESC
     LIMIT 30`,
    [clanId, clanId]
  );

  let myMembership = null;
  if (userId) {
    const [[row]] = await pool.query(
      "SELECT id, user_id, role, status FROM clan_members WHERE clan_id = ? AND user_id = ? LIMIT 1",
      [clanId, userId]
    );
    myMembership = row || null;
  }

  return {
    clan: {
      ...clan,
      member_count: toInt(clan.member_count),
      leader_name: memberName({
        full_name: clan.leader_full_name,
        username: clan.leader_username,
        user_id: clan.leader_user_id,
      }),
    },
    members: members.map((row) => ({ ...row, display_name: memberName(row) })),
    quests,
    my_membership: myMembership,
  };
}

async function getMyClan(userId) {
  const membership = await getCurrentMembership(pool, userId);
  if (!membership) return { clan: null, members: [], my_membership: null, quests: [] };
  return getClanDetails(membership.clan_id, userId);
}

async function requireClanMember(db, clanId, userId) {
  const [[membership]] = await db.query(
    `SELECT cm.*, c.name AS clan_name
     FROM clan_members cm
     JOIN clans c ON c.id = cm.clan_id
     WHERE cm.clan_id = ? AND cm.user_id = ? AND cm.status = 'active' AND c.status = 'active'
     LIMIT 1`,
    [clanId, userId]
  );
  if (!membership) throw new Error("Clan membership required");
  return membership;
}

async function listClanChat(clanId, userId, { limit = 80 } = {}) {
  await ensureClanChatTable(pool);
  await requireClanMember(pool, clanId, userId);
  const cappedLimit = Math.max(1, Math.min(120, toInt(limit, 80)));
  const [rows] = await pool.query(
    `SELECT m.id, m.clan_id, m.user_id, m.message, m.status, m.created_at,
            u.username, u.full_name,
            NULL AS profile_url,
            cm.role
     FROM clan_chat_messages m
     LEFT JOIN users u ON u.id = m.user_id
     LEFT JOIN clan_members cm ON cm.clan_id = m.clan_id AND cm.user_id = m.user_id
     WHERE m.clan_id = ? AND m.status = 'active'
     ORDER BY m.created_at DESC, m.id DESC
     LIMIT ?`,
    [clanId, cappedLimit]
  );
  return rows
    .reverse()
    .map((row) => ({
      ...row,
      message: maskProfanity(row.message),
      display_name: memberName(row),
      role: row.role || "member",
    }));
}

async function sendClanChat(clanId, userId, body) {
  await ensureClanChatTable(pool);
  await requireClanMember(pool, clanId, userId);
  const original = cleanText(body?.message, 1000);
  if (!original) throw new Error("Message is required");
  const masked = maskProfanity(original);
  const [result] = await pool.query(
    `INSERT INTO clan_chat_messages (clan_id, user_id, message, original_message)
     VALUES (?, ?, ?, ?)`,
    [clanId, userId, masked, original]
  );
  const messages = await listClanChat(clanId, userId, { limit: 80 });
  return {
    message: "Message sent",
    chat_message_id: result.insertId,
    messages,
  };
}

async function deleteClanChatMessage(clanId, messageId, userId) {
  await ensureClanChatTable(pool);
  const membership = await requireClanMember(pool, clanId, userId);
  const [[message]] = await pool.query(
    `SELECT id, clan_id, user_id, status
     FROM clan_chat_messages
     WHERE id = ? AND clan_id = ? AND status = 'active'
     LIMIT 1`,
    [messageId, clanId]
  );
  if (!message) throw new Error("Message not found");
  const ownsMessage = Number(message.user_id) === Number(userId);
  const canModerate = ["leader", "co_leader"].includes(membership.role);
  if (!ownsMessage && !canModerate) throw new Error("You can only delete your own messages");
  await pool.query("UPDATE clan_chat_messages SET status = 'deleted' WHERE id = ?", [messageId]);
  return {
    message: "Message deleted",
    messages: await listClanChat(clanId, userId, { limit: 80 }),
  };
}

async function createClan(userId, body) {
  const name = cleanText(body?.name, 120);
  if (name.length < 3) throw new Error("Clan name must be at least 3 characters");

  const joinPolicy = ["open", "request", "invite_only", "closed"].includes(body?.join_policy)
    ? body.join_policy
    : "request";
  const baseSlug = slugify(body?.slug || name);
  if (!baseSlug) throw new Error("Clan name is invalid");

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const settings = await ensureClanSettings(conn);
    if (!settings.is_enabled) throw new Error("Clan creation is disabled");

    const existingMembership = await getCurrentMembership(conn, userId);
    if (existingMembership) throw new Error("You are already in a clan");

    const [[user]] = await conn.query(
      "SELECT id, cop_point FROM users WHERE id = ? LIMIT 1 FOR UPDATE",
      [userId]
    );
    if (!user) throw new Error("User not found");
    const cost = toInt(settings.creation_cost_cop_points);
    if (toInt(user.cop_point) < cost) throw new Error("Insufficient CopUpCoin to create clan");

    const [insert] = await conn.query(
      `INSERT INTO clans
        (name, slug, logo_url, banner_url, description, leader_user_id, join_policy,
         creation_cost_cop_points, created_by, updated_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name,
        baseSlug,
        cleanText(body?.logo_url, 500) || null,
        cleanText(body?.banner_url, 500) || null,
        cleanText(body?.description, 2000) || null,
        userId,
        joinPolicy,
        cost,
        userId,
        userId,
      ]
    );
    const clanId = insert.insertId;

    await conn.query(
      `INSERT INTO clan_members (clan_id, user_id, role, status, approved_by, role_updated_by, role_updated_at)
       VALUES (?, ?, 'leader', 'active', ?, ?, NOW())`,
      [clanId, userId, userId, userId]
    );

    if (cost > 0) {
      const before = toInt(user.cop_point);
      const after = before - cost;
      await conn.query("UPDATE users SET cop_point = ? WHERE id = ?", [after, userId]);
      await conn.query(
        `INSERT INTO clan_coin_ledger
          (clan_id, user_id, direction, amount_cop_points, user_balance_before,
           user_balance_after, reason, reference_type, reference_id, created_by)
         VALUES (?, ?, 'debit', ?, ?, ?, 'clan_creation', 'clan', ?, ?)`,
        [clanId, userId, cost, before, after, clanId, userId]
      );
    }

    await conn.query(
      `INSERT INTO clan_activity_events (clan_id, actor_user_id, event_type, details)
       VALUES (?, ?, 'clan_created', ?)`,
      [clanId, userId, name]
    );

    await conn.commit();
    return getClanDetails(clanId, userId);
  } catch (err) {
    await conn.rollback();
    if (isDuplicateError(err)) throw new Error("Clan name is already taken");
    throw err;
  } finally {
    conn.release();
  }
}

async function joinClan(userId, clanId, body = {}) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const current = await getCurrentMembership(conn, userId);
    if (current) throw new Error("You are already in a clan");

    const [[clan]] = await conn.query("SELECT * FROM clans WHERE id = ? LIMIT 1 FOR UPDATE", [clanId]);
    if (!clan || clan.status !== "active") throw new Error("Clan not found");
    if (clan.join_policy === "closed" || clan.join_policy === "invite_only") {
      throw new Error("This clan is not open for direct join requests");
    }

    const settings = await ensureClanSettings(conn);
    if (settings.max_members) {
      const [[countRow]] = await conn.query(
        "SELECT COUNT(*) AS total FROM clan_members WHERE clan_id = ? AND status = 'active'",
        [clanId]
      );
      if (toInt(countRow.total) >= settings.max_members) throw new Error("Clan is full");
    }

    if (clan.join_policy === "open") {
      await conn.query(
        `INSERT INTO clan_members (clan_id, user_id, role, status, approved_by)
         VALUES (?, ?, 'member', 'active', ?)
         ON DUPLICATE KEY UPDATE status = 'active', role = 'member', joined_at = NOW(), left_at = NULL`,
        [clanId, userId, userId]
      );
      await conn.query(
        "INSERT INTO clan_activity_events (clan_id, actor_user_id, event_type) VALUES (?, ?, 'member_joined')",
        [clanId, userId]
      );
      await conn.commit();
      return { message: "Joined clan", status: "active" };
    }

    await conn.query(
      `INSERT INTO clan_join_requests (clan_id, user_id, message, status)
       VALUES (?, ?, ?, 'pending')
       ON DUPLICATE KEY UPDATE message = VALUES(message), updated_at = NOW()`,
      [clanId, userId, cleanText(body?.message, 500) || null]
    );
    await conn.commit();
    return { message: "Join request sent", status: "pending" };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function leaveClan(userId, clanId) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const [[membership]] = await conn.query(
      "SELECT * FROM clan_members WHERE clan_id = ? AND user_id = ? AND status = 'active' LIMIT 1 FOR UPDATE",
      [clanId, userId]
    );
    if (!membership) throw new Error("You are not an active clan member");
    if (membership.role === "leader") throw new Error("Transfer leadership or remove the clan first");

    await conn.query(
      "UPDATE clan_members SET status = 'left', left_at = NOW() WHERE id = ?",
      [membership.id]
    );
    await conn.query(
      "INSERT INTO clan_activity_events (clan_id, actor_user_id, event_type) VALUES (?, ?, 'member_left')",
      [clanId, userId]
    );
    await conn.commit();
    return { message: "Left clan" };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function requireClanAdmin(db, clanId, userId) {
  const [[membership]] = await db.query(
    `SELECT cm.*, c.leader_user_id
     FROM clan_members cm
     JOIN clans c ON c.id = cm.clan_id
     WHERE cm.clan_id = ? AND cm.user_id = ? AND cm.status = 'active'
     LIMIT 1`,
    [clanId, userId]
  );
  if (!membership || !["leader", "co_leader"].includes(membership.role)) {
    throw new Error("Clan admin access required");
  }
  return membership;
}

async function decideJoinRequest(clanId, requestId, actorId, decision) {
  const approve = decision === "approve";
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await requireClanAdmin(conn, clanId, actorId);
    const [[request]] = await conn.query(
      "SELECT * FROM clan_join_requests WHERE id = ? AND clan_id = ? AND status = 'pending' LIMIT 1 FOR UPDATE",
      [requestId, clanId]
    );
    if (!request) throw new Error("Join request not found");
    if (approve) {
      const existing = await getCurrentMembership(conn, request.user_id);
      if (existing) throw new Error("User is already in a clan");
      await conn.query(
        `INSERT INTO clan_members (clan_id, user_id, role, status, approved_by)
         VALUES (?, ?, 'member', 'active', ?)
         ON DUPLICATE KEY UPDATE status = 'active', role = 'member', joined_at = NOW(), left_at = NULL, approved_by = VALUES(approved_by)`,
        [clanId, request.user_id, actorId]
      );
    }
    await conn.query(
      "UPDATE clan_join_requests SET status = ?, reviewed_by = ?, reviewed_at = NOW() WHERE id = ?",
      [approve ? "approved" : "rejected", actorId, requestId]
    );
    await conn.query(
      "INSERT INTO clan_activity_events (clan_id, actor_user_id, target_user_id, event_type) VALUES (?, ?, ?, ?)",
      [clanId, actorId, request.user_id, approve ? "join_request_approved" : "join_request_rejected"]
    );
    await conn.commit();
    return { message: approve ? "Request approved" : "Request rejected" };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function updateMemberRole(clanId, memberId, actorId, role) {
  if (!["co_leader", "elder", "member"].includes(role)) throw new Error("Invalid role");
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const actor = await requireClanAdmin(conn, clanId, actorId);
    if (actor.role !== "leader") throw new Error("Only the leader can promote or demote members");
    const [[member]] = await conn.query(
      "SELECT * FROM clan_members WHERE id = ? AND clan_id = ? AND status = 'active' LIMIT 1 FOR UPDATE",
      [memberId, clanId]
    );
    if (!member) throw new Error("Member not found");
    if (member.role === "leader") throw new Error("Leader role cannot be changed here");
    await conn.query(
      "UPDATE clan_members SET role = ?, role_updated_by = ?, role_updated_at = NOW() WHERE id = ?",
      [role, actorId, memberId]
    );
    await conn.query(
      "INSERT INTO clan_activity_events (clan_id, actor_user_id, target_user_id, event_type, details) VALUES (?, ?, ?, 'member_role_updated', ?)",
      [clanId, actorId, member.user_id, role]
    );
    await conn.commit();
    return { message: "Member role updated" };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function removeMember(clanId, memberId, actorId) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const actor = await requireClanAdmin(conn, clanId, actorId);
    const [[member]] = await conn.query(
      "SELECT * FROM clan_members WHERE id = ? AND clan_id = ? AND status = 'active' LIMIT 1 FOR UPDATE",
      [memberId, clanId]
    );
    if (!member) throw new Error("Member not found");
    if (member.role === "leader") throw new Error("Leader cannot be removed");
    if (member.role === "co_leader" && actor.role !== "leader") throw new Error("Only the leader can remove co-leaders");
    await conn.query("UPDATE clan_members SET status = 'removed', left_at = NOW() WHERE id = ?", [memberId]);
    await conn.query(
      "INSERT INTO clan_activity_events (clan_id, actor_user_id, target_user_id, event_type) VALUES (?, ?, ?, 'member_removed')",
      [clanId, actorId, member.user_id]
    );
    await conn.commit();
    return { message: "Member removed" };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function listJoinRequests(clanId, userId) {
  await requireClanAdmin(pool, clanId, userId);
  const [rows] = await pool.query(
    `SELECT r.*, u.username, u.full_name, u.email
     FROM clan_join_requests r
     JOIN users u ON u.id = r.user_id
     WHERE r.clan_id = ? AND r.status = 'pending'
     ORDER BY r.created_at ASC`,
    [clanId]
  );
  return rows.map((row) => ({ ...row, display_name: memberName(row) }));
}

async function updateClan(clanId, actorId, body, isAdmin = false) {
  if (!isAdmin) await requireClanAdmin(pool, clanId, actorId);
  const allowed = [];
  const params = [];
  if (body?.name !== undefined) {
    const name = cleanText(body.name, 120);
    if (name.length < 3) throw new Error("Clan name must be at least 3 characters");
    allowed.push("name = ?", "slug = ?");
    params.push(name, slugify(name));
  }
  ["logo_url", "banner_url"].forEach((field) => {
    if (body?.[field] !== undefined) {
      allowed.push(`${field} = ?`);
      params.push(cleanText(body[field], 500) || null);
    }
  });
  if (body?.description !== undefined) {
    allowed.push("description = ?");
    params.push(cleanText(body.description, 2000) || null);
  }
  if (body?.join_policy !== undefined) {
    if (!["open", "request", "invite_only", "closed"].includes(body.join_policy)) {
      throw new Error("Invalid join policy");
    }
    allowed.push("join_policy = ?");
    params.push(body.join_policy);
  }
  if (isAdmin && body?.status !== undefined) {
    if (!["active", "suspended", "deleted"].includes(body.status)) throw new Error("Invalid status");
    allowed.push("status = ?", "deleted_at = ?");
    params.push(body.status, body.status === "deleted" ? new Date() : null);
  }
  if (!allowed.length) throw new Error("No updates provided");
  allowed.push("updated_by = ?");
  params.push(actorId, clanId);
  try {
    const [result] = await pool.query(`UPDATE clans SET ${allowed.join(", ")} WHERE id = ?`, params);
    if (!result.affectedRows) throw new Error("Clan not found");
  } catch (err) {
    if (isDuplicateError(err)) throw new Error("Clan name is already taken");
    throw err;
  }
  return getClanDetails(clanId, actorId);
}

async function listQuests() {
  const [rows] = await pool.query(
    `SELECT q.*,
            COUNT(DISTINCT p.clan_id) AS participating_clans,
            reward.winning_clan_id,
            winner.name AS winning_clan_name
     FROM clan_quests q
     LEFT JOIN clan_quest_participants p ON p.quest_id = q.id AND p.status = 'participating'
     LEFT JOIN clan_quest_rewards reward ON reward.quest_id = q.id
     LEFT JOIN clans winner ON winner.id = reward.winning_clan_id
     GROUP BY q.id
     ORDER BY q.starts_at DESC`
  );
  return rows.map((row) => ({ ...row, participating_clans: toInt(row.participating_clans) }));
}

async function listPublicClanQuests(userId = null) {
  const [questRows] = await pool.query(
    `SELECT q.*,
            COUNT(DISTINCT p.clan_id) AS participating_clans,
            reward.winning_clan_id,
            winner.name AS winning_clan_name
     FROM clan_quests q
     LEFT JOIN clan_quest_participants p ON p.quest_id = q.id AND p.status = 'participating'
     LEFT JOIN clan_quest_rewards reward ON reward.quest_id = q.id
     LEFT JOIN clans winner ON winner.id = reward.winning_clan_id
     WHERE q.status IN ('scheduled', 'active', 'completed')
     GROUP BY q.id
     ORDER BY FIELD(q.status, 'active', 'scheduled', 'completed'), q.starts_at DESC
     LIMIT 50`
  );

  const quests = [];
  for (const quest of questRows) {
    const [participants] = await pool.query(
      `SELECT
         p.id AS participation_id,
         p.status AS participation_status,
         p.joined_at,
         c.id AS clan_id,
         c.name,
         c.slug,
         c.logo_url,
         c.banner_url,
         leader.username AS leader_username,
         leader.full_name AS leader_full_name,
         COALESCE(m.member_count, 0) AS member_count,
         COUNT(DISTINCT h.id) AS wins_so_far,
         MAX(COALESCE(h.updated_at, h.created_at)) AS last_win_at
       FROM clan_quest_participants p
       JOIN clans c ON c.id = p.clan_id
       JOIN users leader ON leader.id = c.leader_user_id
       LEFT JOIN (
         SELECT clan_id, COUNT(*) AS member_count
         FROM clan_members
         WHERE status = 'active'
         GROUP BY clan_id
       ) m ON m.clan_id = c.id
       LEFT JOIN clan_members cm ON cm.clan_id = c.id
       LEFT JOIN heist h ON h.winner_user_id = cm.user_id
        AND h.status = 'completed'
        AND h.winner_user_id IS NOT NULL
        AND cm.joined_at <= COALESCE(h.updated_at, h.created_at)
        AND (cm.left_at IS NULL OR cm.left_at >= COALESCE(h.updated_at, h.created_at))
        AND COALESCE(h.updated_at, h.created_at) BETWEEN ? AND ?
       WHERE p.quest_id = ? AND p.status = 'participating' AND c.status = 'active'
       GROUP BY
         p.id,
         p.status,
         p.joined_at,
         c.id,
         c.name,
         c.slug,
         c.logo_url,
         c.banner_url,
         leader.username,
         leader.full_name,
         m.member_count
       ORDER BY wins_so_far DESC, member_count DESC, p.joined_at ASC`,
      [quest.starts_at, quest.ends_at, quest.id]
    );

    quests.push({
      ...quest,
      participating_clans: toInt(quest.participating_clans),
      prize_amount: toInt(quest.prize_amount),
      participants: participants.map((row, index) => ({
        ...row,
        rank: index + 1,
        member_count: toInt(row.member_count),
        wins_so_far: toInt(row.wins_so_far),
      })),
    });
  }

  const myClan = userId ? await getCurrentMembership(pool, userId) : null;
  return {
    quests,
    my_clan: myClan
      ? {
          clan_id: myClan.clan_id,
          clan_name: myClan.clan_name,
          role: myClan.role,
          status: myClan.status,
        }
      : null,
  };
}

async function listTopClans(limit = 20) {
  const cappedLimit = Math.max(1, Math.min(50, toInt(limit, 20)));
  const [rows] = await pool.query(
    `SELECT
       c.id,
       c.name,
       c.slug,
       c.logo_url,
       c.banner_url,
       c.description,
       c.join_policy,
       c.created_at,
       leader.username AS leader_username,
       leader.full_name AS leader_full_name,
       COALESCE(m.member_count, 0) AS member_count,
       COUNT(DISTINCT h.id) AS heist_wins,
       COALESCE(SUM(h.prize_cop_points), 0) AS heist_prize_cop_points,
       MAX(COALESCE(h.updated_at, h.created_at)) AS last_win_at
     FROM clans c
     JOIN users leader ON leader.id = c.leader_user_id
     LEFT JOIN (
       SELECT clan_id, COUNT(*) AS member_count
       FROM clan_members
       WHERE status = 'active'
       GROUP BY clan_id
     ) m ON m.clan_id = c.id
     LEFT JOIN clan_members cm ON cm.clan_id = c.id
     LEFT JOIN heist h ON h.winner_user_id = cm.user_id
      AND h.status = 'completed'
      AND h.winner_user_id IS NOT NULL
      AND cm.joined_at <= COALESCE(h.updated_at, h.created_at)
      AND (cm.left_at IS NULL OR cm.left_at >= COALESCE(h.updated_at, h.created_at))
     WHERE c.status = 'active'
     GROUP BY
       c.id,
       c.name,
       c.slug,
       c.logo_url,
       c.banner_url,
       c.description,
       c.join_policy,
       c.created_at,
       leader.username,
       leader.full_name,
       m.member_count
     ORDER BY heist_wins DESC, heist_prize_cop_points DESC, member_count DESC, c.created_at ASC
     LIMIT ?`,
    [cappedLimit]
  );

  return rows.map((row, index) => ({
    ...row,
    rank: index + 1,
    member_count: toInt(row.member_count),
    heist_wins: toInt(row.heist_wins),
    heist_prize_cop_points: toInt(row.heist_prize_cop_points),
  }));
}

async function participateQuest(clanId, questId, userId) {
  await requireClanAdmin(pool, clanId, userId);
  const [[quest]] = await pool.query("SELECT * FROM clan_quests WHERE id = ? LIMIT 1", [questId]);
  if (!quest || !["scheduled", "active"].includes(quest.status)) throw new Error("Quest is not available");
  await pool.query(
    `INSERT INTO clan_quest_participants (quest_id, clan_id, status, joined_by)
     VALUES (?, ?, 'participating', ?)
     ON DUPLICATE KEY UPDATE status = 'participating', joined_by = VALUES(joined_by), joined_at = NOW(), withdrawn_at = NULL`,
    [questId, clanId, userId]
  );
  return { message: "Clan joined quest" };
}

async function calculateQuestScores(questId) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const [[quest]] = await conn.query("SELECT * FROM clan_quests WHERE id = ? LIMIT 1 FOR UPDATE", [questId]);
    if (!quest) throw new Error("Quest not found");

    await conn.query("DELETE FROM clan_quest_heist_wins WHERE quest_id = ?", [questId]);
    if (quest.quest_type === "heist_wins") {
      await conn.query(
        `INSERT INTO clan_quest_heist_wins (quest_id, clan_id, heist_id, winner_user_id, won_at, points)
         SELECT ?, cm.clan_id, h.id, h.winner_user_id, COALESCE(h.updated_at, h.created_at), 1
         FROM heist h
         JOIN clan_members cm ON cm.user_id = h.winner_user_id
          AND cm.joined_at <= COALESCE(h.updated_at, h.created_at)
          AND (cm.left_at IS NULL OR cm.left_at >= COALESCE(h.updated_at, h.created_at))
         JOIN clan_quest_participants p ON p.quest_id = ? AND p.clan_id = cm.clan_id AND p.status = 'participating'
         WHERE h.status = 'completed'
           AND h.winner_user_id IS NOT NULL
           AND COALESCE(h.updated_at, h.created_at) BETWEEN ? AND ?`,
        [questId, questId, quest.starts_at, quest.ends_at]
      );
    }

    await conn.query("DELETE FROM clan_quest_scores WHERE quest_id = ?", [questId]);
    await conn.query(
      `INSERT INTO clan_quest_scores (quest_id, clan_id, score, calculated_at)
       SELECT p.quest_id, p.clan_id, COALESCE(SUM(w.points), 0), NOW()
       FROM clan_quest_participants p
       LEFT JOIN clan_quest_heist_wins w ON w.quest_id = p.quest_id AND w.clan_id = p.clan_id
       WHERE p.quest_id = ? AND p.status = 'participating'
       GROUP BY p.quest_id, p.clan_id`,
      [questId]
    );

    const [scores] = await conn.query(
      "SELECT id, score FROM clan_quest_scores WHERE quest_id = ? ORDER BY score DESC, clan_id ASC",
      [questId]
    );
    for (let i = 0; i < scores.length; i += 1) {
      await conn.query(
        "UPDATE clan_quest_scores SET rank_position = ?, is_winner = ? WHERE id = ?",
        [i + 1, i === 0 && toInt(scores[i].score) > 0 ? 1 : 0, scores[i].id]
      );
    }
    await conn.commit();
    return { message: "Quest scores calculated", scores_count: scores.length };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function distributeQuestReward(questId, adminId) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const [[quest]] = await conn.query("SELECT * FROM clan_quests WHERE id = ? LIMIT 1 FOR UPDATE", [questId]);
    if (!quest) throw new Error("Quest not found");
    if (quest.prize_type !== "cop_points") throw new Error("Only CopUpCoin rewards can be auto-distributed");
    const [[score]] = await conn.query(
      "SELECT * FROM clan_quest_scores WHERE quest_id = ? AND is_winner = 1 ORDER BY rank_position ASC LIMIT 1",
      [questId]
    );
    if (!score) throw new Error("No winning clan. Calculate scores first");
    const [members] = await conn.query(
      "SELECT user_id FROM clan_members WHERE clan_id = ? AND status = 'active' ORDER BY joined_at ASC",
      [score.clan_id]
    );
    if (!members.length) throw new Error("Winning clan has no active members");
    const prize = toInt(quest.prize_amount);
    const perMember = Math.floor(prize / members.length);
    const remainder = prize - perMember * members.length;
    const [rewardResult] = await conn.query(
      `INSERT INTO clan_quest_rewards
        (quest_id, winning_clan_id, prize_type, prize_amount, member_count, amount_per_member,
         remainder_amount, status, distributed_by, distributed_at)
       VALUES (?, ?, 'cop_points', ?, ?, ?, ?, 'distributed', ?, NOW())
       ON DUPLICATE KEY UPDATE
         winning_clan_id = VALUES(winning_clan_id),
         prize_amount = VALUES(prize_amount),
         member_count = VALUES(member_count),
         amount_per_member = VALUES(amount_per_member),
         remainder_amount = VALUES(remainder_amount),
         status = 'distributed',
         distributed_by = VALUES(distributed_by),
         distributed_at = NOW()`,
      [questId, score.clan_id, prize, members.length, perMember, remainder, adminId]
    );
    const [[reward]] = await conn.query("SELECT id FROM clan_quest_rewards WHERE quest_id = ? LIMIT 1", [questId]);
    const rewardId = reward?.id || rewardResult.insertId;

    for (const member of members) {
      const [[user]] = await conn.query("SELECT cop_point FROM users WHERE id = ? LIMIT 1 FOR UPDATE", [member.user_id]);
      const before = toInt(user?.cop_point);
      const after = before + perMember;
      await conn.query("UPDATE users SET cop_point = ? WHERE id = ?", [after, member.user_id]);
      await conn.query(
        `INSERT INTO clan_quest_reward_distributions
          (reward_id, quest_id, clan_id, user_id, amount_cop_points, user_balance_before,
           user_balance_after, status, paid_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, 'paid', NOW())
         ON DUPLICATE KEY UPDATE status = 'paid', paid_at = NOW(), user_balance_before = VALUES(user_balance_before),
           user_balance_after = VALUES(user_balance_after), amount_cop_points = VALUES(amount_cop_points)`,
        [rewardId, questId, score.clan_id, member.user_id, perMember, before, after]
      );
      await conn.query(
        `INSERT INTO clan_coin_ledger
          (clan_id, user_id, direction, amount_cop_points, user_balance_before,
           user_balance_after, reason, reference_type, reference_id, created_by)
         VALUES (?, ?, 'credit', ?, ?, ?, 'clan_quest_reward', 'clan_quest_reward', ?, ?)`,
        [score.clan_id, member.user_id, perMember, before, after, rewardId, adminId]
      );
    }
    await conn.query(
      "UPDATE clan_quests SET status = 'completed', completed_by = ?, completed_at = NOW() WHERE id = ?",
      [adminId, questId]
    );
    await conn.commit();
    return { message: "Quest reward distributed", member_count: members.length, amount_per_member: perMember, remainder_amount: remainder };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = {
  cleanText,
  slugify,
  ensureClanSettings,
  ensureClanChatTable,
  listClans,
  getClanDetails,
  getMyClan,
  createClan,
  joinClan,
  leaveClan,
  updateClan,
  listJoinRequests,
  decideJoinRequest,
  updateMemberRole,
  removeMember,
  listQuests,
  listPublicClanQuests,
  listTopClans,
  listClanChat,
  sendClanChat,
  deleteClanChatMessage,
  participateQuest,
  calculateQuestScores,
  distributeQuestReward,
  toInt,
};
