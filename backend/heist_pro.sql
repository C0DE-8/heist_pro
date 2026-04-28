-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 28, 2026 at 01:52 AM
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
-- Table structure for table `admin_analytics_user_exclusions`
--

CREATE TABLE `admin_analytics_user_exclusions` (
  `user_id` int(11) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_analytics_user_exclusions`
--

INSERT INTO `admin_analytics_user_exclusions` (`user_id`, `created_by`, `created_at`) VALUES
(2, 1, '2026-04-21 20:35:35'),
(3, 1, '2026-04-21 20:35:39');

-- --------------------------------------------------------

--
-- Table structure for table `admin_referral_settings`
--

CREATE TABLE `admin_referral_settings` (
  `id` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `required_heist_joins` int(11) NOT NULL DEFAULT 3,
  `reward_cop_points` int(11) NOT NULL DEFAULT 1,
  `reset_version` int(11) NOT NULL DEFAULT 1,
  `updated_by` int(11) DEFAULT NULL,
  `last_reset_by` int(11) DEFAULT NULL,
  `last_reset_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_referral_settings`
--

INSERT INTO `admin_referral_settings` (`id`, `is_enabled`, `required_heist_joins`, `reward_cop_points`, `reset_version`, `updated_by`, `last_reset_by`, `last_reset_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 2, 1, 1, '2026-04-27 16:49:52', '2026-04-27 23:31:44', '2026-04-27 23:49:52');

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_tasks`
--

CREATE TABLE `affiliate_tasks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `required_joins` int(11) NOT NULL,
  `reward_cop_points` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `affiliate_tasks`
--

INSERT INTO `affiliate_tasks` (`id`, `heist_id`, `required_joins`, `reward_cop_points`, `is_active`) VALUES
(1, 1, 1, 1, 1),
(2, 2, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_task_progress`
--

CREATE TABLE `affiliate_task_progress` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `task_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `current_joins` int(11) NOT NULL DEFAULT 0,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `rewarded_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `affiliate_task_progress`
--

INSERT INTO `affiliate_task_progress` (`id`, `task_id`, `user_id`, `current_joins`, `is_completed`, `rewarded_at`) VALUES
(1, 2, 3, 1, 1, '2026-04-17 11:44:29');

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

--
-- Dumping data for table `affiliate_user_links`
--

INSERT INTO `affiliate_user_links` (`id`, `affiliate_user_id`, `heist_id`, `referral_code`, `referral_link`, `total_clicks`, `total_signups`, `total_heist_joins`, `created_at`, `updated_at`) VALUES
(1, 3, 2, 'HRMTFDLTH', 'http://localhost:5173/heists/2/ref/HRMTFDLTH', 19, 0, 1, '2026-04-17 18:01:47', '2026-04-17 18:56:47'),
(2, 3, 1, 'H3PBORYB3', 'http://localhost:5173/heists/1/ref/H3PBORYB3', 15, 0, 0, '2026-04-17 18:16:10', '2026-04-17 19:02:30'),
(3, 3, 5, 'HLU5UXF0A', 'http://localhost:5173/heists/5/ref/HLU5UXF0A', 0, 0, 0, '2026-04-27 22:57:47', '2026-04-27 22:57:47'),
(4, 3, 4, 'HRZ89BW16', 'http://localhost:5173/heists/4/ref/HRZ89BW16', 0, 0, 0, '2026-04-27 22:57:47', '2026-04-27 22:57:47'),
(5, 3, 3, 'HVKKBHV9A', 'http://localhost:5173/heists/3/ref/HVKKBHV9A', 0, 0, 0, '2026-04-27 22:57:47', '2026-04-27 22:57:47');

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

--
-- Dumping data for table `affiliate_user_referrals`
--

INSERT INTO `affiliate_user_referrals` (`id`, `affiliate_user_id`, `referred_user_id`, `heist_id`, `referral_code`, `joined_at`) VALUES
(1, 3, 4, 2, 'HRMTFDLTH', '2026-04-17 18:44:29');

-- --------------------------------------------------------

--
-- Table structure for table `coin_rate`
--

CREATE TABLE `coin_rate` (
  `id` int(11) NOT NULL,
  `unit` int(11) NOT NULL DEFAULT 1,
  `price` decimal(12,2) NOT NULL DEFAULT 100.00,
  `currency` varchar(10) NOT NULL DEFAULT 'NGN',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coin_rate`
--

INSERT INTO `coin_rate` (`id`, `unit`, `price`, `currency`, `created_at`, `updated_at`) VALUES
(1, 1, 100.00, 'NGN', '2026-04-17 19:23:16', '2026-04-17 19:23:16');

-- --------------------------------------------------------

--
-- Table structure for table `cop_point_transfers`
--

CREATE TABLE `cop_point_transfers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sender_user_id` int(11) NOT NULL,
  `recipient_user_id` int(11) NOT NULL,
  `recipient_wallet_address` varchar(100) NOT NULL,
  `cop_points` int(11) NOT NULL,
  `sender_balance_before` int(11) NOT NULL,
  `sender_balance_after` int(11) NOT NULL,
  `recipient_balance_before` int(11) NOT NULL,
  `recipient_balance_after` int(11) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cop_point_transfers`
--

INSERT INTO `cop_point_transfers` (`id`, `sender_user_id`, `recipient_user_id`, `recipient_wallet_address`, `cop_points`, `sender_balance_before`, `sender_balance_after`, `recipient_balance_before`, `recipient_balance_after`, `note`, `created_at`) VALUES
(1, 3, 4, 'coplwnYe2DDW5NynK6NxJB3', 20, 721, 701, 178, 198, 'test of the top up', '2026-04-21 11:18:46');

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
  `total_questions` int(11) NOT NULL DEFAULT 0,
  `questions_per_session` int(11) NOT NULL DEFAULT 0,
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

INSERT INTO `heist` (`id`, `name`, `description`, `min_users`, `ticket_price`, `total_questions`, `questions_per_session`, `prize_cop_points`, `status`, `submissions_locked`, `winner_user_id`, `countdown_started_at`, `countdown_duration_minutes`, `countdown_ends_at`, `starts_at`, `ends_at`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'General Knowledge Heist 001', 'Answer all True or False questions. Winner is ranked by highest correct answers, then fastest time.', 3, 50, 10, 0, 200, 'pending', 0, NULL, NULL, 20, NULL, NULL, NULL, 1, '2026-04-17 07:42:52', '2026-04-21 19:23:16'),
(2, 'weekend heist', 'for the road as we go ', 2, 20, 4, 2, 30, 'completed', 1, 3, '2026-04-21 12:18:51', 2, '2026-04-21 12:28:51', NULL, NULL, 1, '2026-04-17 17:49:02', '2026-04-21 20:37:54'),
(3, 'General Knowledge Heist 001', 'Answer all True or False questions. Winner is ranked by highest correct answers, then fastest time.', 3, 100, 10, 0, 5000, 'pending', 0, NULL, NULL, 20, NULL, NULL, NULL, 1, '2026-04-17 07:42:52', '2026-04-17 13:00:50'),
(4, 'Wealth', 'true false', 3, 0, 3, 3, 0, 'pending', 0, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-04-22 12:46:14', '2026-04-22 12:46:14'),
(5, 'Health & Beauty', 'fixed my soul', 1, 2, 2, 2, 1, 'started', 0, NULL, '2026-04-27 16:47:10', 10, '2026-04-27 16:57:10', NULL, NULL, 1, '2026-04-22 12:48:43', '2026-04-27 23:47:10');

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

--
-- Dumping data for table `heist_participants`
--

INSERT INTO `heist_participants` (`id`, `heist_id`, `user_id`, `affiliate_user_id`, `referral_code`, `joined_at`, `status`) VALUES
(8, 2, 4, 3, 'HRMTFDLTH', '2026-04-17 18:44:29', 'submitted'),
(18, 2, 3, NULL, NULL, '2026-04-21 17:56:08', 'submitted'),
(19, 1, 4, NULL, NULL, '2026-04-21 20:57:01', 'joined'),
(22, 5, 5, NULL, NULL, '2026-04-27 23:47:10', 'submitted');

-- --------------------------------------------------------

--
-- Table structure for table `heist_questions`
--

CREATE TABLE `heist_questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) DEFAULT NULL,
  `question_text` text NOT NULL,
  `correct_answer` enum('true','false') NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `assigned_at` datetime DEFAULT NULL,
  `assigned_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist_questions`
--

INSERT INTO `heist_questions` (`id`, `heist_id`, `question_text`, `correct_answer`, `sort_order`, `is_active`, `assigned_at`, `assigned_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'The sun rises in the east.', 'true', 1, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(2, 1, 'A triangle has four sides.', 'false', 2, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(3, 1, 'Water freezes at 0 degrees Celsius.', 'true', 3, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(4, 1, 'Nigeria is in South America.', 'false', 4, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(5, 1, 'The human heart has four chambers.', 'true', 5, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(6, 1, '2 + 2 = 5.', 'false', 6, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(7, 1, 'The Atlantic Ocean is larger than a swimming pool.', 'true', 7, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(8, 1, 'Birds are mammals.', 'false', 8, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(9, 1, 'Earth is the third planet from the sun.', 'true', 9, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(10, 1, 'Light travels slower than sound.', 'false', 10, 1, NULL, NULL, '2026-04-17 07:42:52', '2026-04-17 07:42:52'),
(11, 2, 'mix yellow and red can give you blue', 'false', 1, 1, NULL, NULL, '2026-04-17 17:51:11', '2026-04-17 17:51:11'),
(12, 2, 'a bed has 4 years', 'false', 2, 1, NULL, NULL, '2026-04-17 17:51:11', '2026-04-17 17:51:11'),
(13, 2, 'the sky is blue', 'true', 3, 1, NULL, NULL, '2026-04-17 17:51:11', '2026-04-17 17:51:11'),
(14, 3, 'the sky is blue', 'true', 1, 1, NULL, NULL, '2026-04-17 17:51:11', '2026-04-17 17:51:11'),
(15, 2, 'can a pig fly', 'false', 1, 1, NULL, NULL, '2026-04-21 17:54:04', '2026-04-21 17:54:04'),
(16, 4, 'The sun rises in the east.', 'true', 1, 1, '2026-04-22 05:46:14', 1, '2026-04-22 12:44:14', '2026-04-22 12:46:14'),
(17, 5, 'A triangle has four sides.', 'false', 2, 1, '2026-04-22 05:48:44', 1, '2026-04-22 12:44:14', '2026-04-22 12:48:44'),
(18, 5, 'Water freezes at 0 degrees Celsius.', 'true', 3, 1, '2026-04-22 05:48:44', 1, '2026-04-22 12:44:14', '2026-04-22 12:48:44'),
(19, NULL, 'Nigeria is in South America.', 'false', 4, 1, NULL, NULL, '2026-04-22 12:44:14', '2026-04-22 12:44:14'),
(20, NULL, 'The human heart has four chambers.', 'true', 5, 1, NULL, NULL, '2026-04-22 12:44:14', '2026-04-22 12:44:14'),
(21, NULL, '2 + 2 equals 5.', 'false', 6, 1, NULL, NULL, '2026-04-22 12:44:14', '2026-04-22 12:44:14'),
(22, NULL, 'Earth is the third planet from the sun.', 'true', 7, 1, NULL, NULL, '2026-04-22 12:44:14', '2026-04-22 12:44:14'),
(23, 4, 'Birds are mammals.', 'false', 8, 1, '2026-04-22 05:46:14', 1, '2026-04-22 12:44:14', '2026-04-22 12:46:14'),
(24, NULL, 'The Atlantic Ocean is larger than a swimming pool.', 'true', 9, 1, NULL, NULL, '2026-04-22 12:44:14', '2026-04-22 12:44:14'),
(25, 4, 'Light travels faster than sound.', 'true', 10, 1, '2026-04-22 05:46:14', 1, '2026-04-22 12:44:14', '2026-04-22 12:46:14'),
(26, NULL, 'is there good in goodness', 'true', 1, 1, NULL, NULL, '2026-04-22 12:49:52', '2026-04-22 12:49:52');

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

--
-- Dumping data for table `heist_submissions`
--

INSERT INTO `heist_submissions` (`id`, `heist_id`, `user_id`, `participant_id`, `affiliate_user_id`, `started_at`, `submitted_at`, `total_time_seconds`, `correct_count`, `wrong_count`, `unanswered_count`, `score_percent`, `status`, `created_at`, `updated_at`) VALUES
(12, 2, 4, 8, 3, '2026-04-21 10:55:32', '2026-04-21 10:55:43', 8, 1, 1, 0, 50.00, 'submitted', '2026-04-21 17:55:32', '2026-04-21 17:55:43'),
(13, 2, 3, 18, NULL, '2026-04-21 10:56:12', '2026-04-21 10:56:22', 7, 1, 1, 0, 50.00, 'submitted', '2026-04-21 17:56:12', '2026-04-21 17:56:22'),
(14, 5, 5, 22, NULL, '2026-04-27 16:47:23', '2026-04-27 16:47:29', 2, 1, 1, 0, 50.00, 'submitted', '2026-04-27 23:47:23', '2026-04-27 23:47:29');

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

--
-- Dumping data for table `heist_submission_answers`
--

INSERT INTO `heist_submission_answers` (`id`, `submission_id`, `heist_id`, `question_id`, `user_id`, `submitted_answer`, `is_correct`, `answered_at`, `time_spent_seconds`, `created_at`) VALUES
(45, 12, 2, 11, 4, 'true', 0, '2026-04-21 10:55:43', 4, '2026-04-21 17:55:43'),
(46, 12, 2, 15, 4, 'false', 1, '2026-04-21 10:55:43', 4, '2026-04-21 17:55:43'),
(47, 13, 2, 11, 3, 'true', 0, '2026-04-21 10:56:22', 3, '2026-04-21 17:56:22'),
(48, 13, 2, 13, 3, 'true', 1, '2026-04-21 10:56:22', 4, '2026-04-21 17:56:22'),
(49, 14, 5, 17, 5, 'false', 1, '2026-04-27 16:47:29', 1, '2026-04-27 23:47:29'),
(50, 14, 5, 18, 5, 'false', 0, '2026-04-27 16:47:29', 1, '2026-04-27 23:47:29');

-- --------------------------------------------------------

--
-- Table structure for table `heist_submission_questions`
--

CREATE TABLE `heist_submission_questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `submission_id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist_submission_questions`
--

INSERT INTO `heist_submission_questions` (`id`, `submission_id`, `heist_id`, `question_id`, `user_id`, `position`, `created_at`) VALUES
(4, 12, 2, 11, 4, 1, '2026-04-21 17:55:32'),
(5, 12, 2, 15, 4, 2, '2026-04-21 17:55:32'),
(6, 13, 2, 11, 3, 1, '2026-04-21 17:56:12'),
(7, 13, 2, 13, 3, 2, '2026-04-21 17:56:12'),
(8, 14, 5, 17, 5, 1, '2026-04-27 23:47:23'),
(9, 14, 5, 18, 5, 2, '2026-04-27 23:47:23');

-- --------------------------------------------------------

--
-- Table structure for table `manual_payin_requests`
--

CREATE TABLE `manual_payin_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `manual_payin_requests`
--

INSERT INTO `manual_payin_requests` (`id`, `user_id`, `amount_ngn`, `coin_rate_unit`, `coin_rate_price`, `coin_amount`, `status`, `proof_reference`, `proof_url`, `user_note`, `admin_id`, `admin_note`, `rejection_reason`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(1, 4, 2500.00, 1, 100.00, 25, 'pending', 'oo', '/uploads/ChatGPTImageApr16202-1776457235579-732443248.png', 'ooi', NULL, NULL, NULL, NULL, '2026-04-17 20:20:35', '2026-04-17 20:20:35');

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
-- Table structure for table `payment_accounts`
--

CREATE TABLE `payment_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `account_name` varchar(150) NOT NULL,
  `account_number` varchar(80) NOT NULL,
  `account_type` varchar(80) NOT NULL,
  `bank_name` varchar(150) DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_accounts`
--

INSERT INTO `payment_accounts` (`id`, `account_name`, `account_number`, `account_type`, `bank_name`, `instructions`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'copup limited', '7065785436', 'bank_transfer', 'moin point', 'payment should be made here ', 1, 1, '2026-04-17 19:41:07', '2026-04-17 19:41:07');

-- --------------------------------------------------------

--
-- Table structure for table `payout_requests`
--

CREATE TABLE `payout_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
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
  `bank_code` varchar(30) DEFAULT NULL,
  `user_note` text DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `admin_note` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payout_requests`
--

INSERT INTO `payout_requests` (`id`, `user_id`, `cop_points`, `amount_ngn`, `coin_rate_unit`, `coin_rate_price`, `status`, `account_name`, `account_number`, `account_type`, `bank_name`, `bank_code`, `user_note`, `admin_id`, `admin_note`, `rejection_reason`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 90.00, 1, 100.00, 'approved', 'sam', '706585436', 'bank_transfer', 'plampay', NULL, 'confim name', 1, 'Payout completed', NULL, '2026-04-17 20:03:55', '2026-04-17 20:03:30', '2026-04-17 20:03:55'),
(2, 4, 1, 90.00, 1, 100.00, 'pending', 'sam', '1234567890', 'bank_transfer', 'opay', NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-17 20:05:22', '2026-04-17 20:05:22'),
(3, 3, 10, 900.00, 1, 100.00, 'pending', 'samule', '70657939734', 'bank_transfer', 'Opay', NULL, 'see', NULL, NULL, NULL, NULL, '2026-04-21 11:57:25', '2026-04-21 11:57:25'),
(4, 3, 2, 180.00, 1, 100.00, 'pending', 'Pastor Bright', '0690000032', 'bank_transfer', 'Access Bank', '044', 'fee', NULL, NULL, NULL, NULL, '2026-04-21 12:54:46', '2026-04-21 12:54:46');

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

--
-- Dumping data for table `referrals`
--

INSERT INTO `referrals` (`id`, `referrer_id`, `referred_id`, `created_at`) VALUES
(1, 2, 3, '2026-04-17 10:35:32'),
(2, 3, 4, '2026-04-17 18:42:25'),
(3, 3, 5, '2026-04-27 23:06:48');

-- --------------------------------------------------------

--
-- Table structure for table `referral_reward_progress`
--

CREATE TABLE `referral_reward_progress` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reset_version` int(11) NOT NULL,
  `referrer_id` int(11) NOT NULL,
  `referred_user_id` int(11) NOT NULL,
  `joined_heists` int(11) NOT NULL DEFAULT 0,
  `rewarded_at` datetime DEFAULT NULL,
  `awarded_cop_points` int(11) NOT NULL DEFAULT 0,
  `last_joined_heist_id` int(11) DEFAULT NULL,
  `last_joined_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `referral_reward_progress`
--

INSERT INTO `referral_reward_progress` (`id`, `reset_version`, `referrer_id`, `referred_user_id`, `joined_heists`, `rewarded_at`, `awarded_cop_points`, `last_joined_heist_id`, `last_joined_at`, `created_at`, `updated_at`) VALUES
(3, 1, 3, 5, 1, '2026-04-27 16:47:51', 1, 5, '2026-04-27 16:47:10', '2026-04-27 23:47:10', '2026-04-27 23:47:51');

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
  `trade_pin_hash` varchar(255) DEFAULT NULL,
  `trade_pin_changed` tinyint(1) NOT NULL DEFAULT 0,
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

INSERT INTO `users` (`id`, `email`, `username`, `full_name`, `password_hash`, `trade_pin_hash`, `trade_pin_changed`, `role`, `is_verified`, `is_blocked`, `referral_code`, `wallet_address`, `game_id`, `cop_point`, `created_at`, `updated_at`) VALUES
(1, 'admin@admin.com', 'admin', 'Heist Admin', '$2b$12$lplYyGYca0nFRf7i8LELPOsEYI41bKEYndz3csoOc4aDyL0FJMCve', NULL, 0, 'admin', 1, 0, 'ADMIN01', 'copADMINWALLET000001', 'ADMIN-GAME-001', 0, '2026-04-17 07:42:52', '2026-04-21 11:03:28'),
(2, 'jossycode0@gmail.com', 'jossy01', 'Jossy Code', '$2b$12$GnGoXL0fuZDdwd1d0p7bnOiXsJ5BHhTUVi3jbVH54K8fgHfedC2pe', NULL, 0, 'user', 1, 0, 'billions', 'coptg67Gv5Ep3Uk29IgEMwH', 'ZSDW-C5PZ-RN8K', 900, '2026-04-17 09:00:03', '2026-04-17 13:44:21'),
(3, '8amlight@gmail.com', 'light', 'Samuel Oghenchovwe', '$2b$12$6YpXM2xJkyu27NPcobfEf./UUDW1GAqw0DiBMh1/GlGONCL3.BJ5S', '$2b$12$4DPjwsX3yThq3Xl0znpMK.lU6rJG9N9ey52cnBMlDqY.R3LppMlX.', 1, 'user', 1, 0, 'light', 'copiOKpOlWoG1ofmEz0FBGR', 'VHA5-EGR2-H276', 680, '2026-04-17 10:35:32', '2026-04-27 23:47:51'),
(4, '8amjoker@gmail.com', 'joker', '8amjoker', '$2b$12$/McCefomtmThjCWl5NvsMONTsHUsVa69SuL.MO0tJPMe5Cu.soVR6', NULL, 0, 'user', 1, 0, 'joker', 'coplwnYe2DDW5NynK6NxJB3', 'P6ZX-Q765-8BZ8', 148, '2026-04-17 18:42:25', '2026-04-21 20:57:01'),
(5, '8amfish@gmail.com', 'fish', 'Providence Oghenetega', '$2b$12$AL928wLwhiNNfVWOVxF31eoQ93CEnR3jXO.Hu9fSpyBv2Rb7yTRD2', NULL, 0, 'user', 1, 0, 'MYBE7NPJ', 'coprMgbFHxK9PVWXSl08mlW', 'VK3J-87TA-TNWN', 98, '2026-04-27 23:06:48', '2026-04-27 23:47:10');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_analytics_user_exclusions`
--
ALTER TABLE `admin_analytics_user_exclusions`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `idx_admin_analytics_exclusions_created_by` (`created_by`);

--
-- Indexes for table `admin_referral_settings`
--
ALTER TABLE `admin_referral_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_admin_referral_settings_updated_by` (`updated_by`),
  ADD KEY `idx_admin_referral_settings_reset_by` (`last_reset_by`);

--
-- Indexes for table `affiliate_tasks`
--
ALTER TABLE `affiliate_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_affiliate_tasks_heist` (`heist_id`),
  ADD KEY `idx_affiliate_tasks_active` (`heist_id`,`is_active`);

--
-- Indexes for table `affiliate_task_progress`
--
ALTER TABLE `affiliate_task_progress`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_affiliate_task_user` (`task_id`,`user_id`),
  ADD KEY `idx_affiliate_task_progress_user` (`user_id`),
  ADD KEY `idx_affiliate_task_progress_completed` (`task_id`,`is_completed`);

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
-- Indexes for table `coin_rate`
--
ALTER TABLE `coin_rate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cop_point_transfers`
--
ALTER TABLE `cop_point_transfers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_transfers_sender` (`sender_user_id`,`created_at`),
  ADD KEY `idx_transfers_recipient` (`recipient_user_id`,`created_at`),
  ADD KEY `idx_transfers_wallet` (`recipient_wallet_address`);

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
  ADD KEY `idx_heist_questions_heist_sort` (`heist_id`,`sort_order`),
  ADD KEY `idx_heist_questions_bank` (`heist_id`,`is_active`),
  ADD KEY `idx_heist_questions_assigned_by` (`assigned_by`);

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
-- Indexes for table `heist_submission_questions`
--
ALTER TABLE `heist_submission_questions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_hsq_submission_question` (`submission_id`,`question_id`),
  ADD UNIQUE KEY `uniq_hsq_submission_position` (`submission_id`,`position`),
  ADD KEY `idx_hsq_submission` (`submission_id`,`position`),
  ADD KEY `idx_hsq_heist_user` (`heist_id`,`user_id`),
  ADD KEY `fk_hsq_question` (`question_id`),
  ADD KEY `fk_hsq_user` (`user_id`);

--
-- Indexes for table `manual_payin_requests`
--
ALTER TABLE `manual_payin_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_manual_payin_user` (`user_id`),
  ADD KEY `idx_manual_payin_status` (`status`,`created_at`),
  ADD KEY `idx_manual_payin_admin` (`admin_id`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_otps_email` (`email`),
  ADD KEY `idx_otps_email_otp` (`email`,`otp`);

--
-- Indexes for table `payment_accounts`
--
ALTER TABLE `payment_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_payment_accounts_active` (`is_active`),
  ADD KEY `idx_payment_accounts_created_by` (`created_by`);

--
-- Indexes for table `payout_requests`
--
ALTER TABLE `payout_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_payout_user` (`user_id`),
  ADD KEY `idx_payout_status` (`status`,`created_at`),
  ADD KEY `idx_payout_admin` (`admin_id`);

--
-- Indexes for table `referrals`
--
ALTER TABLE `referrals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_referrals_referred` (`referred_id`),
  ADD KEY `idx_referrals_referrer` (`referrer_id`);

--
-- Indexes for table `referral_reward_progress`
--
ALTER TABLE `referral_reward_progress`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_referral_reward_cycle_user` (`reset_version`,`referred_user_id`),
  ADD KEY `idx_referral_reward_referrer` (`referrer_id`,`reset_version`),
  ADD KEY `idx_referral_reward_rewarded` (`reset_version`,`rewarded_at`),
  ADD KEY `idx_referral_reward_last_heist` (`last_joined_heist_id`),
  ADD KEY `fk_referral_reward_referred` (`referred_user_id`);

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
-- AUTO_INCREMENT for table `affiliate_tasks`
--
ALTER TABLE `affiliate_tasks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `affiliate_task_progress`
--
ALTER TABLE `affiliate_task_progress`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `affiliate_user_links`
--
ALTER TABLE `affiliate_user_links`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `affiliate_user_referrals`
--
ALTER TABLE `affiliate_user_referrals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `coin_rate`
--
ALTER TABLE `coin_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cop_point_transfers`
--
ALTER TABLE `cop_point_transfers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `heist`
--
ALTER TABLE `heist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `heist_participants`
--
ALTER TABLE `heist_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `heist_questions`
--
ALTER TABLE `heist_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `heist_submissions`
--
ALTER TABLE `heist_submissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `heist_submission_answers`
--
ALTER TABLE `heist_submission_answers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `heist_submission_questions`
--
ALTER TABLE `heist_submission_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `manual_payin_requests`
--
ALTER TABLE `manual_payin_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `payment_accounts`
--
ALTER TABLE `payment_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payout_requests`
--
ALTER TABLE `payout_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `referrals`
--
ALTER TABLE `referrals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `referral_reward_progress`
--
ALTER TABLE `referral_reward_progress`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_analytics_user_exclusions`
--
ALTER TABLE `admin_analytics_user_exclusions`
  ADD CONSTRAINT `fk_admin_analytics_exclusions_admin` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_admin_analytics_exclusions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `admin_referral_settings`
--
ALTER TABLE `admin_referral_settings`
  ADD CONSTRAINT `fk_admin_referral_settings_last_reset_by` FOREIGN KEY (`last_reset_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_admin_referral_settings_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `affiliate_tasks`
--
ALTER TABLE `affiliate_tasks`
  ADD CONSTRAINT `fk_affiliate_tasks_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `affiliate_task_progress`
--
ALTER TABLE `affiliate_task_progress`
  ADD CONSTRAINT `fk_affiliate_task_progress_task` FOREIGN KEY (`task_id`) REFERENCES `affiliate_tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_affiliate_task_progress_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `cop_point_transfers`
--
ALTER TABLE `cop_point_transfers`
  ADD CONSTRAINT `fk_transfers_recipient` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transfers_sender` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_heist_questions_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
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
-- Constraints for table `heist_submission_questions`
--
ALTER TABLE `heist_submission_questions`
  ADD CONSTRAINT `fk_hsq_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hsq_question` FOREIGN KEY (`question_id`) REFERENCES `heist_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hsq_submission` FOREIGN KEY (`submission_id`) REFERENCES `heist_submissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hsq_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `manual_payin_requests`
--
ALTER TABLE `manual_payin_requests`
  ADD CONSTRAINT `fk_manual_payin_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_manual_payin_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment_accounts`
--
ALTER TABLE `payment_accounts`
  ADD CONSTRAINT `fk_payment_accounts_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `payout_requests`
--
ALTER TABLE `payout_requests`
  ADD CONSTRAINT `fk_payout_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payout_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `referrals`
--
ALTER TABLE `referrals`
  ADD CONSTRAINT `fk_referrals_referred` FOREIGN KEY (`referred_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_referrals_referrer` FOREIGN KEY (`referrer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `referral_reward_progress`
--
ALTER TABLE `referral_reward_progress`
  ADD CONSTRAINT `fk_referral_reward_last_heist` FOREIGN KEY (`last_joined_heist_id`) REFERENCES `heist` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_referral_reward_referred` FOREIGN KEY (`referred_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_referral_reward_referrer` FOREIGN KEY (`referrer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
