SET @heist_max_users_missing := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'heist'
    AND COLUMN_NAME = 'max_users'
) = 0;

SET @heist_max_users_sql := IF(
  @heist_max_users_missing,
  'ALTER TABLE `heist` ADD COLUMN `max_users` int(11) DEFAULT NULL AFTER `min_users`',
  'SELECT 1'
);

PREPARE heist_max_users_stmt FROM @heist_max_users_sql;
EXECUTE heist_max_users_stmt;
DEALLOCATE PREPARE heist_max_users_stmt;
