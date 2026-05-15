CREATE TABLE IF NOT EXISTS `auto_heist_settings` (
  `id` tinyint(1) NOT NULL DEFAULT 1,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `min_users` int(11) NOT NULL DEFAULT 1,
  `max_users` int(11) DEFAULT NULL,
  `ticket_price` int(11) NOT NULL DEFAULT 0,
  `prize_cop_points` int(11) NOT NULL DEFAULT 0,
  `questions_per_session` int(11) NOT NULL DEFAULT 0,
  `countdown_duration_minutes` int(11) NOT NULL DEFAULT 10,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `auto_heist_settings`
  (`id`, `is_enabled`, `min_users`, `max_users`, `ticket_price`, `prize_cop_points`, `questions_per_session`, `countdown_duration_minutes`)
VALUES
  (1, 0, 1, NULL, 0, 0, 0, 10);
