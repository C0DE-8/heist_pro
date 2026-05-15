CREATE TABLE IF NOT EXISTS `heist_content_bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_heist_content_bank_active_created` (`is_active`, `created_at`),
  KEY `idx_heist_content_bank_created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `heist_content_bank` (`name`, `description`, `is_active`, `created_by`)
SELECT seed.`name`, seed.`description`, 1, NULL
FROM (
  SELECT
    'Midnight Vault Run' AS `name`,
    'Every bold move starts with one brave answer. Step in, stay sharp, and let your focus open the vault.' AS `description`
  UNION ALL
  SELECT
    'Street Genius Sprint',
    'Your mind is the key. Trust what you know, move with speed, and turn quick thinking into CopUpCoin.'
  UNION ALL
  SELECT
    'Golden Ticket Rush',
    'Small choices can unlock big wins. Keep your spirit high, answer with confidence, and chase the golden moment.'
  UNION ALL
  SELECT
    'Brainwave Battle',
    'Rise above the noise and let your knowledge speak. One clear answer at a time can carry you to the top.'
  UNION ALL
  SELECT
    'Flash Truth Challenge',
    'The clock is fast, but a calm mind is faster. Pick true or false and prove your instinct under pressure.'
  UNION ALL
  SELECT
    'Crown Chase Heist',
    'Winners are built in the seconds where others hesitate. Stay ready, stay steady, and go claim the crown.'
  UNION ALL
  SELECT
    'Lucky Mind Lock',
    'Luck favors the prepared mind. Bring your best focus, beat the questions, and unlock your next win.'
  UNION ALL
  SELECT
    'Victory Code Run',
    'The code is simple: courage, speed, and a clear answer. Play smart and let every move count.'
) seed
WHERE NOT EXISTS (
  SELECT 1
  FROM `heist_content_bank` existing
  WHERE existing.`name` = seed.`name`
);
