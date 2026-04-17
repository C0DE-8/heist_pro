-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 17, 2026 at 09:43 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `heist_pro`
--

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_user_links`
--

CREATE TABLE `affiliate_user_links` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `affiliate_user_id` int(11) NOT NULL,
  `heist_id` int(11) NOT NULL,
  `referral_code` varchar(100) NOT NULL,
  `referral_link` varchar(255) DEFAULT NULL,
  `total_clicks` int(11) NOT NULL DEFAULT 0,
  `total_signups` int(11) NOT NULL DEFAULT 0,
  `total_heist_joins` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_user_referrals`
--

CREATE TABLE `affiliate_user_referrals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `affiliate_user_id` int(11) NOT NULL,
  `referred_user_id` int(11) NOT NULL,
  `heist_id` int(11) NOT NULL,
  `referral_code` varchar(100) NOT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `heist`
--

CREATE TABLE `heist` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `min_users` int(11) NOT NULL DEFAULT 1,
  `ticket_price` int(11) NOT NULL DEFAULT 0,
  `retry_ticket_price` int(11) NOT NULL DEFAULT 0,
  `allow_retry` tinyint(1) NOT NULL DEFAULT 0,
  `total_questions` int(11) NOT NULL DEFAULT 0,
  `prize_cop_points` int(11) NOT NULL DEFAULT 0,
  `status` enum('pending','hold','started','completed','cancelled') NOT NULL DEFAULT 'pending',
  `submissions_locked` tinyint(1) NOT NULL DEFAULT 0,
  `winner_user_id` int(11) DEFAULT NULL,
  `countdown_started_at` datetime DEFAULT NULL,
  `countdown_duration_minutes` int(11) NOT NULL DEFAULT 10,
  `countdown_ends_at` datetime DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist`
--

INSERT INTO `heist` (`id`, `name`, `description`, `min_users`, `ticket_price`, `retry_ticket_price`, `allow_retry`, `total_questions`, `prize_cop_points`, `status`, `submissions_locked`, `winner_user_id`, `countdown_started_at`, `countdown_duration_minutes`, `countdown_ends_at`, `starts_at`, `ends_at`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'General Knowledge Heist 001', 'Answer all True or False questions. Winner is ranked by highest correct answers, then fastest time.', 2, 100, 50, 0, 10, 5000, 'pending', 0, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52');

-- --------------------------------------------------------

--
-- Table structure for table `heist_participants`
--

CREATE TABLE `heist_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `affiliate_user_id` int(11) DEFAULT NULL,
  `referral_code` varchar(100) DEFAULT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('joined','submitted','disqualified','cancelled') NOT NULL DEFAULT 'joined'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `heist_questions`
--

CREATE TABLE `heist_questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `correct_answer` enum('true','false') NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist_questions`
--

INSERT INTO `heist_questions` (`id`, `heist_id`, `question_text`, `correct_answer`, `sort_order`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'The sun rises in the east.', 'true', 1, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(2, 1, 'A triangle has four sides.', 'false', 2, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(3, 1, 'Water freezes at 0 degrees Celsius.', 'true', 3, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(4, 1, 'Nigeria is in South America.', 'false', 4, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(5, 1, 'The human heart has four chambers.', 'true', 5, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(6, 1, '2 + 2 = 5.', 'false', 6, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(7, 1, 'The Atlantic Ocean is larger than a swimming pool.', 'true', 7, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(8, 1, 'Birds are mammals.', 'false', 8, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(9, 1, 'Earth is the third planet from the sun.', 'true', 9, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(10, 1, 'Light travels slower than sound.', 'false', 10, 1, '2026-04-17 07:42:52', '2026-04-17 07:42:52');

-- --------------------------------------------------------

--
-- Table structure for table `heist_submissions`
--

CREATE TABLE `heist_submissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `participant_id` bigint(20) UNSIGNED DEFAULT NULL,
  `affiliate_user_id` int(11) DEFAULT NULL,
  `started_at` datetime NOT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `total_time_seconds` int(11) DEFAULT NULL,
  `correct_count` int(11) NOT NULL DEFAULT 0,
  `wrong_count` int(11) NOT NULL DEFAULT 0,
  `unanswered_count` int(11) NOT NULL DEFAULT 0,
  `score_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `status` enum('started','submitted','cancelled') NOT NULL DEFAULT 'started',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `heist_submission_answers`
--

CREATE TABLE `heist_submission_answers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `submission_id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `submitted_answer` enum('true','false') DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `answered_at` datetime DEFAULT NULL,
  `time_spent_seconds` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otps`
--

CREATE TABLE `otps` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp` varchar(10) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `referrals`
--

CREATE TABLE `referrals` (
  `id` int(11) NOT NULL,
  `referrer_id` int(11) NOT NULL,
  `referred_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `referral_code` varchar(50) DEFAULT NULL,
  `wallet_address` varchar(100) DEFAULT NULL,
  `game_id` varchar(50) DEFAULT NULL,
  `cop_point` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `username`, `full_name`, `password_hash`, `role`, `is_verified`, `is_blocked`, `referral_code`, `wallet_address`, `game_id`, `cop_point`, `created_at`, `updated_at`) VALUES
(1, 'admin@admin.com', 'admin', 'Heist Admin', '$2b$12$abcdefghijklmnopqrstuv123456789012345678901234567890', 'admin', 1, 0, 'ADMIN01', 'copADMINWALLET000001', 'ADMIN-GAME-001', 0, '2026-04-17 07:42:52', '2026-04-17 07:43:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `affiliate_user_links`
--
ALTER TABLE `affiliate_user_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_affiliate_heist_code` (`heist_id`,`referral_code`),
  ADD UNIQUE KEY `uniq_affiliate_user_heist` (`affiliate_user_id`,`heist_id`),
  ADD KEY `idx_affiliate_user_links_user` (`affiliate_user_id`);

--
-- Indexes for table `affiliate_user_referrals`
--
ALTER TABLE `affiliate_user_referrals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_affiliate_referral_user_heist` (`referred_user_id`,`heist_id`),
  ADD KEY `idx_affiliate_user_referrals_affiliate` (`affiliate_user_id`),
  ADD KEY `fk_affiliate_user_referrals_heist` (`heist_id`);

--
-- Indexes for table `heist`
--
ALTER TABLE `heist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_heist_status` (`status`),
  ADD KEY `idx_heist_winner_user` (`winner_user_id`),
  ADD KEY `idx_heist_created_by` (`created_by`);

--
-- Indexes for table `heist_participants`
--
ALTER TABLE `heist_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_heist_participant` (`heist_id`,`user_id`),
  ADD KEY `idx_heist_participants_user` (`user_id`),
  ADD KEY `idx_heist_participants_affiliate_user` (`affiliate_user_id`);

--
-- Indexes for table `heist_questions`
--
ALTER TABLE `heist_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_heist_questions_heist_id` (`heist_id`),
  ADD KEY `idx_heist_questions_heist_sort` (`heist_id`,`sort_order`);

--
-- Indexes for table `heist_submissions`
--
ALTER TABLE `heist_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_heist_submissions_heist_user` (`heist_id`,`user_id`),
  ADD KEY `idx_heist_submissions_participant` (`participant_id`),
  ADD KEY `idx_heist_submissions_affiliate_user` (`affiliate_user_id`),
  ADD KEY `idx_heist_submissions_leaderboard` (`heist_id`,`correct_count`,`total_time_seconds`,`submitted_at`),
  ADD KEY `fk_heist_submissions_user` (`user_id`);

--
-- Indexes for table `heist_submission_answers`
--
ALTER TABLE `heist_submission_answers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_submission_question` (`submission_id`,`question_id`),
  ADD KEY `idx_hsa_heist_user` (`heist_id`,`user_id`),
  ADD KEY `idx_hsa_question` (`question_id`),
  ADD KEY `fk_hsa_user` (`user_id`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_otps_email` (`email`),
  ADD KEY `idx_otps_email_otp` (`email`,`otp`);

--
-- Indexes for table `referrals`
--
ALTER TABLE `referrals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_referrals_referred` (`referred_id`),
  ADD KEY `idx_referrals_referrer` (`referrer_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_users_email` (`email`),
  ADD UNIQUE KEY `uniq_users_username` (`username`),
  ADD UNIQUE KEY `uniq_users_referral_code` (`referral_code`),
  ADD UNIQUE KEY `uniq_users_wallet_address` (`wallet_address`),
  ADD UNIQUE KEY `uniq_users_game_id` (`game_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `affiliate_user_links`
--
ALTER TABLE `affiliate_user_links`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `affiliate_user_referrals`
--
ALTER TABLE `affiliate_user_referrals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `heist`
--
ALTER TABLE `heist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `heist_participants`
--
ALTER TABLE `heist_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `heist_questions`
--
ALTER TABLE `heist_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `heist_submissions`
--
ALTER TABLE `heist_submissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `heist_submission_answers`
--
ALTER TABLE `heist_submission_answers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `referrals`
--
ALTER TABLE `referrals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `affiliate_user_links`
--
ALTER TABLE `affiliate_user_links`
  ADD CONSTRAINT `fk_affiliate_user_links_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_affiliate_user_links_user` FOREIGN KEY (`affiliate_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `affiliate_user_referrals`
--
ALTER TABLE `affiliate_user_referrals`
  ADD CONSTRAINT `fk_affiliate_user_referrals_affiliate` FOREIGN KEY (`affiliate_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_affiliate_user_referrals_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_affiliate_user_referrals_referred` FOREIGN KEY (`referred_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `heist`
--
ALTER TABLE `heist`
  ADD CONSTRAINT `fk_heist_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_heist_winner_user` FOREIGN KEY (`winner_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `heist_participants`
--
ALTER TABLE `heist_participants`
  ADD CONSTRAINT `fk_heist_participants_affiliate_user` FOREIGN KEY (`affiliate_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_heist_participants_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_heist_participants_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `heist_questions`
--
ALTER TABLE `heist_questions`
  ADD CONSTRAINT `fk_heist_questions_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `heist_submissions`
--
ALTER TABLE `heist_submissions`
  ADD CONSTRAINT `fk_heist_submissions_affiliate_user` FOREIGN KEY (`affiliate_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_heist_submissions_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_heist_submissions_participant` FOREIGN KEY (`participant_id`) REFERENCES `heist_participants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_heist_submissions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `heist_submission_answers`
--
ALTER TABLE `heist_submission_answers`
  ADD CONSTRAINT `fk_hsa_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hsa_question` FOREIGN KEY (`question_id`) REFERENCES `heist_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hsa_submission` FOREIGN KEY (`submission_id`) REFERENCES `heist_submissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hsa_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `referrals`
--
ALTER TABLE `referrals`
  ADD CONSTRAINT `fk_referrals_referred` FOREIGN KEY (`referred_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_referrals_referrer` FOREIGN KEY (`referrer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
