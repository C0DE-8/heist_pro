ALTER TABLE `heist`
  ADD COLUMN `questions_per_session` int(11) NOT NULL DEFAULT 0 AFTER `total_questions`;

CREATE TABLE IF NOT EXISTS `heist_submission_questions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_hsq_submission_question` (`submission_id`, `question_id`),
  UNIQUE KEY `uniq_hsq_submission_position` (`submission_id`, `position`),
  KEY `idx_hsq_submission` (`submission_id`, `position`),
  KEY `idx_hsq_heist_user` (`heist_id`, `user_id`),
  CONSTRAINT `fk_hsq_submission`
    FOREIGN KEY (`submission_id`) REFERENCES `heist_submissions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_hsq_heist`
    FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_hsq_question`
    FOREIGN KEY (`question_id`) REFERENCES `heist_questions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_hsq_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
