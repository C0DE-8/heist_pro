CREATE TABLE IF NOT EXISTS `user_notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(64) NOT NULL DEFAULT 'admin_notice',
  `title` varchar(160) NOT NULL,
  `message` text NOT NULL,
  `path` varchar(255) DEFAULT '/dashboard',
  `priority` enum('normal','important') NOT NULL DEFAULT 'important',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_notices_user_created` (`user_id`, `created_at`),
  KEY `idx_user_notices_created_by` (`created_by`),
  CONSTRAINT `fk_user_notices_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_notices_admin`
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
