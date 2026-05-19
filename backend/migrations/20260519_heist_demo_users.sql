CREATE TABLE IF NOT EXISTS `heist_demo_users` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `display_name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_heist_demo_users_display_name` (`display_name`),
  KEY `idx_heist_demo_users_active_created` (`is_active`, `created_at`),
  KEY `idx_heist_demo_users_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET @demo_user_column_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'heist_demo_submissions'
    AND COLUMN_NAME = 'demo_user_id'
);

SET @add_demo_user_column_sql := IF(
  @demo_user_column_exists = 0,
  'ALTER TABLE `heist_demo_submissions` ADD COLUMN `demo_user_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `heist_id`',
  'SELECT 1'
);

PREPARE add_demo_user_column_stmt FROM @add_demo_user_column_sql;
EXECUTE add_demo_user_column_stmt;
DEALLOCATE PREPARE add_demo_user_column_stmt;

SET @demo_user_index_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'heist_demo_submissions'
    AND INDEX_NAME = 'idx_heist_demo_submissions_demo_user'
);

SET @add_demo_user_index_sql := IF(
  @demo_user_index_exists = 0,
  'ALTER TABLE `heist_demo_submissions` ADD KEY `idx_heist_demo_submissions_demo_user` (`demo_user_id`)',
  'SELECT 1'
);

PREPARE add_demo_user_index_stmt FROM @add_demo_user_index_sql;
EXECUTE add_demo_user_index_stmt;
DEALLOCATE PREPARE add_demo_user_index_stmt;

SET @winner_demo_column_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'heist'
    AND COLUMN_NAME = 'winner_demo_submission_id'
);

SET @add_winner_demo_column_sql := IF(
  @winner_demo_column_exists = 0,
  'ALTER TABLE `heist` ADD COLUMN `winner_demo_submission_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `winner_user_id`',
  'SELECT 1'
);

PREPARE add_winner_demo_column_stmt FROM @add_winner_demo_column_sql;
EXECUTE add_winner_demo_column_stmt;
DEALLOCATE PREPARE add_winner_demo_column_stmt;

SET @winner_demo_index_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'heist'
    AND INDEX_NAME = 'idx_heist_winner_demo'
);

SET @add_winner_demo_index_sql := IF(
  @winner_demo_index_exists = 0,
  'ALTER TABLE `heist` ADD KEY `idx_heist_winner_demo` (`winner_demo_submission_id`)',
  'SELECT 1'
);

PREPARE add_winner_demo_index_stmt FROM @add_winner_demo_index_sql;
EXECUTE add_winner_demo_index_stmt;
DEALLOCATE PREPARE add_winner_demo_index_stmt;
