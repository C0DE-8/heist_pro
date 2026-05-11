CREATE TABLE IF NOT EXISTS `push_device_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(512) NOT NULL,
  `platform` varchar(32) NOT NULL DEFAULT 'android',
  `app_version` varchar(64) DEFAULT NULL,
  `last_seen_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_push_device_token` (`token`),
  KEY `idx_push_device_tokens_user` (`user_id`),
  CONSTRAINT `fk_push_device_tokens_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
