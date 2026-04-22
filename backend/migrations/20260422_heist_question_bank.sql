ALTER TABLE `heist_questions`
  MODIFY COLUMN `heist_id` int(11) DEFAULT NULL,
  ADD COLUMN `assigned_at` datetime DEFAULT NULL AFTER `is_active`,
  ADD COLUMN `assigned_by` int(11) DEFAULT NULL AFTER `assigned_at`,
  ADD KEY `idx_heist_questions_bank` (`heist_id`, `is_active`),
  ADD KEY `idx_heist_questions_assigned_by` (`assigned_by`);

ALTER TABLE `heist_questions`
  ADD CONSTRAINT `fk_heist_questions_assigned_by`
    FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE;


INSERT INTO `heist_questions`
  (`heist_id`, `question_text`, `correct_answer`, `sort_order`, `is_active`)
VALUES
  (NULL, 'The sun rises in the east.', 'true', 1, 1),
  (NULL, 'A triangle has four sides.', 'false', 2, 1),
  (NULL, 'Water freezes at 0 degrees Celsius.', 'true', 3, 1),
  (NULL, 'Nigeria is in South America.', 'false', 4, 1),
  (NULL, 'The human heart has four chambers.', 'true', 5, 1),
  (NULL, '2 + 2 equals 5.', 'false', 6, 1),
  (NULL, 'Earth is the third planet from the sun.', 'true', 7, 1),
  (NULL, 'Birds are mammals.', 'false', 8, 1),
  (NULL, 'The Atlantic Ocean is larger than a swimming pool.', 'true', 9, 1),
  (NULL, 'Light travels faster than sound.', 'true', 10, 1);
