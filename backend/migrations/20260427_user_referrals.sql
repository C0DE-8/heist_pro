SET @has_referral_code_column := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'users'
    AND COLUMN_NAME = 'referral_code'
);
SET @sql := IF(
  @has_referral_code_column = 0,
  'ALTER TABLE `users` ADD COLUMN `referral_code` varchar(50) DEFAULT NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS `referrals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referrer_id` int(11) NOT NULL,
  `referred_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_referrals_referred` (`referred_id`),
  KEY `idx_referrals_referrer` (`referrer_id`),
  CONSTRAINT `fk_referrals_referrer`
    FOREIGN KEY (`referrer_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_referrals_referred`
    FOREIGN KEY (`referred_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET @has_users_referral_index := (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'users'
    AND INDEX_NAME = 'uniq_users_referral_code'
);
SET @sql := IF(
  @has_users_referral_index = 0,
  'ALTER TABLE `users` ADD UNIQUE KEY `uniq_users_referral_code` (`referral_code`)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
