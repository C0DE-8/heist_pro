ALTER TABLE `users`
  MODIFY `role` enum('user','affiliate','admin') NOT NULL DEFAULT 'user';

CREATE TABLE IF NOT EXISTS `affiliate_tiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tile_level` int(11) NOT NULL DEFAULT 1,
  `name` varchar(120) NOT NULL,
  `target_tickets` int(11) NOT NULL,
  `reward_cop_points` int(11) NOT NULL,
  `required_affiliates` int(11) NOT NULL DEFAULT 0,
  `plan_price_cop_points` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_affiliate_tiles_active` (`is_active`, `tile_level`, `required_affiliates`, `target_tickets`),
  KEY `idx_affiliate_tiles_created_by` (`created_by`),
  KEY `idx_affiliate_tiles_updated_by` (`updated_by`),
  CONSTRAINT `fk_affiliate_tiles_created_by`
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_affiliate_tiles_updated_by`
    FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `affiliate_tiles`
  (`tile_level`, `name`, `target_tickets`, `reward_cop_points`, `required_affiliates`, `plan_price_cop_points`, `is_active`)
VALUES
  (1, 'Street Scout', 150, 65, 10, 25, 1)
ON DUPLICATE KEY UPDATE `name` = `name`;

CREATE TABLE IF NOT EXISTS `affiliate_tile_memberships` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `tile_id` int(11) NOT NULL,
  `paid_cop_points` int(11) NOT NULL DEFAULT 0,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','cancelled') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_affiliate_tile_user_tile` (`user_id`, `tile_id`),
  KEY `idx_affiliate_tile_memberships_user` (`user_id`, `status`),
  KEY `idx_affiliate_tile_memberships_tile` (`tile_id`, `status`),
  CONSTRAINT `fk_affiliate_tile_memberships_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_affiliate_tile_memberships_tile`
    FOREIGN KEY (`tile_id`) REFERENCES `affiliate_tiles` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `affiliate_tile_payouts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `tile_id` int(11) NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `earned_cop_points` int(11) NOT NULL DEFAULT 0,
  `status` enum('paid') NOT NULL DEFAULT 'paid',
  `paid_by` int(11) DEFAULT NULL,
  `paid_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_affiliate_tile_payout_period` (`user_id`, `tile_id`, `period_start`),
  KEY `idx_affiliate_tile_payout_period` (`period_start`, `period_end`),
  KEY `idx_affiliate_tile_payout_user` (`user_id`, `paid_at`),
  CONSTRAINT `fk_affiliate_tile_payouts_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_affiliate_tile_payouts_tile`
    FOREIGN KEY (`tile_id`) REFERENCES `affiliate_tiles` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_affiliate_tile_payouts_paid_by`
    FOREIGN KEY (`paid_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
