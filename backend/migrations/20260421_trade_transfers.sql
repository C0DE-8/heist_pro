ALTER TABLE `users`
  ADD COLUMN `trade_pin_hash` varchar(255) DEFAULT NULL AFTER `password_hash`,
  ADD COLUMN `trade_pin_changed` tinyint(1) NOT NULL DEFAULT 0 AFTER `trade_pin_hash`;

CREATE TABLE IF NOT EXISTS `cop_point_transfers` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_user_id` int(11) NOT NULL,
  `recipient_user_id` int(11) NOT NULL,
  `recipient_wallet_address` varchar(100) NOT NULL,
  `cop_points` int(11) NOT NULL,
  `sender_balance_before` int(11) NOT NULL,
  `sender_balance_after` int(11) NOT NULL,
  `recipient_balance_before` int(11) NOT NULL,
  `recipient_balance_after` int(11) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_transfers_sender` (`sender_user_id`, `created_at`),
  KEY `idx_transfers_recipient` (`recipient_user_id`, `created_at`),
  KEY `idx_transfers_wallet` (`recipient_wallet_address`),
  CONSTRAINT `fk_transfers_sender`
    FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transfers_recipient`
    FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
