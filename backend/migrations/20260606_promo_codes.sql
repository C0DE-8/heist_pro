CREATE TABLE IF NOT EXISTS promo_codes (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  code varchar(64) NOT NULL,
  copup_jr_amount int(11) NOT NULL,
  max_redemptions int(11) DEFAULT NULL,
  redemption_count int(11) NOT NULL DEFAULT 0,
  is_active tinyint(1) NOT NULL DEFAULT 1,
  expires_at datetime DEFAULT NULL,
  created_by int(11) DEFAULT NULL,
  updated_by int(11) DEFAULT NULL,
  deleted_at datetime DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_promo_codes_code (code),
  KEY idx_promo_codes_status (is_active, expires_at, deleted_at),
  KEY idx_promo_codes_created_by (created_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS promo_code_redemptions (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  promo_code_id bigint(20) UNSIGNED NOT NULL,
  user_id int(11) NOT NULL,
  amount int(11) NOT NULL,
  redeemed_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_promo_redemptions_code_user (promo_code_id, user_id),
  KEY idx_promo_redemptions_user (user_id),
  CONSTRAINT fk_promo_redemptions_code
    FOREIGN KEY (promo_code_id) REFERENCES promo_codes (id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_copup_jr_balances (
  user_id int(11) NOT NULL,
  balance int(11) NOT NULL DEFAULT 0,
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (user_id),
  CONSTRAINT fk_user_copup_jr_balances_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_copup_jr_ledger (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  promo_code_id bigint(20) UNSIGNED DEFAULT NULL,
  redemption_id bigint(20) UNSIGNED DEFAULT NULL,
  heist_id int(11) DEFAULT NULL,
  direction enum('credit','debit') NOT NULL,
  amount int(11) NOT NULL,
  balance_after int(11) NOT NULL,
  reason varchar(80) NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_copup_jr_ledger_user_created (user_id, created_at),
  KEY idx_copup_jr_ledger_heist (heist_id),
  KEY idx_copup_jr_ledger_promo (promo_code_id),
  CONSTRAINT fk_copup_jr_ledger_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE CASCADE,
  CONSTRAINT fk_copup_jr_ledger_promo
    FOREIGN KEY (promo_code_id) REFERENCES promo_codes (id)
    ON DELETE SET NULL,
  CONSTRAINT fk_copup_jr_ledger_redemption
    FOREIGN KEY (redemption_id) REFERENCES promo_code_redemptions (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
