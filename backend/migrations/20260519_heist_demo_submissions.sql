CREATE TABLE IF NOT EXISTS `heist_demo_submissions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `heist_id` int(11) NOT NULL,
  `demo_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `display_name` varchar(120) NOT NULL,
  `correct_count` int(11) NOT NULL DEFAULT 0,
  `wrong_count` int(11) NOT NULL DEFAULT 0,
  `unanswered_count` int(11) NOT NULL DEFAULT 0,
  `score_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `total_time_seconds` int(11) NOT NULL DEFAULT 0,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_heist_demo_submissions_rank` (`heist_id`, `correct_count`, `total_time_seconds`, `submitted_at`),
  KEY `idx_heist_demo_submissions_demo_user` (`demo_user_id`),
  KEY `idx_heist_demo_submissions_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
