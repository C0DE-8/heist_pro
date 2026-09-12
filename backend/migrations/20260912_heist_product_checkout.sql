CREATE TABLE IF NOT EXISTS products (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(180) NOT NULL,
  description text DEFAULT NULL,
  sku varchar(80) DEFAULT NULL,
  is_active tinyint(1) NOT NULL DEFAULT 1,
  created_by int(11) DEFAULT NULL,
  updated_by int(11) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_products_sku (sku),
  KEY idx_products_active_name (is_active, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_images (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id bigint(20) UNSIGNED NOT NULL,
  image_path varchar(500) NOT NULL,
  is_primary tinyint(1) NOT NULL DEFAULT 0,
  sort_order int(11) NOT NULL DEFAULT 0,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_product_images_order (product_id, is_primary, sort_order),
  CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE heist
  ADD COLUMN reward_type enum('cash','product') NOT NULL DEFAULT 'cash' AFTER prize_cop_points,
  ADD COLUMN product_id bigint(20) UNSIGNED DEFAULT NULL AFTER reward_type,
  ADD KEY idx_heist_product (product_id),
  ADD CONSTRAINT fk_heist_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT;

CREATE TABLE IF NOT EXISTS product_win_entitlements (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  heist_id int(11) NOT NULL,
  product_id bigint(20) UNSIGNED NOT NULL,
  user_id int(11) NOT NULL,
  status enum('available','in_cart','ordered','cancelled') NOT NULL DEFAULT 'available',
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_product_win_heist (heist_id),
  KEY idx_product_win_user_status (user_id, status),
  CONSTRAINT fk_product_win_heist FOREIGN KEY (heist_id) REFERENCES heist (id) ON DELETE RESTRICT,
  CONSTRAINT fk_product_win_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
  CONSTRAINT fk_product_win_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_delivery_addresses (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  phone_number varchar(32) NOT NULL,
  detailed_address varchar(1000) NOT NULL,
  state varchar(80) NOT NULL,
  latitude decimal(10,7) NOT NULL,
  longitude decimal(10,7) NOT NULL,
  location_accuracy decimal(10,2) DEFAULT NULL,
  location_captured_at datetime NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_delivery_addresses_user (user_id, updated_at),
  CONSTRAINT fk_delivery_addresses_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS carts (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id int(11) NOT NULL,
  status enum('active','checked_out','abandoned') NOT NULL DEFAULT 'active',
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  KEY idx_carts_user_status (user_id, status),
  CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cart_items (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  cart_id bigint(20) UNSIGNED NOT NULL,
  entitlement_id bigint(20) UNSIGNED NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_cart_entitlement (entitlement_id),
  KEY idx_cart_items_cart (cart_id),
  CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts (id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_entitlement FOREIGN KEY (entitlement_id) REFERENCES product_win_entitlements (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS orders (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  order_reference varchar(64) NOT NULL,
  user_id int(11) NOT NULL,
  status enum('pending','processing','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  recipient_name varchar(180) NOT NULL,
  phone_number varchar(32) NOT NULL,
  detailed_address varchar(1000) NOT NULL,
  state varchar(80) NOT NULL,
  latitude decimal(10,7) NOT NULL,
  longitude decimal(10,7) NOT NULL,
  location_accuracy decimal(10,2) DEFAULT NULL,
  location_captured_at datetime NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_orders_reference (order_reference),
  KEY idx_orders_user_created (user_id, created_at),
  KEY idx_orders_status_created (status, created_at),
  CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS order_items (
  id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id bigint(20) UNSIGNED NOT NULL,
  entitlement_id bigint(20) UNSIGNED NOT NULL,
  heist_id int(11) NOT NULL,
  product_id bigint(20) UNSIGNED NOT NULL,
  product_name varchar(180) NOT NULL,
  product_description text DEFAULT NULL,
  primary_image_path varchar(500) DEFAULT NULL,
  gallery_json longtext DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  UNIQUE KEY uniq_order_item_entitlement (entitlement_id),
  KEY idx_order_items_order (order_id),
  CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_entitlement FOREIGN KEY (entitlement_id) REFERENCES product_win_entitlements (id) ON DELETE RESTRICT,
  CONSTRAINT fk_order_items_heist FOREIGN KEY (heist_id) REFERENCES heist (id) ON DELETE RESTRICT,
  CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
