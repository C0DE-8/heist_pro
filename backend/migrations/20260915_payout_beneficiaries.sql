CREATE TABLE IF NOT EXISTS payout_beneficiaries (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  account_name varchar(150) NOT NULL,
  account_number varchar(10) NOT NULL,
  account_type varchar(80) NOT NULL DEFAULT 'bank_transfer',
  bank_name varchar(150) NOT NULL,
  bank_code varchar(30) NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_payout_beneficiary_account (user_id, bank_code, account_number),
  KEY idx_payout_beneficiaries_user (user_id, updated_at),
  CONSTRAINT fk_payout_beneficiaries_user
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
