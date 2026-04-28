CREATE TABLE IF NOT EXISTS `admin_referral_settings` (
  `id` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `required_heist_joins` int(11) NOT NULL DEFAULT 3,
  `reward_cop_points` int(11) NOT NULL DEFAULT 1,
  `reset_version` int(11) NOT NULL DEFAULT 1,
  `updated_by` int(11) DEFAULT NULL,
  `last_reset_by` int(11) DEFAULT NULL,
  `last_reset_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_admin_referral_settings_updated_by` (`updated_by`),
  KEY `idx_admin_referral_settings_reset_by` (`last_reset_by`),
  CONSTRAINT `fk_admin_referral_settings_updated_by`
    FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_admin_referral_settings_last_reset_by`
    FOREIGN KEY (`last_reset_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `admin_referral_settings`
  (`id`, `is_enabled`, `required_heist_joins`, `reward_cop_points`, `reset_version`)
VALUES
  (1, 0, 3, 1, 1)
ON DUPLICATE KEY UPDATE
  `id` = `id`;

CREATE TABLE IF NOT EXISTS `referral_reward_progress` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `reset_version` int(11) NOT NULL,
  `referrer_id` int(11) NOT NULL,
  `referred_user_id` int(11) NOT NULL,
  `joined_heists` int(11) NOT NULL DEFAULT 0,
  `rewarded_at` datetime DEFAULT NULL,
  `awarded_cop_points` int(11) NOT NULL DEFAULT 0,
  `last_joined_heist_id` int(11) DEFAULT NULL,
  `last_joined_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_referral_reward_cycle_user` (`reset_version`,`referred_user_id`),
  KEY `idx_referral_reward_referrer` (`referrer_id`,`reset_version`),
  KEY `idx_referral_reward_rewarded` (`reset_version`,`rewarded_at`),
  KEY `idx_referral_reward_last_heist` (`last_joined_heist_id`),
  CONSTRAINT `fk_referral_reward_referrer`
    FOREIGN KEY (`referrer_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_referral_reward_referred`
    FOREIGN KEY (`referred_user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_referral_reward_last_heist`
    FOREIGN KEY (`last_joined_heist_id`) REFERENCES `heist` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
