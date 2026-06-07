ALTER TABLE users
  ADD COLUMN registration_ip varchar(64) DEFAULT NULL AFTER game_id,
  ADD COLUMN registration_device_key varchar(128) DEFAULT NULL AFTER registration_ip,
  ADD COLUMN last_login_at timestamp NULL DEFAULT NULL AFTER registration_device_key,
  ADD COLUMN last_seen_at timestamp NULL DEFAULT NULL AFTER last_login_at,
  ADD KEY idx_users_registration_device (registration_device_key),
  ADD KEY idx_users_registration_ip (registration_ip);

CREATE TABLE IF NOT EXISTS user_activity_events (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id int(11) DEFAULT NULL,
  event_type varchar(32) NOT NULL,
  path varchar(255) DEFAULT NULL,
  method varchar(16) DEFAULT NULL,
  ip_address varchar(64) DEFAULT NULL,
  user_agent varchar(500) DEFAULT NULL,
  device_key varchar(128) DEFAULT NULL,
  metadata text DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_user_activity_user_created (user_id, created_at),
  KEY idx_user_activity_event_created (event_type, created_at),
  KEY idx_user_activity_ip_created (ip_address, created_at),
  KEY idx_user_activity_device_created (device_key, created_at),
  CONSTRAINT fk_user_activity_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
