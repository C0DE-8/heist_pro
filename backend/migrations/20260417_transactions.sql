CREATE TABLE IF NOT EXISTS `coin_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit` int(11) NOT NULL DEFAULT 1,
  `price` decimal(12,2) NOT NULL DEFAULT 100.00,
  `currency` varchar(10) NOT NULL DEFAULT 'NGN',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `coin_rate` (`id`, `unit`, `price`, `currency`)
VALUES (1, 1, 100.00, 'NGN')
ON DUPLICATE KEY UPDATE
  `unit` = `unit`,
  `price` = `price`,
  `currency` = `currency`;

CREATE TABLE IF NOT EXISTS `payment_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_name` varchar(150) NOT NULL,
  `account_number` varchar(80) NOT NULL,
  `account_type` varchar(80) NOT NULL,
  `bank_name` varchar(150) DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_payment_accounts_active` (`is_active`),
  KEY `idx_payment_accounts_created_by` (`created_by`),
  CONSTRAINT `fk_payment_accounts_created_by`
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `manual_payin_requests` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `amount_ngn` decimal(12,2) NOT NULL,
  `coin_rate_unit` int(11) NOT NULL,
  `coin_rate_price` decimal(12,2) NOT NULL,
  `coin_amount` int(11) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `proof_reference` varchar(190) DEFAULT NULL,
  `proof_url` varchar(255) DEFAULT NULL,
  `user_note` text DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `admin_note` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_manual_payin_user` (`user_id`),
  KEY `idx_manual_payin_status` (`status`,`created_at`),
  KEY `idx_manual_payin_admin` (`admin_id`),
  CONSTRAINT `fk_manual_payin_admin`
    FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_manual_payin_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `payout_requests` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `cop_points` int(11) NOT NULL,
  `amount_ngn` decimal(12,2) NOT NULL DEFAULT 0.00,
  `coin_rate_unit` int(11) NOT NULL,
  `coin_rate_price` decimal(12,2) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `account_name` varchar(150) NOT NULL,
  `account_number` varchar(80) NOT NULL,
  `account_type` varchar(80) NOT NULL,
  `bank_name` varchar(150) DEFAULT NULL,
  `user_note` text DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `admin_note` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_payout_user` (`user_id`),
  KEY `idx_payout_status` (`status`,`created_at`),
  KEY `idx_payout_admin` (`admin_id`),
  CONSTRAINT `fk_payout_admin`
    FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_payout_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
