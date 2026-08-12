CREATE TABLE IF NOT EXISTS clan_settings (
  id tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  creation_cost_cop_points int(11) NOT NULL DEFAULT 0,
  max_members int(11) DEFAULT NULL,
  is_enabled tinyint(1) NOT NULL DEFAULT 1,
  updated_by int(11) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  CONSTRAINT fk_clan_settings_updated_by
    FOREIGN KEY (updated_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO clan_settings (id, creation_cost_cop_points, max_members, is_enabled)
VALUES (1, 0, NULL, 1)
ON DUPLICATE KEY UPDATE id = id;

CREATE TABLE IF NOT EXISTS clans (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(120) NOT NULL,
  slug varchar(140) NOT NULL,
  logo_url varchar(500) DEFAULT NULL,
  banner_url varchar(500) DEFAULT NULL,
  description text DEFAULT NULL,
  leader_user_id int(11) NOT NULL,
  join_policy enum('open','request','invite_only','closed') NOT NULL DEFAULT 'request',
  status enum('active','suspended','deleted') NOT NULL DEFAULT 'active',
  creation_cost_cop_points int(11) NOT NULL DEFAULT 0,
  created_by int(11) DEFAULT NULL,
  updated_by int(11) DEFAULT NULL,
  deleted_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clans_name (name),
  UNIQUE KEY uniq_clans_slug (slug),
  KEY idx_clans_status_created (status, created_at),
  KEY idx_clans_leader (leader_user_id),
  KEY idx_clans_created_by (created_by),
  CONSTRAINT fk_clans_leader
    FOREIGN KEY (leader_user_id) REFERENCES users (id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_clans_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clans_updated_by
    FOREIGN KEY (updated_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_members (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_id bigint(20) UNSIGNED NOT NULL,
  user_id int(11) NOT NULL,
  role enum('leader','co_leader','elder','member') NOT NULL DEFAULT 'member',
  status enum('active','left','removed','banned') NOT NULL DEFAULT 'active',
  invited_by int(11) DEFAULT NULL,
  approved_by int(11) DEFAULT NULL,
  joined_at timestamp NOT NULL DEFAULT current_timestamp(),
  left_at datetime DEFAULT NULL,
  role_updated_by int(11) DEFAULT NULL,
  role_updated_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_members_clan_user (clan_id, user_id),
  KEY idx_clan_members_user_status (user_id, status),
  KEY idx_clan_members_clan_status_role (clan_id, status, role),
  KEY idx_clan_members_joined_left (clan_id, joined_at, left_at),
  CONSTRAINT fk_clan_members_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_members_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_members_invited_by
    FOREIGN KEY (invited_by) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_members_approved_by
    FOREIGN KEY (approved_by) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_members_role_updated_by
    FOREIGN KEY (role_updated_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_join_requests (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_id bigint(20) UNSIGNED NOT NULL,
  user_id int(11) NOT NULL,
  message varchar(500) DEFAULT NULL,
  status enum('pending','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  reviewed_by int(11) DEFAULT NULL,
  reviewed_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_join_request (clan_id, user_id, status),
  KEY idx_clan_join_requests_user_status (user_id, status),
  KEY idx_clan_join_requests_clan_status (clan_id, status, created_at),
  CONSTRAINT fk_clan_join_requests_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_join_requests_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_join_requests_reviewed_by
    FOREIGN KEY (reviewed_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_invites (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_id bigint(20) UNSIGNED NOT NULL,
  invited_user_id int(11) NOT NULL,
  invited_by int(11) DEFAULT NULL,
  status enum('pending','accepted','declined','cancelled','expired') NOT NULL DEFAULT 'pending',
  expires_at datetime DEFAULT NULL,
  responded_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_invite (clan_id, invited_user_id, status),
  KEY idx_clan_invites_user_status (invited_user_id, status),
  KEY idx_clan_invites_clan_status (clan_id, status, created_at),
  CONSTRAINT fk_clan_invites_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_invites_invited_user
    FOREIGN KEY (invited_user_id) REFERENCES users (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_invites_invited_by
    FOREIGN KEY (invited_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_coin_ledger (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_id bigint(20) UNSIGNED DEFAULT NULL,
  user_id int(11) DEFAULT NULL,
  direction enum('credit','debit') NOT NULL,
  amount_cop_points int(11) NOT NULL,
  user_balance_before int(11) DEFAULT NULL,
  user_balance_after int(11) DEFAULT NULL,
  reason varchar(80) NOT NULL,
  reference_type varchar(80) DEFAULT NULL,
  reference_id bigint(20) UNSIGNED DEFAULT NULL,
  metadata text DEFAULT NULL,
  created_by int(11) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_clan_coin_ledger_clan_created (clan_id, created_at),
  KEY idx_clan_coin_ledger_user_created (user_id, created_at),
  KEY idx_clan_coin_ledger_reference (reference_type, reference_id),
  CONSTRAINT fk_clan_coin_ledger_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_coin_ledger_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_coin_ledger_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_activity_events (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_id bigint(20) UNSIGNED NOT NULL,
  actor_user_id int(11) DEFAULT NULL,
  target_user_id int(11) DEFAULT NULL,
  event_type varchar(80) NOT NULL,
  details text DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_clan_activity_clan_created (clan_id, created_at),
  KEY idx_clan_activity_actor_created (actor_user_id, created_at),
  KEY idx_clan_activity_type_created (event_type, created_at),
  CONSTRAINT fk_clan_activity_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_activity_actor
    FOREIGN KEY (actor_user_id) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_activity_target
    FOREIGN KEY (target_user_id) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_chat_messages (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_quests (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  title varchar(160) NOT NULL,
  description text DEFAULT NULL,
  quest_type enum('heist_wins','custom') NOT NULL DEFAULT 'heist_wins',
  status enum('draft','scheduled','active','completed','cancelled') NOT NULL DEFAULT 'draft',
  starts_at datetime NOT NULL,
  ends_at datetime NOT NULL,
  prize_type enum('cop_points','other') NOT NULL DEFAULT 'cop_points',
  prize_amount int(11) NOT NULL DEFAULT 0,
  reward_metadata text DEFAULT NULL,
  participation_policy enum('opt_in','auto') NOT NULL DEFAULT 'opt_in',
  min_members int(11) NOT NULL DEFAULT 1,
  max_participating_clans int(11) DEFAULT NULL,
  scoring_rule varchar(80) NOT NULL DEFAULT 'successful_heist_wins',
  created_by int(11) DEFAULT NULL,
  updated_by int(11) DEFAULT NULL,
  completed_by int(11) DEFAULT NULL,
  completed_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_clan_quests_status_dates (status, starts_at, ends_at),
  KEY idx_clan_quests_type_status (quest_type, status),
  KEY idx_clan_quests_created_by (created_by),
  CONSTRAINT fk_clan_quests_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_quests_updated_by
    FOREIGN KEY (updated_by) REFERENCES users (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_clan_quests_completed_by
    FOREIGN KEY (completed_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_quest_participants (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  quest_id bigint(20) UNSIGNED NOT NULL,
  clan_id bigint(20) UNSIGNED NOT NULL,
  status enum('participating','withdrawn','disqualified') NOT NULL DEFAULT 'participating',
  joined_by int(11) DEFAULT NULL,
  joined_at timestamp NOT NULL DEFAULT current_timestamp(),
  withdrawn_at datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_quest_participant (quest_id, clan_id),
  KEY idx_clan_quest_participants_clan_status (clan_id, status),
  KEY idx_clan_quest_participants_quest_status (quest_id, status),
  CONSTRAINT fk_clan_quest_participants_quest
    FOREIGN KEY (quest_id) REFERENCES clan_quests (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_participants_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_participants_joined_by
    FOREIGN KEY (joined_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_quest_heist_wins (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  quest_id bigint(20) UNSIGNED NOT NULL,
  clan_id bigint(20) UNSIGNED NOT NULL,
  heist_id int(11) NOT NULL,
  winner_user_id int(11) NOT NULL,
  won_at datetime NOT NULL,
  points int(11) NOT NULL DEFAULT 1,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_quest_heist_win (quest_id, heist_id, winner_user_id),
  KEY idx_clan_quest_heist_wins_score (quest_id, clan_id, points),
  KEY idx_clan_quest_heist_wins_user (winner_user_id, won_at),
  CONSTRAINT fk_clan_quest_heist_wins_quest
    FOREIGN KEY (quest_id) REFERENCES clan_quests (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_heist_wins_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_heist_wins_heist
    FOREIGN KEY (heist_id) REFERENCES heist (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_heist_wins_user
    FOREIGN KEY (winner_user_id) REFERENCES users (id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_quest_scores (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  quest_id bigint(20) UNSIGNED NOT NULL,
  clan_id bigint(20) UNSIGNED NOT NULL,
  score int(11) NOT NULL DEFAULT 0,
  rank_position int(11) DEFAULT NULL,
  is_winner tinyint(1) NOT NULL DEFAULT 0,
  calculated_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_quest_score (quest_id, clan_id),
  KEY idx_clan_quest_scores_rank (quest_id, rank_position, score),
  KEY idx_clan_quest_scores_clan (clan_id),
  CONSTRAINT fk_clan_quest_scores_quest
    FOREIGN KEY (quest_id) REFERENCES clan_quests (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_scores_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_quest_rewards (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  quest_id bigint(20) UNSIGNED NOT NULL,
  winning_clan_id bigint(20) UNSIGNED NOT NULL,
  prize_type enum('cop_points','other') NOT NULL DEFAULT 'cop_points',
  prize_amount int(11) NOT NULL DEFAULT 0,
  member_count int(11) NOT NULL DEFAULT 0,
  amount_per_member int(11) NOT NULL DEFAULT 0,
  remainder_amount int(11) NOT NULL DEFAULT 0,
  status enum('pending','distributed','cancelled') NOT NULL DEFAULT 'pending',
  distributed_by int(11) DEFAULT NULL,
  distributed_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_quest_reward (quest_id),
  KEY idx_clan_quest_rewards_clan_status (winning_clan_id, status),
  CONSTRAINT fk_clan_quest_rewards_quest
    FOREIGN KEY (quest_id) REFERENCES clan_quests (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_rewards_clan
    FOREIGN KEY (winning_clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_quest_rewards_distributed_by
    FOREIGN KEY (distributed_by) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clan_quest_reward_distributions (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  reward_id bigint(20) UNSIGNED NOT NULL,
  quest_id bigint(20) UNSIGNED NOT NULL,
  clan_id bigint(20) UNSIGNED NOT NULL,
  user_id int(11) NOT NULL,
  amount_cop_points int(11) NOT NULL DEFAULT 0,
  user_balance_before int(11) DEFAULT NULL,
  user_balance_after int(11) DEFAULT NULL,
  status enum('pending','paid','failed','cancelled') NOT NULL DEFAULT 'pending',
  paid_at datetime DEFAULT NULL,
  failure_reason varchar(255) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_clan_quest_reward_user (reward_id, user_id),
  KEY idx_clan_reward_distributions_user (user_id, created_at),
  KEY idx_clan_reward_distributions_quest_clan (quest_id, clan_id, status),
  CONSTRAINT fk_clan_reward_distributions_reward
    FOREIGN KEY (reward_id) REFERENCES clan_quest_rewards (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_reward_distributions_quest
    FOREIGN KEY (quest_id) REFERENCES clan_quests (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_reward_distributions_clan
    FOREIGN KEY (clan_id) REFERENCES clans (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_clan_reward_distributions_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE OR REPLACE VIEW clan_admin_overview AS
SELECT
  c.id,
  c.name,
  c.slug,
  c.logo_url,
  c.banner_url,
  c.description,
  c.join_policy,
  c.status,
  c.creation_cost_cop_points,
  c.leader_user_id,
  leader.username AS leader_username,
  leader.email AS leader_email,
  COALESCE(m.member_count, 0) AS member_count,
  COALESCE(w.lifetime_quest_heist_win_points, 0) AS lifetime_quest_heist_win_points,
  c.created_at,
  c.updated_at
FROM clans c
JOIN users leader ON leader.id = c.leader_user_id
LEFT JOIN (
  SELECT clan_id, COUNT(*) AS member_count
  FROM clan_members
  WHERE status = 'active'
  GROUP BY clan_id
) m ON m.clan_id = c.id
LEFT JOIN (
  SELECT clan_id, SUM(points) AS lifetime_quest_heist_win_points
  FROM clan_quest_heist_wins
  GROUP BY clan_id
) w ON w.clan_id = c.id;
