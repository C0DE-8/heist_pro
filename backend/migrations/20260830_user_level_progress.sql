CREATE TABLE IF NOT EXISTS level_badges (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS level_definitions (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS xp_source_rules (
  source varchar(40) NOT NULL,
  xp_amount int(11) NOT NULL DEFAULT 0,
  label varchar(120) NOT NULL,
  is_active tinyint(1) NOT NULL DEFAULT 1,
  updated_by int(11) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (source)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_xp_totals (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_xp_events (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_level_rewards (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS level_admin_audit_logs (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  admin_user_id int(11) DEFAULT NULL,
  target_user_id int(11) DEFAULT NULL,
  action varchar(80) NOT NULL,
  metadata json DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_level_admin_audit_admin (admin_user_id, created_at),
  KEY idx_level_admin_audit_target (target_user_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO level_badges (name, badge_order, is_active) VALUES
  ('Beginner', 1, 1),
  ('Rookie', 2, 1),
  ('Hustler', 3, 1),
  ('Raider', 4, 1),
  ('Specialist', 5, 1),
  ('Elite', 6, 1),
  ('Mastermind', 7, 1),
  ('Legend', 8, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO xp_source_rules (source, xp_amount, label, is_active) VALUES
  ('daily_login', 10, 'Daily check-in', 1),
  ('heist_play', 15, 'Play a heist', 1),
  ('heist_win', 100, 'Win a heist', 1),
  ('referral_signup', 50, 'Referral signup', 1),
  ('deposit', 1, 'Completed deposit', 1),
  ('withdrawal', 1, 'Completed withdrawal', 1),
  ('admin_adjustment', 0, 'Admin adjustment', 1)
ON DUPLICATE KEY UPDATE source = source;

INSERT INTO level_definitions
  (badge_id, level_order, badge_level, roman_label, xp_required, coupon_copup_jr_amount, is_active)
SELECT b.id, levels.level_order, levels.badge_level, levels.roman_label,
       levels.xp_required, levels.coupon_copup_jr_amount, 1
FROM level_badges b
JOIN (
  SELECT 1 badge_order, 1 level_order, 1 badge_level, 'I' roman_label, 0 xp_required, 5 coupon_copup_jr_amount
  UNION ALL SELECT 1, 2, 2, 'II', 100, 10
  UNION ALL SELECT 1, 3, 3, 'III', 200, 15
  UNION ALL SELECT 1, 4, 4, 'IV', 300, 20
  UNION ALL SELECT 1, 5, 5, 'V', 400, 25
  UNION ALL SELECT 2, 6, 1, 'I', 500, 30
  UNION ALL SELECT 2, 7, 2, 'II', 600, 35
  UNION ALL SELECT 2, 8, 3, 'III', 700, 40
  UNION ALL SELECT 2, 9, 4, 'IV', 800, 45
  UNION ALL SELECT 2, 10, 5, 'V', 900, 50
  UNION ALL SELECT 3, 11, 1, 'I', 1000, 55
  UNION ALL SELECT 3, 12, 2, 'II', 1100, 60
  UNION ALL SELECT 3, 13, 3, 'III', 1200, 65
  UNION ALL SELECT 3, 14, 4, 'IV', 1300, 70
  UNION ALL SELECT 3, 15, 5, 'V', 1400, 75
  UNION ALL SELECT 4, 16, 1, 'I', 1500, 80
  UNION ALL SELECT 4, 17, 2, 'II', 1600, 85
  UNION ALL SELECT 4, 18, 3, 'III', 1700, 90
  UNION ALL SELECT 4, 19, 4, 'IV', 1800, 95
  UNION ALL SELECT 4, 20, 5, 'V', 1900, 100
  UNION ALL SELECT 5, 21, 1, 'I', 2000, 105
  UNION ALL SELECT 5, 22, 2, 'II', 2100, 110
  UNION ALL SELECT 5, 23, 3, 'III', 2200, 115
  UNION ALL SELECT 5, 24, 4, 'IV', 2300, 120
  UNION ALL SELECT 5, 25, 5, 'V', 2400, 125
  UNION ALL SELECT 6, 26, 1, 'I', 2500, 130
  UNION ALL SELECT 6, 27, 2, 'II', 2600, 135
  UNION ALL SELECT 6, 28, 3, 'III', 2700, 140
  UNION ALL SELECT 6, 29, 4, 'IV', 2800, 145
  UNION ALL SELECT 6, 30, 5, 'V', 2900, 150
  UNION ALL SELECT 7, 31, 1, 'I', 3000, 155
  UNION ALL SELECT 7, 32, 2, 'II', 3100, 160
  UNION ALL SELECT 7, 33, 3, 'III', 3200, 165
  UNION ALL SELECT 7, 34, 4, 'IV', 3300, 170
  UNION ALL SELECT 7, 35, 5, 'V', 3400, 175
  UNION ALL SELECT 8, 36, 1, 'I', 3500, 180
  UNION ALL SELECT 8, 37, 2, 'II', 3600, 185
  UNION ALL SELECT 8, 38, 3, 'III', 3700, 190
  UNION ALL SELECT 8, 39, 4, 'IV', 3800, 195
  UNION ALL SELECT 8, 40, 5, 'V', 3900, 200
) levels ON levels.badge_order = b.badge_order
ON DUPLICATE KEY UPDATE badge_id = VALUES(badge_id);
