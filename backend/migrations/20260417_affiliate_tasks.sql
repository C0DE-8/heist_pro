CREATE TABLE IF NOT EXISTS `affiliate_tasks` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `heist_id` int(11) NOT NULL,
  `required_joins` int(11) NOT NULL,
  `reward_cop_points` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_affiliate_tasks_heist` (`heist_id`),
  KEY `idx_affiliate_tasks_active` (`heist_id`,`is_active`),
  CONSTRAINT `fk_affiliate_tasks_heist`
    FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `affiliate_task_progress` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `current_joins` int(11) NOT NULL DEFAULT 0,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `rewarded_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_affiliate_task_user` (`task_id`,`user_id`),
  KEY `idx_affiliate_task_progress_user` (`user_id`),
  KEY `idx_affiliate_task_progress_completed` (`task_id`,`is_completed`),
  CONSTRAINT `fk_affiliate_task_progress_task`
    FOREIGN KEY (`task_id`) REFERENCES `affiliate_tasks` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_affiliate_task_progress_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
