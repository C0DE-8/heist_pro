-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 12, 2026 at 07:50 PM
-- Server version: 11.4.13-MariaDB-cll-lve-log
-- PHP Version: 8.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `copuscdi_copupbid_top`
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
(2, 1, '2026-04-21 20:38:56'),
(3, 1, '2026-04-21 20:38:59'),
(4, 1, '2026-08-21 00:23:50');

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
(1, 1, 3, 1, 2, 1, 1, '2026-05-12 11:18:37', '2026-04-27 23:52:19', '2026-05-12 15:18:43');

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
(3, 5, 1, 1, 1);

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

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_tiles`
--

CREATE TABLE `affiliate_tiles` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `affiliate_tiles`
--

INSERT INTO `affiliate_tiles` (`id`, `tile_level`, `name`, `target_tickets`, `reward_cop_points`, `required_affiliates`, `plan_price_cop_points`, `is_active`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'Street Scout', 150, 65, 10, 25, 1, NULL, NULL, '2026-05-14 10:06:03', '2026-05-14 10:06:03'),
(2, 2, 'Raider', 500, 200, 25, 100, 1, 1, 1, '2026-05-14 12:14:09', '2026-05-14 12:14:09'),
(3, 3, 'Commander', 1500, 600, 50, 300, 1, 1, 1, '2026-05-14 12:15:44', '2026-05-14 12:15:44'),
(4, 4, 'Syndicate Elite', 5000, 1200, 100, 750, 1, 1, 1, '2026-05-14 12:16:49', '2026-05-14 12:17:13'),
(5, 5, 'Heist King', 10000, 2000, 250, 1900, 1, 1, 1, '2026-05-14 12:18:48', '2026-05-14 12:20:30');

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_tile_memberships`
--

CREATE TABLE `affiliate_tile_memberships` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `tile_id` int(11) NOT NULL,
  `paid_cop_points` int(11) NOT NULL DEFAULT 0,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','cancelled') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_tile_payouts`
--

CREATE TABLE `affiliate_tile_payouts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `tile_id` int(11) NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `earned_cop_points` int(11) NOT NULL DEFAULT 0,
  `status` enum('paid') NOT NULL DEFAULT 'paid',
  `paid_by` int(11) DEFAULT NULL,
  `paid_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `affiliate_tile_payouts`
--

INSERT INTO `affiliate_tile_payouts` (`id`, `user_id`, `tile_id`, `period_start`, `period_end`, `earned_cop_points`, `status`, `paid_by`, `paid_at`) VALUES
(1, 3, 1, '2026-04-01', '2026-05-01', 1, 'paid', NULL, '2026-05-22 13:11:58'),
(2, 3, 2, '2026-08-01', '2026-09-01', 4, 'paid', NULL, '2026-09-01 10:43:21');

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
(4, 15, 4, 'HUNX5AIEF', 'https://copupbid.top/heists/4/ref/HUNX5AIEF', 1, 0, 0, '2026-04-25 16:01:41', '2026-04-25 16:01:59'),
(5, 3, 4, 'HLGRIPC1X', 'https://copupbid.top/heists/4/ref/HLGRIPC1X', 0, 0, 0, '2026-04-25 18:13:25', '2026-04-25 18:13:25'),
(6, 2, 5, 'H40Y625J2', 'https://copupbid.top/heists/5/ref/H40Y625J2', 0, 0, 0, '2026-04-25 20:21:36', '2026-04-25 20:21:36'),
(7, 19, 5, 'HT2K09NFU', 'https://copupbid.top/heists/5/ref/HT2K09NFU', 0, 0, 0, '2026-04-26 14:06:43', '2026-04-26 14:06:43'),
(8, 19, 6, 'HDQSX3BFQ', 'https://copupbid.top/heists/6/ref/HDQSX3BFQ', 15, 0, 0, '2026-04-26 14:56:24', '2026-04-27 20:31:34'),
(9, 17, 6, 'HGLRYJTIC', 'https://copupbid.top/heists/6/ref/HGLRYJTIC', 0, 0, 0, '2026-04-27 20:10:37', '2026-04-27 20:10:37'),
(10, 17, 7, 'HEWH401T5', 'https://copupbid.top/heists/7/ref/HEWH401T5', 0, 0, 0, '2026-04-28 07:36:58', '2026-04-28 07:36:58'),
(11, 35, 9, 'HQF5P224E', 'https://copupbid.top/heists/9/ref/HQF5P224E', 1, 0, 0, '2026-05-04 12:34:20', '2026-05-04 12:34:30'),
(12, 3, 9, 'HJMSQXTCF', 'https://copupbid.top/heists/9/ref/HJMSQXTCF', 0, 0, 0, '2026-05-04 12:36:13', '2026-05-04 12:36:13'),
(13, 2, 24, 'HRH9ORY90', 'https://copupbid.top/heists/24/ref/HRH9ORY90', 4, 0, 0, '2026-05-15 15:04:49', '2026-05-15 22:27:30'),
(14, 55, 25, 'HKHTCJEEB', 'https://copupbid.top/heists/25/ref/HKHTCJEEB', 0, 0, 0, '2026-05-22 22:10:13', '2026-05-22 22:10:13'),
(15, 55, 28, 'HYLW0MM72', 'https://copupbid.top/heists/28/ref/HYLW0MM72', 0, 0, 0, '2026-06-07 21:23:18', '2026-06-07 21:23:18');

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
-- Table structure for table `auto_heist_settings`
--

CREATE TABLE `auto_heist_settings` (
  `id` tinyint(1) NOT NULL DEFAULT 1,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `min_users` int(11) NOT NULL DEFAULT 1,
  `max_users` int(11) DEFAULT NULL,
  `ticket_price` int(11) NOT NULL DEFAULT 0,
  `prize_cop_points` int(11) NOT NULL DEFAULT 0,
  `questions_per_session` int(11) NOT NULL DEFAULT 0,
  `countdown_duration_minutes` int(11) NOT NULL DEFAULT 10,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auto_heist_settings`
--

INSERT INTO `auto_heist_settings` (`id`, `is_enabled`, `min_users`, `max_users`, `ticket_price`, `prize_cop_points`, `questions_per_session`, `countdown_duration_minutes`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 1, 6, 10, 2, 5, 3, 10, NULL, 1, '2026-05-15 11:10:04', '2026-08-31 18:31:45');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('active','checked_out','abandoned') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` bigint(20) UNSIGNED NOT NULL,
  `entitlement_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clans`
--

CREATE TABLE `clans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `slug` varchar(140) NOT NULL,
  `logo_url` varchar(500) DEFAULT NULL,
  `banner_url` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `leader_user_id` int(11) NOT NULL,
  `join_policy` enum('open','request','invite_only','closed') NOT NULL DEFAULT 'request',
  `status` enum('active','suspended','deleted') NOT NULL DEFAULT 'active',
  `creation_cost_cop_points` int(11) NOT NULL DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clans`
--

INSERT INTO `clans` (`id`, `name`, `slug`, `logo_url`, `banner_url`, `description`, `leader_user_id`, `join_policy`, `status`, `creation_cost_cop_points`, `created_by`, `updated_by`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'The farmers', 'the-farmers', '/uploads/clans/the-farmers-logo-1784253838059-603933439.png', '/uploads/clans/the-farmers-banner-1784253805239-363817130.jpeg', 'More then just farmeing the system', 4, 'request', 'active', 0, 4, 4, NULL, '2026-07-17 02:03:28', '2026-07-17 02:04:02'),
(2, 'Takers', 'takers', '/uploads/clans/takers-logo-1784284314000-94234682.png', '/uploads/clans/takers-banner-1784284370424-395126133.jpg', 'Here to win ,we take everything 🙂🤍', 2, 'open', 'active', 10, 2, 2, NULL, '2026-07-17 10:33:01', '2026-07-17 10:33:01');

-- --------------------------------------------------------

--
-- Table structure for table `clan_activity_events`
--

CREATE TABLE `clan_activity_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `actor_user_id` int(11) DEFAULT NULL,
  `target_user_id` int(11) DEFAULT NULL,
  `event_type` varchar(80) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clan_activity_events`
--

INSERT INTO `clan_activity_events` (`id`, `clan_id`, `actor_user_id`, `target_user_id`, `event_type`, `details`, `created_at`) VALUES
(1, 1, 4, NULL, 'clan_created', 'The farmers', '2026-07-17 02:03:28'),
(2, 2, 2, NULL, 'clan_created', 'Takers', '2026-07-17 10:33:01'),
(3, 2, 5, NULL, 'member_joined', NULL, '2026-07-17 10:40:03'),
(4, 2, 75, NULL, 'member_joined', NULL, '2026-08-16 12:28:13'),
(5, 2, 82, NULL, 'member_joined', NULL, '2026-09-02 02:20:52');

-- --------------------------------------------------------

--
-- Table structure for table `clan_chat_messages`
--

CREATE TABLE `clan_chat_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `original_message` text DEFAULT NULL,
  `status` enum('active','deleted') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clan_chat_messages`
--

INSERT INTO `clan_chat_messages` (`id`, `clan_id`, `user_id`, `message`, `original_message`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 2, 'Let\'s win', 'Let\'s win', 'active', '2026-07-17 10:38:48', '2026-07-17 10:38:48'),
(2, 2, 5, 'Takers clan let\'s go 😏', 'Takers clan let\'s go 😏', 'active', '2026-07-17 10:42:24', '2026-07-17 10:42:24');

-- --------------------------------------------------------

--
-- Table structure for table `clan_coin_ledger`
--

CREATE TABLE `clan_coin_ledger` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `direction` enum('credit','debit') NOT NULL,
  `amount_cop_points` int(11) NOT NULL,
  `user_balance_before` int(11) DEFAULT NULL,
  `user_balance_after` int(11) DEFAULT NULL,
  `reason` varchar(80) NOT NULL,
  `reference_type` varchar(80) DEFAULT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clan_coin_ledger`
--

INSERT INTO `clan_coin_ledger` (`id`, `clan_id`, `user_id`, `direction`, `amount_cop_points`, `user_balance_before`, `user_balance_after`, `reason`, `reference_type`, `reference_id`, `metadata`, `created_by`, `created_at`) VALUES
(1, 2, 2, 'debit', 10, 864, 854, 'clan_creation', 'clan', 2, NULL, 2, '2026-07-17 10:33:01');

-- --------------------------------------------------------

--
-- Table structure for table `clan_invites`
--

CREATE TABLE `clan_invites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `invited_user_id` int(11) NOT NULL,
  `invited_by` int(11) DEFAULT NULL,
  `status` enum('pending','accepted','declined','cancelled','expired') NOT NULL DEFAULT 'pending',
  `expires_at` datetime DEFAULT NULL,
  `responded_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_join_requests`
--

CREATE TABLE `clan_join_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` varchar(500) DEFAULT NULL,
  `status` enum('pending','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `reviewed_by` int(11) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clan_join_requests`
--

INSERT INTO `clan_join_requests` (`id`, `clan_id`, `user_id`, `message`, `status`, `reviewed_by`, `reviewed_at`, `created_at`, `updated_at`) VALUES
(1, 1, 12, NULL, 'pending', NULL, NULL, '2026-07-17 10:50:35', '2026-07-17 10:50:35'),
(2, 1, 3, NULL, 'pending', NULL, NULL, '2026-08-12 01:29:33', '2026-08-12 01:29:33');

-- --------------------------------------------------------

--
-- Table structure for table `clan_members`
--

CREATE TABLE `clan_members` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('leader','co_leader','elder','member') NOT NULL DEFAULT 'member',
  `status` enum('active','left','removed','banned') NOT NULL DEFAULT 'active',
  `invited_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `left_at` datetime DEFAULT NULL,
  `role_updated_by` int(11) DEFAULT NULL,
  `role_updated_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clan_members`
--

INSERT INTO `clan_members` (`id`, `clan_id`, `user_id`, `role`, `status`, `invited_by`, `approved_by`, `joined_at`, `left_at`, `role_updated_by`, `role_updated_at`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 'leader', 'active', NULL, 4, '2026-07-17 02:03:28', NULL, 4, '2026-07-16 22:03:28', '2026-07-17 02:03:28', '2026-07-17 02:03:28'),
(2, 2, 2, 'leader', 'active', NULL, 2, '2026-07-17 10:33:01', NULL, 2, '2026-07-17 06:33:01', '2026-07-17 10:33:01', '2026-07-17 10:33:01'),
(3, 2, 5, 'member', 'active', NULL, 5, '2026-07-17 10:40:03', NULL, NULL, NULL, '2026-07-17 10:40:03', '2026-07-17 10:40:03'),
(4, 2, 75, 'member', 'active', NULL, 75, '2026-08-16 12:28:13', NULL, NULL, NULL, '2026-08-16 12:28:13', '2026-08-16 12:28:13'),
(5, 2, 82, 'member', 'active', NULL, 82, '2026-09-02 02:20:52', NULL, NULL, NULL, '2026-09-02 02:20:52', '2026-09-02 02:20:52');

-- --------------------------------------------------------

--
-- Table structure for table `clan_quests`
--

CREATE TABLE `clan_quests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(160) NOT NULL,
  `description` text DEFAULT NULL,
  `quest_type` enum('heist_wins','custom') NOT NULL DEFAULT 'heist_wins',
  `status` enum('draft','scheduled','active','completed','cancelled') NOT NULL DEFAULT 'draft',
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `prize_type` enum('cop_points','other') NOT NULL DEFAULT 'cop_points',
  `prize_amount` int(11) NOT NULL DEFAULT 0,
  `reward_metadata` text DEFAULT NULL,
  `participation_policy` enum('opt_in','auto') NOT NULL DEFAULT 'opt_in',
  `min_members` int(11) NOT NULL DEFAULT 1,
  `max_participating_clans` int(11) DEFAULT NULL,
  `scoring_rule` varchar(80) NOT NULL DEFAULT 'successful_heist_wins',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `completed_by` int(11) DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_quest_heist_wins`
--

CREATE TABLE `clan_quest_heist_wins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quest_id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `winner_user_id` int(11) NOT NULL,
  `won_at` datetime NOT NULL,
  `points` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_quest_participants`
--

CREATE TABLE `clan_quest_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quest_id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('participating','withdrawn','disqualified') NOT NULL DEFAULT 'participating',
  `joined_by` int(11) DEFAULT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `withdrawn_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_quest_rewards`
--

CREATE TABLE `clan_quest_rewards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quest_id` bigint(20) UNSIGNED NOT NULL,
  `winning_clan_id` bigint(20) UNSIGNED NOT NULL,
  `prize_type` enum('cop_points','other') NOT NULL DEFAULT 'cop_points',
  `prize_amount` int(11) NOT NULL DEFAULT 0,
  `member_count` int(11) NOT NULL DEFAULT 0,
  `amount_per_member` int(11) NOT NULL DEFAULT 0,
  `remainder_amount` int(11) NOT NULL DEFAULT 0,
  `status` enum('pending','distributed','cancelled') NOT NULL DEFAULT 'pending',
  `distributed_by` int(11) DEFAULT NULL,
  `distributed_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_quest_reward_distributions`
--

CREATE TABLE `clan_quest_reward_distributions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reward_id` bigint(20) UNSIGNED NOT NULL,
  `quest_id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount_cop_points` int(11) NOT NULL DEFAULT 0,
  `user_balance_before` int(11) DEFAULT NULL,
  `user_balance_after` int(11) DEFAULT NULL,
  `status` enum('pending','paid','failed','cancelled') NOT NULL DEFAULT 'pending',
  `paid_at` datetime DEFAULT NULL,
  `failure_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_quest_scores`
--

CREATE TABLE `clan_quest_scores` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quest_id` bigint(20) UNSIGNED NOT NULL,
  `clan_id` bigint(20) UNSIGNED NOT NULL,
  `score` int(11) NOT NULL DEFAULT 0,
  `rank_position` int(11) DEFAULT NULL,
  `is_winner` tinyint(1) NOT NULL DEFAULT 0,
  `calculated_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clan_settings`
--

CREATE TABLE `clan_settings` (
  `id` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `creation_cost_cop_points` int(11) NOT NULL DEFAULT 0,
  `max_members` int(11) DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clan_settings`
--

INSERT INTO `clan_settings` (`id`, `creation_cost_cop_points`, `max_members`, `is_enabled`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 10, 10, 1, 1, '2026-07-17 01:26:47', '2026-07-17 02:06:35');

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
(1, 3, 12, 'copVIfTehNGMpRxsaRkmqyp', 2, 460, 458, 0, 2, 'Join the heist and play', '2026-04-21 15:10:40'),
(2, 3, 8, 'copT0A7kEoiE5KXJfKTZdUc', 2, 476, 474, 0, 2, '498 left', '2026-04-25 18:01:12'),
(3, 3, 8, 'copT0A7kEoiE5KXJfKTZdUc', 2, 474, 472, 0, 2, 'Remaing 496', '2026-04-26 12:11:42'),
(4, 3, 19, 'copCu7OLX9xIeqfUM44yxUy', 2, 472, 470, 0, 2, 'Fee', '2026-04-26 14:00:42'),
(5, 3, 17, 'copw1U8JYJfuNOOsb6ROsxL', 2, 470, 468, 0, 2, 'Referral bonus', '2026-04-27 20:03:10'),
(6, 3, 28, 'copLAonJqGZJvy9a7SNRqO7', 2, 466, 464, 0, 2, 'Fee', '2026-05-04 10:13:09'),
(7, 3, 30, 'copINrZET7XDt8E1de3BzaV', 2, 464, 462, 0, 2, NULL, '2026-05-04 10:17:06'),
(8, 3, 29, 'copcJHVZPjv9kXUwaxBLVGs', 2, 462, 460, 0, 2, NULL, '2026-05-04 10:20:09'),
(9, 3, 36, 'cop1iCAsjBVtrXDqwFnrhe0', 2, 460, 458, 0, 2, 'Fee', '2026-05-04 13:04:40'),
(10, 3, 37, 'cop4VfjO1JY5KScLo61Hf9o', 2, 458, 456, 0, 2, 'Fee', '2026-05-04 13:08:43'),
(11, 3, 38, 'copbn1hKK5fBduJ5GUVhrrm', 2, 456, 454, 0, 2, 'Fee', '2026-05-04 13:09:22'),
(12, 3, 40, 'copkDKyhyRYawkR1nHgaLHD', 2, 454, 452, 0, 2, NULL, '2026-05-06 17:12:21'),
(13, 3, 15, 'copLflkBY7W8AH9wg465i6q', 2, 453, 451, 0, 2, 'Fee', '2026-05-10 16:44:06'),
(14, 15, 3, 'copiOKpOlWoG1ofmEz0FBGR', 2, 5, 3, 451, 453, 'Fre', '2026-05-10 16:48:06'),
(15, 3, 45, 'copCIbBG67vJEQ5VFM3B9nK', 12, 451, 439, 0, 12, 'Savev', '2026-05-10 22:33:24'),
(16, 4, 3, 'copiOKpOlWoG1ofmEz0FBGR', 2, 5176, 5174, 439, 441, 'Fee', '2026-05-11 02:33:47'),
(17, 4, 3, 'copiOKpOlWoG1ofmEz0FBGR', 1, 5174, 5173, 441, 442, 'Fee', '2026-05-11 03:48:34'),
(18, 3, 12, 'copVIfTehNGMpRxsaRkmqyp', 7, 442, 435, 3, 10, 'Fee', '2026-05-11 19:32:55'),
(19, 3, 39, 'copVOYburS4AlDRwUfSpsUe', 2, 435, 433, 0, 2, 'Fee', '2026-05-12 11:59:32'),
(20, 3, 48, 'copm6t58lZSK0hsAM14PHp3', 1, 433, 432, 0, 1, 'Coin', '2026-05-12 13:55:00'),
(21, 3, 49, 'cop7jLAqufEooSbC8Qp3aaU', 1, 432, 431, 0, 1, 'Fee', '2026-05-12 13:56:28'),
(22, 3, 50, 'copHgs1hPDyk74wqfQZBwXO', 1, 431, 430, 0, 1, 'Fee', '2026-05-12 14:24:58'),
(23, 3, 51, 'copzgEQZXI9FV5O0MBnMfox', 1, 430, 429, 0, 1, 'Fee', '2026-05-12 14:26:22'),
(24, 4, 56, 'copUvx6E1M3pNSl2WSrYoal', 3, 5173, 5170, 0, 3, 'Diamond', '2026-05-23 08:29:49'),
(25, 2, 68, 'copMTnFXTChxYA2hFXldg9M', 10, 874, 864, 0, 10, 'User buffer coin ✌️', '2026-06-22 19:23:22'),
(26, 3, 72, 'coptnOenvGQPp7temQJ8lRG', 4, 434, 430, 0, 4, 'Fee', '2026-08-14 19:05:00'),
(27, 3, 77, 'copT5Q4sll4yAeR3bTBqTO5', 2, 398, 396, 0, 2, 'Habibi', '2026-08-31 09:47:19'),
(28, 3, 79, 'cop2vElzJofxEwWjDkRpdra', 2, 386, 384, 0, 2, 'From mercy', '2026-08-31 13:02:52'),
(29, 80, 82, 'copGB2WePz5sIhQ5ysOmMz6', 2, 3, 1, 0, 2, NULL, '2026-09-02 02:15:38');

-- --------------------------------------------------------

--
-- Table structure for table `heist`
--

CREATE TABLE `heist` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `min_users` int(11) NOT NULL DEFAULT 1,
  `max_users` int(11) DEFAULT NULL,
  `ticket_price` int(11) NOT NULL DEFAULT 0,
  `total_questions` int(11) NOT NULL DEFAULT 0,
  `questions_per_session` int(11) NOT NULL DEFAULT 0,
  `prize_cop_points` int(11) NOT NULL DEFAULT 0,
  `reward_type` enum('cash','product') NOT NULL DEFAULT 'cash',
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('pending','hold','started','completed','cancelled') NOT NULL DEFAULT 'pending',
  `submissions_locked` tinyint(1) NOT NULL DEFAULT 0,
  `winner_user_id` int(11) DEFAULT NULL,
  `winner_demo_submission_id` bigint(20) UNSIGNED DEFAULT NULL,
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

INSERT INTO `heist` (`id`, `name`, `description`, `min_users`, `max_users`, `ticket_price`, `total_questions`, `questions_per_session`, `prize_cop_points`, `reward_type`, `product_id`, `status`, `submissions_locked`, `winner_user_id`, `winner_demo_submission_id`, `countdown_started_at`, `countdown_duration_minutes`, `countdown_ends_at`, `starts_at`, `ends_at`, `created_by`, `created_at`, `updated_at`) VALUES
(3, 'The Sunday Shift ', 'have a bless week', 4, NULL, 2, 0, 0, 5, 'cash', NULL, 'completed', 1, 12, NULL, '2026-04-21 16:05:14', 2, '2026-04-21 16:07:14', NULL, NULL, 1, '2026-04-19 10:09:14', '2026-04-22 10:29:05'),
(4, 'Shadow Protocol', 'The system is live. Adapt quickly, outmaneuver your rivals, and secure the reward before the window closes.', 3, NULL, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-04-25 14:05:14', 20, '2026-04-25 14:25:14', NULL, NULL, 1, '2026-04-22 13:41:16', '2026-04-25 18:25:16'),
(5, 'The scholar\'s heist ', 'Smart move for the brains 😉', 3, NULL, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-04-26 10:01:14', 10, '2026-04-26 10:11:14', NULL, NULL, 1, '2026-04-25 19:04:07', '2026-04-26 14:11:31'),
(6, 'Sunday vibes', 'GOD DID IT AGAIN', 3, NULL, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 17, NULL, '2026-04-27 16:31:58', 10, '2026-04-27 16:41:58', NULL, NULL, 1, '2026-04-26 14:26:58', '2026-04-27 20:42:16'),
(7, '404 not found ', 'Simple error codes to make little coin', 3, NULL, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-04-29 09:57:09', 10, '2026-04-29 10:07:09', NULL, NULL, 1, '2026-04-27 21:12:58', '2026-04-29 14:07:30'),
(8, 'One piece 🧩 ', 'From where I am I set close to the sea only to see and question from the piece ', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-05-01 04:41:38', 10, '2026-05-01 04:51:38', NULL, NULL, 1, '2026-04-29 21:17:04', '2026-05-01 08:51:58'),
(9, 'May 💯', 'Happy new month ', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-05-05 16:36:09', 10, '2026-05-05 16:46:09', NULL, NULL, 1, '2026-05-01 09:33:42', '2026-05-05 20:46:29'),
(10, 'Ben heist', 'Test your speed ', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 28, NULL, '2026-05-04 06:21:36', 10, '2026-05-04 06:31:36', NULL, NULL, 1, '2026-05-04 10:14:21', '2026-05-04 10:24:26'),
(11, '💯 level ', 'Let level up ', 3, NULL, 2, 5, 5, 10, 'cash', NULL, 'completed', 1, 38, NULL, '2026-05-04 09:09:30', 10, '2026-05-04 09:19:30', NULL, NULL, 1, '2026-05-04 13:05:51', '2026-05-04 13:11:29'),
(12, 'Test', 'Random but easy 🙂‍↕️', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 31, NULL, '2026-05-06 12:54:01', 10, '2026-05-06 13:04:01', NULL, NULL, 1, '2026-05-05 20:41:48', '2026-05-06 17:04:29'),
(13, 'ACE', 'Let speed 🚄 win', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 42, NULL, '2026-05-06 13:08:19', 10, '2026-05-06 13:18:19', NULL, NULL, 1, '2026-05-06 17:01:52', '2026-05-06 17:14:13'),
(14, 'Let farm ', 'More money 💰', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-05-06 14:32:02', 10, '2026-05-06 14:42:02', NULL, NULL, 1, '2026-05-06 17:18:32', '2026-05-06 18:42:06'),
(15, 'Let farm again ', 'Money needs to be made 💰', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 32, NULL, '2026-05-08 03:46:55', 10, '2026-05-08 03:56:55', NULL, NULL, 1, '2026-05-06 19:19:52', '2026-05-08 07:49:12'),
(16, 'God did it again', 'Its can only be God ❣️🙏', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 15, NULL, '2026-05-10 12:45:39', 10, '2026-05-10 12:55:39', NULL, NULL, 1, '2026-05-08 07:50:14', '2026-05-10 16:46:35'),
(17, 'A blessed week 🙏', 'Happy new week.', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 40, NULL, '2026-05-10 13:13:32', 10, '2026-05-10 13:23:32', NULL, NULL, 1, '2026-05-10 16:52:19', '2026-05-10 17:15:00'),
(18, 'Good evening 🌃', '“Let the evening bring me word of your unfailing love, for I have put my trust in you.”  Psalm 143:8 ✨', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 8, NULL, '2026-05-12 08:04:26', 10, '2026-05-12 08:14:26', NULL, NULL, 1, '2026-05-10 17:17:00', '2026-05-12 12:14:54'),
(19, 'Delulu', 'Let go crazy', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 49, NULL, '2026-05-12 10:50:38', 10, '2026-05-12 11:00:38', NULL, NULL, 1, '2026-05-12 13:26:08', '2026-05-12 15:00:59'),
(20, 'Let farm 2.0', '001', 2, NULL, 1, 5, 5, 3, 'cash', NULL, 'completed', 1, 49, NULL, '2026-05-12 10:00:19', 10, '2026-05-12 10:10:19', NULL, NULL, 1, '2026-05-12 13:58:01', '2026-05-12 14:02:14'),
(21, 'Let farm 3.0', 'Let make funds ', 2, NULL, 1, 3, 3, 3, 'cash', NULL, 'completed', 1, 51, NULL, '2026-05-12 10:27:06', 10, '2026-05-12 10:37:06', NULL, NULL, 1, '2026-05-12 14:23:54', '2026-05-12 14:28:21'),
(22, 'Some where in the world', '💯', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 52, NULL, '2026-05-12 11:40:46', 10, '2026-05-12 11:50:46', NULL, NULL, 1, '2026-05-12 15:02:59', '2026-05-12 15:42:39'),
(23, 'Neon Covenant Breach', 'The Lord is my light and my salvation; whom shall I fear? — Psalm 27:1', 3, NULL, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 50, NULL, '2026-05-15 00:46:46', 10, '2026-05-15 00:56:46', NULL, NULL, 1, '2026-05-12 15:42:27', '2026-05-15 04:57:02'),
(24, 'Crown Chase Heist', 'Winners are built in the seconds where others hesitate. Stay ready, stay steady, and go claim the crown.', 3, NULL, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 50, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-05-15 11:23:30', '2026-05-19 09:55:07'),
(25, 'The Lord is my shepherd', 'The grace 🌹 of God', 6, NULL, 3, 3, 3, 15, 'cash', NULL, 'completed', 1, 56, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-05-19 12:51:17', '2026-05-23 09:06:07'),
(26, 'Flash Truth Challenge', 'The clock is fast, but a calm mind is faster. Pick true or false and prove your instinct under pressure.', 6, NULL, 3, 3, 3, 15, 'cash', NULL, 'completed', 1, NULL, 8, NULL, 10, NULL, NULL, NULL, 1, '2026-05-23 09:50:20', '2026-06-01 11:13:51'),
(27, 'Happy new month ', 'It\'s a bless month 💫 with a new beginning 😄', 6, NULL, 3, 3, 3, 15, 'cash', NULL, 'completed', 1, NULL, 13, NULL, 10, NULL, NULL, NULL, 1, '2026-06-01 11:15:12', '2026-06-06 10:38:43'),
(28, 'Maga weekend rush', 'Let get a fat load of coins 🫴', 60, NULL, 5, 3, 3, 200, 'cash', NULL, 'completed', 0, NULL, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-06-06 12:20:29', '2026-06-17 09:01:00'),
(29, 'Victory Code Run', 'The code is simple: courage, speed, and a clear answer. Play smart and let every move count.', 4, 6, 3, 3, 3, 10, 'cash', NULL, 'completed', 1, NULL, 21, '2026-06-22 15:17:09', 10, '2026-06-22 15:27:09', NULL, NULL, 1, '2026-06-22 12:14:21', '2026-06-22 19:29:24'),
(30, 'Street Genius Sprint', 'Your mind is the key. Trust what you know, move with speed, and turn quick thinking into CopUpCoin.', 4, 11, 3, 3, 3, 10, 'cash', NULL, 'completed', 0, NULL, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-07-01 08:03:03', '2026-07-07 08:07:14'),
(31, 'Egg roll give away ', 'Free', 2, NULL, 0, 5, 5, 9, 'cash', NULL, 'completed', 1, 71, NULL, '2026-07-01 08:36:25', 10, '2026-07-01 08:46:25', NULL, NULL, 1, '2026-07-01 12:33:13', '2026-07-01 12:38:00'),
(32, 'Been a while', 'Keep pushing', 4, NULL, 0, 5, 5, 2, 'cash', NULL, 'completed', 1, 72, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-12 21:31:26', '2026-08-14 14:35:47'),
(33, 'Brainwave Battle', 'Rise above the noise and let your knowledge speak. One clear answer at a time can carry you to the top.', 3, NULL, 2, 5, 5, 6, 'cash', NULL, 'completed', 1, 3, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-14 14:36:31', '2026-08-14 18:41:38'),
(34, 'Midnight Vault Run', 'Every bold move starts with one brave answer. Step in, stay sharp, and let your focus open the vault.', 3, NULL, 2, 3, 3, 6, 'cash', NULL, 'completed', 1, 72, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-14 18:42:17', '2026-08-20 23:48:22'),
(35, 'Take action night ', 'You only fail if you don’t take again ', 3, 3, 20, 3, 3, 50, 'cash', NULL, 'completed', 1, NULL, 38, NULL, 10, NULL, NULL, NULL, 1, '2026-08-21 00:43:05', '2026-08-21 00:46:50'),
(36, 'Lucky Mind Lock', 'Luck favors the prepared mind. Bring your best focus, beat the questions, and unlock your next win.', 6, 11, 10, 3, 3, 60, 'cash', NULL, 'completed', 0, NULL, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-21 00:51:29', '2026-08-24 15:46:52'),
(37, 'Brainwave Battle', 'Rise above the noise and let your knowledge speak. One clear answer at a time can carry you to the top.', 2, NULL, 0, 5, 5, 3, 'cash', NULL, 'completed', 1, 76, NULL, '2026-08-30 21:17:46', 10, '2026-08-30 21:27:46', NULL, NULL, 1, '2026-08-31 01:16:45', '2026-08-31 01:21:08'),
(38, 'Golden Ticket Rush', 'Small choices can unlock big wins. Keep your spirit high, answer with confidence, and chase the golden moment.', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 77, NULL, '2026-08-31 05:57:40', 10, '2026-08-31 06:07:40', NULL, NULL, 1, '2026-08-31 01:37:07', '2026-08-31 10:00:29'),
(39, 'Flash Truth Challenge', 'The clock is fast, but a calm mind is faster. Pick true or false and prove your instinct under pressure.', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 77, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-31 10:01:34', '2026-08-31 10:05:31'),
(40, 'Victory Code Run', 'The code is simple: courage, speed, and a clear answer. Play smart and let every move count.', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 79, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-31 10:06:41', '2026-08-31 13:22:45'),
(41, 'A new day ', 'The last Monday of a powerful month ', 3, NULL, 2, 5, 5, 5, 'cash', NULL, 'completed', 1, 80, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-31 13:23:49', '2026-08-31 18:30:49'),
(42, 'Street Genius Sprint', 'Your mind is the key. Trust what you know, move with speed, and turn quick thinking into CopUpCoin.', 6, 10, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, 79, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-08-31 18:31:47', '2026-09-01 14:20:09'),
(43, 'Victory Code Run', 'The code is simple: courage, speed, and a clear answer. Play smart and let every move count.', 6, 10, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, NULL, 60, NULL, 10, NULL, NULL, NULL, 1, '2026-09-01 14:20:29', '2026-09-12 15:50:53'),
(44, 'Golden Ticket Rush', 'Small choices can unlock big wins. Keep your spirit high, answer with confidence, and chase the golden moment.', 6, 10, 2, 3, 3, 5, 'cash', NULL, 'pending', 0, NULL, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-09-12 15:51:00', '2026-09-12 15:51:00'),
(45, 'Golden Ticket Rush', 'Small choices can unlock big wins. Keep your spirit high, answer with confidence, and chase the golden moment.', 6, 10, 2, 3, 3, 5, 'cash', NULL, 'completed', 1, NULL, NULL, NULL, 10, NULL, NULL, NULL, 1, '2026-09-12 15:51:13', '2026-09-12 15:51:59');

-- --------------------------------------------------------

--
-- Table structure for table `heist_content_bank`
--

CREATE TABLE `heist_content_bank` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist_content_bank`
--

INSERT INTO `heist_content_bank` (`id`, `name`, `description`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Midnight Vault Run', 'Every bold move starts with one brave answer. Step in, stay sharp, and let your focus open the vault.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(2, 'Street Genius Sprint', 'Your mind is the key. Trust what you know, move with speed, and turn quick thinking into CopUpCoin.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(3, 'Golden Ticket Rush', 'Small choices can unlock big wins. Keep your spirit high, answer with confidence, and chase the golden moment.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(4, 'Brainwave Battle', 'Rise above the noise and let your knowledge speak. One clear answer at a time can carry you to the top.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(5, 'Flash Truth Challenge', 'The clock is fast, but a calm mind is faster. Pick true or false and prove your instinct under pressure.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(6, 'Crown Chase Heist', 'Winners are built in the seconds where others hesitate. Stay ready, stay steady, and go claim the crown.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(7, 'Lucky Mind Lock', 'Luck favors the prepared mind. Bring your best focus, beat the questions, and unlock your next win.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06'),
(8, 'Victory Code Run', 'The code is simple: courage, speed, and a clear answer. Play smart and let every move count.', 1, NULL, '2026-05-15 11:15:06', '2026-05-15 11:15:06');

-- --------------------------------------------------------

--
-- Table structure for table `heist_demo_submissions`
--

CREATE TABLE `heist_demo_submissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `demo_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `display_name` varchar(120) NOT NULL,
  `correct_count` int(11) NOT NULL DEFAULT 0,
  `wrong_count` int(11) NOT NULL DEFAULT 0,
  `unanswered_count` int(11) NOT NULL DEFAULT 0,
  `score_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `total_time_seconds` int(11) NOT NULL DEFAULT 0,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist_demo_submissions`
--

INSERT INTO `heist_demo_submissions` (`id`, `heist_id`, `demo_user_id`, `display_name`, `correct_count`, `wrong_count`, `unanswered_count`, `score_percent`, `total_time_seconds`, `submitted_at`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 24, 1, 'Bea001', 1, 2, 0, 33.33, 60, '2026-05-19 05:54:07', 1, '2026-05-19 09:54:07', '2026-05-19 09:54:07'),
(2, 24, 2, 'Kewe', 1, 2, 0, 33.33, 39, '2026-05-19 05:54:42', 1, '2026-05-19 09:54:42', '2026-05-19 09:54:42'),
(3, 24, 4, 'SpongeBob', 3, 0, 0, 100.00, 66, '2026-05-19 05:54:58', 1, '2026-05-19 09:54:58', '2026-05-19 09:54:58'),
(4, 25, 4, 'SpongeBob', 1, 2, 0, 33.33, 60, '2026-05-23 05:06:56', 1, '2026-05-23 09:06:56', '2026-05-23 09:06:56'),
(5, 25, 1, 'Bea001', 1, 0, 0, 33.33, 60, '2026-05-23 05:07:21', 1, '2026-05-23 09:07:21', '2026-05-23 09:07:21'),
(6, 25, 2, 'Kewe', 2, 0, 0, 66.67, 92, '2026-05-23 05:09:24', 1, '2026-05-23 09:09:24', '2026-05-23 09:09:24'),
(7, 25, 3, 'Jackie', 3, 0, 0, 100.00, 201, '2026-05-23 05:09:37', 1, '2026-05-23 09:09:37', '2026-05-23 09:09:37'),
(8, 26, 1, 'Bea001', 3, 0, 0, 100.00, 29, '2026-06-01 07:11:49', 1, '2026-06-01 11:11:49', '2026-06-01 11:11:49'),
(9, 26, 3, 'Jackie', 1, 0, 0, 33.33, 60, '2026-06-01 07:12:28', 1, '2026-06-01 11:12:28', '2026-06-01 11:12:28'),
(10, 26, 2, 'Kewe', 3, 0, 0, 100.00, 31, '2026-06-01 07:12:45', 1, '2026-06-01 11:12:45', '2026-06-01 11:12:45'),
(11, 26, 5, 'Ben001', 0, 0, 3, 0.00, 100, '2026-06-01 07:13:26', 1, '2026-06-01 11:13:26', '2026-06-01 11:13:26'),
(12, 26, 4, 'SpongeBob', 3, 0, 0, 100.00, 60, '2026-06-01 07:13:38', 1, '2026-06-01 11:13:38', '2026-06-01 11:13:38'),
(13, 27, 6, 'Favour sz', 3, 0, 0, 100.00, 6, '2026-06-06 06:33:26', 1, '2026-06-06 10:33:26', '2026-06-06 10:33:26'),
(14, 27, 5, 'Ben001', 2, 1, 0, 66.67, 8, '2026-06-06 06:33:57', 1, '2026-06-06 10:33:57', '2026-06-06 10:33:57'),
(15, 27, 7, 'Daniel spade', 1, 2, 0, 33.33, 10, '2026-06-06 06:34:57', 1, '2026-06-06 10:34:57', '2026-06-06 10:34:57'),
(16, 28, 5, 'Ben001', 2, 1, 0, 66.67, 91, '2026-06-06 08:21:25', 1, '2026-06-06 12:21:25', '2026-06-06 12:21:25'),
(17, 28, 8, 'Maro', 3, 0, 0, 100.00, 13, '2026-06-06 13:14:53', 1, '2026-06-06 17:14:53', '2026-06-06 17:14:53'),
(18, 28, 11, 'Havin', 3, 0, 0, 100.00, 3, '2026-06-17 16:43:00', 1, '2026-06-17 08:51:56', '2026-06-17 08:51:56'),
(19, 28, 9, 'Victoria', 3, 0, 0, 100.00, 3, '2026-06-06 18:51:00', 1, '2026-06-17 08:54:41', '2026-06-17 08:54:41'),
(20, 28, 13, 'Grace', 3, 0, 0, 100.00, 3, '2026-06-05 10:43:00', 1, '2026-06-17 08:58:19', '2026-06-17 08:58:19'),
(21, 29, 13, 'Grace', 3, 0, 0, 100.00, 7, '2026-06-22 17:47:00', 1, '2026-06-22 18:46:33', '2026-06-22 18:46:33'),
(22, 29, 11, 'Havin', 2, 1, 0, 66.67, 6, '2026-06-22 19:41:00', 1, '2026-06-22 18:47:05', '2026-06-22 18:47:05'),
(23, 29, 9, 'Victoria', 2, 1, 0, 66.67, 6, '2026-06-22 18:54:00', 1, '2026-06-22 18:47:37', '2026-06-22 18:47:37'),
(24, 29, 6, 'Favour sz', 1, 2, 0, 33.33, 6, '2026-06-22 19:39:00', 1, '2026-06-22 18:48:24', '2026-06-22 18:48:24'),
(26, 29, 8, 'Maro', 3, 0, 0, 100.00, 11, '2026-06-22 19:42:00', 1, '2026-06-22 18:49:53', '2026-06-22 18:49:53'),
(27, 30, 8, 'Maro', 2, 1, 0, 66.67, 7, '2026-07-07 09:01:00', 1, '2026-07-07 08:05:08', '2026-07-07 08:05:08'),
(28, 32, 6, 'Favour sz', 2, 3, 0, 40.00, 120, '2026-08-14 13:58:00', 1, '2026-08-14 13:05:22', '2026-08-14 13:05:22'),
(29, 32, 12, 'Gerad', 3, 2, 0, 60.00, 70, '2026-08-14 09:06:38', 1, '2026-08-14 13:06:38', '2026-08-14 13:06:38'),
(30, 33, 6, 'Favour sz', 1, 4, 0, 20.00, 60, '2026-08-14 12:41:13', 1, '2026-08-14 16:41:13', '2026-08-14 16:41:13'),
(31, 33, 12, 'Gerad', 4, 1, 0, 80.00, 90, '2026-08-14 12:41:39', 1, '2026-08-14 16:41:39', '2026-08-14 16:41:39'),
(32, 33, 13, 'Grace', 2, 3, 0, 40.00, 100, '2026-08-14 12:41:57', 1, '2026-08-14 16:41:57', '2026-08-14 16:41:57'),
(33, 33, 3, 'Jackie', 1, 0, 0, 20.00, 60, '2026-08-14 12:42:18', 1, '2026-08-14 16:42:18', '2026-08-14 16:42:18'),
(34, 35, 6, 'Favour sz', 3, 0, 0, 100.00, 60, '2026-08-20 20:43:37', 1, '2026-08-21 00:43:37', '2026-08-21 00:43:37'),
(35, 35, 12, 'Gerad', 2, 1, 0, 66.67, 40, '2026-08-20 20:43:54', 1, '2026-08-21 00:43:54', '2026-08-21 00:43:54'),
(36, 35, 13, 'Grace', 3, 0, 0, 100.00, 61, '2026-08-20 20:44:20', 1, '2026-08-21 00:44:20', '2026-08-21 00:44:20'),
(37, 35, 13, 'Grace', 3, 0, 0, 100.00, 68, '2026-08-20 20:44:43', 1, '2026-08-21 00:44:43', '2026-08-21 00:44:43'),
(38, 35, 4, 'SpongeBob square', 3, 0, 0, 100.00, 14, '2026-08-20 20:46:30', 1, '2026-08-21 00:46:30', '2026-08-21 00:46:30'),
(39, 36, 9, 'Victoria', 3, 0, 0, 100.00, 30, '2026-08-20 20:51:56', 1, '2026-08-21 00:51:56', '2026-08-21 00:51:56'),
(40, 36, 11, 'Havin', 3, 0, 0, 100.00, 25, '2026-08-20 20:52:14', 1, '2026-08-21 00:52:14', '2026-08-21 00:52:14'),
(41, 36, 13, 'Grace', 2, 1, 0, 66.67, 15, '2026-08-22 06:57:32', 1, '2026-08-22 10:57:32', '2026-08-22 10:57:32'),
(42, 36, 12, 'Gerad', 3, 0, 0, 100.00, 9, '2026-08-22 06:57:53', 1, '2026-08-22 10:57:53', '2026-08-22 10:57:53'),
(43, 36, 8, 'Maro', 1, 2, 0, 33.33, 15, '2026-08-24 11:44:09', 1, '2026-08-24 15:44:09', '2026-08-24 15:44:09'),
(44, 37, 12, 'Gerad', 4, 1, 0, 80.00, 60, '2026-08-30 21:20:58', 1, '2026-08-31 01:20:58', '2026-08-31 01:20:58'),
(45, 38, 2, 'Kewe', 4, 1, 0, 80.00, 30, '2026-08-30 21:41:45', 1, '2026-08-31 01:41:45', '2026-08-31 01:41:45'),
(46, 38, 6, 'Favour sz', 3, 1, 0, 60.00, 60, '2026-08-31 05:54:01', 1, '2026-08-31 09:54:01', '2026-08-31 09:54:01'),
(47, 39, 8, 'Maro', 2, 3, 0, 40.00, 60, '2026-08-31 06:02:30', 1, '2026-08-31 10:02:30', '2026-08-31 10:02:30'),
(48, 39, 13, 'Grace', 2, 3, 0, 40.00, 39, '2026-08-31 06:03:19', 1, '2026-08-31 10:03:19', '2026-08-31 10:03:19'),
(49, 39, 10, 'Sarah mello', 3, 1, 0, 60.00, 60, '2026-08-31 06:04:48', 1, '2026-08-31 10:04:48', '2026-08-31 10:04:48'),
(50, 40, 4, 'SpongeBob square', 4, 0, 0, 80.00, 120, '2026-08-31 06:21:42', 1, '2026-08-31 10:21:42', '2026-08-31 10:21:42'),
(51, 40, 12, 'Gerad', 4, 1, 0, 80.00, 60, '2026-08-31 08:38:44', 1, '2026-08-31 12:38:44', '2026-08-31 12:38:44'),
(52, 40, 11, 'Havin', 3, 0, 0, 60.00, 61, '2026-08-31 09:22:27', 1, '2026-08-31 13:22:27', '2026-08-31 13:22:27'),
(53, 41, 12, 'Gerad', 0, 0, 0, 0.00, 60, '2026-08-31 09:51:31', 1, '2026-08-31 13:51:31', '2026-08-31 13:51:31'),
(54, 41, 13, 'Grace', 4, 1, 0, 80.00, 30, '2026-08-31 09:52:02', 1, '2026-08-31 13:52:02', '2026-08-31 13:52:02'),
(55, 41, 11, 'Havin', 3, 2, 0, 60.00, 40, '2026-08-31 09:52:28', 1, '2026-08-31 13:52:28', '2026-08-31 13:52:28'),
(56, 41, 11, 'Havin', 4, 1, 0, 80.00, 50, '2026-08-31 10:21:37', 1, '2026-08-31 14:21:37', '2026-08-31 14:21:37'),
(57, 42, 9, 'Victoria', 2, 1, 0, 66.67, 60, '2026-08-31 14:32:21', 1, '2026-08-31 18:32:21', '2026-08-31 18:32:21'),
(58, 43, 6, 'Favour sz', 1, 0, 0, 33.33, 60, '2026-09-12 11:46:08', 1, '2026-09-12 15:46:08', '2026-09-12 15:46:08'),
(59, 43, 12, 'Gerad', 2, 0, 0, 66.67, 40, '2026-09-12 11:46:41', 1, '2026-09-12 15:46:41', '2026-09-12 15:46:41'),
(60, 43, 11, 'Havin', 3, 0, 0, 100.00, 14, '2026-09-12 11:50:48', 1, '2026-09-12 15:50:48', '2026-09-12 15:50:48');

-- --------------------------------------------------------

--
-- Table structure for table `heist_demo_users`
--

CREATE TABLE `heist_demo_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `display_name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `heist_demo_users`
--

INSERT INTO `heist_demo_users` (`id`, `display_name`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Bea001', 0, 1, '2026-05-19 09:53:04', '2026-06-06 06:58:54'),
(2, 'Kewe', 1, 1, '2026-05-19 09:53:11', '2026-06-01 11:12:08'),
(3, 'Jackie', 1, 1, '2026-05-19 09:53:36', '2026-06-01 11:12:10'),
(4, 'SpongeBob square', 1, 1, '2026-05-19 09:53:47', '2026-06-06 10:36:28'),
(5, 'Ben001', 0, 1, '2026-06-01 11:13:03', '2026-08-14 12:58:48'),
(6, 'Favour sz', 1, 1, '2026-06-06 10:31:45', '2026-06-06 10:31:45'),
(7, 'Daniel spade', 0, 1, '2026-06-06 10:34:39', '2026-06-06 17:14:24'),
(8, 'Maro', 1, 1, '2026-06-06 10:35:39', '2026-06-06 10:35:39'),
(9, 'Victoria', 1, 1, '2026-06-06 10:35:52', '2026-06-06 10:35:52'),
(10, 'Sarah mello', 1, 1, '2026-06-06 10:36:14', '2026-06-06 10:36:14'),
(11, 'Havin', 1, 1, '2026-06-06 10:37:22', '2026-06-06 10:37:22'),
(12, 'Gerad', 1, 1, '2026-06-06 10:37:59', '2026-06-06 10:37:59'),
(13, 'Grace', 1, 1, '2026-06-17 08:56:54', '2026-06-17 08:56:54');

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
(11, 3, 11, NULL, NULL, '2026-04-19 20:03:43', 'submitted'),
(13, 3, 8, NULL, NULL, '2026-04-19 23:20:47', 'submitted'),
(14, 3, 2, NULL, NULL, '2026-04-20 05:58:24', 'submitted'),
(15, 3, 12, NULL, NULL, '2026-04-21 15:12:57', 'submitted'),
(16, 3, 3, NULL, NULL, '2026-04-21 15:37:13', 'submitted'),
(17, 3, 4, NULL, NULL, '2026-04-21 15:47:47', 'submitted'),
(18, 3, 7, NULL, NULL, '2026-04-21 15:55:06', 'submitted'),
(19, 4, 13, NULL, NULL, '2026-04-25 15:48:39', 'submitted'),
(20, 4, 15, NULL, NULL, '2026-04-25 15:59:11', 'submitted'),
(21, 4, 8, NULL, NULL, '2026-04-25 18:05:14', 'submitted'),
(22, 5, 17, NULL, NULL, '2026-04-25 20:16:19', 'submitted'),
(23, 5, 8, NULL, NULL, '2026-04-25 20:36:33', 'submitted'),
(24, 5, 19, NULL, NULL, '2026-04-26 14:01:14', 'submitted'),
(25, 6, 8, NULL, NULL, '2026-04-26 15:21:28', 'submitted'),
(26, 6, 17, NULL, NULL, '2026-04-27 20:26:04', 'submitted'),
(27, 6, 3, NULL, NULL, '2026-04-27 20:31:58', 'submitted'),
(28, 7, 8, NULL, NULL, '2026-04-28 13:48:14', 'submitted'),
(29, 7, 25, NULL, NULL, '2026-04-28 14:41:17', 'submitted'),
(30, 7, 14, NULL, NULL, '2026-04-29 13:57:09', 'submitted'),
(31, 8, 25, NULL, NULL, '2026-04-30 06:04:44', 'submitted'),
(32, 8, 8, NULL, NULL, '2026-04-30 21:31:47', 'submitted'),
(33, 8, 11, NULL, NULL, '2026-05-01 08:41:38', 'submitted'),
(34, 9, 8, NULL, NULL, '2026-05-01 19:36:59', 'submitted'),
(35, 10, 28, NULL, NULL, '2026-05-04 10:15:20', 'submitted'),
(36, 10, 30, NULL, NULL, '2026-05-04 10:17:45', 'submitted'),
(37, 10, 29, NULL, NULL, '2026-05-04 10:21:36', 'submitted'),
(38, 9, 12, NULL, NULL, '2026-05-04 11:13:27', 'submitted'),
(39, 11, 36, NULL, NULL, '2026-05-04 13:06:12', 'submitted'),
(40, 11, 37, NULL, NULL, '2026-05-04 13:08:50', 'submitted'),
(41, 11, 38, NULL, NULL, '2026-05-04 13:09:30', 'submitted'),
(42, 9, 31, NULL, NULL, '2026-05-05 20:36:09', 'submitted'),
(43, 12, 31, NULL, NULL, '2026-05-06 09:21:57', 'submitted'),
(44, 12, 8, NULL, NULL, '2026-05-06 16:11:08', 'submitted'),
(45, 12, 40, NULL, NULL, '2026-05-06 16:54:01', 'submitted'),
(46, 12, 41, NULL, NULL, '2026-05-06 16:54:43', 'submitted'),
(47, 12, 42, NULL, NULL, '2026-05-06 17:03:53', 'joined'),
(48, 13, 41, NULL, NULL, '2026-05-06 17:05:52', 'submitted'),
(49, 13, 31, NULL, NULL, '2026-05-06 17:06:45', 'submitted'),
(50, 13, 42, NULL, NULL, '2026-05-06 17:08:19', 'submitted'),
(51, 13, 12, NULL, NULL, '2026-05-06 17:08:23', 'submitted'),
(52, 13, 40, NULL, NULL, '2026-05-06 17:12:46', 'submitted'),
(53, 14, 42, NULL, NULL, '2026-05-06 17:53:10', 'submitted'),
(54, 14, 41, NULL, NULL, '2026-05-06 17:54:52', 'submitted'),
(55, 14, 32, NULL, NULL, '2026-05-06 18:32:02', 'submitted'),
(56, 14, 8, NULL, NULL, '2026-05-06 18:35:50', 'submitted'),
(57, 15, 8, NULL, NULL, '2026-05-07 09:25:13', 'submitted'),
(58, 15, 32, NULL, NULL, '2026-05-07 18:46:20', 'submitted'),
(59, 15, 3, NULL, NULL, '2026-05-08 07:46:55', 'submitted'),
(60, 16, 8, NULL, NULL, '2026-05-08 11:58:18', 'submitted'),
(61, 16, 2, NULL, NULL, '2026-05-10 16:44:24', 'submitted'),
(62, 16, 15, NULL, NULL, '2026-05-10 16:45:39', 'submitted'),
(63, 17, 40, NULL, NULL, '2026-05-10 17:01:19', 'submitted'),
(64, 17, 41, NULL, NULL, '2026-05-10 17:04:54', 'submitted'),
(65, 17, 3, NULL, NULL, '2026-05-10 17:13:32', 'joined'),
(66, 18, 8, NULL, NULL, '2026-05-10 17:50:54', 'submitted'),
(67, 18, 45, NULL, NULL, '2026-05-11 01:04:11', 'submitted'),
(68, 18, 39, NULL, NULL, '2026-05-12 12:04:26', 'submitted'),
(69, 19, 8, NULL, NULL, '2026-05-12 13:26:52', 'submitted'),
(70, 20, 48, NULL, NULL, '2026-05-12 13:58:27', 'submitted'),
(71, 20, 49, NULL, NULL, '2026-05-12 14:00:19', 'submitted'),
(72, 19, 40, NULL, NULL, '2026-05-12 14:09:07', 'submitted'),
(73, 21, 50, NULL, NULL, '2026-05-12 14:25:39', 'submitted'),
(74, 21, 51, NULL, NULL, '2026-05-12 14:27:06', 'submitted'),
(75, 19, 49, NULL, NULL, '2026-05-12 14:50:38', 'submitted'),
(76, 22, 8, NULL, NULL, '2026-05-12 15:03:20', 'submitted'),
(77, 22, 49, NULL, NULL, '2026-05-12 15:21:43', 'submitted'),
(78, 22, 52, NULL, NULL, '2026-05-12 15:40:46', 'submitted'),
(79, 23, 49, NULL, NULL, '2026-05-12 15:50:52', 'submitted'),
(80, 23, 50, NULL, NULL, '2026-05-14 08:34:55', 'submitted'),
(81, 23, 40, NULL, NULL, '2026-05-15 04:46:46', 'submitted'),
(82, 24, 50, NULL, NULL, '2026-05-16 18:08:58', 'submitted'),
(83, 25, 8, NULL, NULL, '2026-05-22 14:16:23', 'submitted'),
(84, 25, 56, NULL, NULL, '2026-05-23 08:34:11', 'submitted'),
(85, 26, 8, NULL, NULL, '2026-05-23 18:50:53', 'submitted'),
(86, 28, 4, NULL, NULL, '2026-06-06 13:30:58', 'submitted'),
(87, 28, 17, NULL, NULL, '2026-06-06 14:14:06', 'submitted'),
(88, 28, 59, NULL, NULL, '2026-06-06 14:19:57', 'submitted'),
(89, 28, 8, NULL, NULL, '2026-06-06 16:41:03', 'submitted'),
(91, 28, 61, NULL, NULL, '2026-06-06 16:47:28', 'submitted'),
(97, 28, 67, NULL, NULL, '2026-06-06 18:36:18', 'submitted'),
(98, 28, 2, NULL, NULL, '2026-06-17 08:45:25', 'submitted'),
(99, 30, 17, NULL, NULL, '2026-07-01 08:10:30', 'submitted'),
(100, 30, 69, NULL, NULL, '2026-07-01 08:18:09', 'submitted'),
(101, 31, 71, NULL, NULL, '2026-07-01 12:35:03', 'submitted'),
(102, 31, 70, NULL, NULL, '2026-07-01 12:36:25', 'submitted'),
(103, 30, 8, NULL, NULL, '2026-07-04 23:51:40', 'submitted'),
(104, 32, 74, NULL, NULL, '2026-08-14 08:35:25', 'submitted'),
(105, 32, 72, NULL, NULL, '2026-08-14 12:46:15', 'submitted'),
(106, 32, 3, NULL, NULL, '2026-08-14 12:56:09', 'submitted'),
(107, 33, 72, NULL, NULL, '2026-08-14 14:41:36', 'submitted'),
(108, 33, 3, NULL, NULL, '2026-08-14 16:42:30', 'submitted'),
(109, 34, 72, NULL, NULL, '2026-08-14 19:17:51', 'submitted'),
(110, 35, 3, NULL, NULL, '2026-08-21 00:45:17', 'submitted'),
(111, 36, 3, NULL, NULL, '2026-08-21 00:52:32', 'submitted'),
(112, 37, 76, NULL, NULL, '2026-08-31 01:17:20', 'submitted'),
(113, 37, 3, NULL, NULL, '2026-08-31 01:17:46', 'submitted'),
(114, 38, 76, NULL, NULL, '2026-08-31 01:38:05', 'submitted'),
(115, 38, 3, NULL, NULL, '2026-08-31 01:38:43', 'submitted'),
(116, 38, 77, NULL, NULL, '2026-08-31 09:57:40', 'submitted'),
(117, 39, 77, NULL, NULL, '2026-08-31 10:01:50', 'submitted'),
(118, 40, 77, NULL, NULL, '2026-08-31 10:46:59', 'submitted'),
(119, 40, 79, NULL, NULL, '2026-08-31 13:08:46', 'submitted'),
(120, 41, 80, NULL, NULL, '2026-08-31 13:43:14', 'submitted'),
(121, 42, 79, NULL, NULL, '2026-08-31 18:48:08', 'submitted'),
(122, 42, 80, NULL, NULL, '2026-08-31 23:42:10', 'submitted'),
(123, 43, 80, NULL, NULL, '2026-09-01 14:22:00', 'submitted'),
(124, 43, 82, NULL, NULL, '2026-09-02 02:16:30', 'submitted'),
(125, 43, 79, NULL, NULL, '2026-09-02 19:51:39', 'submitted'),
(126, 43, 3, NULL, NULL, '2026-09-12 15:47:27', 'submitted');

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
(20, NULL, 'The sun rises in the east.', 'true', 1, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(21, NULL, 'A triangle has four sides.', 'false', 2, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(22, 22, 'Water freezes at 0 degrees Celsius.', 'true', 3, 1, '2026-05-12 11:02:59', 1, '2026-04-22 12:54:29', '2026-05-12 15:02:59'),
(23, NULL, 'Nigeria is in South America.', 'false', 4, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(24, NULL, 'The human heart has four chambers.', 'true', 5, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(25, 24, '2 + 2 equals 5.', 'false', 6, 1, '2026-05-15 07:23:30', 1, '2026-04-22 12:54:29', '2026-05-15 11:23:30'),
(26, NULL, 'Earth is the third planet from the sun.', 'true', 7, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(27, NULL, 'Birds are mammals.', 'false', 8, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(28, NULL, 'The Atlantic Ocean is larger than a swimming pool.', 'true', 9, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(29, NULL, 'Light travels faster than sound.', 'true', 10, 1, NULL, NULL, '2026-04-22 12:54:29', '2026-04-22 12:54:29'),
(30, NULL, 'The moon is a planet.', 'false', 11, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(31, NULL, 'Humans have 206 bones.', 'true', 12, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(32, NULL, 'Sharks are fish.', 'true', 13, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(33, 30, 'The capital of France is Berlin.', 'false', 14, 1, '2026-07-01 04:03:03', 1, '2026-04-22 13:18:43', '2026-07-01 08:03:03'),
(34, NULL, 'Fire is cold.', 'false', 15, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(35, NULL, 'The Earth orbits the sun.', 'true', 16, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(36, NULL, 'Bananas grow on trees.', 'false', 17, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(37, NULL, 'Sound can travel through water.', 'true', 18, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(38, NULL, 'An octopus has three hearts.', 'true', 19, 1, NULL, NULL, '2026-04-22 13:18:43', '2026-04-22 13:18:43'),
(39, 4, 'Gold is heavier than plastic.', 'true', 20, 1, '2026-04-22 09:41:16', 1, '2026-04-22 13:18:43', '2026-04-22 13:41:16'),
(40, 6, 'The speed of light is slower than sound.', 'false', 21, 1, '2026-04-26 10:26:58', 1, '2026-04-22 13:19:13', '2026-04-26 14:26:58'),
(41, NULL, 'A square has four equal sides.', 'true', 22, 1, NULL, NULL, '2026-04-22 13:19:13', '2026-04-22 13:19:13'),
(42, 5, 'Fish can live on land.', 'false', 23, 1, '2026-04-25 15:04:07', 1, '2026-04-22 13:19:13', '2026-04-25 19:04:07'),
(43, 37, 'The human brain controls the body.', 'true', 24, 1, '2026-08-30 21:16:45', 1, '2026-04-22 13:19:13', '2026-08-31 01:16:45'),
(44, NULL, 'Ice is hotter than fire.', 'false', 25, 1, NULL, NULL, '2026-04-22 13:19:13', '2026-04-22 13:19:13'),
(45, NULL, 'The Pacific Ocean is the largest ocean.', 'true', 26, 1, NULL, NULL, '2026-04-22 13:19:13', '2026-04-22 13:19:13'),
(46, NULL, 'A week has 10 days.', 'false', 27, 1, NULL, NULL, '2026-04-22 13:19:13', '2026-04-22 13:19:13'),
(47, 20, 'Electricity can power machines.', 'true', 28, 1, '2026-05-12 09:58:01', 1, '2026-04-22 13:19:13', '2026-05-12 13:58:01'),
(48, NULL, 'Mount Everest is the tallest mountain.', 'true', 29, 1, NULL, NULL, '2026-04-22 13:19:13', '2026-04-22 13:19:13'),
(49, NULL, 'Cats are reptiles.', 'false', 30, 1, NULL, NULL, '2026-04-22 13:19:13', '2026-04-22 13:19:13'),
(50, NULL, 'Nigeria is in Africa.', 'true', 31, 1, NULL, NULL, '2026-04-22 13:19:25', '2026-04-22 13:19:25'),
(51, 40, 'The Sahara is a rainforest.', 'false', 32, 1, '2026-08-31 06:06:41', 1, '2026-04-22 13:19:25', '2026-08-31 10:06:41'),
(52, NULL, 'Rain falls from clouds.', 'true', 33, 1, NULL, NULL, '2026-04-22 13:19:25', '2026-04-22 13:19:25'),
(53, NULL, 'The sun is cold.', 'false', 34, 1, NULL, NULL, '2026-04-22 13:19:25', '2026-04-22 13:19:25'),
(54, 7, 'Plants need sunlight to grow.', 'true', 35, 1, '2026-04-27 17:12:58', 1, '2026-04-22 13:19:25', '2026-04-27 21:12:58'),
(55, NULL, 'Air has no weight.', 'false', 36, 1, NULL, NULL, '2026-04-22 13:19:25', '2026-04-22 13:19:25'),
(56, 9, 'Water is made of hydrogen and oxygen.', 'true', 37, 1, '2026-05-01 05:33:42', 1, '2026-04-22 13:19:25', '2026-05-01 09:33:42'),
(57, 8, 'Birds cannot fly.', 'false', 38, 1, '2026-04-29 17:17:04', 1, '2026-04-22 13:19:25', '2026-04-29 21:17:04'),
(58, 45, 'A day has 24 hours.', 'true', 39, 1, '2026-09-12 11:51:13', 1, '2026-04-22 13:19:25', '2026-09-12 15:51:13'),
(59, NULL, 'Humans can breathe underwater naturally.', 'false', 40, 1, NULL, NULL, '2026-04-22 13:19:25', '2026-04-22 13:19:25'),
(60, 41, 'The sky is blue during the day.', 'true', 41, 1, '2026-08-31 09:23:49', 1, '2026-04-22 13:19:37', '2026-08-31 13:23:49'),
(61, NULL, 'Fire needs oxygen to burn.', 'true', 42, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(62, NULL, 'Cars run on water only.', 'false', 43, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(63, NULL, 'Sugar tastes salty.', 'false', 44, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(64, NULL, 'The liver is an organ.', 'true', 45, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(65, 12, 'A circle has corners.', 'false', 46, 1, '2026-05-05 16:41:48', 1, '2026-04-22 13:19:37', '2026-05-05 20:41:48'),
(66, NULL, 'Humans need oxygen to survive.', 'true', 47, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(67, 33, 'Winter is hotter than summer.', 'false', 48, 1, '2026-08-14 10:36:31', 1, '2026-04-22 13:19:37', '2026-08-14 14:36:31'),
(68, NULL, 'The internet uses electricity.', 'true', 49, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(69, NULL, 'Dogs can speak human language.', 'false', 50, 1, NULL, NULL, '2026-04-22 13:19:37', '2026-04-22 13:19:37'),
(70, 13, 'The brain is inside the skull.', 'true', 51, 1, '2026-05-06 13:01:52', 1, '2026-04-22 13:19:49', '2026-05-06 17:01:52'),
(71, 20, 'Water boils at 50 degrees Celsius.', 'false', 52, 1, '2026-05-12 09:58:01', 1, '2026-04-22 13:19:49', '2026-05-12 13:58:01'),
(72, NULL, 'The heart pumps blood.', 'true', 53, 1, NULL, NULL, '2026-04-22 13:19:49', '2026-04-22 13:19:49'),
(73, 13, 'Trees produce oxygen.', 'true', 54, 1, '2026-05-06 13:01:52', 1, '2026-04-22 13:19:49', '2026-05-06 17:01:52'),
(74, NULL, 'Glass is made from sand.', 'true', 55, 1, NULL, NULL, '2026-04-22 13:19:49', '2026-04-22 13:19:49'),
(75, NULL, 'Humans have wings.', 'false', 56, 1, NULL, NULL, '2026-04-22 13:19:49', '2026-04-22 13:19:49'),
(76, NULL, 'The sun is a star.', 'true', 57, 1, NULL, NULL, '2026-04-22 13:19:49', '2026-04-22 13:19:49'),
(77, NULL, 'Night is brighter than day.', 'false', 58, 1, NULL, NULL, '2026-04-22 13:19:49', '2026-04-22 13:19:49'),
(78, NULL, 'Lightning is a form of electricity.', 'true', 59, 1, NULL, NULL, '2026-04-22 13:19:49', '2026-04-22 13:19:49'),
(79, 14, 'Fish can breathe air like humans.', 'false', 60, 1, '2026-05-06 13:18:32', 1, '2026-04-22 13:19:49', '2026-05-06 17:18:32'),
(80, 8, 'The human body has two lungs.', 'true', 61, 1, '2026-04-29 17:17:04', 1, '2026-04-22 13:23:22', '2026-04-29 21:17:04'),
(81, 35, 'The sun revolves around the Earth.', 'false', 62, 1, '2026-08-20 20:43:05', 1, '2026-04-22 13:23:22', '2026-08-21 00:43:05'),
(82, NULL, 'Water is colorless.', 'true', 63, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(83, NULL, 'All insects have six legs.', 'true', 64, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(84, NULL, 'A rectangle has five sides.', 'false', 65, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(85, NULL, 'The brain needs oxygen to function.', 'true', 66, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(86, NULL, 'Snow is hot.', 'false', 67, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(87, NULL, 'The Earth has one moon.', 'true', 68, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(88, 18, 'Humans can survive without water forever.', 'false', 69, 1, '2026-05-10 13:17:00', 1, '2026-04-22 13:23:22', '2026-05-10 17:17:00'),
(89, NULL, 'Electricity can flow through wires.', 'true', 70, 1, NULL, NULL, '2026-04-22 13:23:22', '2026-04-22 13:23:22'),
(90, NULL, 'The tongue helps in tasting.', 'true', 71, 1, NULL, NULL, '2026-04-22 13:23:33', '2026-04-22 13:23:33'),
(91, NULL, 'Sound travels faster than light.', 'false', 72, 1, NULL, NULL, '2026-04-22 13:23:33', '2026-04-22 13:23:33'),
(92, NULL, 'Milk comes from plants.', 'false', 73, 1, NULL, NULL, '2026-04-22 13:23:33', '2026-04-22 13:23:33'),
(93, 7, 'Humans have five senses.', 'true', 74, 1, '2026-04-27 17:12:58', 1, '2026-04-22 13:23:33', '2026-04-27 21:12:58'),
(94, NULL, 'The ocean is made of saltwater.', 'true', 75, 1, NULL, NULL, '2026-04-22 13:23:33', '2026-04-22 13:23:33'),
(95, 14, 'Fire can exist without oxygen.', 'false', 76, 1, '2026-05-06 13:18:32', 1, '2026-04-22 13:23:33', '2026-05-06 17:18:32'),
(96, 4, 'A year has 365 days.', 'true', 77, 1, '2026-04-22 09:41:16', 1, '2026-04-22 13:23:33', '2026-04-22 13:41:16'),
(97, 9, 'The Earth is flat.', 'false', 78, 1, '2026-05-01 05:33:42', 1, '2026-04-22 13:23:33', '2026-05-01 09:33:42'),
(98, NULL, 'Leaves are usually green.', 'true', 79, 1, NULL, NULL, '2026-04-22 13:23:33', '2026-04-22 13:23:33'),
(99, 14, 'Humans have tails.', 'false', 80, 1, '2026-05-06 13:18:32', 1, '2026-04-22 13:23:33', '2026-05-06 17:18:32'),
(100, NULL, 'The North Pole is colder than the equator.', 'true', 81, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(101, NULL, 'Deserts receive heavy rainfall.', 'false', 82, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(102, 9, 'The sun sets in the west.', 'true', 83, 1, '2026-05-01 05:33:42', 1, '2026-04-22 13:23:52', '2026-05-01 09:33:42'),
(103, NULL, 'Plants produce carbon dioxide only.', 'false', 84, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(104, NULL, 'Humans need food to survive.', 'true', 85, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(105, NULL, 'Glass is flexible like rubber.', 'false', 86, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(106, NULL, 'The sky can appear red during sunset.', 'true', 87, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(107, 13, 'Rivers flow uphill naturally.', 'false', 88, 1, '2026-05-06 13:01:52', 1, '2026-04-22 13:23:52', '2026-05-06 17:01:52'),
(108, NULL, 'The Earth rotates on its axis.', 'true', 89, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(109, NULL, 'All animals live in water.', 'false', 90, 1, NULL, NULL, '2026-04-22 13:23:52', '2026-04-22 13:23:52'),
(110, NULL, 'Humans have two eyes.', 'true', 91, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(111, NULL, 'Ice sinks in water.', 'false', 92, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(112, 11, 'Fire produces heat.', 'true', 93, 1, '2026-05-04 09:05:51', 1, '2026-04-22 13:24:02', '2026-05-04 13:05:51'),
(113, NULL, 'Birds lay eggs.', 'true', 94, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(114, NULL, 'Cars can fly naturally.', 'false', 95, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(115, 18, 'The Earth is round.', 'true', 96, 1, '2026-05-10 13:17:00', 1, '2026-04-22 13:24:02', '2026-05-10 17:17:00'),
(116, NULL, 'Humans can breathe in space without aid.', 'false', 97, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(117, NULL, 'Water is essential for life.', 'true', 98, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(118, NULL, 'The sun is made of ice.', 'false', 99, 1, NULL, NULL, '2026-04-22 13:24:02', '2026-04-22 13:24:02'),
(119, 12, 'Plants grow from seeds.', 'true', 100, 1, '2026-05-05 16:41:48', 1, '2026-04-22 13:24:02', '2026-05-05 20:41:48'),
(120, 21, 'The brain sends signals through nerves.', 'true', 101, 1, '2026-05-12 10:23:54', 1, '2026-04-22 13:24:15', '2026-05-12 14:23:54'),
(121, NULL, 'Humans can see in total darkness naturally.', 'false', 102, 1, NULL, NULL, '2026-04-22 13:24:15', '2026-04-22 13:24:15'),
(122, 13, 'The heart beats continuously.', 'true', 103, 1, '2026-05-06 13:01:52', 1, '2026-04-22 13:24:15', '2026-05-06 17:01:52'),
(123, 44, 'Water has a taste of its own.', 'false', 104, 1, '2026-09-12 11:51:00', 1, '2026-04-22 13:24:15', '2026-09-12 15:51:00'),
(124, NULL, 'The Earth has gravity.', 'true', 105, 1, NULL, NULL, '2026-04-22 13:24:15', '2026-04-22 13:24:15'),
(125, NULL, 'Fire is a solid.', 'false', 106, 1, NULL, NULL, '2026-04-22 13:24:15', '2026-04-22 13:24:15'),
(126, NULL, 'Humans need sleep.', 'true', 107, 1, NULL, NULL, '2026-04-22 13:24:15', '2026-04-22 13:24:15'),
(127, 36, 'The sun is closer at night.', 'false', 108, 1, '2026-08-20 20:51:29', 1, '2026-04-22 13:24:15', '2026-08-21 00:51:29'),
(128, 21, 'Oxygen is needed for combustion.', 'true', 109, 1, '2026-05-12 10:23:54', 1, '2026-04-22 13:24:15', '2026-05-12 14:23:54'),
(129, NULL, 'All metals are liquid at room temperature.', 'false', 110, 1, NULL, NULL, '2026-04-22 13:24:15', '2026-04-22 13:24:15'),
(130, 43, 'A week has seven days.', 'true', 111, 1, '2026-09-01 10:20:29', 1, '2026-04-22 13:26:14', '2026-09-01 14:20:29'),
(131, 15, 'December comes before June.', 'false', 112, 1, '2026-05-06 15:19:52', 1, '2026-04-22 13:26:14', '2026-05-06 19:19:52'),
(132, NULL, 'Shoes are worn on the feet.', 'true', 113, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(133, NULL, 'A chair is used for sleeping in the sky.', 'false', 114, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(134, NULL, 'People use phones to make calls.', 'true', 115, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(135, NULL, 'Rice is a type of drink.', 'false', 116, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(136, NULL, 'A book can be used for reading.', 'true', 117, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(137, NULL, 'Fish live in the desert.', 'false', 118, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(138, 14, 'A car usually has wheels.', 'true', 119, 1, '2026-05-06 13:18:32', 1, '2026-04-22 13:26:14', '2026-05-06 17:18:32'),
(139, NULL, 'Rain is usually dry.', 'false', 120, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(140, 15, 'People wear hats on their heads.', 'true', 121, 1, '2026-05-06 15:19:52', 1, '2026-04-22 13:26:14', '2026-05-06 19:19:52'),
(141, 31, 'A spoon is bigger than a bus.', 'false', 122, 1, '2026-07-01 08:33:13', 1, '2026-04-22 13:26:14', '2026-07-01 12:33:13'),
(142, 8, 'Bread can be eaten.', 'true', 123, 1, '2026-04-29 17:17:04', 1, '2026-04-22 13:26:14', '2026-04-29 21:17:04'),
(143, NULL, 'The moon is made of wood.', 'false', 124, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(144, NULL, 'A teacher can work in a school.', 'true', 125, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(145, NULL, 'Soap is used to wash the body.', 'true', 126, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(146, NULL, 'A pillow is usually made of stone.', 'false', 127, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(147, NULL, 'Children go to school to learn.', 'true', 128, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(148, NULL, 'A bag is used to carry things.', 'true', 129, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(149, NULL, 'Television can fit inside a shoe.', 'false', 130, 1, NULL, NULL, '2026-04-22 13:26:14', '2026-04-22 13:26:14'),
(150, NULL, 'Breakfast is usually eaten in the morning.', 'true', 131, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(151, NULL, 'People sleep with their eyes on their hands.', 'false', 132, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(152, 44, 'Water can be kept in a bottle.', 'true', 133, 1, '2026-09-12 11:51:00', 1, '2026-04-22 13:26:27', '2026-09-12 15:51:00'),
(153, 6, 'A door is used for entering a room.', 'true', 134, 1, '2026-04-26 10:26:58', 1, '2026-04-22 13:26:27', '2026-04-26 14:26:58'),
(154, NULL, 'Bananas are blue in color naturally.', 'false', 135, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(155, NULL, 'A pen can be used for writing.', 'true', 136, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(156, NULL, 'A refrigerator is used to keep food cold.', 'true', 137, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(157, NULL, 'People wear socks on their ears.', 'false', 138, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(158, 38, 'A bus can carry many people.', 'true', 139, 1, '2026-08-30 21:37:07', 1, '2026-04-22 13:26:27', '2026-08-31 01:37:07'),
(159, NULL, 'The floor is above the ceiling.', 'false', 140, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(160, NULL, 'Money can be used to buy things.', 'true', 141, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(161, NULL, 'A cup can hold water.', 'true', 142, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(162, NULL, 'A bicycle has no tires.', 'false', 143, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(163, 11, 'A mirror can show your reflection.', 'true', 144, 1, '2026-05-04 09:05:51', 1, '2026-04-22 13:26:27', '2026-05-04 13:05:51'),
(164, NULL, 'People use umbrellas when it rains.', 'true', 145, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(165, 30, 'A chicken is bigger than a house.', 'false', 146, 1, '2026-07-01 04:03:03', 1, '2026-04-22 13:26:27', '2026-07-01 08:03:03'),
(166, NULL, 'A bed is used for sleeping.', 'true', 147, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(167, NULL, 'The sun comes out only inside buildings.', 'false', 148, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(168, 42, 'Food can be cooked in a kitchen.', 'true', 149, 1, '2026-08-31 14:31:47', 1, '2026-04-22 13:26:27', '2026-08-31 18:31:47'),
(169, NULL, 'A school bag is used to carry books.', 'true', 150, 1, NULL, NULL, '2026-04-22 13:26:27', '2026-04-22 13:26:27'),
(170, NULL, 'A clock shows time.', 'true', 151, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(171, NULL, 'Shoes are worn on the hands.', 'false', 152, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(172, 45, 'People drink water when they are thirsty.', 'true', 153, 1, '2026-09-12 11:51:13', 1, '2026-04-22 13:31:44', '2026-09-12 15:51:13'),
(173, NULL, 'A bed is used for cooking food.', 'false', 154, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(174, NULL, 'A phone can send messages.', 'true', 155, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(175, NULL, 'A fan makes the air colder by freezing it.', 'false', 156, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(176, 10, 'A plate is used to serve food.', 'true', 157, 1, '2026-05-04 06:14:21', 1, '2026-04-22 13:31:44', '2026-05-04 10:14:21'),
(177, 30, 'A door is used to fly.', 'false', 158, 1, '2026-07-01 04:03:03', 1, '2026-04-22 13:31:44', '2026-07-01 08:03:03'),
(178, NULL, 'A car needs fuel or energy to move.', 'true', 159, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(179, NULL, 'People eat stones as food.', 'false', 160, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(180, 17, 'A shirt is worn on the body.', 'true', 161, 1, '2026-05-10 12:52:19', 1, '2026-04-22 13:31:44', '2026-05-10 16:52:19'),
(181, NULL, 'A pencil can be used to write.', 'true', 162, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(182, 37, 'A house can walk on its own.', 'false', 163, 1, '2026-08-30 21:16:45', 1, '2026-04-22 13:31:44', '2026-08-31 01:16:45'),
(183, 27, 'A road is used for traveling.', 'true', 164, 1, '2026-06-01 07:15:12', 1, '2026-04-22 13:31:44', '2026-06-01 11:15:12'),
(184, NULL, 'A spoon is used for eating.', 'true', 165, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(185, 32, 'A table is used for swimming.', 'false', 166, 1, '2026-08-14 08:59:23', 1, '2026-04-22 13:31:44', '2026-08-14 12:59:23'),
(186, NULL, 'People use soap to clean.', 'true', 167, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(187, 5, 'A fridge keeps things warm.', 'false', 168, 1, '2026-04-25 15:04:07', 1, '2026-04-22 13:31:44', '2026-04-25 19:04:07'),
(188, 19, 'A teacher helps students learn.', 'true', 169, 1, '2026-05-12 09:26:08', 1, '2026-04-22 13:31:44', '2026-05-12 13:26:08'),
(189, NULL, 'A bag is worn on the feet.', 'false', 170, 1, NULL, NULL, '2026-04-22 13:31:44', '2026-04-22 13:31:44'),
(190, NULL, 'A television shows videos.', 'true', 171, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(191, NULL, 'A cup is used to sit on.', 'false', 172, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(192, NULL, 'People use keys to open locks.', 'true', 173, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(193, NULL, 'A window is used for cooking.', 'false', 174, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(194, NULL, 'Shoes protect your feet.', 'true', 175, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(195, 7, 'A bed is made of fire.', 'false', 176, 1, '2026-04-27 17:12:58', 1, '2026-04-22 13:31:56', '2026-04-27 21:12:58'),
(196, 4, 'A bus is bigger than a bicycle.', 'true', 177, 1, '2026-04-22 09:41:16', 1, '2026-04-22 13:31:56', '2026-04-22 13:41:16'),
(197, NULL, 'A hat is worn on the feet.', 'false', 178, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(198, NULL, 'A computer can process information.', 'true', 179, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(199, NULL, 'A chair is used to drive.', 'false', 180, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(200, NULL, 'A mirror reflects images.', 'true', 181, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(201, NULL, 'A spoon is used to cut wood.', 'false', 182, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(202, NULL, 'A door can be opened and closed.', 'true', 183, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(203, 37, 'A pen writes by itself without a person.', 'false', 184, 1, '2026-08-30 21:16:45', 1, '2026-04-22 13:31:56', '2026-08-31 01:16:45'),
(204, NULL, 'People wear clothes to cover their body.', 'true', 185, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(205, NULL, 'A road is found in the sky.', 'false', 186, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(206, NULL, 'A bag can hold items.', 'true', 187, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(207, NULL, 'A pillow is used to eat food.', 'false', 188, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(208, NULL, 'A fan can move air.', 'true', 189, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(209, NULL, 'A house is smaller than a shoe.', 'false', 190, 1, NULL, NULL, '2026-04-22 13:31:56', '2026-04-22 13:31:56'),
(210, 35, 'People use a fork to eat food.', 'true', 191, 1, '2026-08-20 20:43:05', 1, '2026-04-22 13:32:32', '2026-08-21 00:43:05'),
(211, NULL, 'A shoe is worn on the head.', 'false', 192, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(212, NULL, 'A bus can carry passengers.', 'true', 193, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(213, NULL, 'A phone cannot make calls.', 'false', 194, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(214, 10, 'A bed is used for sleeping.', 'true', 195, 1, '2026-05-04 06:14:21', 1, '2026-04-22 13:32:32', '2026-05-04 10:14:21'),
(215, NULL, 'A cup is used to store fire.', 'false', 196, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(216, 9, 'A clock helps tell time.', 'true', 197, 1, '2026-05-01 05:33:42', 1, '2026-04-22 13:32:32', '2026-05-01 09:33:42'),
(217, NULL, 'A table is used to swim.', 'false', 198, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(218, NULL, 'People wear glasses to see better.', 'true', 199, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(219, 15, 'A spoon is used to fly.', 'false', 200, 1, '2026-05-06 15:19:52', 1, '2026-04-22 13:32:32', '2026-05-06 19:19:52'),
(220, 23, 'A door can be locked.', 'true', 201, 1, '2026-05-12 11:42:27', 1, '2026-04-22 13:32:32', '2026-05-12 15:42:27'),
(221, NULL, 'A car runs without any energy.', 'false', 202, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(222, 22, 'A bag is used to carry items.', 'true', 203, 1, '2026-05-12 11:02:59', 1, '2026-04-22 13:32:32', '2026-05-12 15:02:59'),
(223, 35, 'A fan produces fire.', 'false', 204, 1, '2026-08-20 20:43:05', 1, '2026-04-22 13:32:32', '2026-08-21 00:43:05'),
(224, 19, 'A pen is used for writing.', 'true', 205, 1, '2026-05-12 09:26:08', 1, '2026-04-22 13:32:32', '2026-05-12 13:26:08'),
(225, NULL, 'A chair is used for driving.', 'false', 206, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(226, NULL, 'People eat food when hungry.', 'true', 207, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(227, NULL, 'A fridge is used to heat food.', 'false', 208, 1, NULL, NULL, '2026-04-22 13:32:32', '2026-04-22 13:32:32'),
(228, 16, 'A road is used for movement.', 'true', 209, 1, '2026-05-08 03:50:14', 1, '2026-04-22 13:32:32', '2026-05-08 07:50:14'),
(229, 31, 'A pillow is used for running.', 'false', 210, 1, '2026-07-01 08:33:13', 1, '2026-04-22 13:32:32', '2026-07-01 12:33:13'),
(230, 6, 'A mirror shows reflection.', 'true', 211, 1, '2026-04-26 10:26:58', 1, '2026-04-22 13:32:44', '2026-04-26 14:26:58'),
(231, NULL, 'A book is used to cook food.', 'false', 212, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(232, NULL, 'A bicycle has two wheels.', 'true', 213, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(233, NULL, 'A house can fly naturally.', 'false', 214, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(234, NULL, 'A teacher teaches students.', 'true', 215, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(235, NULL, 'A pen is used to eat food.', 'false', 216, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(236, NULL, 'A kitchen is used to cook meals.', 'true', 217, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(237, NULL, 'A car is smaller than a shoe.', 'false', 218, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(238, NULL, 'A shirt is worn on the body.', 'true', 219, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(239, 39, 'A bed is used for jumping only.', 'false', 220, 1, '2026-08-31 06:01:34', 1, '2026-04-22 13:32:44', '2026-08-31 10:01:34'),
(240, NULL, 'A cup can hold liquid.', 'true', 221, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(241, NULL, 'A window is used to write.', 'false', 222, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(242, NULL, 'People use keys to unlock doors.', 'true', 223, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(243, NULL, 'A spoon is used to dig roads.', 'false', 224, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(244, 29, 'A fan moves air around.', 'true', 225, 1, '2026-06-22 08:14:21', 1, '2026-04-22 13:32:44', '2026-06-22 12:14:21'),
(245, NULL, 'A phone is used only for sleeping.', 'false', 226, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(246, NULL, 'A bag can carry books.', 'true', 227, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(247, NULL, 'A table is used to fly.', 'false', 228, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(248, NULL, 'A shoe protects the foot.', 'true', 229, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(249, NULL, 'A chair is used to swim.', 'false', 230, 1, NULL, NULL, '2026-04-22 13:32:44', '2026-04-22 13:32:44'),
(250, 41, 'A road connects places.', 'true', 231, 1, '2026-08-31 09:23:49', 1, '2026-04-22 13:33:30', '2026-08-31 13:23:49'),
(251, 8, 'A fridge is used to freeze heat.', 'false', 232, 1, '2026-04-29 17:17:04', 1, '2026-04-22 13:33:30', '2026-04-29 21:17:04'),
(252, NULL, 'A pencil can draw.', 'true', 233, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(253, NULL, 'A door is always open.', 'false', 234, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(254, 39, 'A bus travels on roads.', 'true', 235, 1, '2026-08-31 06:01:34', 1, '2026-04-22 13:33:30', '2026-08-31 10:01:34'),
(255, NULL, 'A cup is used for walking.', 'false', 236, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(256, 18, 'A mirror can show your face.', 'true', 237, 1, '2026-05-10 13:17:00', 1, '2026-04-22 13:33:30', '2026-05-10 17:17:00'),
(257, NULL, 'A book can speak by itself.', 'false', 238, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(258, 37, 'A plate is used to serve food.', 'true', 239, 1, '2026-08-30 21:16:45', 1, '2026-04-22 13:33:30', '2026-08-31 01:16:45'),
(259, NULL, 'A fan is used to boil water.', 'false', 240, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(260, NULL, 'People use beds to sleep.', 'true', 241, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(261, NULL, 'A shoe is used to eat food.', 'false', 242, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(262, NULL, 'A computer can display information.', 'true', 243, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(263, NULL, 'A table can run by itself.', 'false', 244, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(264, 16, 'A spoon helps in eating.', 'true', 245, 1, '2026-05-08 03:50:14', 1, '2026-04-22 13:33:30', '2026-05-08 07:50:14'),
(265, 31, 'A bag cannot hold anything.', 'false', 246, 1, '2026-07-01 08:33:13', 1, '2026-04-22 13:33:30', '2026-07-01 12:33:13'),
(266, NULL, 'A phone can connect people.', 'true', 247, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(267, NULL, 'A chair floats in the sky.', 'false', 248, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(268, 23, 'A house provides shelter.', 'true', 249, 1, '2026-05-12 11:42:27', 1, '2026-04-22 13:33:30', '2026-05-12 15:42:27'),
(269, NULL, 'A road is found in water only.', 'false', 250, 1, NULL, NULL, '2026-04-22 13:33:30', '2026-04-22 13:33:30'),
(270, 36, 'A phone can ring.', 'true', 251, 1, '2026-08-20 20:51:29', 1, '2026-04-22 13:35:46', '2026-08-21 00:51:29'),
(271, 15, 'A shoe is used to write.', 'false', 252, 1, '2026-05-06 15:19:52', 1, '2026-04-22 13:35:46', '2026-05-06 19:19:52'),
(272, 32, 'A bus carries people.', 'true', 253, 1, '2026-08-14 08:59:23', 1, '2026-04-22 13:35:46', '2026-08-14 12:59:23'),
(273, NULL, 'A bed is used to drive.', 'false', 254, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(274, NULL, 'A cup can hold water.', 'true', 255, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(275, NULL, 'A table is used for flying.', 'false', 256, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(276, NULL, 'A mirror shows your image.', 'true', 257, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(277, NULL, 'A bag cannot carry items.', 'false', 258, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(278, 41, 'A chair is used for sitting.', 'true', 259, 1, '2026-08-31 09:23:49', 1, '2026-04-22 13:35:46', '2026-08-31 13:23:49'),
(279, 34, 'A spoon is used for cutting trees.', 'false', 260, 1, '2026-08-14 14:42:17', 1, '2026-04-22 13:35:46', '2026-08-14 18:42:17'),
(280, 26, 'A fridge keeps food cold.', 'true', 261, 1, '2026-05-23 05:50:20', 1, '2026-04-22 13:35:46', '2026-05-23 09:50:20'),
(281, 28, 'A door is always closed.', 'false', 262, 1, '2026-06-06 08:20:29', 1, '2026-04-22 13:35:46', '2026-06-06 12:20:29'),
(282, NULL, 'A pen can write.', 'true', 263, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(283, NULL, 'A car can move.', 'true', 264, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(284, 25, 'A road is used for swimming.', 'false', 265, 1, '2026-05-19 08:51:17', 1, '2026-04-22 13:35:46', '2026-05-19 12:51:17'),
(285, NULL, 'A hat is worn on the head.', 'true', 266, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(286, 17, 'A pillow is used for eating.', 'false', 267, 1, '2026-05-10 12:52:19', 1, '2026-04-22 13:35:46', '2026-05-10 16:52:19'),
(287, 10, 'A clock tells time.', 'true', 268, 1, '2026-05-04 06:14:21', 1, '2026-04-22 13:35:46', '2026-05-04 10:14:21'),
(288, 12, 'A house can walk.', 'false', 269, 1, '2026-05-05 16:41:48', 1, '2026-04-22 13:35:46', '2026-05-05 20:41:48'),
(289, NULL, 'A book can be read.', 'true', 270, 1, NULL, NULL, '2026-04-22 13:35:46', '2026-04-22 13:35:46'),
(290, 32, 'A window lets light in.', 'true', 271, 1, '2026-08-14 08:59:23', 1, '2026-04-22 13:36:01', '2026-08-14 12:59:23'),
(291, NULL, 'A bicycle has no wheels.', 'false', 272, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(292, NULL, 'A teacher works in a school.', 'true', 273, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(293, 42, 'A phone is used to cook food.', 'false', 274, 1, '2026-08-31 14:31:47', 1, '2026-04-22 13:36:01', '2026-08-31 18:31:47'),
(294, NULL, 'A spoon helps you eat.', 'true', 275, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(295, 14, 'A table can jump.', 'false', 276, 1, '2026-05-06 13:18:32', 1, '2026-04-22 13:36:01', '2026-05-06 17:18:32'),
(296, NULL, 'A bag is used to carry items.', 'true', 277, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(297, NULL, 'A car can fly naturally.', 'false', 278, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(298, NULL, 'A chair is used for sitting.', 'true', 279, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(299, NULL, 'A door is used for entering rooms.', 'true', 280, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(300, NULL, 'A fridge is used to heat food.', 'false', 281, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(301, 10, 'A mirror can reflect light.', 'true', 282, 1, '2026-05-04 06:14:21', 1, '2026-04-22 13:36:01', '2026-05-04 10:14:21'),
(302, NULL, 'A book can walk.', 'false', 283, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(303, 5, 'A plate holds food.', 'true', 284, 1, '2026-04-25 15:04:07', 1, '2026-04-22 13:36:01', '2026-04-25 19:04:07'),
(304, NULL, 'A shoe is used for swimming.', 'false', 285, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(305, NULL, 'A clock shows time.', 'true', 286, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(306, NULL, 'A house is smaller than a spoon.', 'false', 287, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(307, 11, 'A pen writes on paper.', 'true', 288, 1, '2026-05-04 09:05:51', 1, '2026-04-22 13:36:01', '2026-05-04 13:05:51'),
(308, NULL, 'A bus is smaller than a toy car.', 'false', 289, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(309, NULL, 'A bed is used for rest.', 'true', 290, 1, NULL, NULL, '2026-04-22 13:36:01', '2026-04-22 13:36:01'),
(310, NULL, 'A cup can break if dropped.', 'true', 291, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(311, NULL, 'A chair is used for flying.', 'false', 292, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(312, NULL, 'A road helps people travel.', 'true', 293, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(313, 10, 'A fan produces water.', 'false', 294, 1, '2026-05-04 06:14:21', 1, '2026-04-22 13:36:15', '2026-05-04 10:14:21'),
(314, NULL, 'A bag can hold books.', 'true', 295, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(315, NULL, 'A spoon is used to drive.', 'false', 296, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(316, NULL, 'A phone connects people.', 'true', 297, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(317, NULL, 'A table can run.', 'false', 298, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(318, 34, 'A house protects people.', 'true', 299, 1, '2026-08-14 14:42:17', 1, '2026-04-22 13:36:15', '2026-08-14 18:42:17'),
(319, NULL, 'A pillow is used for sleeping.', 'true', 300, 1, NULL, NULL, '2026-04-22 13:36:15', '2026-04-22 13:36:15'),
(320, NULL, 'The capital of Australia is Sydney.', 'false', 301, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(321, 12, 'Lightning can strike the same place twice.', 'true', 302, 1, '2026-05-05 16:41:48', 1, '2026-04-22 13:36:28', '2026-05-05 20:41:48'),
(322, 43, 'Humans can distinguish more than five senses.', 'true', 303, 1, '2026-09-01 10:20:29', 1, '2026-04-22 13:36:28', '2026-09-01 14:20:29'),
(323, 29, 'Gold is heavier than iron for the same volume.', 'true', 304, 1, '2026-06-22 08:14:21', 1, '2026-04-22 13:36:28', '2026-06-22 12:14:21'),
(324, 8, 'Sound cannot travel in a vacuum.', 'true', 305, 1, '2026-04-29 17:17:04', 1, '2026-04-22 13:36:28', '2026-04-29 21:17:04'),
(325, NULL, 'The Great Wall of China is visible from space with the naked eye.', 'false', 306, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(326, NULL, 'Water expands when it freezes.', 'true', 307, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(327, NULL, 'All deserts are hot.', 'false', 308, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(328, NULL, 'A leap year occurs every 4 years without exception.', 'false', 309, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(329, 12, 'The human body can survive longer without food than without water.', 'true', 310, 1, '2026-05-05 16:41:48', 1, '2026-04-22 13:36:28', '2026-05-05 20:41:48'),
(330, NULL, 'Bats are blind.', 'false', 311, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(331, NULL, 'The Pacific Ocean is larger than all land combined.', 'true', 312, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(332, NULL, 'An octopus has more than one brain.', 'true', 313, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(333, NULL, 'Bananas grow on trees.', 'false', 314, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(334, NULL, 'The sun is white, not yellow.', 'true', 315, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(335, NULL, 'Glass is technically a liquid.', 'false', 316, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(336, NULL, 'Humans share some DNA with bananas.', 'true', 317, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(337, NULL, 'Mount Kilimanjaro is the tallest mountain in the world.', 'false', 318, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(338, NULL, 'Sharks existed before trees.', 'true', 319, 1, NULL, NULL, '2026-04-22 13:36:28', '2026-04-22 13:36:28'),
(339, 11, 'The Earth is closer to the sun in summer.', 'false', 320, 1, '2026-05-04 09:05:51', 1, '2026-04-22 13:36:28', '2026-05-04 13:05:51'),
(340, NULL, 'If you drop a feather and a stone in a vacuum, they fall at the same speed.', 'true', 321, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(341, NULL, 'There are more stars in the sky than grains of sand on Earth.', 'true', 322, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(342, NULL, 'Humans use 100% of their brain.', 'false', 323, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(343, 11, 'A tomato is a fruit.', 'true', 324, 1, '2026-05-04 09:05:51', 1, '2026-04-22 13:36:41', '2026-05-04 13:05:51'),
(344, 22, 'Cold water boils faster than hot water.', 'false', 325, 1, '2026-05-12 11:02:59', 1, '2026-04-22 13:36:41', '2026-05-12 15:02:59'),
(345, NULL, 'The longest river in the world is the Amazon.', 'true', 326, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(346, 15, 'Your fingernails continue growing after death.', 'false', 327, 1, '2026-05-06 15:19:52', 1, '2026-04-22 13:36:41', '2026-05-06 19:19:52'),
(347, NULL, 'A group of lions is called a pride.', 'true', 328, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(348, 28, 'The moon produces its own light.', 'false', 329, 1, '2026-06-06 08:20:29', 1, '2026-04-22 13:36:41', '2026-06-06 12:20:29'),
(349, 13, 'There are more possible chess games than atoms in the universe.', 'true', 330, 1, '2026-05-06 13:01:52', 1, '2026-04-22 13:36:41', '2026-05-06 17:01:52'),
(350, NULL, 'Spiders are insects.', 'false', 331, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(351, NULL, 'The human body is made up of mostly water.', 'true', 332, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(352, NULL, 'You can see air with the naked eye.', 'false', 333, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(353, NULL, 'Penguins can fly underwater but not in the air.', 'true', 334, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(354, NULL, 'The brain feels pain.', 'false', 335, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(355, 9, 'A day on Venus is longer than a year on Venus.', 'true', 336, 1, '2026-05-01 05:33:42', 1, '2026-04-22 13:36:41', '2026-05-01 09:33:42'),
(356, NULL, 'Diamonds are made from compressed coal.', 'false', 337, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(357, 39, 'The speed of light is constant in a vacuum.', 'true', 338, 1, '2026-08-31 06:01:34', 1, '2026-04-22 13:36:41', '2026-08-31 10:01:34'),
(358, NULL, 'You can hear sound in space.', 'false', 339, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(359, NULL, 'Humans have walked on Mars.', 'false', 340, 1, NULL, NULL, '2026-04-22 13:36:41', '2026-04-22 13:36:41'),
(360, 19, 'The Great Wall of China is visible from space with the naked eye.', 'false', 341, 1, '2026-05-12 09:26:08', 1, '2026-04-22 17:36:41', '2026-05-12 13:26:08'),
(361, NULL, 'Water boils at 100 degrees Celsius at sea level.', 'true', 342, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(362, NULL, 'Bats are blind.', 'false', 343, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(363, NULL, 'The human body has 206 bones.', 'true', 344, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(364, NULL, 'Lightning never strikes the same place twice.', 'false', 345, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(365, NULL, 'Sharks are mammals.', 'false', 346, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(366, NULL, 'The Earth revolves around the Sun.', 'true', 347, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(367, NULL, 'Bananas grow on trees.', 'false', 348, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(368, NULL, 'An octopus has three hearts.', 'true', 349, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(369, NULL, 'Goldfish only have a memory of three seconds.', 'false', 350, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(370, NULL, 'The capital of Australia is Sydney.', 'false', 351, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(371, 22, 'Humans and dinosaurs lived at the same time.', 'false', 352, 1, '2026-05-12 11:02:59', 1, '2026-04-22 17:36:41', '2026-05-12 15:02:59'),
(372, NULL, 'A group of lions is called a pride.', 'true', 353, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(373, NULL, 'The Pacific Ocean is the largest ocean on Earth.', 'true', 354, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(374, NULL, 'Penguins can fly naturally.', 'false', 355, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(375, NULL, 'Mount Everest is the tallest mountain above sea level.', 'true', 356, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(376, 38, 'The speed of light is faster than the speed of sound.', 'true', 357, 1, '2026-08-30 21:37:07', 1, '2026-04-22 17:36:41', '2026-08-31 01:37:07'),
(377, NULL, 'Spiders are insects.', 'false', 358, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(378, NULL, 'Venus is the closest planet to the Sun.', 'false', 359, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(379, NULL, 'The Nile is the longest river in the world.', 'true', 360, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(380, NULL, 'Cheetahs are the fastest land animals.', 'true', 361, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(381, NULL, 'The Moon produces its own light.', 'false', 362, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(382, NULL, 'Honey never spoils.', 'true', 363, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(383, NULL, 'A camel stores water in its humps.', 'false', 364, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(384, NULL, 'The Eiffel Tower is located in London.', 'false', 365, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(385, NULL, 'Sound travels faster in water than in air.', 'true', 366, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(386, NULL, 'Koalas are bears.', 'false', 367, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(387, NULL, 'The human heart has four chambers.', 'true', 368, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(388, NULL, 'An ostrich can fly.', 'false', 369, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(389, NULL, 'There are seven continents on Earth.', 'true', 370, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(390, NULL, 'Diamonds are made from carbon.', 'true', 371, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(391, NULL, 'The Amazon River is in Africa.', 'false', 372, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(392, NULL, 'Humans breathe oxygen.', 'true', 373, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(393, 32, 'Frogs are reptiles.', 'false', 374, 1, '2026-08-14 08:59:23', 1, '2026-04-22 17:36:41', '2026-08-14 12:59:23'),
(394, NULL, 'The Sun is a star.', 'true', 375, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(395, NULL, 'Adult humans have 32 teeth.', 'true', 376, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(396, NULL, 'Polar bears live in Antarctica.', 'false', 377, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(397, NULL, 'The piano has 88 keys.', 'true', 378, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(398, NULL, 'Coffee is made from berries.', 'true', 379, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(399, NULL, 'Fish can breathe underwater using lungs.', 'false', 380, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(400, NULL, 'The Statue of Liberty was a gift from France.', 'true', 381, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(401, NULL, 'The human brain stops working during sleep.', 'false', 382, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(402, NULL, 'Mars is known as the Red Planet.', 'true', 383, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(403, NULL, 'Plants produce oxygen.', 'true', 384, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(404, NULL, 'A week has eight days.', 'false', 385, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(405, 40, 'Whales are fish.', 'false', 386, 1, '2026-08-31 06:06:41', 1, '2026-04-22 17:36:41', '2026-08-31 10:06:41'),
(406, NULL, 'The human body needs water to survive.', 'true', 387, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(407, NULL, 'Saturn is famous for its rings.', 'true', 388, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(408, NULL, 'Birds are cold-blooded animals.', 'false', 389, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(409, NULL, 'Ice sinks in water.', 'false', 390, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(410, NULL, 'A leap year has 366 days.', 'true', 391, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(411, NULL, 'The Atlantic Ocean is bigger than the Pacific Ocean.', 'false', 392, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(412, NULL, 'Butterflies start life as caterpillars.', 'true', 393, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(413, NULL, 'The Earth is flat.', 'false', 394, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(414, NULL, 'Kangaroos are native to Australia.', 'true', 395, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(415, NULL, 'Chocolate is toxic to dogs.', 'true', 396, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(416, NULL, 'The color of emeralds is blue.', 'false', 397, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(417, 40, 'Jupiter is the largest planet in the Solar System.', 'true', 398, 1, '2026-08-31 06:06:41', 1, '2026-04-22 17:36:41', '2026-08-31 10:06:41'),
(418, NULL, 'Snakes have legs.', 'false', 399, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(419, NULL, 'Humans can survive without sleep forever.', 'false', 400, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(420, NULL, 'The human body contains more than 600 muscles.', 'true', 401, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(421, NULL, 'The blue whale is the largest animal on Earth.', 'true', 402, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(422, NULL, 'Humans have five senses only.', 'false', 403, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(423, NULL, 'The Sahara is the largest desert in the world.', 'false', 404, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(424, NULL, 'The currency of Japan is the Yen.', 'true', 405, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(425, NULL, 'Dolphins are mammals.', 'true', 406, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(426, NULL, 'The human body has only one lung.', 'false', 407, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(427, 39, 'Venus is hotter than Mercury.', 'true', 408, 1, '2026-08-31 06:01:34', 1, '2026-04-22 17:36:41', '2026-08-31 10:01:34');
INSERT INTO `heist_questions` (`id`, `heist_id`, `question_text`, `correct_answer`, `sort_order`, `is_active`, `assigned_at`, `assigned_by`, `created_at`, `updated_at`) VALUES
(428, 21, 'A crocodile cannot stick its tongue out.', 'true', 409, 1, '2026-05-12 10:23:54', 1, '2026-04-22 17:36:41', '2026-05-12 14:23:54'),
(429, NULL, 'The tallest animal in the world is the giraffe.', 'true', 410, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(430, NULL, 'The Sun revolves around the Earth.', 'false', 411, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(431, NULL, 'Owls can rotate their heads more than 180 degrees.', 'true', 412, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(432, NULL, 'Penguins live only in cold places.', 'false', 413, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(433, 24, 'Humans share about 60 percent of their DNA with bananas.', 'true', 414, 1, '2026-05-15 07:23:30', 1, '2026-04-22 17:36:41', '2026-05-15 11:23:30'),
(434, NULL, 'The shortest war in history lasted less than one hour.', 'true', 415, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(435, 40, 'The Great Pyramid of Giza is in Mexico.', 'false', 416, 1, '2026-08-31 06:06:41', 1, '2026-04-22 17:36:41', '2026-08-31 10:06:41'),
(436, 17, 'A snail can sleep for up to three years.', 'true', 417, 1, '2026-05-10 12:52:19', 1, '2026-04-22 17:36:41', '2026-05-10 16:52:19'),
(437, NULL, 'The human nose can detect thousands of different smells.', 'true', 418, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(438, NULL, 'Lightning is hotter than the surface of the Sun.', 'true', 419, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(439, NULL, 'Turtles can leave their shells completely.', 'false', 420, 1, NULL, NULL, '2026-04-22 17:36:41', '2026-04-22 17:36:41'),
(440, 20, 'The human skeleton renews itself over time.', 'true', 421, 1, '2026-05-12 09:58:01', 1, '2026-04-22 17:36:41', '2026-05-12 13:58:01'),
(441, NULL, 'An octopus has three hearts.', 'true', 422, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(442, 17, 'Mount Everest is the closest point on Earth to the moon.', 'false', 423, 1, '2026-05-10 12:52:19', 1, '2026-05-07 06:04:37', '2026-05-10 16:52:19'),
(443, 37, 'Goldfish only have a three-second memory.', 'false', 424, 1, '2026-08-30 21:16:45', 1, '2026-05-07 06:04:37', '2026-08-31 01:16:45'),
(444, NULL, 'The Atlantic Ocean is the largest ocean on Earth.', 'false', 425, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(445, 33, 'A group of crows is called a murder.', 'true', 426, 1, '2026-08-14 10:36:31', 1, '2026-05-07 06:04:37', '2026-08-14 14:36:31'),
(446, 31, 'Bananas grow on trees.', 'false', 427, 1, '2026-07-01 08:33:13', 1, '2026-05-07 06:04:37', '2026-07-01 12:33:13'),
(447, NULL, 'The capital of Australia is Sydney.', 'false', 428, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(448, NULL, 'Sharks are mammals.', 'false', 429, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(449, NULL, 'Honey never spoils.', 'true', 430, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(450, NULL, 'A bachelor is a person who is married.', 'false', 431, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(451, NULL, 'The Great Wall of China is visible from the Moon with the naked eye.', 'false', 432, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(452, NULL, 'The Mona Lisa has no clearly visible eyebrows.', 'true', 433, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(453, NULL, 'There are 24 hours in a day.', 'true', 434, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(454, NULL, 'The Eiffel Tower can be taller in the summer.', 'true', 435, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(455, 19, 'Humans share 50 percent of their DNA with bananas.', 'true', 436, 1, '2026-05-12 09:26:08', 1, '2026-05-07 06:04:37', '2026-05-12 13:26:08'),
(456, 39, 'A jiffy is an actual unit of time.', 'true', 437, 1, '2026-08-31 06:01:34', 1, '2026-05-07 06:04:37', '2026-08-31 10:01:34'),
(457, NULL, 'Strawberries are not actually berries.', 'true', 438, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(458, NULL, 'The total number of steps in the Eiffel Tower is 1665.', 'true', 439, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(459, NULL, 'The human heart beats about 100,000 times a day.', 'true', 440, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(460, NULL, 'Water covers approximately 71 percent of the Earth\'s surface.', 'true', 441, 1, NULL, NULL, '2026-05-07 06:04:37', '2026-05-07 06:04:37'),
(461, NULL, 'A lightning bolt is five times hotter than the surface of the sun.', 'true', 442, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(462, NULL, 'The unicorn is the national animal of Scotland.', 'true', 443, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(463, 20, 'An ant can lift 5,000 times its body weight.', 'true', 444, 1, '2026-05-12 09:58:01', 1, '2026-05-07 06:05:41', '2026-05-12 13:58:01'),
(464, NULL, 'The Great Wall of China is longer than the distance between London and Beijing.', 'true', 445, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(465, NULL, 'Chameleons change color only to blend into their surroundings.', 'false', 446, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(466, NULL, 'There are more lifeforms on your skin than there are people on the planet.', 'true', 447, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(467, NULL, 'The state of Florida is bigger than the country of England.', 'true', 448, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(468, NULL, 'Humans are the only animals that blush.', 'true', 449, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(469, NULL, 'Spiders are insects.', 'false', 450, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(470, NULL, 'The Pacific Ocean is larger than all the Earth’s land area combined.', 'true', 451, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(471, 16, 'The fingerprints of a koala are so indistinguishable from humans that they have on occasion been confused at crime scenes.', 'true', 452, 1, '2026-05-08 03:50:14', 1, '2026-05-07 06:05:41', '2026-05-08 07:50:14'),
(472, NULL, 'The heart of a shrimp is located in its head.', 'true', 453, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(473, NULL, 'Sloths take two weeks to digest a meal.', 'true', 454, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(474, NULL, 'A snail can breathe through its foot.', 'false', 455, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(475, NULL, 'The moon has moonquakes.', 'true', 456, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(476, NULL, 'Venus is the only planet that rotates clockwise.', 'true', 457, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(477, NULL, 'The dead skin on your body is not actually alive.', 'true', 458, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(478, NULL, 'One teaspoon of a neutron star would weigh six billion tons.', 'true', 459, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(479, 25, 'Cats have more bones than humans.', 'true', 460, 1, '2026-05-19 08:51:17', 1, '2026-05-07 06:05:41', '2026-05-19 12:51:17'),
(480, NULL, 'A cloud can weigh more than a million pounds.', 'true', 461, 1, NULL, NULL, '2026-05-07 06:05:41', '2026-05-07 06:05:41'),
(481, 22, 'A human nose can remember 50,000 different scents.', 'true', 462, 1, '2026-05-12 11:02:59', 1, '2026-05-07 06:07:15', '2026-05-12 15:02:59'),
(482, 23, 'The Great Wall of China is a single continuous wall.', 'false', 463, 1, '2026-05-12 11:42:27', 1, '2026-05-07 06:07:15', '2026-05-12 15:42:27'),
(483, NULL, 'The first orange carrots were grown in the 17th century.', 'true', 464, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(484, NULL, 'Coca-Cola originally contained cocaine.', 'true', 465, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(485, NULL, 'Polar bear skin is white.', 'false', 466, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(486, NULL, 'There are more stars in the universe than grains of sand on all the Earth\'s beaches.', 'true', 467, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(487, 27, 'The small pocket in jeans was originally designed to store coins.', 'false', 468, 1, '2026-06-01 07:15:12', 1, '2026-05-07 06:07:15', '2026-06-01 11:15:12'),
(488, NULL, 'A strawberry is not a berry, but a banana is.', 'true', 469, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(489, NULL, 'Elephants are the only animals that cannot jump.', 'true', 470, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(490, NULL, 'The letter \"Q\" is the only letter that doesn\'t appear in any US state name.', 'true', 471, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(491, NULL, 'Nutmeg is extremely poisonous if injected intravenously.', 'true', 472, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(492, NULL, 'Water makes a different sound when it is hot versus when it is cold.', 'true', 473, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(493, NULL, 'A woodchuck can actually chuck wood.', 'false', 474, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(494, NULL, 'An apple, potato, and onion all taste the same if you eat them with your nose plugged.', 'true', 475, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(495, NULL, 'The first person to survive going over Niagara Falls in a barrel was a 63-year-old schoolteacher.', 'true', 476, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(496, 20, 'Competitive art used to be an Olympic sport.', 'true', 477, 1, '2026-05-12 09:58:01', 1, '2026-05-07 06:07:15', '2026-05-12 13:58:01'),
(497, NULL, 'Rabbits cannot puke.', 'true', 478, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(498, NULL, 'A \"jiffy\" is an actual unit of time for 1/100th of a second.', 'true', 479, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(499, NULL, 'The world’s oldest wooden wheel has been around for more than 5,000 years.', 'true', 480, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(500, NULL, 'The heart of a blue whale is the size of a car.', 'true', 481, 1, NULL, NULL, '2026-05-07 06:07:15', '2026-05-07 06:07:15'),
(501, NULL, 'The inventor of the Frisbee was turned into a Frisbee after he died.', 'true', 482, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(502, NULL, 'A bolt of lightning contains enough energy to toast 100,000 slices of bread.', 'true', 483, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(503, NULL, 'The average person spends six months of their lifetime waiting for red lights to turn green.', 'true', 484, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(504, NULL, 'The majority of your brain is fat.', 'true', 485, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(505, NULL, 'A cow-bison hybrid is called a \"Beefalo\".', 'true', 486, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(506, NULL, 'Scotland has 421 words for \"snow\".', 'true', 487, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(507, NULL, 'The \"D\" in D-Day stands for \"Doomsday\".', 'false', 488, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(508, NULL, 'In Switzerland, it is illegal to own just one guinea pig.', 'true', 489, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(509, NULL, 'The first alarm clock could only ring at 4 a.m.', 'true', 490, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(510, NULL, 'There are more fake flamingos in the world than real ones.', 'true', 491, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(511, 43, 'Vatican City is the smallest country in the world.', 'true', 492, 1, '2026-09-01 10:20:29', 1, '2026-05-07 06:08:12', '2026-09-01 14:20:29'),
(512, NULL, 'An individual blood cell takes about 60 seconds to make a complete circuit of the body.', 'true', 493, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(513, NULL, 'The total weight of all the ants on Earth is greater than the total weight of all the humans on Earth.', 'false', 494, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(514, NULL, 'A group of owls is called a parliament.', 'true', 495, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(515, NULL, 'The moon is perfectly spherical.', 'false', 496, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(516, 34, 'The human body contains enough carbon to make 900 pencils.', 'true', 497, 1, '2026-08-14 14:42:17', 1, '2026-05-07 06:08:12', '2026-08-14 18:42:17'),
(517, 45, 'The first iPhone was released in 2005.', 'false', 498, 1, '2026-09-12 11:51:13', 1, '2026-05-07 06:08:12', '2026-09-12 15:51:13'),
(518, NULL, 'Ketchup was once sold as medicine.', 'true', 499, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(519, NULL, 'A cloud can weigh more than a million pounds.', 'true', 500, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(520, NULL, 'The Eiffel Tower was originally intended for Barcelona.', 'true', 501, 1, NULL, NULL, '2026-05-07 06:08:12', '2026-05-07 06:08:12'),
(521, NULL, 'In \"Tom and Jerry,\" Tom is a cat and Jerry is a mouse.', 'true', 502, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(522, NULL, 'Ben 10 uses a device called the Omnitrix to transform into aliens.', 'true', 503, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(523, NULL, 'Superman is weakened by a green rock called Kryptonite.', 'true', 504, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(524, NULL, 'Spider-Man\'s real name is Bruce Wayne.', 'false', 505, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(525, 41, 'In \"The Lion King,\" Simba is a tiger.', 'false', 506, 1, '2026-08-31 09:23:49', 1, '2026-05-07 06:09:45', '2026-08-31 13:23:49'),
(526, 33, 'Batman lives in a city called Gotham.', 'true', 507, 1, '2026-08-14 10:36:31', 1, '2026-05-07 06:09:45', '2026-08-14 14:36:31'),
(527, 28, 'SpongeBob SquarePants lives in a hollowed-out apple underwater.', 'false', 508, 1, '2026-06-06 08:20:29', 1, '2026-05-07 06:09:45', '2026-06-06 12:20:29'),
(528, NULL, 'Cinderella lost a glass slipper at the ball.', 'true', 509, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(529, NULL, 'Harry Potter has a lightning bolt-shaped scar on his forehead.', 'true', 510, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(530, NULL, 'Mickey Mouse was the first cartoon character to ever speak.', 'false', 511, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(531, NULL, 'In \"Ben 10,\" Heatblast is an alien made of fire.', 'true', 512, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(532, NULL, 'The Hulk turns green when he gets very sad.', 'false', 513, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(533, 31, 'Shrek is a giant green ogre.', 'true', 514, 1, '2026-07-01 08:33:13', 1, '2026-05-07 06:09:45', '2026-07-01 12:33:13'),
(534, NULL, 'Iron Man\'s real name is Tony Stark.', 'true', 515, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(535, NULL, 'The movie \"Titanic\" is based on a true story.', 'true', 516, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(536, NULL, 'Scooby-Doo is a Great Dane.', 'true', 517, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(537, NULL, 'Elsa from \"Frozen\" has the power to control fire.', 'false', 518, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(538, NULL, 'Pikachu is a character from the Dragon Ball Z series.', 'false', 519, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(539, 26, 'Buzz Lightyear and Woody are the main characters in \"Toy Story\".', 'true', 520, 1, '2026-05-23 05:50:20', 1, '2026-05-07 06:09:45', '2026-05-23 09:50:20'),
(540, NULL, 'Superman works as a journalist for the Daily Planet.', 'true', 521, 1, NULL, NULL, '2026-05-07 06:09:45', '2026-05-07 06:09:45'),
(541, NULL, 'Ben 10\'s cousin is named Gwen.', 'true', 522, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(542, NULL, 'The Joker is the arch-enemy of Superman.', 'false', 523, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(543, NULL, 'In \"Tom and Jerry,\" the dog who often protects Jerry is named Spike.', 'true', 524, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(544, NULL, 'Po from \"Kung Fu Panda\" is a giant panda.', 'true', 525, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(545, 16, 'Wolverine is a member of the X-Men.', 'true', 526, 1, '2026-05-08 03:50:14', 1, '2026-05-07 06:13:05', '2026-05-08 07:50:14'),
(546, NULL, 'The Flash is known for being the slowest man alive.', 'false', 527, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(547, NULL, 'In \"Finding Nemo,\" Nemo is a clownfish.', 'true', 528, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(548, NULL, 'The Autobots are the heroes in the \"Transformers\" series.', 'true', 529, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(549, 38, 'Wonder Woman carries a \"Lasso of Truth\".', 'true', 530, 1, '2026-08-30 21:37:07', 1, '2026-05-07 06:13:05', '2026-08-31 01:37:07'),
(550, NULL, 'Naruto Uzumaki is a ninja from the Hidden Leaf Village.', 'true', 531, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(551, NULL, 'Thanos is a villain in the Marvel Cinematic Universe.', 'true', 532, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(552, NULL, 'Black Panther is the king of a fictional country called Wakanda.', 'true', 533, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(553, 24, 'In \"Despicable Me,\" the minions are purple by default.', 'false', 534, 1, '2026-05-15 07:23:30', 1, '2026-05-07 06:13:05', '2026-05-15 11:23:30'),
(554, NULL, 'Tarzan was raised by gorillas in the jungle.', 'true', 535, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(555, NULL, 'The character \"Bugs Bunny\" is famous for saying \"What\'s up, doc?\".', 'true', 536, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(556, NULL, 'Thor is the God of Mischief.', 'false', 537, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(557, NULL, 'Optimus Prime transforms into a semi-truck.', 'true', 538, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(558, NULL, 'In \"The Incredibles,\" the baby Jack-Jack has no powers.', 'false', 539, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(559, NULL, 'Scooby-Doo and his friends travel in a van called the Mystery Machine.', 'true', 540, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(560, NULL, 'The Grinch tried to steal Christmas.', 'true', 541, 1, NULL, NULL, '2026-05-07 06:13:05', '2026-05-07 06:13:05'),
(561, NULL, 'A penny costs more than one cent to manufacture.', 'true', 542, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(562, 32, 'The inventor of the Pringles can is buried in one.', 'true', 543, 1, '2026-08-14 08:59:23', 1, '2026-05-07 06:14:15', '2026-08-14 12:59:23'),
(563, 18, 'There are more possible iterations of a game of chess than there are atoms in the observable universe.', 'true', 544, 1, '2026-05-10 13:17:00', 1, '2026-05-07 06:14:15', '2026-05-10 17:17:00'),
(564, NULL, 'An ostrich\'s eye is bigger than its brain.', 'true', 545, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(565, NULL, 'The average person will shed 40 pounds of skin in their lifetime.', 'true', 546, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(566, 25, 'Every continent has a city named Rome.', 'false', 547, 1, '2026-05-19 08:51:17', 1, '2026-05-07 06:14:15', '2026-05-19 12:51:17'),
(567, NULL, 'It is impossible to hum while holding your nose.', 'true', 548, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(568, NULL, 'The national animal of Scotland is the Unicorn.', 'true', 549, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(569, NULL, 'Human teeth are as strong as shark teeth.', 'true', 550, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(570, NULL, 'A jellyfish is 95 percent water.', 'true', 551, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(571, 17, 'The King of Hearts is the only king without a mustache.', 'true', 552, 1, '2026-05-10 12:52:19', 1, '2026-05-07 06:14:15', '2026-05-10 16:52:19'),
(572, NULL, 'The moon has a smell similar to gunpowder.', 'true', 553, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(573, NULL, 'Chewing gum while peeling onions will keep you from crying.', 'false', 554, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(574, NULL, 'A duck\'s quack does not echo.', 'false', 555, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(575, 18, 'The wood frog can hold its pee for up to eight months.', 'true', 556, 1, '2026-05-10 13:17:00', 1, '2026-05-07 06:14:15', '2026-05-10 17:17:00'),
(576, NULL, 'Napoleon Bonaparte was exceptionally short.', 'false', 557, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(577, 26, 'The electric chair was invented by a dentist.', 'true', 558, 1, '2026-05-23 05:50:20', 1, '2026-05-07 06:14:15', '2026-05-23 09:50:20'),
(578, NULL, 'Blue whales eat half a million calories in one mouthful.', 'true', 559, 1, NULL, NULL, '2026-05-07 06:14:15', '2026-05-07 06:14:15'),
(579, 36, 'Wombat poop is cube-shaped.', 'true', 560, 1, '2026-08-20 20:51:29', 1, '2026-05-07 06:14:15', '2026-08-21 00:51:29'),
(580, 19, 'Your fingernails grow faster than your toenails.', 'true', 561, 1, '2026-05-12 09:26:08', 1, '2026-05-07 06:14:15', '2026-05-12 13:26:08'),
(581, NULL, 'A human could swim through the veins of a blue whale.', 'true', 562, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(582, NULL, 'Bananas are radioactive.', 'true', 563, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(583, NULL, 'The Sahara Desert can experience snowfall.', 'true', 564, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(584, NULL, 'The first person to ever be convicted of speeding was going 8 mph.', 'true', 565, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(585, NULL, 'A \"moment\" is an actual measurement of time lasting 90 seconds.', 'true', 566, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(586, NULL, 'Goldfish can see both infrared and ultraviolet light.', 'true', 567, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(587, NULL, 'Oxford University is older than the Aztec Empire.', 'true', 568, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(588, 33, 'An individual blood cell takes about 60 seconds to make a complete circuit of the body.', 'true', 569, 1, '2026-08-14 10:36:31', 1, '2026-05-07 06:15:02', '2026-08-14 14:36:31'),
(589, NULL, 'There are more trees on Earth than stars in the Milky Way.', 'true', 570, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(590, NULL, 'Armadillos are the only animals that can catch leprosy from humans.', 'false', 571, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(591, NULL, 'A cloud can weigh over a million pounds.', 'true', 572, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(592, NULL, 'The \"hash\" or \"pound\" symbol (#) is technically called an octothorpe.', 'true', 573, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(593, NULL, 'You can breathe and swallow at the same time.', 'false', 574, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(594, NULL, 'The inventor of the microwave oven only received $2 for his discovery.', 'true', 575, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(595, NULL, 'Koalas have human-like fingerprints.', 'true', 576, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(596, NULL, 'The shortest war in history lasted 38 minutes.', 'true', 577, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(597, 38, 'Venus is the only planet that rotates clockwise.', 'true', 578, 1, '2026-08-30 21:37:07', 1, '2026-05-07 06:15:02', '2026-08-31 01:37:07'),
(598, NULL, 'A strawberry is a berry, but a pumpkin is not.', 'false', 579, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(599, NULL, 'There is a species of jellyfish that is biologically immortal.', 'true', 580, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(600, NULL, 'The heart of a shrimp is located in its head.', 'true', 581, 1, NULL, NULL, '2026-05-07 06:15:02', '2026-05-07 06:15:02'),
(601, NULL, 'It is physically impossible for pigs to look up into the sky.', 'true', 582, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(602, 42, 'A group of flamingos is called a \"flamboyance\".', 'true', 583, 1, '2026-08-31 14:31:47', 1, '2026-05-07 06:18:10', '2026-08-31 18:31:47'),
(603, NULL, 'The inventor of the stop sign never learned how to drive.', 'true', 584, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(604, 44, 'A shark can grow and lose over 30,000 teeth in its lifetime.', 'true', 585, 1, '2026-09-12 11:51:00', 1, '2026-05-07 06:18:10', '2026-09-12 15:51:00'),
(605, NULL, 'The \"M\'s\" in M&Ms stand for Mars and Murrie.', 'true', 586, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(606, NULL, 'In the original version of Cinderella, her slippers were made of fur, not glass.', 'false', 587, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(607, 38, 'A hippopotamus can run faster than a human.', 'true', 588, 1, '2026-08-30 21:37:07', 1, '2026-05-07 06:18:10', '2026-08-31 01:37:07'),
(608, 40, 'The average person swallows eight spiders a year while sleeping.', 'false', 589, 1, '2026-08-31 06:06:41', 1, '2026-05-07 06:18:10', '2026-08-31 10:06:41'),
(609, NULL, 'Cows have \"best friends\" and get stressed when separated.', 'true', 590, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(610, NULL, 'The fake name for a movie being filmed is called a \"smokescreen\".', 'false', 591, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(611, NULL, 'Ketchup was originally made from fermented fish, not tomatoes.', 'true', 592, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(612, NULL, 'Sloths can hold their breath longer than dolphins.', 'true', 593, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(613, NULL, 'There is a town in Norway called \"Hell\" that freezes over every winter.', 'true', 594, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(614, NULL, 'Rats laugh when you tickle them.', 'true', 595, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(615, NULL, 'The dot over the letter \"i\" and \"j\" is called a \"tittle\".', 'true', 596, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(616, NULL, 'Most Disney characters wear gloves to make them easier to animate.', 'true', 597, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(617, 27, 'Dolphins have names for each other.', 'true', 598, 1, '2026-06-01 07:15:12', 1, '2026-05-07 06:18:10', '2026-06-01 11:15:12'),
(618, NULL, 'The lighter was invented before the match.', 'true', 599, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(619, NULL, 'Kangaroos can fart.', 'false', 600, 1, NULL, NULL, '2026-05-07 06:18:10', '2026-05-07 06:18:10'),
(620, 29, 'A \"butt\" is an actual unit of measurement for wine.', 'true', 601, 1, '2026-06-22 08:14:21', 1, '2026-05-07 06:18:10', '2026-06-22 12:14:21'),
(621, NULL, 'The Bible is the best-selling book of all time.', 'true', 602, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(622, NULL, 'Noah’s Ark contained two of every kind of animal only.', 'false', 603, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(623, 16, 'The shortest verse in the Bible is \"Jesus wept.\"', 'true', 604, 1, '2026-05-08 03:50:14', 1, '2026-05-07 06:20:15', '2026-05-08 07:50:14'),
(624, NULL, 'David killed the giant Goliath with a sword.', 'false', 605, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(625, NULL, 'There are 66 books in the standard Protestant Bible.', 'true', 606, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(626, 33, 'The first book of the Bible is called Exodus.', 'false', 607, 1, '2026-08-14 10:36:31', 1, '2026-05-07 06:20:15', '2026-08-14 14:36:31'),
(627, NULL, 'Methuselah is the oldest person mentioned in the Bible, living 969 years.', 'true', 608, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(628, NULL, 'The Bible was originally written in English.', 'false', 609, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(629, NULL, 'Moses led the Israelites across the Red Sea.', 'true', 610, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(630, NULL, 'There were exactly three wise men who visited baby Jesus.', 'false', 611, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(631, NULL, 'The Last Supper took place on the night before Jesus was crucified.', 'true', 612, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(632, NULL, 'Jonah was swallowed by a \"great fish\" or whale.', 'true', 613, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(633, NULL, 'The Bible mentions that an apple was the forbidden fruit in Eden.', 'false', 614, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(634, NULL, 'Paul the Apostle was originally known as Saul of Tarsus.', 'true', 615, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(635, NULL, 'Jesus had 12 main disciples.', 'true', 616, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(636, NULL, 'The Ten Commandments were given to Moses on Mount Sinai.', 'true', 617, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(637, NULL, 'The New Testament begins with the Book of Acts.', 'false', 618, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(638, 41, 'Samson lost his great strength when his hair was cut.', 'true', 619, 1, '2026-08-31 09:23:49', 1, '2026-05-07 06:20:15', '2026-08-31 13:23:49'),
(639, NULL, 'The city of Jericho’s walls fell after the Israelites marched around it.', 'true', 620, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15'),
(640, NULL, 'John the Baptist was a cousin of Jesus.', 'true', 621, 1, NULL, NULL, '2026-05-07 06:20:15', '2026-05-07 06:20:15');

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
(9, 3, 8, 13, NULL, '2026-04-19 19:20:47', '2026-04-21 09:48:42', 8, 1, 2, 0, 33.33, 'submitted', '2026-04-19 23:20:47', '2026-04-21 13:48:42'),
(10, 3, 2, 14, NULL, '2026-04-21 09:41:48', '2026-04-21 09:42:11', 13, 1, 2, 0, 33.33, 'submitted', '2026-04-21 13:41:48', '2026-04-21 13:42:11'),
(11, 3, 11, 11, NULL, '2026-04-21 09:50:59', '2026-04-21 09:54:16', 182, 3, 0, 0, 100.00, 'submitted', '2026-04-21 13:50:59', '2026-04-21 13:54:16'),
(12, 3, 12, 15, NULL, '2026-04-21 11:20:00', '2026-04-21 11:20:30', 17, 3, 0, 0, 100.00, 'submitted', '2026-04-21 15:20:00', '2026-04-21 15:20:30'),
(13, 3, 3, 16, NULL, '2026-04-21 11:37:18', '2026-04-21 11:38:00', 20, 2, 1, 0, 66.67, 'submitted', '2026-04-21 15:37:18', '2026-04-21 15:38:00'),
(14, 3, 4, 17, NULL, '2026-04-21 11:47:52', '2026-04-21 11:48:36', 37, 2, 1, 0, 66.67, 'submitted', '2026-04-21 15:47:52', '2026-04-21 15:48:36'),
(15, 3, 7, 18, NULL, '2026-04-21 11:55:22', '2026-04-21 12:01:25', 261, 3, 0, 0, 100.00, 'submitted', '2026-04-21 15:55:22', '2026-04-21 16:01:25'),
(16, 4, 13, 19, NULL, '2026-04-25 11:48:47', '2026-04-25 11:49:10', 13, 3, 0, 0, 100.00, 'submitted', '2026-04-25 15:48:47', '2026-04-25 15:49:10'),
(17, 4, 15, 20, NULL, '2026-04-25 11:59:30', '2026-04-25 11:59:52', 14, 3, 0, 0, 100.00, 'submitted', '2026-04-25 15:59:30', '2026-04-25 15:59:52'),
(18, 4, 8, 21, NULL, '2026-04-25 14:05:19', '2026-04-25 14:05:38', 9, 3, 0, 0, 100.00, 'submitted', '2026-04-25 18:05:19', '2026-04-25 18:05:38'),
(19, 5, 17, 22, NULL, '2026-04-25 16:16:26', '2026-04-25 16:17:05', 21, 2, 1, 0, 66.67, 'submitted', '2026-04-25 20:16:26', '2026-04-25 20:17:05'),
(20, 5, 8, 23, NULL, '2026-04-25 16:36:39', '2026-04-25 16:36:56', 9, 3, 0, 0, 100.00, 'submitted', '2026-04-25 20:36:39', '2026-04-25 20:36:56'),
(21, 5, 19, 24, NULL, '2026-04-26 10:03:03', '2026-04-26 10:03:25', 13, 3, 0, 0, 100.00, 'submitted', '2026-04-26 14:03:03', '2026-04-26 14:03:25'),
(22, 6, 8, 25, NULL, '2026-04-26 11:21:33', '2026-04-26 11:21:44', 6, 3, 0, 0, 100.00, 'submitted', '2026-04-26 15:21:33', '2026-04-26 15:21:44'),
(23, 6, 17, 26, NULL, '2026-04-27 16:26:11', '2026-04-27 16:26:30', 5, 3, 0, 0, 100.00, 'submitted', '2026-04-27 20:26:11', '2026-04-27 20:26:30'),
(24, 6, 3, 27, NULL, '2026-04-27 16:34:01', '2026-04-27 16:34:33', 23, 2, 1, 0, 66.67, 'submitted', '2026-04-27 20:34:01', '2026-04-27 20:34:33'),
(25, 7, 8, 28, NULL, '2026-04-28 09:48:22', '2026-04-28 09:48:34', 5, 3, 0, 0, 100.00, 'submitted', '2026-04-28 13:48:22', '2026-04-28 13:48:34'),
(26, 7, 25, 29, NULL, '2026-04-28 10:41:21', '2026-04-28 10:41:40', 12, 3, 0, 0, 100.00, 'submitted', '2026-04-28 14:41:21', '2026-04-28 14:41:40'),
(27, 7, 14, 30, NULL, '2026-04-29 09:57:19', '2026-04-29 09:58:15', 26, 2, 1, 0, 66.67, 'submitted', '2026-04-29 13:57:19', '2026-04-29 13:58:15'),
(28, 8, 25, 31, NULL, '2026-04-30 02:04:49', '2026-04-30 02:05:45', 42, 3, 2, 0, 60.00, 'submitted', '2026-04-30 06:04:49', '2026-04-30 06:05:45'),
(29, 8, 8, 32, NULL, '2026-04-30 17:31:55', '2026-04-30 17:32:17', 12, 5, 0, 0, 100.00, 'submitted', '2026-04-30 21:31:55', '2026-04-30 21:32:17'),
(30, 8, 11, 33, NULL, '2026-05-01 04:41:51', '2026-05-01 04:44:21', 122, 4, 1, 0, 80.00, 'submitted', '2026-05-01 08:41:51', '2026-05-01 08:44:21'),
(31, 9, 8, 34, NULL, '2026-05-01 15:37:24', '2026-05-01 15:37:55', 14, 5, 0, 0, 100.00, 'submitted', '2026-05-01 19:37:24', '2026-05-01 19:37:55'),
(32, 10, 28, 35, NULL, '2026-05-04 06:15:39', '2026-05-04 06:16:07', 13, 5, 0, 0, 100.00, 'submitted', '2026-05-04 10:15:39', '2026-05-04 10:16:07'),
(33, 10, 30, 36, NULL, '2026-05-04 06:18:14', '2026-05-04 06:18:41', 15, 5, 0, 0, 100.00, 'submitted', '2026-05-04 10:18:14', '2026-05-04 10:18:41'),
(34, 10, 29, 37, NULL, '2026-05-04 06:22:05', '2026-05-04 06:22:37', 20, 5, 0, 0, 100.00, 'submitted', '2026-05-04 10:22:05', '2026-05-04 10:22:37'),
(35, 9, 12, 38, NULL, '2026-05-04 07:13:42', '2026-05-04 07:14:24', 22, 4, 1, 0, 80.00, 'submitted', '2026-05-04 11:13:42', '2026-05-04 11:14:24'),
(36, 11, 36, 39, NULL, '2026-05-04 09:06:37', '2026-05-04 09:07:17', 29, 4, 1, 0, 80.00, 'submitted', '2026-05-04 13:06:37', '2026-05-04 13:07:17'),
(37, 11, 37, 40, NULL, '2026-05-04 09:09:30', '2026-05-04 09:10:04', 18, 4, 1, 0, 80.00, 'submitted', '2026-05-04 13:09:30', '2026-05-04 13:10:04'),
(38, 11, 38, 41, NULL, '2026-05-04 09:09:41', '2026-05-04 09:10:12', 16, 4, 1, 0, 80.00, 'submitted', '2026-05-04 13:09:41', '2026-05-04 13:10:12'),
(39, 9, 31, 42, NULL, '2026-05-05 16:36:26', '2026-05-05 16:37:03', 15, 4, 1, 0, 80.00, 'submitted', '2026-05-05 20:36:26', '2026-05-05 20:37:03'),
(40, 12, 31, 43, NULL, '2026-05-06 05:22:03', '2026-05-06 05:22:33', 19, 5, 0, 0, 100.00, 'submitted', '2026-05-06 09:22:03', '2026-05-06 09:22:33'),
(41, 12, 8, 44, NULL, '2026-05-06 12:11:12', '2026-05-06 12:11:43', 17, 4, 1, 0, 80.00, 'submitted', '2026-05-06 16:11:12', '2026-05-06 16:11:43'),
(42, 12, 40, 45, NULL, '2026-05-06 12:54:22', '2026-05-06 12:54:52', 18, 3, 2, 0, 60.00, 'submitted', '2026-05-06 16:54:22', '2026-05-06 16:54:52'),
(43, 12, 41, 46, NULL, '2026-05-06 12:54:58', '2026-05-06 12:55:45', 28, 5, 0, 0, 100.00, 'submitted', '2026-05-06 16:54:58', '2026-05-06 16:55:45'),
(44, 13, 41, 48, NULL, '2026-05-06 13:06:45', '2026-05-06 13:07:24', 20, 3, 2, 0, 60.00, 'submitted', '2026-05-06 17:06:45', '2026-05-06 17:07:24'),
(45, 13, 31, 49, NULL, '2026-05-06 13:08:00', '2026-05-06 13:08:35', 18, 5, 0, 0, 100.00, 'submitted', '2026-05-06 17:08:00', '2026-05-06 17:08:35'),
(46, 13, 42, 50, NULL, '2026-05-06 13:08:23', '2026-05-06 13:08:40', 6, 5, 0, 0, 100.00, 'submitted', '2026-05-06 17:08:23', '2026-05-06 17:08:40'),
(47, 13, 12, 51, NULL, '2026-05-06 13:08:28', '2026-05-06 13:09:07', 21, 4, 1, 0, 80.00, 'submitted', '2026-05-06 17:08:28', '2026-05-06 17:09:07'),
(48, 13, 40, 52, NULL, '2026-05-06 13:12:50', '2026-05-06 13:13:05', 6, 5, 0, 0, 100.00, 'submitted', '2026-05-06 17:12:50', '2026-05-06 17:13:05'),
(49, 14, 42, 53, NULL, '2026-05-06 13:53:32', '2026-05-06 13:53:53', 11, 5, 0, 0, 100.00, 'submitted', '2026-05-06 17:53:32', '2026-05-06 17:53:53'),
(50, 14, 41, 54, NULL, '2026-05-06 13:55:00', '2026-05-06 13:55:26', 10, 5, 0, 0, 100.00, 'submitted', '2026-05-06 17:55:00', '2026-05-06 17:55:26'),
(51, 14, 32, 55, NULL, '2026-05-06 14:32:20', '2026-05-06 14:33:37', 49, 5, 0, 0, 100.00, 'submitted', '2026-05-06 18:32:20', '2026-05-06 18:33:37'),
(52, 14, 8, 56, NULL, '2026-05-06 14:35:55', '2026-05-06 14:36:14', 8, 5, 0, 0, 100.00, 'submitted', '2026-05-06 18:35:55', '2026-05-06 18:36:14'),
(53, 15, 8, 57, NULL, '2026-05-07 05:25:18', '2026-05-07 05:25:44', 14, 4, 1, 0, 80.00, 'submitted', '2026-05-07 09:25:18', '2026-05-07 09:25:44'),
(54, 15, 32, 58, NULL, '2026-05-07 14:55:00', '2026-05-07 14:55:43', 15, 5, 0, 0, 100.00, 'submitted', '2026-05-07 18:55:00', '2026-05-07 18:55:43'),
(55, 15, 3, 59, NULL, '2026-05-08 03:47:29', '2026-05-08 03:48:11', 27, 4, 1, 0, 80.00, 'submitted', '2026-05-08 07:47:29', '2026-05-08 07:48:11'),
(56, 16, 8, 60, NULL, '2026-05-08 07:58:23', '2026-05-08 07:58:57', 12, 5, 0, 0, 100.00, 'submitted', '2026-05-08 11:58:23', '2026-05-08 11:58:57'),
(57, 16, 2, 61, NULL, '2026-05-10 12:44:28', '2026-05-10 12:44:44', 6, 5, 0, 0, 100.00, 'submitted', '2026-05-10 16:44:28', '2026-05-10 16:44:44'),
(58, 16, 15, 62, NULL, '2026-05-10 12:45:44', '2026-05-10 12:45:56', 5, 5, 0, 0, 100.00, 'submitted', '2026-05-10 16:45:44', '2026-05-10 16:45:56'),
(59, 17, 40, 63, NULL, '2026-05-10 13:01:30', '2026-05-10 13:01:53', 13, 3, 2, 0, 60.00, 'submitted', '2026-05-10 17:01:30', '2026-05-10 17:01:53'),
(60, 17, 41, 64, NULL, '2026-05-10 13:05:03', '2026-05-10 13:05:46', 25, 3, 2, 0, 60.00, 'submitted', '2026-05-10 17:05:03', '2026-05-10 17:05:46'),
(61, 17, 3, 65, NULL, '2026-05-10 13:13:37', NULL, NULL, 0, 0, 0, 0.00, 'started', '2026-05-10 17:13:37', '2026-05-10 17:13:37'),
(62, 18, 8, 66, NULL, '2026-05-10 13:50:59', '2026-05-10 13:51:30', 17, 5, 0, 0, 100.00, 'submitted', '2026-05-10 17:50:59', '2026-05-10 17:51:30'),
(63, 18, 45, 67, NULL, '2026-05-10 21:04:30', '2026-05-10 21:05:36', 47, 3, 2, 0, 60.00, 'submitted', '2026-05-11 01:04:30', '2026-05-11 01:05:36'),
(64, 18, 39, 68, NULL, '2026-05-12 08:04:37', '2026-05-12 08:05:22', 17, 4, 1, 0, 80.00, 'submitted', '2026-05-12 12:04:37', '2026-05-12 12:05:22'),
(65, 19, 8, 69, NULL, '2026-05-12 09:26:55', '2026-05-12 09:27:21', 14, 4, 1, 0, 80.00, 'submitted', '2026-05-12 13:26:55', '2026-05-12 13:27:21'),
(66, 20, 48, 70, NULL, '2026-05-12 09:59:06', '2026-05-12 09:59:55', 34, 4, 1, 0, 80.00, 'submitted', '2026-05-12 13:59:06', '2026-05-12 13:59:55'),
(67, 20, 49, 71, NULL, '2026-05-12 10:00:25', '2026-05-12 10:01:15', 33, 5, 0, 0, 100.00, 'submitted', '2026-05-12 14:00:25', '2026-05-12 14:01:15'),
(68, 19, 40, 72, NULL, '2026-05-12 10:09:15', '2026-05-12 10:09:39', 15, 4, 1, 0, 80.00, 'submitted', '2026-05-12 14:09:15', '2026-05-12 14:09:39'),
(69, 21, 50, 73, NULL, '2026-05-12 10:26:02', '2026-05-12 10:26:28', 11, 2, 1, 0, 66.67, 'submitted', '2026-05-12 14:26:02', '2026-05-12 14:26:28'),
(70, 21, 51, 74, NULL, '2026-05-12 10:27:14', '2026-05-12 10:27:28', 7, 3, 0, 0, 100.00, 'submitted', '2026-05-12 14:27:14', '2026-05-12 14:27:28'),
(71, 19, 49, 75, NULL, '2026-05-12 10:51:38', '2026-05-12 10:52:50', 52, 5, 0, 0, 100.00, 'submitted', '2026-05-12 14:51:38', '2026-05-12 14:52:50'),
(72, 22, 8, 76, NULL, '2026-05-12 11:03:24', '2026-05-12 11:03:51', 15, 4, 1, 0, 80.00, 'submitted', '2026-05-12 15:03:24', '2026-05-12 15:03:51'),
(73, 22, 49, 77, NULL, '2026-05-12 11:21:51', '2026-05-12 11:23:38', 89, 5, 0, 0, 100.00, 'submitted', '2026-05-12 15:21:51', '2026-05-12 15:23:38'),
(74, 22, 52, 78, NULL, '2026-05-12 11:40:52', '2026-05-12 11:41:11', 9, 5, 0, 0, 100.00, 'submitted', '2026-05-12 15:40:52', '2026-05-12 15:41:11'),
(75, 23, 49, 79, NULL, '2026-05-12 11:51:01', '2026-05-12 11:51:27', 12, 2, 1, 0, 66.67, 'submitted', '2026-05-12 15:51:01', '2026-05-12 15:51:27'),
(76, 23, 50, 80, NULL, '2026-05-14 04:35:03', '2026-05-14 04:35:16', 6, 2, 1, 0, 66.67, 'submitted', '2026-05-14 08:35:03', '2026-05-14 08:35:16'),
(77, 23, 40, 81, NULL, '2026-05-15 00:46:53', '2026-05-15 00:47:05', 7, 2, 1, 0, 66.67, 'submitted', '2026-05-15 04:46:53', '2026-05-15 04:47:05'),
(78, 24, 50, 82, NULL, '2026-05-16 14:09:14', '2026-05-16 14:09:36', 10, 3, 0, 0, 100.00, 'submitted', '2026-05-16 18:09:14', '2026-05-16 18:09:36'),
(79, 25, 8, 83, NULL, '2026-05-22 10:26:56', '2026-05-22 10:27:14', 10, 2, 1, 0, 66.67, 'submitted', '2026-05-22 14:26:56', '2026-05-22 14:27:14'),
(80, 25, 56, 84, NULL, '2026-05-23 04:34:47', '2026-05-23 04:37:14', 84, 3, 0, 0, 100.00, 'submitted', '2026-05-23 08:34:47', '2026-05-23 08:37:14'),
(81, 26, 8, 85, NULL, '2026-05-23 14:51:01', '2026-05-23 14:51:38', 30, 3, 0, 0, 100.00, 'submitted', '2026-05-23 18:51:01', '2026-05-23 18:51:38'),
(82, 28, 4, 86, NULL, '2026-06-06 09:31:07', '2026-06-06 09:32:12', 58, 1, 2, 0, 33.33, 'submitted', '2026-06-06 13:31:07', '2026-06-06 13:32:12'),
(83, 28, 17, 87, NULL, '2026-06-06 10:14:16', '2026-06-06 10:14:45', 14, 3, 0, 0, 100.00, 'submitted', '2026-06-06 14:14:16', '2026-06-06 14:14:45'),
(84, 28, 59, 88, NULL, '2026-06-06 10:20:05', '2026-06-06 10:20:26', 4, 3, 0, 0, 100.00, 'submitted', '2026-06-06 14:20:05', '2026-06-06 14:20:26'),
(85, 28, 8, 89, NULL, '2026-06-06 12:41:09', '2026-06-06 12:41:23', 9, 2, 1, 0, 66.67, 'submitted', '2026-06-06 16:41:09', '2026-06-06 16:41:23'),
(87, 28, 61, 91, NULL, '2026-06-06 12:47:34', '2026-06-06 12:47:45', 4, 3, 0, 0, 100.00, 'submitted', '2026-06-06 16:47:34', '2026-06-06 16:47:45'),
(93, 28, 67, 97, NULL, '2026-06-06 14:36:23', '2026-06-06 14:36:36', 3, 3, 0, 0, 100.00, 'submitted', '2026-06-06 18:36:23', '2026-06-06 18:36:36'),
(94, 28, 2, 98, NULL, '2026-06-17 04:45:29', '2026-06-17 04:45:50', 13, 2, 1, 0, 66.67, 'submitted', '2026-06-17 08:45:29', '2026-06-17 08:45:50'),
(95, 30, 17, 99, NULL, '2026-07-01 04:10:37', '2026-07-01 04:11:07', 11, 3, 0, 0, 100.00, 'submitted', '2026-07-01 08:10:37', '2026-07-01 08:11:07'),
(96, 30, 69, 100, NULL, '2026-07-01 04:18:14', '2026-07-01 04:18:33', 3, 3, 0, 0, 100.00, 'submitted', '2026-07-01 08:18:14', '2026-07-01 08:18:33'),
(97, 31, 71, 101, NULL, '2026-07-01 08:35:21', '2026-07-01 08:35:59', 20, 4, 1, 0, 80.00, 'submitted', '2026-07-01 12:35:21', '2026-07-01 12:35:59'),
(98, 31, 70, 102, NULL, '2026-07-01 08:36:34', '2026-07-01 08:37:04', 22, 4, 1, 0, 80.00, 'submitted', '2026-07-01 12:36:34', '2026-07-01 12:37:04'),
(99, 30, 8, 103, NULL, '2026-07-04 19:52:36', '2026-07-04 19:52:49', 6, 3, 0, 0, 100.00, 'submitted', '2026-07-04 23:52:36', '2026-07-04 23:52:49'),
(100, 32, 3, 106, NULL, '2026-08-14 08:59:36', '2026-08-14 09:00:39', 48, 4, 1, 0, 80.00, 'submitted', '2026-08-14 12:59:36', '2026-08-14 13:00:39'),
(101, 32, 72, 105, NULL, '2026-08-14 09:04:37', '2026-08-14 09:06:39', 61, 5, 0, 0, 100.00, 'submitted', '2026-08-14 13:04:37', '2026-08-14 13:06:39'),
(102, 32, 74, 104, NULL, '2026-08-14 09:26:33', '2026-08-14 09:30:41', 21, 4, 1, 0, 80.00, 'submitted', '2026-08-14 13:26:33', '2026-08-14 13:30:41'),
(103, 33, 72, 107, NULL, '2026-08-14 10:41:41', '2026-08-14 10:43:16', 74, 4, 1, 0, 80.00, 'submitted', '2026-08-14 14:41:41', '2026-08-14 14:43:16'),
(104, 33, 3, 108, NULL, '2026-08-14 12:42:40', '2026-08-14 12:43:30', 35, 4, 1, 0, 80.00, 'submitted', '2026-08-14 16:42:40', '2026-08-14 16:43:30'),
(105, 34, 72, 109, NULL, '2026-08-14 15:18:58', '2026-08-14 15:19:43', 28, 3, 0, 0, 100.00, 'submitted', '2026-08-14 19:18:58', '2026-08-14 19:19:43'),
(106, 35, 3, 110, NULL, '2026-08-20 20:45:19', '2026-08-20 20:45:39', 15, 3, 0, 0, 100.00, 'submitted', '2026-08-21 00:45:19', '2026-08-21 00:45:39'),
(107, 36, 3, 111, NULL, '2026-08-20 20:52:35', '2026-08-20 20:52:51', 11, 3, 0, 0, 100.00, 'submitted', '2026-08-21 00:52:35', '2026-08-21 00:52:51'),
(108, 37, 76, 112, NULL, '2026-08-30 21:17:31', '2026-08-30 21:17:58', 18, 4, 1, 0, 80.00, 'submitted', '2026-08-31 01:17:31', '2026-08-31 01:17:58'),
(109, 37, 3, 113, NULL, '2026-08-30 21:17:49', '2026-08-30 21:18:19', 23, 4, 1, 0, 80.00, 'submitted', '2026-08-31 01:17:49', '2026-08-31 01:18:19'),
(110, 38, 76, 114, NULL, '2026-08-30 21:38:19', '2026-08-30 21:38:58', 31, 3, 2, 0, 60.00, 'submitted', '2026-08-31 01:38:19', '2026-08-31 01:38:58'),
(111, 38, 3, 115, NULL, '2026-08-30 21:38:46', '2026-08-30 21:39:14', 20, 4, 1, 0, 80.00, 'submitted', '2026-08-31 01:38:46', '2026-08-31 01:39:14'),
(112, 38, 77, 116, NULL, '2026-08-31 05:58:03', '2026-08-31 05:58:54', 35, 5, 0, 0, 100.00, 'submitted', '2026-08-31 09:58:03', '2026-08-31 09:58:54'),
(113, 39, 77, 117, NULL, '2026-08-31 06:02:03', '2026-08-31 06:03:01', 45, 4, 1, 0, 80.00, 'submitted', '2026-08-31 10:02:03', '2026-08-31 10:03:01'),
(114, 40, 77, 118, NULL, '2026-08-31 06:47:02', '2026-08-31 06:48:00', 47, 3, 2, 0, 60.00, 'submitted', '2026-08-31 10:47:02', '2026-08-31 10:48:00'),
(115, 40, 79, 119, NULL, '2026-08-31 09:09:48', '2026-08-31 09:12:20', 134, 5, 0, 0, 100.00, 'submitted', '2026-08-31 13:09:48', '2026-08-31 13:12:20'),
(116, 41, 80, 120, NULL, '2026-08-31 09:44:59', '2026-08-31 09:45:29', 17, 5, 0, 0, 100.00, 'submitted', '2026-08-31 13:44:59', '2026-08-31 13:45:29'),
(117, 42, 79, 121, NULL, '2026-08-31 14:48:19', '2026-08-31 14:49:53', 86, 3, 0, 0, 100.00, 'submitted', '2026-08-31 18:48:19', '2026-08-31 18:49:53'),
(118, 42, 80, 122, NULL, '2026-08-31 19:42:18', '2026-08-31 19:42:37', 12, 2, 1, 0, 66.67, 'submitted', '2026-08-31 23:42:18', '2026-08-31 23:42:37'),
(119, 43, 80, 123, NULL, '2026-09-01 10:22:05', '2026-09-01 10:22:31', 16, 3, 0, 0, 100.00, 'submitted', '2026-09-01 14:22:05', '2026-09-01 14:22:31'),
(120, 43, 82, 124, NULL, '2026-09-01 22:16:39', '2026-09-01 22:17:25', 8, 2, 1, 0, 66.67, 'submitted', '2026-09-02 02:16:39', '2026-09-02 02:17:25'),
(121, 43, 79, 125, NULL, '2026-09-02 15:52:33', '2026-09-02 15:55:08', 146, 3, 0, 0, 100.00, 'submitted', '2026-09-02 19:52:33', '2026-09-02 19:55:08'),
(122, 43, 3, 126, NULL, '2026-09-12 11:47:37', '2026-09-12 11:48:20', 37, 1, 2, 0, 33.33, 'submitted', '2026-09-12 15:47:37', '2026-09-12 15:48:20');

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
(68, 16, 4, 196, 13, 'true', 1, '2026-04-25 11:49:10', 6, '2026-04-25 15:49:10'),
(69, 16, 4, 96, 13, 'true', 1, '2026-04-25 11:49:10', 4, '2026-04-25 15:49:10'),
(70, 16, 4, 39, 13, 'true', 1, '2026-04-25 11:49:10', 3, '2026-04-25 15:49:10'),
(71, 17, 4, 196, 15, 'true', 1, '2026-04-25 11:59:52', 7, '2026-04-25 15:59:52'),
(72, 17, 4, 39, 15, 'true', 1, '2026-04-25 11:59:52', 5, '2026-04-25 15:59:52'),
(73, 17, 4, 96, 15, 'true', 1, '2026-04-25 11:59:52', 2, '2026-04-25 15:59:52'),
(74, 18, 4, 196, 8, 'true', 1, '2026-04-25 14:05:38', 5, '2026-04-25 18:05:38'),
(75, 18, 4, 96, 8, 'true', 1, '2026-04-25 14:05:38', 2, '2026-04-25 18:05:38'),
(76, 18, 4, 39, 8, 'true', 1, '2026-04-25 14:05:38', 2, '2026-04-25 18:05:38'),
(77, 19, 5, 187, 17, 'true', 0, '2026-04-25 16:17:05', 11, '2026-04-25 20:17:05'),
(78, 19, 5, 303, 17, 'true', 1, '2026-04-25 16:17:05', 4, '2026-04-25 20:17:05'),
(79, 19, 5, 42, 17, 'false', 1, '2026-04-25 16:17:05', 6, '2026-04-25 20:17:05'),
(80, 20, 5, 187, 8, 'false', 1, '2026-04-25 16:36:56', 3, '2026-04-25 20:36:56'),
(81, 20, 5, 303, 8, 'true', 1, '2026-04-25 16:36:56', 3, '2026-04-25 20:36:56'),
(82, 20, 5, 42, 8, 'false', 1, '2026-04-25 16:36:56', 3, '2026-04-25 20:36:56'),
(83, 21, 5, 303, 19, 'true', 1, '2026-04-26 10:03:25', 5, '2026-04-26 14:03:25'),
(84, 21, 5, 42, 19, 'false', 1, '2026-04-26 10:03:25', 4, '2026-04-26 14:03:25'),
(85, 21, 5, 187, 19, 'false', 1, '2026-04-26 10:03:25', 4, '2026-04-26 14:03:25'),
(86, 22, 6, 40, 8, 'false', 1, '2026-04-26 11:21:44', 3, '2026-04-26 15:21:44'),
(87, 22, 6, 230, 8, 'true', 1, '2026-04-26 11:21:44', 2, '2026-04-26 15:21:44'),
(88, 22, 6, 153, 8, 'true', 1, '2026-04-26 11:21:44', 1, '2026-04-26 15:21:44'),
(89, 23, 6, 40, 17, 'false', 1, '2026-04-27 16:26:30', 2, '2026-04-27 20:26:30'),
(90, 23, 6, 230, 17, 'true', 1, '2026-04-27 16:26:30', 2, '2026-04-27 20:26:30'),
(91, 23, 6, 153, 17, 'true', 1, '2026-04-27 16:26:30', 1, '2026-04-27 20:26:30'),
(92, 24, 6, 40, 3, 'true', 0, '2026-04-27 16:34:33', 9, '2026-04-27 20:34:33'),
(93, 24, 6, 230, 3, 'true', 1, '2026-04-27 16:34:33', 7, '2026-04-27 20:34:33'),
(94, 24, 6, 153, 3, 'true', 1, '2026-04-27 16:34:33', 7, '2026-04-27 20:34:33'),
(95, 25, 7, 93, 8, 'true', 1, '2026-04-28 09:48:34', 2, '2026-04-28 13:48:34'),
(96, 25, 7, 195, 8, 'false', 1, '2026-04-28 09:48:34', 2, '2026-04-28 13:48:34'),
(97, 25, 7, 54, 8, 'true', 1, '2026-04-28 09:48:34', 1, '2026-04-28 13:48:34'),
(98, 26, 7, 93, 25, 'true', 1, '2026-04-28 10:41:40', 4, '2026-04-28 14:41:40'),
(99, 26, 7, 195, 25, 'false', 1, '2026-04-28 10:41:40', 5, '2026-04-28 14:41:40'),
(100, 26, 7, 54, 25, 'true', 1, '2026-04-28 10:41:40', 3, '2026-04-28 14:41:40'),
(101, 27, 7, 93, 14, 'true', 1, '2026-04-29 09:58:15', 13, '2026-04-29 13:58:15'),
(102, 27, 7, 195, 14, 'true', 0, '2026-04-29 09:58:15', 7, '2026-04-29 13:58:15'),
(103, 27, 7, 54, 14, 'true', 1, '2026-04-29 09:58:15', 6, '2026-04-29 13:58:15'),
(104, 28, 8, 57, 25, 'false', 1, '2026-04-30 02:05:45', 6, '2026-04-30 06:05:45'),
(105, 28, 8, 80, 25, 'false', 0, '2026-04-30 02:05:45', 9, '2026-04-30 06:05:45'),
(106, 28, 8, 251, 25, 'false', 1, '2026-04-30 02:05:45', 14, '2026-04-30 06:05:45'),
(107, 28, 8, 142, 25, 'true', 1, '2026-04-30 02:05:45', 4, '2026-04-30 06:05:45'),
(108, 28, 8, 324, 25, 'false', 0, '2026-04-30 02:05:45', 9, '2026-04-30 06:05:45'),
(109, 29, 8, 80, 8, 'true', 1, '2026-04-30 17:32:17', 3, '2026-04-30 21:32:17'),
(110, 29, 8, 251, 8, 'false', 1, '2026-04-30 17:32:17', 2, '2026-04-30 21:32:17'),
(111, 29, 8, 324, 8, 'true', 1, '2026-04-30 17:32:17', 3, '2026-04-30 21:32:17'),
(112, 29, 8, 142, 8, 'true', 1, '2026-04-30 17:32:17', 2, '2026-04-30 21:32:17'),
(113, 29, 8, 57, 8, 'false', 1, '2026-04-30 17:32:17', 2, '2026-04-30 21:32:17'),
(114, 30, 8, 80, 11, 'true', 1, '2026-05-01 04:44:21', 70, '2026-05-01 08:44:21'),
(115, 30, 8, 57, 11, 'false', 1, '2026-05-01 04:44:21', 4, '2026-05-01 08:44:21'),
(116, 30, 8, 324, 11, 'false', 0, '2026-05-01 04:44:21', 37, '2026-05-01 08:44:21'),
(117, 30, 8, 251, 11, 'false', 1, '2026-05-01 04:44:21', 5, '2026-05-01 08:44:21'),
(118, 30, 8, 142, 11, 'true', 1, '2026-05-01 04:44:21', 6, '2026-05-01 08:44:21'),
(119, 31, 9, 56, 8, 'true', 1, '2026-05-01 15:37:55', 3, '2026-05-01 19:37:55'),
(120, 31, 9, 97, 8, 'false', 1, '2026-05-01 15:37:55', 3, '2026-05-01 19:37:55'),
(121, 31, 9, 216, 8, 'true', 1, '2026-05-01 15:37:55', 2, '2026-05-01 19:37:55'),
(122, 31, 9, 102, 8, 'true', 1, '2026-05-01 15:37:55', 3, '2026-05-01 19:37:55'),
(123, 31, 9, 355, 8, 'true', 1, '2026-05-01 15:37:55', 3, '2026-05-01 19:37:55'),
(124, 32, 10, 301, 28, 'true', 1, '2026-05-04 06:16:07', 5, '2026-05-04 10:16:07'),
(125, 32, 10, 287, 28, 'true', 1, '2026-05-04 06:16:07', 2, '2026-05-04 10:16:07'),
(126, 32, 10, 313, 28, 'false', 1, '2026-05-04 06:16:07', 2, '2026-05-04 10:16:07'),
(127, 32, 10, 176, 28, 'true', 1, '2026-05-04 06:16:07', 2, '2026-05-04 10:16:07'),
(128, 32, 10, 214, 28, 'true', 1, '2026-05-04 06:16:07', 2, '2026-05-04 10:16:07'),
(129, 33, 10, 313, 30, 'false', 1, '2026-05-04 06:18:41', 7, '2026-05-04 10:18:41'),
(130, 33, 10, 214, 30, 'true', 1, '2026-05-04 06:18:41', 2, '2026-05-04 10:18:41'),
(131, 33, 10, 176, 30, 'true', 1, '2026-05-04 06:18:41', 2, '2026-05-04 10:18:41'),
(132, 33, 10, 287, 30, 'true', 1, '2026-05-04 06:18:41', 2, '2026-05-04 10:18:41'),
(133, 33, 10, 301, 30, 'true', 1, '2026-05-04 06:18:41', 2, '2026-05-04 10:18:41'),
(134, 34, 10, 176, 29, 'true', 1, '2026-05-04 06:22:37', 4, '2026-05-04 10:22:37'),
(135, 34, 10, 214, 29, 'true', 1, '2026-05-04 06:22:37', 4, '2026-05-04 10:22:37'),
(136, 34, 10, 313, 29, 'false', 1, '2026-05-04 06:22:37', 4, '2026-05-04 10:22:37'),
(137, 34, 10, 287, 29, 'true', 1, '2026-05-04 06:22:37', 3, '2026-05-04 10:22:37'),
(138, 34, 10, 301, 29, 'true', 1, '2026-05-04 06:22:37', 5, '2026-05-04 10:22:37'),
(139, 35, 9, 102, 12, 'true', 1, '2026-05-04 07:14:24', 6, '2026-05-04 11:14:24'),
(140, 35, 9, 216, 12, 'true', 1, '2026-05-04 07:14:24', 4, '2026-05-04 11:14:24'),
(141, 35, 9, 56, 12, 'true', 1, '2026-05-04 07:14:24', 3, '2026-05-04 11:14:24'),
(142, 35, 9, 97, 12, 'false', 1, '2026-05-04 07:14:24', 3, '2026-05-04 11:14:24'),
(143, 35, 9, 355, 12, 'false', 0, '2026-05-04 07:14:24', 6, '2026-05-04 11:14:24'),
(144, 36, 11, 343, 36, 'true', 1, '2026-05-04 09:07:17', 5, '2026-05-04 13:07:17'),
(145, 36, 11, 339, 36, 'false', 1, '2026-05-04 09:07:17', 5, '2026-05-04 13:07:17'),
(146, 36, 11, 112, 36, 'true', 1, '2026-05-04 09:07:17', 3, '2026-05-04 13:07:17'),
(147, 36, 11, 163, 36, 'true', 1, '2026-05-04 09:07:17', 12, '2026-05-04 13:07:17'),
(148, 36, 11, 307, 36, 'false', 0, '2026-05-04 09:07:17', 4, '2026-05-04 13:07:17'),
(149, 37, 11, 112, 37, 'true', 1, '2026-05-04 09:10:04', 4, '2026-05-04 13:10:04'),
(150, 37, 11, 339, 37, 'true', 0, '2026-05-04 09:10:04', 6, '2026-05-04 13:10:04'),
(151, 37, 11, 307, 37, 'true', 1, '2026-05-04 09:10:04', 2, '2026-05-04 13:10:04'),
(152, 37, 11, 343, 37, 'true', 1, '2026-05-04 09:10:04', 2, '2026-05-04 13:10:04'),
(153, 37, 11, 163, 37, 'true', 1, '2026-05-04 09:10:04', 4, '2026-05-04 13:10:04'),
(154, 38, 11, 307, 38, 'true', 1, '2026-05-04 09:10:12', 3, '2026-05-04 13:10:12'),
(155, 38, 11, 112, 38, 'true', 1, '2026-05-04 09:10:12', 3, '2026-05-04 13:10:12'),
(156, 38, 11, 339, 38, 'true', 0, '2026-05-04 09:10:12', 5, '2026-05-04 13:10:12'),
(157, 38, 11, 343, 38, 'true', 1, '2026-05-04 09:10:12', 3, '2026-05-04 13:10:12'),
(158, 38, 11, 163, 38, 'true', 1, '2026-05-04 09:10:12', 2, '2026-05-04 13:10:12'),
(159, 39, 9, 102, 31, 'true', 1, '2026-05-05 16:37:03', 5, '2026-05-05 20:37:03'),
(160, 39, 9, 216, 31, 'true', 1, '2026-05-05 16:37:03', 3, '2026-05-05 20:37:03'),
(161, 39, 9, 56, 31, 'true', 1, '2026-05-05 16:37:03', 2, '2026-05-05 20:37:03'),
(162, 39, 9, 97, 31, 'false', 1, '2026-05-05 16:37:03', 2, '2026-05-05 20:37:03'),
(163, 39, 9, 355, 31, 'false', 0, '2026-05-05 16:37:03', 3, '2026-05-05 20:37:03'),
(164, 40, 12, 65, 31, 'false', 1, '2026-05-06 05:22:33', 3, '2026-05-06 09:22:33'),
(165, 40, 12, 119, 31, 'true', 1, '2026-05-06 05:22:33', 3, '2026-05-06 09:22:33'),
(166, 40, 12, 321, 31, 'true', 1, '2026-05-06 05:22:33', 4, '2026-05-06 09:22:33'),
(167, 40, 12, 288, 31, 'false', 1, '2026-05-06 05:22:33', 2, '2026-05-06 09:22:33'),
(168, 40, 12, 329, 31, 'true', 1, '2026-05-06 05:22:33', 7, '2026-05-06 09:22:33'),
(169, 41, 12, 329, 8, 'false', 0, '2026-05-06 12:11:43', 5, '2026-05-06 16:11:43'),
(170, 41, 12, 119, 8, 'true', 1, '2026-05-06 12:11:43', 3, '2026-05-06 16:11:43'),
(171, 41, 12, 321, 8, 'true', 1, '2026-05-06 12:11:43', 6, '2026-05-06 16:11:43'),
(172, 41, 12, 65, 8, 'false', 1, '2026-05-06 12:11:43', 2, '2026-05-06 16:11:43'),
(173, 41, 12, 288, 8, 'false', 1, '2026-05-06 12:11:43', 1, '2026-05-06 16:11:43'),
(174, 42, 12, 321, 40, 'false', 0, '2026-05-06 12:54:52', 8, '2026-05-06 16:54:52'),
(175, 42, 12, 65, 40, 'false', 1, '2026-05-06 12:54:52', 2, '2026-05-06 16:54:52'),
(176, 42, 12, 329, 40, 'false', 0, '2026-05-06 12:54:52', 4, '2026-05-06 16:54:52'),
(177, 42, 12, 119, 40, 'true', 1, '2026-05-06 12:54:52', 3, '2026-05-06 16:54:52'),
(178, 42, 12, 288, 40, 'false', 1, '2026-05-06 12:54:52', 1, '2026-05-06 16:54:52'),
(179, 43, 12, 288, 41, 'false', 1, '2026-05-06 12:55:45', 6, '2026-05-06 16:55:45'),
(180, 43, 12, 65, 41, 'false', 1, '2026-05-06 12:55:45', 3, '2026-05-06 16:55:45'),
(181, 43, 12, 329, 41, 'true', 1, '2026-05-06 12:55:45', 4, '2026-05-06 16:55:45'),
(182, 43, 12, 321, 41, 'true', 1, '2026-05-06 12:55:45', 11, '2026-05-06 16:55:45'),
(183, 43, 12, 119, 41, 'true', 1, '2026-05-06 12:55:45', 4, '2026-05-06 16:55:45'),
(184, 44, 13, 70, 41, 'true', 1, '2026-05-06 13:07:24', 4, '2026-05-06 17:07:24'),
(185, 44, 13, 73, 41, 'false', 0, '2026-05-06 13:07:24', 3, '2026-05-06 17:07:24'),
(186, 44, 13, 122, 41, 'true', 1, '2026-05-06 13:07:24', 3, '2026-05-06 17:07:24'),
(187, 44, 13, 107, 41, 'false', 1, '2026-05-06 13:07:24', 3, '2026-05-06 17:07:24'),
(188, 44, 13, 349, 41, 'false', 0, '2026-05-06 13:07:24', 7, '2026-05-06 17:07:24'),
(189, 45, 13, 349, 31, 'true', 1, '2026-05-06 13:08:35', 6, '2026-05-06 17:08:35'),
(190, 45, 13, 107, 31, 'false', 1, '2026-05-06 13:08:35', 4, '2026-05-06 17:08:35'),
(191, 45, 13, 73, 31, 'true', 1, '2026-05-06 13:08:35', 3, '2026-05-06 17:08:35'),
(192, 45, 13, 70, 31, 'true', 1, '2026-05-06 13:08:35', 3, '2026-05-06 17:08:35'),
(193, 45, 13, 122, 31, 'true', 1, '2026-05-06 13:08:35', 2, '2026-05-06 17:08:35'),
(194, 46, 13, 349, 42, 'true', 1, '2026-05-06 13:08:40', 2, '2026-05-06 17:08:40'),
(195, 46, 13, 122, 42, 'true', 1, '2026-05-06 13:08:40', 1, '2026-05-06 17:08:40'),
(196, 46, 13, 73, 42, 'true', 1, '2026-05-06 13:08:40', 1, '2026-05-06 17:08:40'),
(197, 46, 13, 70, 42, 'true', 1, '2026-05-06 13:08:40', 1, '2026-05-06 17:08:40'),
(198, 46, 13, 107, 42, 'false', 1, '2026-05-06 13:08:40', 1, '2026-05-06 17:08:40'),
(199, 47, 13, 73, 12, 'true', 1, '2026-05-06 13:09:07', 5, '2026-05-06 17:09:07'),
(200, 47, 13, 70, 12, 'true', 1, '2026-05-06 13:09:07', 2, '2026-05-06 17:09:07'),
(201, 47, 13, 349, 12, 'false', 0, '2026-05-06 13:09:07', 8, '2026-05-06 17:09:07'),
(202, 47, 13, 122, 12, 'true', 1, '2026-05-06 13:09:07', 2, '2026-05-06 17:09:07'),
(203, 47, 13, 107, 12, 'false', 1, '2026-05-06 13:09:07', 4, '2026-05-06 17:09:07'),
(204, 48, 13, 70, 40, 'true', 1, '2026-05-06 13:13:05', 2, '2026-05-06 17:13:05'),
(205, 48, 13, 122, 40, 'true', 1, '2026-05-06 13:13:05', 1, '2026-05-06 17:13:05'),
(206, 48, 13, 73, 40, 'true', 1, '2026-05-06 13:13:05', 1, '2026-05-06 17:13:05'),
(207, 48, 13, 107, 40, 'false', 1, '2026-05-06 13:13:05', 1, '2026-05-06 17:13:05'),
(208, 48, 13, 349, 40, 'true', 1, '2026-05-06 13:13:05', 1, '2026-05-06 17:13:05'),
(209, 49, 14, 79, 42, 'false', 1, '2026-05-06 13:53:53', 3, '2026-05-06 17:53:53'),
(210, 49, 14, 95, 42, 'false', 1, '2026-05-06 13:53:53', 2, '2026-05-06 17:53:53'),
(211, 49, 14, 138, 42, 'true', 1, '2026-05-06 13:53:53', 2, '2026-05-06 17:53:53'),
(212, 49, 14, 99, 42, 'false', 1, '2026-05-06 13:53:53', 2, '2026-05-06 17:53:53'),
(213, 49, 14, 295, 42, 'false', 1, '2026-05-06 13:53:53', 2, '2026-05-06 17:53:53'),
(214, 50, 14, 295, 41, 'false', 1, '2026-05-06 13:55:26', 2, '2026-05-06 17:55:26'),
(215, 50, 14, 99, 41, 'false', 1, '2026-05-06 13:55:26', 2, '2026-05-06 17:55:26'),
(216, 50, 14, 138, 41, 'true', 1, '2026-05-06 13:55:26', 2, '2026-05-06 17:55:26'),
(217, 50, 14, 79, 41, 'false', 1, '2026-05-06 13:55:26', 2, '2026-05-06 17:55:26'),
(218, 50, 14, 95, 41, 'false', 1, '2026-05-06 13:55:26', 2, '2026-05-06 17:55:26'),
(219, 51, 14, 99, 32, 'false', 1, '2026-05-06 14:33:37', 4, '2026-05-06 18:33:37'),
(220, 51, 14, 95, 32, 'false', 1, '2026-05-06 14:33:37', 6, '2026-05-06 18:33:37'),
(221, 51, 14, 79, 32, 'false', 1, '2026-05-06 14:33:37', 33, '2026-05-06 18:33:37'),
(222, 51, 14, 295, 32, 'false', 1, '2026-05-06 14:33:37', 4, '2026-05-06 18:33:37'),
(223, 51, 14, 138, 32, 'true', 1, '2026-05-06 14:33:37', 2, '2026-05-06 18:33:37'),
(224, 52, 14, 138, 8, 'true', 1, '2026-05-06 14:36:14', 2, '2026-05-06 18:36:14'),
(225, 52, 14, 95, 8, 'false', 1, '2026-05-06 14:36:14', 2, '2026-05-06 18:36:14'),
(226, 52, 14, 295, 8, 'false', 1, '2026-05-06 14:36:14', 1, '2026-05-06 18:36:14'),
(227, 52, 14, 99, 8, 'false', 1, '2026-05-06 14:36:14', 1, '2026-05-06 18:36:14'),
(228, 52, 14, 79, 8, 'false', 1, '2026-05-06 14:36:14', 2, '2026-05-06 18:36:14'),
(229, 53, 15, 131, 8, 'true', 0, '2026-05-07 05:25:44', 2, '2026-05-07 09:25:44'),
(230, 53, 15, 346, 8, 'false', 1, '2026-05-07 05:25:44', 3, '2026-05-07 09:25:44'),
(231, 53, 15, 271, 8, 'false', 1, '2026-05-07 05:25:44', 5, '2026-05-07 09:25:44'),
(232, 53, 15, 140, 8, 'true', 1, '2026-05-07 05:25:44', 2, '2026-05-07 09:25:44'),
(233, 53, 15, 219, 8, 'false', 1, '2026-05-07 05:25:44', 2, '2026-05-07 09:25:44'),
(234, 54, 15, 219, 32, 'false', 1, '2026-05-07 14:55:43', 3, '2026-05-07 18:55:43'),
(235, 54, 15, 346, 32, 'false', 1, '2026-05-07 14:55:43', 4, '2026-05-07 18:55:43'),
(236, 54, 15, 140, 32, 'true', 1, '2026-05-07 14:55:43', 3, '2026-05-07 18:55:43'),
(237, 54, 15, 271, 32, 'false', 1, '2026-05-07 14:55:43', 2, '2026-05-07 18:55:43'),
(238, 54, 15, 131, 32, 'false', 1, '2026-05-07 14:55:43', 3, '2026-05-07 18:55:43'),
(239, 55, 15, 271, 3, 'false', 1, '2026-05-08 03:48:11', 6, '2026-05-08 07:48:11'),
(240, 55, 15, 346, 3, 'true', 0, '2026-05-08 03:48:11', 7, '2026-05-08 07:48:11'),
(241, 55, 15, 131, 3, 'false', 1, '2026-05-08 03:48:11', 9, '2026-05-08 07:48:11'),
(242, 55, 15, 219, 3, 'false', 1, '2026-05-08 03:48:11', 2, '2026-05-08 07:48:11'),
(243, 55, 15, 140, 3, 'true', 1, '2026-05-08 03:48:11', 3, '2026-05-08 07:48:11'),
(244, 56, 16, 228, 8, 'true', 1, '2026-05-08 07:58:57', 2, '2026-05-08 11:58:57'),
(245, 56, 16, 264, 8, 'true', 1, '2026-05-08 07:58:57', 1, '2026-05-08 11:58:57'),
(246, 56, 16, 545, 8, 'true', 1, '2026-05-08 07:58:57', 2, '2026-05-08 11:58:57'),
(247, 56, 16, 471, 8, 'true', 1, '2026-05-08 07:58:57', 5, '2026-05-08 11:58:57'),
(248, 56, 16, 623, 8, 'true', 1, '2026-05-08 07:58:57', 2, '2026-05-08 11:58:57'),
(249, 57, 16, 471, 2, 'true', 1, '2026-05-10 12:44:44', 1, '2026-05-10 16:44:44'),
(250, 57, 16, 623, 2, 'true', 1, '2026-05-10 12:44:44', 1, '2026-05-10 16:44:44'),
(251, 57, 16, 264, 2, 'true', 1, '2026-05-10 12:44:44', 1, '2026-05-10 16:44:44'),
(252, 57, 16, 545, 2, 'true', 1, '2026-05-10 12:44:44', 1, '2026-05-10 16:44:44'),
(253, 57, 16, 228, 2, 'true', 1, '2026-05-10 12:44:44', 2, '2026-05-10 16:44:44'),
(254, 58, 16, 623, 15, 'true', 1, '2026-05-10 12:45:56', 1, '2026-05-10 16:45:56'),
(255, 58, 16, 545, 15, 'true', 1, '2026-05-10 12:45:56', 1, '2026-05-10 16:45:56'),
(256, 58, 16, 471, 15, 'true', 1, '2026-05-10 12:45:56', 1, '2026-05-10 16:45:56'),
(257, 58, 16, 264, 15, 'true', 1, '2026-05-10 12:45:56', 1, '2026-05-10 16:45:56'),
(258, 58, 16, 228, 15, 'true', 1, '2026-05-10 12:45:56', 1, '2026-05-10 16:45:56'),
(259, 59, 17, 436, 40, 'false', 0, '2026-05-10 13:01:53', 3, '2026-05-10 17:01:53'),
(260, 59, 17, 442, 40, 'false', 1, '2026-05-10 13:01:53', 3, '2026-05-10 17:01:53'),
(261, 59, 17, 286, 40, 'false', 1, '2026-05-10 13:01:53', 2, '2026-05-10 17:01:53'),
(262, 59, 17, 180, 40, 'true', 1, '2026-05-10 13:01:53', 2, '2026-05-10 17:01:53'),
(263, 59, 17, 571, 40, 'false', 0, '2026-05-10 13:01:53', 3, '2026-05-10 17:01:53'),
(264, 60, 17, 286, 41, 'false', 1, '2026-05-10 13:05:46', 3, '2026-05-10 17:05:46'),
(265, 60, 17, 571, 41, 'false', 0, '2026-05-10 13:05:46', 7, '2026-05-10 17:05:46'),
(266, 60, 17, 180, 41, 'true', 1, '2026-05-10 13:05:46', 4, '2026-05-10 17:05:46'),
(267, 60, 17, 442, 41, 'false', 1, '2026-05-10 13:05:46', 4, '2026-05-10 17:05:46'),
(268, 60, 17, 436, 41, 'false', 0, '2026-05-10 13:05:46', 7, '2026-05-10 17:05:46'),
(269, 62, 18, 88, 8, 'false', 1, '2026-05-10 13:51:30', 3, '2026-05-10 17:51:30'),
(270, 62, 18, 563, 8, 'true', 1, '2026-05-10 13:51:30', 6, '2026-05-10 17:51:30'),
(271, 62, 18, 575, 8, 'true', 1, '2026-05-10 13:51:30', 4, '2026-05-10 17:51:30'),
(272, 62, 18, 256, 8, 'true', 1, '2026-05-10 13:51:30', 2, '2026-05-10 17:51:30'),
(273, 62, 18, 115, 8, 'true', 1, '2026-05-10 13:51:30', 2, '2026-05-10 17:51:30'),
(274, 63, 18, 563, 45, 'false', 0, '2026-05-10 21:05:36', 19, '2026-05-11 01:05:36'),
(275, 63, 18, 256, 45, 'true', 1, '2026-05-10 21:05:36', 8, '2026-05-11 01:05:36'),
(276, 63, 18, 575, 45, 'true', 1, '2026-05-10 21:05:36', 11, '2026-05-11 01:05:36'),
(277, 63, 18, 88, 45, 'false', 1, '2026-05-10 21:05:36', 6, '2026-05-11 01:05:36'),
(278, 63, 18, 115, 45, 'false', 0, '2026-05-10 21:05:36', 3, '2026-05-11 01:05:36'),
(279, 64, 18, 563, 39, 'true', 1, '2026-05-12 08:05:22', 5, '2026-05-12 12:05:22'),
(280, 64, 18, 575, 39, 'true', 1, '2026-05-12 08:05:22', 6, '2026-05-12 12:05:22'),
(281, 64, 18, 256, 39, 'true', 1, '2026-05-12 08:05:22', 2, '2026-05-12 12:05:22'),
(282, 64, 18, 88, 39, 'false', 1, '2026-05-12 08:05:22', 2, '2026-05-12 12:05:22'),
(283, 64, 18, 115, 39, 'false', 0, '2026-05-12 08:05:22', 2, '2026-05-12 12:05:22'),
(284, 65, 19, 455, 8, 'false', 0, '2026-05-12 09:27:21', 3, '2026-05-12 13:27:21'),
(285, 65, 19, 224, 8, 'true', 1, '2026-05-12 09:27:21', 2, '2026-05-12 13:27:21'),
(286, 65, 19, 580, 8, 'true', 1, '2026-05-12 09:27:21', 3, '2026-05-12 13:27:21'),
(287, 65, 19, 360, 8, 'false', 1, '2026-05-12 09:27:21', 2, '2026-05-12 13:27:21'),
(288, 65, 19, 188, 8, 'true', 1, '2026-05-12 09:27:21', 4, '2026-05-12 13:27:21'),
(289, 66, 20, 463, 48, 'true', 1, '2026-05-12 09:59:55', 5, '2026-05-12 13:59:55'),
(290, 66, 20, 440, 48, 'false', 0, '2026-05-12 09:59:55', 7, '2026-05-12 13:59:55'),
(291, 66, 20, 47, 48, 'true', 1, '2026-05-12 09:59:55', 6, '2026-05-12 13:59:55'),
(292, 66, 20, 496, 48, 'true', 1, '2026-05-12 09:59:55', 12, '2026-05-12 13:59:55'),
(293, 66, 20, 71, 48, 'false', 1, '2026-05-12 09:59:55', 4, '2026-05-12 13:59:55'),
(294, 67, 20, 496, 49, 'true', 1, '2026-05-12 10:01:15', 8, '2026-05-12 14:01:15'),
(295, 67, 20, 47, 49, 'true', 1, '2026-05-12 10:01:15', 4, '2026-05-12 14:01:15'),
(296, 67, 20, 463, 49, 'true', 1, '2026-05-12 10:01:15', 5, '2026-05-12 14:01:15'),
(297, 67, 20, 71, 49, 'false', 1, '2026-05-12 10:01:15', 12, '2026-05-12 14:01:15'),
(298, 67, 20, 440, 49, 'true', 1, '2026-05-12 10:01:15', 4, '2026-05-12 14:01:15'),
(299, 68, 19, 224, 40, 'true', 1, '2026-05-12 10:09:39', 2, '2026-05-12 14:09:39'),
(300, 68, 19, 360, 40, 'false', 1, '2026-05-12 10:09:39', 4, '2026-05-12 14:09:39'),
(301, 68, 19, 188, 40, 'true', 1, '2026-05-12 10:09:39', 2, '2026-05-12 14:09:39'),
(302, 68, 19, 455, 40, 'false', 0, '2026-05-12 10:09:39', 4, '2026-05-12 14:09:39'),
(303, 68, 19, 580, 40, 'true', 1, '2026-05-12 10:09:39', 3, '2026-05-12 14:09:39'),
(304, 69, 21, 428, 50, 'false', 0, '2026-05-12 10:26:28', 7, '2026-05-12 14:26:28'),
(305, 69, 21, 120, 50, 'true', 1, '2026-05-12 10:26:28', 2, '2026-05-12 14:26:28'),
(306, 69, 21, 128, 50, 'true', 1, '2026-05-12 10:26:28', 2, '2026-05-12 14:26:28'),
(307, 70, 21, 428, 51, 'true', 1, '2026-05-12 10:27:28', 4, '2026-05-12 14:27:28'),
(308, 70, 21, 120, 51, 'true', 1, '2026-05-12 10:27:28', 2, '2026-05-12 14:27:28'),
(309, 70, 21, 128, 51, 'true', 1, '2026-05-12 10:27:28', 1, '2026-05-12 14:27:28'),
(310, 71, 19, 455, 49, 'true', 1, '2026-05-12 10:52:50', 17, '2026-05-12 14:52:50'),
(311, 71, 19, 224, 49, 'true', 1, '2026-05-12 10:52:50', 6, '2026-05-12 14:52:50'),
(312, 71, 19, 360, 49, 'false', 1, '2026-05-12 10:52:50', 11, '2026-05-12 14:52:50'),
(313, 71, 19, 580, 49, 'true', 1, '2026-05-12 10:52:50', 12, '2026-05-12 14:52:50'),
(314, 71, 19, 188, 49, 'true', 1, '2026-05-12 10:52:50', 6, '2026-05-12 14:52:50'),
(315, 72, 22, 344, 8, 'true', 0, '2026-05-12 11:03:51', 4, '2026-05-12 15:03:51'),
(316, 72, 22, 22, 8, 'true', 1, '2026-05-12 11:03:51', 2, '2026-05-12 15:03:51'),
(317, 72, 22, 371, 8, 'false', 1, '2026-05-12 11:03:51', 3, '2026-05-12 15:03:51'),
(318, 72, 22, 222, 8, 'true', 1, '2026-05-12 11:03:51', 3, '2026-05-12 15:03:51'),
(319, 72, 22, 481, 8, 'true', 1, '2026-05-12 11:03:51', 3, '2026-05-12 15:03:51'),
(320, 73, 22, 222, 49, 'true', 1, '2026-05-12 11:23:38', 4, '2026-05-12 15:23:38'),
(321, 73, 22, 22, 49, 'true', 1, '2026-05-12 11:23:38', 30, '2026-05-12 15:23:38'),
(322, 73, 22, 344, 49, 'false', 1, '2026-05-12 11:23:38', 20, '2026-05-12 15:23:38'),
(323, 73, 22, 481, 49, 'true', 1, '2026-05-12 11:23:38', 15, '2026-05-12 15:23:38'),
(324, 73, 22, 371, 49, 'false', 1, '2026-05-12 11:23:38', 20, '2026-05-12 15:23:38'),
(325, 74, 22, 481, 52, 'true', 1, '2026-05-12 11:41:11', 2, '2026-05-12 15:41:11'),
(326, 74, 22, 222, 52, 'true', 1, '2026-05-12 11:41:11', 1, '2026-05-12 15:41:11'),
(327, 74, 22, 22, 52, 'true', 1, '2026-05-12 11:41:11', 2, '2026-05-12 15:41:11'),
(328, 74, 22, 371, 52, 'false', 1, '2026-05-12 11:41:11', 2, '2026-05-12 15:41:11'),
(329, 74, 22, 344, 52, 'false', 1, '2026-05-12 11:41:11', 2, '2026-05-12 15:41:11'),
(330, 75, 23, 482, 49, 'true', 0, '2026-05-12 11:51:27', 6, '2026-05-12 15:51:27'),
(331, 75, 23, 220, 49, 'true', 1, '2026-05-12 11:51:27', 3, '2026-05-12 15:51:27'),
(332, 75, 23, 268, 49, 'true', 1, '2026-05-12 11:51:27', 3, '2026-05-12 15:51:27'),
(333, 76, 23, 220, 50, 'true', 1, '2026-05-14 04:35:16', 3, '2026-05-14 08:35:16'),
(334, 76, 23, 482, 50, 'true', 0, '2026-05-14 04:35:16', 2, '2026-05-14 08:35:16'),
(335, 76, 23, 268, 50, 'true', 1, '2026-05-14 04:35:16', 1, '2026-05-14 08:35:16'),
(336, 77, 23, 220, 40, 'true', 1, '2026-05-15 00:47:05', 2, '2026-05-15 04:47:05'),
(337, 77, 23, 482, 40, 'true', 0, '2026-05-15 00:47:05', 3, '2026-05-15 04:47:05'),
(338, 77, 23, 268, 40, 'true', 1, '2026-05-15 00:47:05', 2, '2026-05-15 04:47:05'),
(339, 78, 24, 25, 50, 'false', 1, '2026-05-16 14:09:36', 3, '2026-05-16 18:09:36'),
(340, 78, 24, 553, 50, 'false', 1, '2026-05-16 14:09:36', 3, '2026-05-16 18:09:36'),
(341, 78, 24, 433, 50, 'true', 1, '2026-05-16 14:09:36', 4, '2026-05-16 18:09:36'),
(342, 79, 25, 284, 8, 'false', 1, '2026-05-22 10:27:14', 2, '2026-05-22 14:27:14'),
(343, 79, 25, 479, 8, 'true', 1, '2026-05-22 10:27:14', 4, '2026-05-22 14:27:14'),
(344, 79, 25, 566, 8, 'true', 0, '2026-05-22 10:27:14', 4, '2026-05-22 14:27:14'),
(345, 80, 25, 479, 56, 'true', 1, '2026-05-23 04:37:14', 48, '2026-05-23 08:37:14'),
(346, 80, 25, 566, 56, 'false', 1, '2026-05-23 04:37:14', 24, '2026-05-23 08:37:14'),
(347, 80, 25, 284, 56, 'false', 1, '2026-05-23 04:37:14', 12, '2026-05-23 08:37:14'),
(348, 81, 26, 539, 8, 'true', 1, '2026-05-23 14:51:38', 17, '2026-05-23 18:51:38'),
(349, 81, 26, 577, 8, 'true', 1, '2026-05-23 14:51:38', 11, '2026-05-23 18:51:38'),
(350, 81, 26, 280, 8, 'true', 1, '2026-05-23 14:51:38', 2, '2026-05-23 18:51:38'),
(351, 82, 28, 281, 4, 'true', 0, '2026-06-06 09:32:12', 18, '2026-06-06 13:32:12'),
(352, 82, 28, 348, 4, 'false', 1, '2026-06-06 09:32:12', 3, '2026-06-06 13:32:12'),
(353, 82, 28, 527, 4, 'true', 0, '2026-06-06 09:32:12', 37, '2026-06-06 13:32:12'),
(354, 83, 28, 348, 17, 'false', 1, '2026-06-06 10:14:45', 4, '2026-06-06 14:14:45'),
(355, 83, 28, 527, 17, 'false', 1, '2026-06-06 10:14:45', 4, '2026-06-06 14:14:45'),
(356, 83, 28, 281, 17, 'false', 1, '2026-06-06 10:14:45', 6, '2026-06-06 14:14:45'),
(357, 84, 28, 348, 59, 'false', 1, '2026-06-06 10:20:26', 2, '2026-06-06 14:20:26'),
(358, 84, 28, 527, 59, 'false', 1, '2026-06-06 10:20:26', 1, '2026-06-06 14:20:26'),
(359, 84, 28, 281, 59, 'false', 1, '2026-06-06 10:20:26', 1, '2026-06-06 14:20:26'),
(360, 85, 28, 527, 8, 'false', 1, '2026-06-06 12:41:23', 4, '2026-06-06 16:41:23'),
(361, 85, 28, 281, 8, 'true', 0, '2026-06-06 12:41:23', 3, '2026-06-06 16:41:23'),
(362, 85, 28, 348, 8, 'false', 1, '2026-06-06 12:41:23', 2, '2026-06-06 16:41:23'),
(366, 87, 28, 527, 61, 'false', 1, '2026-06-06 12:47:45', 2, '2026-06-06 16:47:45'),
(367, 87, 28, 348, 61, 'false', 1, '2026-06-06 12:47:45', 1, '2026-06-06 16:47:45'),
(368, 87, 28, 281, 61, 'false', 1, '2026-06-06 12:47:45', 1, '2026-06-06 16:47:45'),
(381, 93, 28, 281, 67, 'false', 1, '2026-06-06 14:36:36', 1, '2026-06-06 18:36:36'),
(382, 93, 28, 348, 67, 'false', 1, '2026-06-06 14:36:36', 1, '2026-06-06 18:36:36'),
(383, 93, 28, 527, 67, 'false', 1, '2026-06-06 14:36:36', 1, '2026-06-06 18:36:36'),
(384, 94, 28, 527, 2, 'true', 0, '2026-06-17 04:45:50', 7, '2026-06-17 08:45:50'),
(385, 94, 28, 281, 2, 'false', 1, '2026-06-17 04:45:50', 3, '2026-06-17 08:45:50'),
(386, 94, 28, 348, 2, 'false', 1, '2026-06-17 04:45:50', 3, '2026-06-17 08:45:50'),
(387, 95, 30, 33, 17, 'false', 1, '2026-07-01 04:11:07', 4, '2026-07-01 08:11:07'),
(388, 95, 30, 165, 17, 'false', 1, '2026-07-01 04:11:07', 3, '2026-07-01 08:11:07'),
(389, 95, 30, 177, 17, 'false', 1, '2026-07-01 04:11:07', 4, '2026-07-01 08:11:07'),
(390, 96, 30, 177, 69, 'false', 1, '2026-07-01 04:18:33', 1, '2026-07-01 08:18:33'),
(391, 96, 30, 33, 69, 'false', 1, '2026-07-01 04:18:33', 1, '2026-07-01 08:18:33'),
(392, 96, 30, 165, 69, 'false', 1, '2026-07-01 04:18:33', 1, '2026-07-01 08:18:33'),
(393, 97, 31, 229, 71, 'false', 1, '2026-07-01 08:35:59', 8, '2026-07-01 12:35:59'),
(394, 97, 31, 265, 71, 'false', 1, '2026-07-01 08:35:59', 4, '2026-07-01 12:35:59'),
(395, 97, 31, 533, 71, 'false', 0, '2026-07-01 08:35:59', 3, '2026-07-01 12:35:59'),
(396, 97, 31, 141, 71, 'false', 1, '2026-07-01 08:35:59', 3, '2026-07-01 12:35:59'),
(397, 97, 31, 446, 71, 'false', 1, '2026-07-01 08:35:59', 2, '2026-07-01 12:35:59'),
(398, 98, 31, 141, 70, 'false', 1, '2026-07-01 08:37:04', 5, '2026-07-01 12:37:04'),
(399, 98, 31, 533, 70, 'true', 1, '2026-07-01 08:37:04', 7, '2026-07-01 12:37:04'),
(400, 98, 31, 446, 70, 'true', 0, '2026-07-01 08:37:04', 3, '2026-07-01 12:37:04'),
(401, 98, 31, 229, 70, 'false', 1, '2026-07-01 08:37:04', 3, '2026-07-01 12:37:04'),
(402, 98, 31, 265, 70, 'false', 1, '2026-07-01 08:37:04', 4, '2026-07-01 12:37:04'),
(403, 99, 30, 177, 8, 'false', 1, '2026-07-04 19:52:49', 2, '2026-07-04 23:52:49'),
(404, 99, 30, 165, 8, 'false', 1, '2026-07-04 19:52:49', 2, '2026-07-04 23:52:49'),
(405, 99, 30, 33, 8, 'false', 1, '2026-07-04 19:52:49', 2, '2026-07-04 23:52:49'),
(406, 100, 32, 272, 3, 'true', 1, '2026-08-14 09:00:39', 32, '2026-08-14 13:00:39'),
(407, 100, 32, 290, 3, 'true', 1, '2026-08-14 09:00:39', 4, '2026-08-14 13:00:39'),
(408, 100, 32, 562, 3, 'false', 0, '2026-08-14 09:00:39', 5, '2026-08-14 13:00:39'),
(409, 100, 32, 393, 3, 'false', 1, '2026-08-14 09:00:39', 4, '2026-08-14 13:00:39'),
(410, 100, 32, 185, 3, 'false', 1, '2026-08-14 09:00:39', 3, '2026-08-14 13:00:39'),
(411, 101, 32, 562, 72, 'true', 1, '2026-08-14 09:06:39', 23, '2026-08-14 13:06:39'),
(412, 101, 32, 393, 72, 'false', 1, '2026-08-14 09:06:39', 15, '2026-08-14 13:06:39'),
(413, 101, 32, 290, 72, 'true', 1, '2026-08-14 09:06:39', 7, '2026-08-14 13:06:39'),
(414, 101, 32, 272, 72, 'true', 1, '2026-08-14 09:06:39', 12, '2026-08-14 13:06:39'),
(415, 101, 32, 185, 72, 'false', 1, '2026-08-14 09:06:39', 4, '2026-08-14 13:06:39'),
(416, 102, 32, 290, 74, 'true', 1, '2026-08-14 09:30:41', 10, '2026-08-14 13:30:41'),
(417, 102, 32, 393, 74, 'false', 1, '2026-08-14 09:30:41', 4, '2026-08-14 13:30:41'),
(418, 102, 32, 272, 74, 'true', 1, '2026-08-14 09:30:41', 2, '2026-08-14 13:30:41'),
(419, 102, 32, 562, 74, 'false', 0, '2026-08-14 09:30:41', 2, '2026-08-14 13:30:41'),
(420, 102, 32, 185, 74, 'false', 1, '2026-08-14 09:30:41', 3, '2026-08-14 13:30:41'),
(421, 103, 33, 67, 72, 'true', 0, '2026-08-14 10:43:16', 5, '2026-08-14 14:43:16'),
(422, 103, 33, 445, 72, 'true', 1, '2026-08-14 10:43:16', 31, '2026-08-14 14:43:16'),
(423, 103, 33, 626, 72, 'false', 1, '2026-08-14 10:43:16', 13, '2026-08-14 14:43:16'),
(424, 103, 33, 588, 72, 'true', 1, '2026-08-14 10:43:16', 18, '2026-08-14 14:43:16'),
(425, 103, 33, 526, 72, 'true', 1, '2026-08-14 10:43:16', 7, '2026-08-14 14:43:16'),
(426, 104, 33, 526, 3, 'true', 1, '2026-08-14 12:43:30', 5, '2026-08-14 16:43:30'),
(427, 104, 33, 67, 3, 'false', 1, '2026-08-14 12:43:30', 9, '2026-08-14 16:43:30'),
(428, 104, 33, 588, 3, 'true', 1, '2026-08-14 12:43:30', 4, '2026-08-14 16:43:30'),
(429, 104, 33, 626, 3, 'false', 1, '2026-08-14 12:43:30', 12, '2026-08-14 16:43:30'),
(430, 104, 33, 445, 3, 'false', 0, '2026-08-14 12:43:30', 5, '2026-08-14 16:43:30'),
(431, 105, 34, 516, 72, 'true', 1, '2026-08-14 15:19:43', 11, '2026-08-14 19:19:43'),
(432, 105, 34, 318, 72, 'true', 1, '2026-08-14 15:19:43', 8, '2026-08-14 19:19:43'),
(433, 105, 34, 279, 72, 'false', 1, '2026-08-14 15:19:43', 9, '2026-08-14 19:19:43'),
(434, 106, 35, 223, 3, 'false', 1, '2026-08-20 20:45:39', 6, '2026-08-21 00:45:39'),
(435, 106, 35, 81, 3, 'false', 1, '2026-08-20 20:45:39', 6, '2026-08-21 00:45:39'),
(436, 106, 35, 210, 3, 'true', 1, '2026-08-20 20:45:39', 3, '2026-08-21 00:45:39'),
(437, 107, 36, 127, 3, 'false', 1, '2026-08-20 20:52:51', 3, '2026-08-21 00:52:51'),
(438, 107, 36, 579, 3, 'true', 1, '2026-08-20 20:52:51', 6, '2026-08-21 00:52:51'),
(439, 107, 36, 270, 3, 'true', 1, '2026-08-20 20:52:51', 2, '2026-08-21 00:52:51'),
(440, 108, 37, 203, 76, 'false', 1, '2026-08-30 21:17:58', 4, '2026-08-31 01:17:58'),
(441, 108, 37, 43, 76, 'true', 1, '2026-08-30 21:17:58', 3, '2026-08-31 01:17:58'),
(442, 108, 37, 258, 76, 'true', 1, '2026-08-30 21:17:58', 2, '2026-08-31 01:17:58'),
(443, 108, 37, 182, 76, 'false', 1, '2026-08-30 21:17:58', 2, '2026-08-31 01:17:58'),
(444, 108, 37, 443, 76, 'true', 0, '2026-08-30 21:17:58', 7, '2026-08-31 01:17:58'),
(445, 109, 37, 182, 3, 'false', 1, '2026-08-30 21:18:19', 3, '2026-08-31 01:18:19'),
(446, 109, 37, 203, 3, 'false', 1, '2026-08-30 21:18:19', 8, '2026-08-31 01:18:19'),
(447, 109, 37, 258, 3, 'true', 1, '2026-08-30 21:18:19', 4, '2026-08-31 01:18:19'),
(448, 109, 37, 443, 3, 'true', 0, '2026-08-30 21:18:19', 2, '2026-08-31 01:18:19'),
(449, 109, 37, 43, 3, 'true', 1, '2026-08-30 21:18:19', 6, '2026-08-31 01:18:19'),
(450, 110, 38, 597, 76, 'false', 0, '2026-08-30 21:38:58', 14, '2026-08-31 01:38:58'),
(451, 110, 38, 607, 76, 'false', 0, '2026-08-30 21:38:58', 7, '2026-08-31 01:38:58'),
(452, 110, 38, 549, 76, 'true', 1, '2026-08-30 21:38:58', 3, '2026-08-31 01:38:58'),
(453, 110, 38, 158, 76, 'true', 1, '2026-08-30 21:38:58', 3, '2026-08-31 01:38:58'),
(454, 110, 38, 376, 76, 'true', 1, '2026-08-30 21:38:58', 4, '2026-08-31 01:38:58'),
(455, 111, 38, 158, 3, 'true', 1, '2026-08-30 21:39:14', 6, '2026-08-31 01:39:14'),
(456, 111, 38, 549, 3, 'true', 1, '2026-08-30 21:39:14', 5, '2026-08-31 01:39:14'),
(457, 111, 38, 597, 3, 'false', 0, '2026-08-30 21:39:14', 3, '2026-08-31 01:39:14'),
(458, 111, 38, 607, 3, 'true', 1, '2026-08-30 21:39:14', 4, '2026-08-31 01:39:14'),
(459, 111, 38, 376, 3, 'true', 1, '2026-08-30 21:39:14', 2, '2026-08-31 01:39:14'),
(460, 112, 38, 607, 77, 'true', 1, '2026-08-31 05:58:54', 8, '2026-08-31 09:58:54'),
(461, 112, 38, 597, 77, 'true', 1, '2026-08-31 05:58:54', 7, '2026-08-31 09:58:54'),
(462, 112, 38, 549, 77, 'true', 1, '2026-08-31 05:58:54', 6, '2026-08-31 09:58:54'),
(463, 112, 38, 376, 77, 'true', 1, '2026-08-31 05:58:54', 7, '2026-08-31 09:58:54'),
(464, 112, 38, 158, 77, 'true', 1, '2026-08-31 05:58:54', 7, '2026-08-31 09:58:54'),
(465, 113, 39, 254, 77, 'true', 1, '2026-08-31 06:03:01', 4, '2026-08-31 10:03:01'),
(466, 113, 39, 239, 77, 'false', 1, '2026-08-31 06:03:01', 3, '2026-08-31 10:03:01'),
(467, 113, 39, 427, 77, 'false', 0, '2026-08-31 06:03:01', 4, '2026-08-31 10:03:01'),
(468, 113, 39, 456, 77, 'true', 1, '2026-08-31 06:03:01', 23, '2026-08-31 10:03:01'),
(469, 113, 39, 357, 77, 'true', 1, '2026-08-31 06:03:01', 11, '2026-08-31 10:03:01'),
(470, 114, 40, 417, 77, 'false', 0, '2026-08-31 06:48:00', 8, '2026-08-31 10:48:00'),
(471, 114, 40, 435, 77, 'false', 1, '2026-08-31 06:48:00', 10, '2026-08-31 10:48:00'),
(472, 114, 40, 608, 77, 'false', 1, '2026-08-31 06:48:00', 9, '2026-08-31 10:48:00'),
(473, 114, 40, 51, 77, 'false', 1, '2026-08-31 06:48:00', 16, '2026-08-31 10:48:00'),
(474, 114, 40, 405, 77, 'true', 0, '2026-08-31 06:48:00', 4, '2026-08-31 10:48:00'),
(475, 115, 40, 608, 79, 'false', 1, '2026-08-31 09:12:20', 37, '2026-08-31 13:12:20'),
(476, 115, 40, 435, 79, 'false', 1, '2026-08-31 09:12:20', 29, '2026-08-31 13:12:20'),
(477, 115, 40, 417, 79, 'true', 1, '2026-08-31 09:12:20', 29, '2026-08-31 13:12:20'),
(478, 115, 40, 405, 79, 'false', 1, '2026-08-31 09:12:20', 20, '2026-08-31 13:12:20'),
(479, 115, 40, 51, 79, 'false', 1, '2026-08-31 09:12:20', 19, '2026-08-31 13:12:20'),
(480, 116, 41, 60, 80, 'true', 1, '2026-08-31 09:45:29', 3, '2026-08-31 13:45:29'),
(481, 116, 41, 638, 80, 'true', 1, '2026-08-31 09:45:29', 3, '2026-08-31 13:45:29'),
(482, 116, 41, 250, 80, 'true', 1, '2026-08-31 09:45:29', 3, '2026-08-31 13:45:29'),
(483, 116, 41, 278, 80, 'true', 1, '2026-08-31 09:45:29', 2, '2026-08-31 13:45:29'),
(484, 116, 41, 525, 80, 'false', 1, '2026-08-31 09:45:29', 6, '2026-08-31 13:45:29'),
(485, 117, 42, 602, 79, 'true', 1, '2026-08-31 14:49:53', 59, '2026-08-31 18:49:53'),
(486, 117, 42, 168, 79, 'true', 1, '2026-08-31 14:49:53', 18, '2026-08-31 18:49:53'),
(487, 117, 42, 293, 79, 'false', 1, '2026-08-31 14:49:53', 9, '2026-08-31 18:49:53'),
(488, 118, 42, 168, 80, 'true', 1, '2026-08-31 19:42:37', 3, '2026-08-31 23:42:37'),
(489, 118, 42, 293, 80, 'false', 1, '2026-08-31 19:42:37', 3, '2026-08-31 23:42:37'),
(490, 118, 42, 602, 80, 'false', 0, '2026-08-31 19:42:37', 6, '2026-08-31 23:42:37'),
(491, 119, 43, 130, 80, 'true', 1, '2026-09-01 10:22:31', 3, '2026-09-01 14:22:31'),
(492, 119, 43, 322, 80, 'true', 1, '2026-09-01 10:22:31', 6, '2026-09-01 14:22:31'),
(493, 119, 43, 511, 80, 'true', 1, '2026-09-01 10:22:31', 7, '2026-09-01 14:22:31'),
(494, 120, 43, 322, 82, 'true', 1, '2026-09-01 22:17:25', 5, '2026-09-02 02:17:25'),
(495, 120, 43, 511, 82, 'false', 0, '2026-09-01 22:17:25', 2, '2026-09-02 02:17:25'),
(496, 120, 43, 130, 82, 'true', 1, '2026-09-01 22:17:25', 1, '2026-09-02 02:17:25'),
(497, 121, 43, 130, 79, 'true', 1, '2026-09-02 15:55:08', 40, '2026-09-02 19:55:08'),
(498, 121, 43, 511, 79, 'true', 1, '2026-09-02 15:55:08', 73, '2026-09-02 19:55:08'),
(499, 121, 43, 322, 79, 'true', 1, '2026-09-02 15:55:08', 33, '2026-09-02 19:55:08'),
(500, 122, 43, 511, 3, 'false', 0, '2026-09-12 11:48:20', 28, '2026-09-12 15:48:20'),
(501, 122, 43, 130, 3, 'true', 1, '2026-09-12 11:48:20', 2, '2026-09-12 15:48:20'),
(502, 122, 43, 322, 3, 'false', 0, '2026-09-12 11:48:20', 7, '2026-09-12 15:48:20');

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
(1, 16, 4, 196, 13, 1, '2026-04-25 15:48:47'),
(2, 16, 4, 96, 13, 2, '2026-04-25 15:48:47'),
(3, 16, 4, 39, 13, 3, '2026-04-25 15:48:47'),
(4, 17, 4, 196, 15, 1, '2026-04-25 15:59:30'),
(5, 17, 4, 39, 15, 2, '2026-04-25 15:59:30'),
(6, 17, 4, 96, 15, 3, '2026-04-25 15:59:30'),
(7, 18, 4, 196, 8, 1, '2026-04-25 18:05:19'),
(8, 18, 4, 96, 8, 2, '2026-04-25 18:05:19'),
(9, 18, 4, 39, 8, 3, '2026-04-25 18:05:19'),
(10, 19, 5, 187, 17, 1, '2026-04-25 20:16:26'),
(11, 19, 5, 303, 17, 2, '2026-04-25 20:16:26'),
(12, 19, 5, 42, 17, 3, '2026-04-25 20:16:26'),
(13, 20, 5, 187, 8, 1, '2026-04-25 20:36:39'),
(14, 20, 5, 303, 8, 2, '2026-04-25 20:36:39'),
(15, 20, 5, 42, 8, 3, '2026-04-25 20:36:39'),
(16, 21, 5, 303, 19, 1, '2026-04-26 14:03:03'),
(17, 21, 5, 42, 19, 2, '2026-04-26 14:03:03'),
(18, 21, 5, 187, 19, 3, '2026-04-26 14:03:03'),
(19, 22, 6, 40, 8, 1, '2026-04-26 15:21:33'),
(20, 22, 6, 230, 8, 2, '2026-04-26 15:21:33'),
(21, 22, 6, 153, 8, 3, '2026-04-26 15:21:33'),
(22, 23, 6, 40, 17, 1, '2026-04-27 20:26:11'),
(23, 23, 6, 230, 17, 2, '2026-04-27 20:26:11'),
(24, 23, 6, 153, 17, 3, '2026-04-27 20:26:11'),
(25, 24, 6, 40, 3, 1, '2026-04-27 20:34:01'),
(26, 24, 6, 230, 3, 2, '2026-04-27 20:34:01'),
(27, 24, 6, 153, 3, 3, '2026-04-27 20:34:01'),
(28, 25, 7, 93, 8, 1, '2026-04-28 13:48:22'),
(29, 25, 7, 195, 8, 2, '2026-04-28 13:48:22'),
(30, 25, 7, 54, 8, 3, '2026-04-28 13:48:22'),
(31, 26, 7, 93, 25, 1, '2026-04-28 14:41:21'),
(32, 26, 7, 195, 25, 2, '2026-04-28 14:41:21'),
(33, 26, 7, 54, 25, 3, '2026-04-28 14:41:21'),
(34, 27, 7, 93, 14, 1, '2026-04-29 13:57:19'),
(35, 27, 7, 195, 14, 2, '2026-04-29 13:57:19'),
(36, 27, 7, 54, 14, 3, '2026-04-29 13:57:19'),
(37, 28, 8, 57, 25, 1, '2026-04-30 06:04:49'),
(38, 28, 8, 80, 25, 2, '2026-04-30 06:04:49'),
(39, 28, 8, 251, 25, 3, '2026-04-30 06:04:49'),
(40, 28, 8, 142, 25, 4, '2026-04-30 06:04:49'),
(41, 28, 8, 324, 25, 5, '2026-04-30 06:04:49'),
(42, 29, 8, 80, 8, 1, '2026-04-30 21:31:55'),
(43, 29, 8, 251, 8, 2, '2026-04-30 21:31:55'),
(44, 29, 8, 324, 8, 3, '2026-04-30 21:31:55'),
(45, 29, 8, 142, 8, 4, '2026-04-30 21:31:55'),
(46, 29, 8, 57, 8, 5, '2026-04-30 21:31:55'),
(47, 30, 8, 80, 11, 1, '2026-05-01 08:41:51'),
(48, 30, 8, 57, 11, 2, '2026-05-01 08:41:51'),
(49, 30, 8, 324, 11, 3, '2026-05-01 08:41:51'),
(50, 30, 8, 251, 11, 4, '2026-05-01 08:41:51'),
(51, 30, 8, 142, 11, 5, '2026-05-01 08:41:51'),
(52, 31, 9, 56, 8, 1, '2026-05-01 19:37:24'),
(53, 31, 9, 97, 8, 2, '2026-05-01 19:37:24'),
(54, 31, 9, 216, 8, 3, '2026-05-01 19:37:24'),
(55, 31, 9, 102, 8, 4, '2026-05-01 19:37:24'),
(56, 31, 9, 355, 8, 5, '2026-05-01 19:37:24'),
(57, 32, 10, 301, 28, 1, '2026-05-04 10:15:39'),
(58, 32, 10, 287, 28, 2, '2026-05-04 10:15:39'),
(59, 32, 10, 313, 28, 3, '2026-05-04 10:15:39'),
(60, 32, 10, 176, 28, 4, '2026-05-04 10:15:39'),
(61, 32, 10, 214, 28, 5, '2026-05-04 10:15:39'),
(62, 33, 10, 313, 30, 1, '2026-05-04 10:18:14'),
(63, 33, 10, 214, 30, 2, '2026-05-04 10:18:14'),
(64, 33, 10, 176, 30, 3, '2026-05-04 10:18:14'),
(65, 33, 10, 287, 30, 4, '2026-05-04 10:18:14'),
(66, 33, 10, 301, 30, 5, '2026-05-04 10:18:14'),
(67, 34, 10, 176, 29, 1, '2026-05-04 10:22:05'),
(68, 34, 10, 214, 29, 2, '2026-05-04 10:22:05'),
(69, 34, 10, 313, 29, 3, '2026-05-04 10:22:05'),
(70, 34, 10, 287, 29, 4, '2026-05-04 10:22:05'),
(71, 34, 10, 301, 29, 5, '2026-05-04 10:22:05'),
(72, 35, 9, 102, 12, 1, '2026-05-04 11:13:42'),
(73, 35, 9, 216, 12, 2, '2026-05-04 11:13:42'),
(74, 35, 9, 56, 12, 3, '2026-05-04 11:13:42'),
(75, 35, 9, 97, 12, 4, '2026-05-04 11:13:42'),
(76, 35, 9, 355, 12, 5, '2026-05-04 11:13:42'),
(77, 36, 11, 343, 36, 1, '2026-05-04 13:06:37'),
(78, 36, 11, 339, 36, 2, '2026-05-04 13:06:37'),
(79, 36, 11, 112, 36, 3, '2026-05-04 13:06:37'),
(80, 36, 11, 163, 36, 4, '2026-05-04 13:06:37'),
(81, 36, 11, 307, 36, 5, '2026-05-04 13:06:37'),
(82, 37, 11, 112, 37, 1, '2026-05-04 13:09:30'),
(83, 37, 11, 339, 37, 2, '2026-05-04 13:09:30'),
(84, 37, 11, 307, 37, 3, '2026-05-04 13:09:30'),
(85, 37, 11, 343, 37, 4, '2026-05-04 13:09:30'),
(86, 37, 11, 163, 37, 5, '2026-05-04 13:09:30'),
(87, 38, 11, 307, 38, 1, '2026-05-04 13:09:41'),
(88, 38, 11, 112, 38, 2, '2026-05-04 13:09:41'),
(89, 38, 11, 339, 38, 3, '2026-05-04 13:09:41'),
(90, 38, 11, 343, 38, 4, '2026-05-04 13:09:41'),
(91, 38, 11, 163, 38, 5, '2026-05-04 13:09:41'),
(92, 39, 9, 102, 31, 1, '2026-05-05 20:36:26'),
(93, 39, 9, 216, 31, 2, '2026-05-05 20:36:26'),
(94, 39, 9, 56, 31, 3, '2026-05-05 20:36:26'),
(95, 39, 9, 97, 31, 4, '2026-05-05 20:36:26'),
(96, 39, 9, 355, 31, 5, '2026-05-05 20:36:26'),
(97, 40, 12, 65, 31, 1, '2026-05-06 09:22:03'),
(98, 40, 12, 119, 31, 2, '2026-05-06 09:22:03'),
(99, 40, 12, 321, 31, 3, '2026-05-06 09:22:03'),
(100, 40, 12, 288, 31, 4, '2026-05-06 09:22:03'),
(101, 40, 12, 329, 31, 5, '2026-05-06 09:22:03'),
(102, 41, 12, 329, 8, 1, '2026-05-06 16:11:12'),
(103, 41, 12, 119, 8, 2, '2026-05-06 16:11:12'),
(104, 41, 12, 321, 8, 3, '2026-05-06 16:11:12'),
(105, 41, 12, 65, 8, 4, '2026-05-06 16:11:12'),
(106, 41, 12, 288, 8, 5, '2026-05-06 16:11:12'),
(107, 42, 12, 321, 40, 1, '2026-05-06 16:54:22'),
(108, 42, 12, 65, 40, 2, '2026-05-06 16:54:22'),
(109, 42, 12, 329, 40, 3, '2026-05-06 16:54:22'),
(110, 42, 12, 119, 40, 4, '2026-05-06 16:54:22'),
(111, 42, 12, 288, 40, 5, '2026-05-06 16:54:22'),
(112, 43, 12, 288, 41, 1, '2026-05-06 16:54:58'),
(113, 43, 12, 65, 41, 2, '2026-05-06 16:54:58'),
(114, 43, 12, 329, 41, 3, '2026-05-06 16:54:58'),
(115, 43, 12, 321, 41, 4, '2026-05-06 16:54:58'),
(116, 43, 12, 119, 41, 5, '2026-05-06 16:54:58'),
(117, 44, 13, 70, 41, 1, '2026-05-06 17:06:45'),
(118, 44, 13, 73, 41, 2, '2026-05-06 17:06:45'),
(119, 44, 13, 122, 41, 3, '2026-05-06 17:06:45'),
(120, 44, 13, 107, 41, 4, '2026-05-06 17:06:45'),
(121, 44, 13, 349, 41, 5, '2026-05-06 17:06:45'),
(122, 45, 13, 349, 31, 1, '2026-05-06 17:08:00'),
(123, 45, 13, 107, 31, 2, '2026-05-06 17:08:00'),
(124, 45, 13, 73, 31, 3, '2026-05-06 17:08:00'),
(125, 45, 13, 70, 31, 4, '2026-05-06 17:08:00'),
(126, 45, 13, 122, 31, 5, '2026-05-06 17:08:00'),
(127, 46, 13, 349, 42, 1, '2026-05-06 17:08:23'),
(128, 46, 13, 122, 42, 2, '2026-05-06 17:08:23'),
(129, 46, 13, 73, 42, 3, '2026-05-06 17:08:23'),
(130, 46, 13, 70, 42, 4, '2026-05-06 17:08:23'),
(131, 46, 13, 107, 42, 5, '2026-05-06 17:08:23'),
(132, 47, 13, 73, 12, 1, '2026-05-06 17:08:28'),
(133, 47, 13, 70, 12, 2, '2026-05-06 17:08:28'),
(134, 47, 13, 349, 12, 3, '2026-05-06 17:08:28'),
(135, 47, 13, 122, 12, 4, '2026-05-06 17:08:28'),
(136, 47, 13, 107, 12, 5, '2026-05-06 17:08:28'),
(137, 48, 13, 70, 40, 1, '2026-05-06 17:12:50'),
(138, 48, 13, 122, 40, 2, '2026-05-06 17:12:50'),
(139, 48, 13, 73, 40, 3, '2026-05-06 17:12:50'),
(140, 48, 13, 107, 40, 4, '2026-05-06 17:12:50'),
(141, 48, 13, 349, 40, 5, '2026-05-06 17:12:50'),
(142, 49, 14, 79, 42, 1, '2026-05-06 17:53:32'),
(143, 49, 14, 95, 42, 2, '2026-05-06 17:53:32'),
(144, 49, 14, 138, 42, 3, '2026-05-06 17:53:32'),
(145, 49, 14, 99, 42, 4, '2026-05-06 17:53:32'),
(146, 49, 14, 295, 42, 5, '2026-05-06 17:53:32'),
(147, 50, 14, 295, 41, 1, '2026-05-06 17:55:00'),
(148, 50, 14, 99, 41, 2, '2026-05-06 17:55:00'),
(149, 50, 14, 138, 41, 3, '2026-05-06 17:55:00'),
(150, 50, 14, 79, 41, 4, '2026-05-06 17:55:00'),
(151, 50, 14, 95, 41, 5, '2026-05-06 17:55:00'),
(152, 51, 14, 99, 32, 1, '2026-05-06 18:32:20'),
(153, 51, 14, 95, 32, 2, '2026-05-06 18:32:20'),
(154, 51, 14, 79, 32, 3, '2026-05-06 18:32:20'),
(155, 51, 14, 295, 32, 4, '2026-05-06 18:32:20'),
(156, 51, 14, 138, 32, 5, '2026-05-06 18:32:20'),
(157, 52, 14, 138, 8, 1, '2026-05-06 18:35:55'),
(158, 52, 14, 95, 8, 2, '2026-05-06 18:35:55'),
(159, 52, 14, 295, 8, 3, '2026-05-06 18:35:55'),
(160, 52, 14, 99, 8, 4, '2026-05-06 18:35:55'),
(161, 52, 14, 79, 8, 5, '2026-05-06 18:35:55'),
(162, 53, 15, 131, 8, 1, '2026-05-07 09:25:18'),
(163, 53, 15, 346, 8, 2, '2026-05-07 09:25:18'),
(164, 53, 15, 271, 8, 3, '2026-05-07 09:25:18'),
(165, 53, 15, 140, 8, 4, '2026-05-07 09:25:18'),
(166, 53, 15, 219, 8, 5, '2026-05-07 09:25:18'),
(167, 54, 15, 219, 32, 1, '2026-05-07 18:55:00'),
(168, 54, 15, 346, 32, 2, '2026-05-07 18:55:00'),
(169, 54, 15, 140, 32, 3, '2026-05-07 18:55:00'),
(170, 54, 15, 271, 32, 4, '2026-05-07 18:55:00'),
(171, 54, 15, 131, 32, 5, '2026-05-07 18:55:00'),
(172, 55, 15, 271, 3, 1, '2026-05-08 07:47:29'),
(173, 55, 15, 346, 3, 2, '2026-05-08 07:47:29'),
(174, 55, 15, 131, 3, 3, '2026-05-08 07:47:29'),
(175, 55, 15, 219, 3, 4, '2026-05-08 07:47:29'),
(176, 55, 15, 140, 3, 5, '2026-05-08 07:47:29'),
(177, 56, 16, 228, 8, 1, '2026-05-08 11:58:23'),
(178, 56, 16, 264, 8, 2, '2026-05-08 11:58:23'),
(179, 56, 16, 545, 8, 3, '2026-05-08 11:58:23'),
(180, 56, 16, 471, 8, 4, '2026-05-08 11:58:23'),
(181, 56, 16, 623, 8, 5, '2026-05-08 11:58:23'),
(182, 57, 16, 471, 2, 1, '2026-05-10 16:44:28'),
(183, 57, 16, 623, 2, 2, '2026-05-10 16:44:28'),
(184, 57, 16, 264, 2, 3, '2026-05-10 16:44:28'),
(185, 57, 16, 545, 2, 4, '2026-05-10 16:44:28'),
(186, 57, 16, 228, 2, 5, '2026-05-10 16:44:28'),
(187, 58, 16, 623, 15, 1, '2026-05-10 16:45:44'),
(188, 58, 16, 545, 15, 2, '2026-05-10 16:45:44'),
(189, 58, 16, 471, 15, 3, '2026-05-10 16:45:44'),
(190, 58, 16, 264, 15, 4, '2026-05-10 16:45:44'),
(191, 58, 16, 228, 15, 5, '2026-05-10 16:45:44'),
(192, 59, 17, 436, 40, 1, '2026-05-10 17:01:30'),
(193, 59, 17, 442, 40, 2, '2026-05-10 17:01:30'),
(194, 59, 17, 286, 40, 3, '2026-05-10 17:01:30'),
(195, 59, 17, 180, 40, 4, '2026-05-10 17:01:30'),
(196, 59, 17, 571, 40, 5, '2026-05-10 17:01:30'),
(197, 60, 17, 286, 41, 1, '2026-05-10 17:05:03'),
(198, 60, 17, 571, 41, 2, '2026-05-10 17:05:03'),
(199, 60, 17, 180, 41, 3, '2026-05-10 17:05:03'),
(200, 60, 17, 442, 41, 4, '2026-05-10 17:05:03'),
(201, 60, 17, 436, 41, 5, '2026-05-10 17:05:03'),
(202, 61, 17, 286, 3, 1, '2026-05-10 17:13:37'),
(203, 61, 17, 571, 3, 2, '2026-05-10 17:13:37'),
(204, 61, 17, 180, 3, 3, '2026-05-10 17:13:37'),
(205, 61, 17, 436, 3, 4, '2026-05-10 17:13:37'),
(206, 61, 17, 442, 3, 5, '2026-05-10 17:13:37'),
(207, 62, 18, 88, 8, 1, '2026-05-10 17:50:59'),
(208, 62, 18, 563, 8, 2, '2026-05-10 17:50:59'),
(209, 62, 18, 575, 8, 3, '2026-05-10 17:50:59'),
(210, 62, 18, 256, 8, 4, '2026-05-10 17:50:59'),
(211, 62, 18, 115, 8, 5, '2026-05-10 17:50:59'),
(212, 63, 18, 563, 45, 1, '2026-05-11 01:04:30'),
(213, 63, 18, 256, 45, 2, '2026-05-11 01:04:30'),
(214, 63, 18, 575, 45, 3, '2026-05-11 01:04:30'),
(215, 63, 18, 88, 45, 4, '2026-05-11 01:04:30'),
(216, 63, 18, 115, 45, 5, '2026-05-11 01:04:30'),
(217, 64, 18, 563, 39, 1, '2026-05-12 12:04:37'),
(218, 64, 18, 575, 39, 2, '2026-05-12 12:04:37'),
(219, 64, 18, 256, 39, 3, '2026-05-12 12:04:37'),
(220, 64, 18, 88, 39, 4, '2026-05-12 12:04:37'),
(221, 64, 18, 115, 39, 5, '2026-05-12 12:04:37'),
(222, 65, 19, 455, 8, 1, '2026-05-12 13:26:55'),
(223, 65, 19, 224, 8, 2, '2026-05-12 13:26:55'),
(224, 65, 19, 580, 8, 3, '2026-05-12 13:26:55'),
(225, 65, 19, 360, 8, 4, '2026-05-12 13:26:55'),
(226, 65, 19, 188, 8, 5, '2026-05-12 13:26:55'),
(227, 66, 20, 463, 48, 1, '2026-05-12 13:59:06'),
(228, 66, 20, 440, 48, 2, '2026-05-12 13:59:06'),
(229, 66, 20, 47, 48, 3, '2026-05-12 13:59:06'),
(230, 66, 20, 496, 48, 4, '2026-05-12 13:59:06'),
(231, 66, 20, 71, 48, 5, '2026-05-12 13:59:06'),
(232, 67, 20, 496, 49, 1, '2026-05-12 14:00:25'),
(233, 67, 20, 47, 49, 2, '2026-05-12 14:00:25'),
(234, 67, 20, 463, 49, 3, '2026-05-12 14:00:25'),
(235, 67, 20, 71, 49, 4, '2026-05-12 14:00:25'),
(236, 67, 20, 440, 49, 5, '2026-05-12 14:00:25'),
(237, 68, 19, 224, 40, 1, '2026-05-12 14:09:15'),
(238, 68, 19, 360, 40, 2, '2026-05-12 14:09:15'),
(239, 68, 19, 188, 40, 3, '2026-05-12 14:09:15'),
(240, 68, 19, 455, 40, 4, '2026-05-12 14:09:15'),
(241, 68, 19, 580, 40, 5, '2026-05-12 14:09:15'),
(242, 69, 21, 428, 50, 1, '2026-05-12 14:26:02'),
(243, 69, 21, 120, 50, 2, '2026-05-12 14:26:02'),
(244, 69, 21, 128, 50, 3, '2026-05-12 14:26:02'),
(245, 70, 21, 428, 51, 1, '2026-05-12 14:27:14'),
(246, 70, 21, 120, 51, 2, '2026-05-12 14:27:14'),
(247, 70, 21, 128, 51, 3, '2026-05-12 14:27:14'),
(248, 71, 19, 455, 49, 1, '2026-05-12 14:51:38'),
(249, 71, 19, 224, 49, 2, '2026-05-12 14:51:38'),
(250, 71, 19, 360, 49, 3, '2026-05-12 14:51:38'),
(251, 71, 19, 580, 49, 4, '2026-05-12 14:51:38'),
(252, 71, 19, 188, 49, 5, '2026-05-12 14:51:38'),
(253, 72, 22, 344, 8, 1, '2026-05-12 15:03:24'),
(254, 72, 22, 22, 8, 2, '2026-05-12 15:03:24'),
(255, 72, 22, 371, 8, 3, '2026-05-12 15:03:24'),
(256, 72, 22, 222, 8, 4, '2026-05-12 15:03:24'),
(257, 72, 22, 481, 8, 5, '2026-05-12 15:03:24'),
(258, 73, 22, 222, 49, 1, '2026-05-12 15:21:51'),
(259, 73, 22, 22, 49, 2, '2026-05-12 15:21:51'),
(260, 73, 22, 344, 49, 3, '2026-05-12 15:21:51'),
(261, 73, 22, 481, 49, 4, '2026-05-12 15:21:51'),
(262, 73, 22, 371, 49, 5, '2026-05-12 15:21:51'),
(263, 74, 22, 481, 52, 1, '2026-05-12 15:40:52'),
(264, 74, 22, 222, 52, 2, '2026-05-12 15:40:52'),
(265, 74, 22, 22, 52, 3, '2026-05-12 15:40:52'),
(266, 74, 22, 371, 52, 4, '2026-05-12 15:40:52'),
(267, 74, 22, 344, 52, 5, '2026-05-12 15:40:52'),
(268, 75, 23, 482, 49, 1, '2026-05-12 15:51:01'),
(269, 75, 23, 220, 49, 2, '2026-05-12 15:51:01'),
(270, 75, 23, 268, 49, 3, '2026-05-12 15:51:01'),
(271, 76, 23, 220, 50, 1, '2026-05-14 08:35:03'),
(272, 76, 23, 482, 50, 2, '2026-05-14 08:35:03'),
(273, 76, 23, 268, 50, 3, '2026-05-14 08:35:03'),
(274, 77, 23, 220, 40, 1, '2026-05-15 04:46:53'),
(275, 77, 23, 482, 40, 2, '2026-05-15 04:46:53'),
(276, 77, 23, 268, 40, 3, '2026-05-15 04:46:53'),
(277, 78, 24, 25, 50, 1, '2026-05-16 18:09:14'),
(278, 78, 24, 553, 50, 2, '2026-05-16 18:09:14'),
(279, 78, 24, 433, 50, 3, '2026-05-16 18:09:14'),
(280, 79, 25, 284, 8, 1, '2026-05-22 14:26:56'),
(281, 79, 25, 479, 8, 2, '2026-05-22 14:26:56'),
(282, 79, 25, 566, 8, 3, '2026-05-22 14:26:56'),
(283, 80, 25, 479, 56, 1, '2026-05-23 08:34:47'),
(284, 80, 25, 566, 56, 2, '2026-05-23 08:34:47'),
(285, 80, 25, 284, 56, 3, '2026-05-23 08:34:47'),
(286, 81, 26, 539, 8, 1, '2026-05-23 18:51:01'),
(287, 81, 26, 577, 8, 2, '2026-05-23 18:51:01'),
(288, 81, 26, 280, 8, 3, '2026-05-23 18:51:01'),
(289, 82, 28, 281, 4, 1, '2026-06-06 13:31:07'),
(290, 82, 28, 348, 4, 2, '2026-06-06 13:31:07'),
(291, 82, 28, 527, 4, 3, '2026-06-06 13:31:07'),
(292, 83, 28, 348, 17, 1, '2026-06-06 14:14:16'),
(293, 83, 28, 527, 17, 2, '2026-06-06 14:14:16'),
(294, 83, 28, 281, 17, 3, '2026-06-06 14:14:16'),
(295, 84, 28, 348, 59, 1, '2026-06-06 14:20:05'),
(296, 84, 28, 527, 59, 2, '2026-06-06 14:20:05'),
(297, 84, 28, 281, 59, 3, '2026-06-06 14:20:05'),
(298, 85, 28, 527, 8, 1, '2026-06-06 16:41:09'),
(299, 85, 28, 281, 8, 2, '2026-06-06 16:41:09'),
(300, 85, 28, 348, 8, 3, '2026-06-06 16:41:09'),
(304, 87, 28, 527, 61, 1, '2026-06-06 16:47:34'),
(305, 87, 28, 348, 61, 2, '2026-06-06 16:47:34'),
(306, 87, 28, 281, 61, 3, '2026-06-06 16:47:34'),
(322, 93, 28, 281, 67, 1, '2026-06-06 18:36:23'),
(323, 93, 28, 348, 67, 2, '2026-06-06 18:36:23'),
(324, 93, 28, 527, 67, 3, '2026-06-06 18:36:23'),
(325, 94, 28, 527, 2, 1, '2026-06-17 08:45:29'),
(326, 94, 28, 281, 2, 2, '2026-06-17 08:45:29'),
(327, 94, 28, 348, 2, 3, '2026-06-17 08:45:29'),
(328, 95, 30, 33, 17, 1, '2026-07-01 08:10:37'),
(329, 95, 30, 165, 17, 2, '2026-07-01 08:10:37'),
(330, 95, 30, 177, 17, 3, '2026-07-01 08:10:37'),
(331, 96, 30, 177, 69, 1, '2026-07-01 08:18:14'),
(332, 96, 30, 33, 69, 2, '2026-07-01 08:18:14'),
(333, 96, 30, 165, 69, 3, '2026-07-01 08:18:14'),
(334, 97, 31, 229, 71, 1, '2026-07-01 12:35:21'),
(335, 97, 31, 265, 71, 2, '2026-07-01 12:35:21'),
(336, 97, 31, 533, 71, 3, '2026-07-01 12:35:21'),
(337, 97, 31, 141, 71, 4, '2026-07-01 12:35:21'),
(338, 97, 31, 446, 71, 5, '2026-07-01 12:35:21'),
(339, 98, 31, 141, 70, 1, '2026-07-01 12:36:34'),
(340, 98, 31, 533, 70, 2, '2026-07-01 12:36:34'),
(341, 98, 31, 446, 70, 3, '2026-07-01 12:36:34'),
(342, 98, 31, 229, 70, 4, '2026-07-01 12:36:34'),
(343, 98, 31, 265, 70, 5, '2026-07-01 12:36:34'),
(344, 99, 30, 177, 8, 1, '2026-07-04 23:52:36'),
(345, 99, 30, 165, 8, 2, '2026-07-04 23:52:36'),
(346, 99, 30, 33, 8, 3, '2026-07-04 23:52:36'),
(347, 100, 32, 272, 3, 1, '2026-08-14 12:59:36'),
(348, 100, 32, 290, 3, 2, '2026-08-14 12:59:36'),
(349, 100, 32, 562, 3, 3, '2026-08-14 12:59:36'),
(350, 100, 32, 393, 3, 4, '2026-08-14 12:59:36'),
(351, 100, 32, 185, 3, 5, '2026-08-14 12:59:36'),
(352, 101, 32, 562, 72, 1, '2026-08-14 13:04:37'),
(353, 101, 32, 393, 72, 2, '2026-08-14 13:04:37'),
(354, 101, 32, 290, 72, 3, '2026-08-14 13:04:37'),
(355, 101, 32, 272, 72, 4, '2026-08-14 13:04:37'),
(356, 101, 32, 185, 72, 5, '2026-08-14 13:04:37'),
(357, 102, 32, 290, 74, 1, '2026-08-14 13:26:33'),
(358, 102, 32, 393, 74, 2, '2026-08-14 13:26:33'),
(359, 102, 32, 272, 74, 3, '2026-08-14 13:26:33'),
(360, 102, 32, 562, 74, 4, '2026-08-14 13:26:33'),
(361, 102, 32, 185, 74, 5, '2026-08-14 13:26:33'),
(362, 103, 33, 67, 72, 1, '2026-08-14 14:41:41'),
(363, 103, 33, 445, 72, 2, '2026-08-14 14:41:41'),
(364, 103, 33, 626, 72, 3, '2026-08-14 14:41:41'),
(365, 103, 33, 588, 72, 4, '2026-08-14 14:41:41'),
(366, 103, 33, 526, 72, 5, '2026-08-14 14:41:41'),
(367, 104, 33, 526, 3, 1, '2026-08-14 16:42:40'),
(368, 104, 33, 67, 3, 2, '2026-08-14 16:42:40'),
(369, 104, 33, 588, 3, 3, '2026-08-14 16:42:40'),
(370, 104, 33, 626, 3, 4, '2026-08-14 16:42:40'),
(371, 104, 33, 445, 3, 5, '2026-08-14 16:42:40'),
(372, 105, 34, 516, 72, 1, '2026-08-14 19:18:58'),
(373, 105, 34, 318, 72, 2, '2026-08-14 19:18:58'),
(374, 105, 34, 279, 72, 3, '2026-08-14 19:18:58'),
(375, 106, 35, 223, 3, 1, '2026-08-21 00:45:19'),
(376, 106, 35, 81, 3, 2, '2026-08-21 00:45:19'),
(377, 106, 35, 210, 3, 3, '2026-08-21 00:45:19'),
(378, 107, 36, 127, 3, 1, '2026-08-21 00:52:35'),
(379, 107, 36, 579, 3, 2, '2026-08-21 00:52:35'),
(380, 107, 36, 270, 3, 3, '2026-08-21 00:52:35'),
(381, 108, 37, 203, 76, 1, '2026-08-31 01:17:31'),
(382, 108, 37, 43, 76, 2, '2026-08-31 01:17:31'),
(383, 108, 37, 258, 76, 3, '2026-08-31 01:17:31'),
(384, 108, 37, 182, 76, 4, '2026-08-31 01:17:31'),
(385, 108, 37, 443, 76, 5, '2026-08-31 01:17:31'),
(386, 109, 37, 182, 3, 1, '2026-08-31 01:17:49'),
(387, 109, 37, 203, 3, 2, '2026-08-31 01:17:49'),
(388, 109, 37, 258, 3, 3, '2026-08-31 01:17:49'),
(389, 109, 37, 443, 3, 4, '2026-08-31 01:17:49'),
(390, 109, 37, 43, 3, 5, '2026-08-31 01:17:49'),
(391, 110, 38, 597, 76, 1, '2026-08-31 01:38:19'),
(392, 110, 38, 607, 76, 2, '2026-08-31 01:38:19'),
(393, 110, 38, 549, 76, 3, '2026-08-31 01:38:19'),
(394, 110, 38, 158, 76, 4, '2026-08-31 01:38:19'),
(395, 110, 38, 376, 76, 5, '2026-08-31 01:38:19'),
(396, 111, 38, 158, 3, 1, '2026-08-31 01:38:46'),
(397, 111, 38, 549, 3, 2, '2026-08-31 01:38:46'),
(398, 111, 38, 597, 3, 3, '2026-08-31 01:38:46'),
(399, 111, 38, 607, 3, 4, '2026-08-31 01:38:46'),
(400, 111, 38, 376, 3, 5, '2026-08-31 01:38:46'),
(401, 112, 38, 607, 77, 1, '2026-08-31 09:58:03'),
(402, 112, 38, 597, 77, 2, '2026-08-31 09:58:03'),
(403, 112, 38, 549, 77, 3, '2026-08-31 09:58:03'),
(404, 112, 38, 376, 77, 4, '2026-08-31 09:58:03'),
(405, 112, 38, 158, 77, 5, '2026-08-31 09:58:03'),
(406, 113, 39, 254, 77, 1, '2026-08-31 10:02:03'),
(407, 113, 39, 239, 77, 2, '2026-08-31 10:02:03'),
(408, 113, 39, 427, 77, 3, '2026-08-31 10:02:03'),
(409, 113, 39, 456, 77, 4, '2026-08-31 10:02:03'),
(410, 113, 39, 357, 77, 5, '2026-08-31 10:02:03'),
(411, 114, 40, 417, 77, 1, '2026-08-31 10:47:02'),
(412, 114, 40, 435, 77, 2, '2026-08-31 10:47:02'),
(413, 114, 40, 608, 77, 3, '2026-08-31 10:47:02'),
(414, 114, 40, 51, 77, 4, '2026-08-31 10:47:02'),
(415, 114, 40, 405, 77, 5, '2026-08-31 10:47:02'),
(416, 115, 40, 608, 79, 1, '2026-08-31 13:09:48'),
(417, 115, 40, 435, 79, 2, '2026-08-31 13:09:48'),
(418, 115, 40, 417, 79, 3, '2026-08-31 13:09:48'),
(419, 115, 40, 405, 79, 4, '2026-08-31 13:09:48'),
(420, 115, 40, 51, 79, 5, '2026-08-31 13:09:48'),
(421, 116, 41, 60, 80, 1, '2026-08-31 13:44:59'),
(422, 116, 41, 638, 80, 2, '2026-08-31 13:44:59'),
(423, 116, 41, 250, 80, 3, '2026-08-31 13:44:59'),
(424, 116, 41, 278, 80, 4, '2026-08-31 13:44:59'),
(425, 116, 41, 525, 80, 5, '2026-08-31 13:44:59'),
(426, 117, 42, 602, 79, 1, '2026-08-31 18:48:19'),
(427, 117, 42, 168, 79, 2, '2026-08-31 18:48:19'),
(428, 117, 42, 293, 79, 3, '2026-08-31 18:48:19'),
(429, 118, 42, 168, 80, 1, '2026-08-31 23:42:18'),
(430, 118, 42, 293, 80, 2, '2026-08-31 23:42:18'),
(431, 118, 42, 602, 80, 3, '2026-08-31 23:42:18'),
(432, 119, 43, 130, 80, 1, '2026-09-01 14:22:06'),
(433, 119, 43, 322, 80, 2, '2026-09-01 14:22:06'),
(434, 119, 43, 511, 80, 3, '2026-09-01 14:22:06'),
(435, 120, 43, 322, 82, 1, '2026-09-02 02:16:39'),
(436, 120, 43, 511, 82, 2, '2026-09-02 02:16:39'),
(437, 120, 43, 130, 82, 3, '2026-09-02 02:16:39'),
(438, 121, 43, 130, 79, 1, '2026-09-02 19:52:33'),
(439, 121, 43, 511, 79, 2, '2026-09-02 19:52:33'),
(440, 121, 43, 322, 79, 3, '2026-09-02 19:52:33'),
(441, 122, 43, 511, 3, 1, '2026-09-12 15:47:37'),
(442, 122, 43, 130, 3, 2, '2026-09-12 15:47:37'),
(443, 122, 43, 322, 3, 3, '2026-09-12 15:47:37');

-- --------------------------------------------------------

--
-- Table structure for table `level_admin_audit_logs`
--

CREATE TABLE `level_admin_audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_user_id` int(11) DEFAULT NULL,
  `target_user_id` int(11) DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `level_badges`
--

CREATE TABLE `level_badges` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `badge_order` int(11) NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `level_badges`
--

INSERT INTO `level_badges` (`id`, `name`, `badge_order`, `image_path`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Beginner', 1, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(2, 'Rookie', 2, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(3, 'Hustler', 3, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(4, 'Raider', 4, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(5, 'Specialist', 5, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(6, 'Elite', 6, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(7, 'Mastermind', 7, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(8, 'Legend', 8, NULL, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05');

-- --------------------------------------------------------

--
-- Table structure for table `level_definitions`
--

CREATE TABLE `level_definitions` (
  `id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `level_order` int(11) NOT NULL,
  `badge_level` int(11) NOT NULL,
  `roman_label` varchar(8) NOT NULL,
  `xp_required` int(11) NOT NULL,
  `coupon_copup_jr_amount` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `level_definitions`
--

INSERT INTO `level_definitions` (`id`, `badge_id`, `level_order`, `badge_level`, `roman_label`, `xp_required`, `coupon_copup_jr_amount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 5, 5, 'V', 400, 25, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(2, 1, 4, 4, 'IV', 300, 20, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(3, 1, 3, 3, 'III', 200, 15, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(4, 1, 2, 2, 'II', 100, 10, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(5, 1, 1, 1, 'I', 0, 5, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(6, 2, 10, 5, 'V', 900, 50, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(7, 2, 9, 4, 'IV', 800, 45, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(8, 2, 8, 3, 'III', 700, 40, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(9, 2, 7, 2, 'II', 600, 35, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(10, 2, 6, 1, 'I', 500, 30, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(11, 3, 15, 5, 'V', 1400, 75, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(12, 3, 14, 4, 'IV', 1300, 70, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(13, 3, 13, 3, 'III', 1200, 65, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(14, 3, 12, 2, 'II', 1100, 60, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(15, 3, 11, 1, 'I', 1000, 55, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(16, 4, 20, 5, 'V', 1900, 100, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(17, 4, 19, 4, 'IV', 1800, 95, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(18, 4, 18, 3, 'III', 1700, 90, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(19, 4, 17, 2, 'II', 1600, 85, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(20, 4, 16, 1, 'I', 1500, 80, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(21, 5, 25, 5, 'V', 2400, 125, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(22, 5, 24, 4, 'IV', 2300, 120, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(23, 5, 23, 3, 'III', 2200, 115, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(24, 5, 22, 2, 'II', 2100, 110, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(25, 5, 21, 1, 'I', 2000, 105, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(26, 6, 30, 5, 'V', 2900, 150, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(27, 6, 29, 4, 'IV', 2800, 145, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(28, 6, 28, 3, 'III', 2700, 140, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(29, 6, 27, 2, 'II', 2600, 135, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(30, 6, 26, 1, 'I', 2500, 130, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(31, 7, 35, 5, 'V', 3400, 175, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(32, 7, 34, 4, 'IV', 3300, 170, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(33, 7, 33, 3, 'III', 3200, 165, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(34, 7, 32, 2, 'II', 3100, 160, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(35, 7, 31, 1, 'I', 3000, 155, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(36, 8, 40, 5, 'V', 3900, 200, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(37, 8, 39, 4, 'IV', 3800, 195, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(38, 8, 38, 3, 'III', 3700, 190, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(39, 8, 37, 2, 'II', 3600, 185, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
(40, 8, 36, 1, 'I', 3500, 180, 1, '2026-08-30 23:06:05', '2026-08-30 23:06:05');

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
(1, 4, 2500.00, 1, 100.00, 25, 'rejected', 'oo', '/uploads/ChatGPTImageApr16202-1776457235579-732443248.png', 'ooi', 1, NULL, 'Information nor clear ', '2026-04-18 15:23:18', '2026-04-17 20:20:35', '2026-04-18 15:23:18'),
(2, 11, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260419--1776606241402-967250667.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-04-19 13:54:55', '2026-04-19 13:44:01', '2026-04-19 13:54:55'),
(3, 8, 200.00, 1, 100.00, 2, 'approved', 'copupbid ', '/uploads/1000350062-1776630942553-654002120.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-04-19 21:02:02', '2026-04-19 20:35:42', '2026-04-19 21:02:02'),
(4, 13, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_2026-04-2-1777125228131-865262294.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-04-25 15:31:45', '2026-04-25 13:53:48', '2026-04-25 15:31:45'),
(5, 15, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/IMG_3306-1777132624699-920588414.png', NULL, 1, 'Payment confirmed', NULL, '2026-04-25 15:57:53', '2026-04-25 15:57:04', '2026-04-25 15:57:53'),
(6, 17, 200.00, 1, 100.00, 2, 'approved', 'Sent', '/uploads/Screenshot_20260425--1777147946844-555369065.png', 'Sent', 1, 'Payment confirmed', NULL, '2026-04-25 20:14:53', '2026-04-25 20:12:26', '2026-04-25 20:14:53'),
(7, 8, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/1000360852-1777148679475-624354130.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-04-25 20:25:08', '2026-04-25 20:24:39', '2026-04-25 20:25:08'),
(8, 8, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/1000360850-1777383673848-647323606.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-04-28 13:41:59', '2026-04-28 13:41:13', '2026-04-28 13:41:59'),
(9, 25, 1000.00, 1, 100.00, 10, 'approved', 'copupbid', '/uploads/1000617194-1777387176316-174778155.jpg', '❤️', 1, 'Payment confirmed', NULL, '2026-04-28 14:40:13', '2026-04-28 14:39:36', '2026-04-28 14:40:13'),
(10, 14, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260428--1777397043918-142285909.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-04-28 17:32:35', '2026-04-28 17:24:03', '2026-04-28 17:32:35'),
(11, 11, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260501--1777624798563-929465482.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-05-01 08:40:40', '2026-05-01 08:39:58', '2026-05-01 08:40:40'),
(12, 12, 400.00, 1, 100.00, 4, 'approved', NULL, '/uploads/Screenshot_20260504--1777893940825-758632925.png', NULL, 1, 'Payment confirmed', NULL, '2026-05-04 11:26:06', '2026-05-04 11:25:40', '2026-05-04 11:26:06'),
(13, 31, 200.00, 1, 100.00, 2, 'approved', 'Opay', '/uploads/295802-1778013243880-476596493.png', NULL, 1, 'Payment confirmed', NULL, '2026-05-05 20:34:54', '2026-05-05 20:34:03', '2026-05-05 20:34:54'),
(14, 31, 200.00, 1, 100.00, 2, 'approved', 'Opay', '/uploads/296842-1778059275767-606860372.png', NULL, 1, 'Payment confirmed', NULL, '2026-05-06 09:21:47', '2026-05-06 09:21:15', '2026-05-06 09:21:47'),
(15, 40, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260506--1778086326927-185595687.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-05-06 16:52:36', '2026-05-06 16:52:06', '2026-05-06 16:52:36'),
(16, 41, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260506--1778086371391-530400694.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-05-06 16:53:16', '2026-05-06 16:52:51', '2026-05-06 16:53:16'),
(17, 41, 400.00, 1, 100.00, 4, 'approved', NULL, '/uploads/Screenshot_20260506--1778086763344-13970122.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-05-06 16:59:52', '2026-05-06 16:59:23', '2026-05-06 16:59:52'),
(18, 42, 400.00, 1, 100.00, 4, 'approved', NULL, '/uploads/IMG_8278-1778086860725-3717237.png', NULL, 1, 'Payment confirmed', NULL, '2026-05-06 17:02:05', '2026-05-06 17:01:00', '2026-05-06 17:02:05'),
(19, 32, 500.00, 1, 100.00, 5, 'approved', NULL, '/uploads/Screenshot_20260506--1778092019544-743034897.jpg', NULL, 1, 'Payment confirmed', NULL, '2026-05-06 18:30:50', '2026-05-06 18:26:59', '2026-05-06 18:30:50'),
(20, 3, 1000.00, 1, 100.00, 10, 'rejected', NULL, '/uploads/Abandonedspiderlairi-1778103389348-950687596.png', NULL, 1, NULL, 'Not clear ', '2026-05-06 22:10:11', '2026-05-06 21:36:29', '2026-05-06 22:10:11'),
(21, 3, 100.00, 1, 100.00, 1, 'rejected', NULL, '/uploads/Screenshot_20260506--1778104052994-64366496.jpg', NULL, 1, NULL, 'Not clear ', '2026-05-06 22:10:05', '2026-05-06 21:47:33', '2026-05-06 22:10:05'),
(22, 3, 100.00, 1, 100.00, 1, 'approved', NULL, '/uploads/Screenshot_20260506--1778105466124-126125156.jpg', NULL, 1, 'Reviewed from Telegram', NULL, '2026-05-06 22:36:55', '2026-05-06 22:11:06', '2026-05-06 22:36:55'),
(23, 3, 1000.00, 1, 100.00, 10, 'rejected', NULL, '/uploads/Screenshot_20260506--1778107591123-132202558.jpg', NULL, 1, 'Reviewed from Telegram', 'Rejected from Telegram', '2026-05-06 22:46:40', '2026-05-06 22:46:31', '2026-05-06 22:46:40'),
(24, 3, 1000.00, 1, 100.00, 10, 'rejected', NULL, '/uploads/Screenshot_20260505--1778107679606-430430500.jpg', NULL, 1, 'Processed by Copupbid AI Review System', 'Declined by Copupbid AI Validation', '2026-05-06 22:48:12', '2026-05-06 22:47:59', '2026-05-06 22:48:12'),
(25, 3, 100.00, 1, 100.00, 1, 'approved', NULL, '/uploads/file_00000000956c71f-1778107761699-344660872.png', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-06 22:49:30', '2026-05-06 22:49:21', '2026-05-06 22:49:30'),
(26, 40, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260510--1778432413837-55978963.jpg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-10 17:00:53', '2026-05-10 17:00:13', '2026-05-10 17:00:53'),
(27, 41, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/Screenshot_20260510--1778432667350-949674880.jpg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-10 17:04:40', '2026-05-10 17:04:27', '2026-05-10 17:04:40'),
(28, 49, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/receipt-177859724931-1778597266669-205030987.jpeg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-12 14:48:07', '2026-05-12 14:47:46', '2026-05-12 14:48:07'),
(29, 52, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/338220-1778600383184-619407307.png', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-12 15:39:51', '2026-05-12 15:39:43', '2026-05-12 15:39:51'),
(30, 50, 300.00, 1, 100.00, 3, 'approved', NULL, '/uploads/Screenshot_2026-05-1-1778747662755-25799055.jpg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-14 08:34:31', '2026-05-14 08:34:22', '2026-05-14 08:34:31'),
(31, 51, 200.00, 1, 100.00, 2, 'approved', 'Pay', '/uploads/1000548656-1778838323234-619665706.jpg', 'Pay', 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-15 10:02:24', '2026-05-15 09:45:23', '2026-05-15 10:02:24'),
(32, 8, 300.00, 1, 100.00, 3, 'approved', NULL, '/uploads/1000392244-1779456905033-301244586.jpg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-22 13:35:26', '2026-05-22 13:35:05', '2026-05-22 13:35:26'),
(33, 8, 200.00, 1, 100.00, 2, 'approved', NULL, '/uploads/1000393797-1779562122613-738353970.jpg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-23 18:49:53', '2026-05-23 18:48:42', '2026-05-23 18:49:53'),
(34, 8, 500.00, 1, 100.00, 5, 'approved', NULL, '/uploads/1000411320-1780763987436-531014476.jpg', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-06-06 16:45:09', '2026-06-06 16:39:47', '2026-06-06 16:45:09'),
(35, 17, 300.00, 1, 100.00, 3, 'approved', NULL, '/uploads/1001545924-1782893226425-561847939.png', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-07-01 08:07:53', '2026-07-01 08:07:06', '2026-07-01 08:07:53'),
(36, 69, 300.00, 1, 100.00, 3, 'approved', NULL, '/uploads/Screenshot_20260701--1782893868105-507984942.png', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-07-01 08:17:55', '2026-07-01 08:17:48', '2026-07-01 08:17:55');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_reference` varchar(64) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('pending','processing','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  `recipient_name` varchar(180) NOT NULL,
  `phone_number` varchar(32) NOT NULL,
  `detailed_address` varchar(1000) NOT NULL,
  `state` varchar(80) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `location_accuracy` decimal(10,2) DEFAULT NULL,
  `location_captured_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `entitlement_id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `product_name` varchar(180) NOT NULL,
  `product_description` text DEFAULT NULL,
  `primary_image_path` varchar(500) DEFAULT NULL,
  `gallery_json` longtext DEFAULT NULL,
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

--
-- Dumping data for table `otps`
--

INSERT INTO `otps` (`id`, `email`, `otp`, `expires_at`, `created_at`) VALUES
(77, 'kachidunamis30@gmail.com', '511049', '2026-05-11 02:40:46', '2026-05-11 06:30:46'),
(113, 'oghenekevwe617@gmail.com', '211999', '2026-08-31 07:01:30', '2026-08-31 10:51:30');

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
(1, 'copup limited', '7065785436', 'bank_transfer', 'moin point', 'payment should be made here ', 0, 1, '2026-04-17 19:41:07', '2026-04-18 15:26:49'),
(2, 'Copupbid Limited', '7065785436', 'Bank Transfer', 'moin point', 'payment should be made here ', 0, 1, '2026-04-18 15:26:49', '2026-04-18 15:27:55'),
(3, 'Copupbid Limited', '7065785436', 'Bank Transfer', 'Monie Point', 'payment should be made here ', 0, 1, '2026-04-18 15:27:55', '2026-04-18 15:28:58'),
(4, 'Copupbid Limited', '7065785436', 'Bank Transfer', 'Monie Point', 'Kindly make your payment to the account above.\nOnce done, submit your payment proof or transaction ID for quick confirmation.\nYour balance will be updated after verification.', 1, 1, '2026-04-18 15:28:58', '2026-04-18 15:28:58');

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
(2, 4, 1, 90.00, 1, 100.00, 'approved', 'sam', '1234567890', 'bank_transfer', 'opay', NULL, NULL, 1, 'Payout completed', NULL, '2026-04-18 15:23:26', '2026-04-17 20:05:22', '2026-04-18 15:23:26'),
(3, 3, 10, 900.00, 1, 100.00, 'rejected', '17012345789', 'samuel light', 'bank_transfer', 'make bank', NULL, 'fee', 1, NULL, 'Noted needed ', '2026-04-25 15:32:47', '2026-04-21 11:45:47', '2026-04-25 15:32:47'),
(4, 3, 10, 900.00, 1, 100.00, 'rejected', 'SAMUEL OGHENEFEJIRO OGHENECHOVWE', '7065785436', 'bank_transfer', 'Opay', '100004', 'test fee', 1, NULL, 'Not needed ', '2026-04-25 15:32:42', '2026-04-21 13:23:27', '2026-04-25 15:32:42'),
(5, 3, 1, 90.00, 1, 100.00, 'approved', 'SAMUEL OGHENEFEJIRO OGHENECHOVWE', '7065785436', 'bank_transfer', 'Opay', '100004', 'sam here ', 1, 'Payout completed', NULL, '2026-04-25 15:32:09', '2026-04-21 13:26:42', '2026-04-25 15:32:09'),
(6, 2, 1, 90.00, 1, 100.00, 'rejected', 'JOSHUA OCHUKO OKPAN', '8120675871', 'bank_transfer', 'Opay', '100004', 'Cool ', 1, NULL, 'Not needed ', '2026-04-25 15:32:35', '2026-04-21 13:31:11', '2026-04-25 15:32:35'),
(7, 8, 5, 450.00, 1, 100.00, 'approved', 'BRIAN OGHENEFEJIRO GEORGE-OKE', '9018535763', 'bank_transfer', 'PALMPAY', '100033', NULL, 1, 'Payout completed', NULL, '2026-04-25 19:20:10', '2026-04-25 19:14:02', '2026-04-25 19:20:10'),
(8, 8, 5, 450.00, 1, 100.00, 'approved', 'BRIAN OGHENEFEJIRO GEORGE-OKE', '9018535763', 'bank_transfer', 'Moniepoint Microfinance Bank', '090405', NULL, 1, 'Payout completed', NULL, '2026-04-26 21:55:03', '2026-04-26 21:52:48', '2026-04-26 21:55:03'),
(9, 17, 5, 450.00, 1, 100.00, 'approved', 'NOBLE CHIBUEYIM IHUTE', '7073660016', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Payout completed', NULL, '2026-04-28 08:45:50', '2026-04-28 08:43:29', '2026-04-28 08:45:50'),
(10, 8, 6, 540.00, 1, 100.00, 'approved', 'BRIAN OGHENEFEJIRO GEORGE-OKE', '9018535763', 'bank_transfer', 'Moniepoint Microfinance Bank', '090405', NULL, 1, 'Payout completed', NULL, '2026-05-01 23:56:53', '2026-05-01 23:54:49', '2026-05-01 23:56:53'),
(11, 28, 5, 450.00, 1, 100.00, 'approved', 'SANDRA ONYIYECHUKWU OSADINIZU', '9033967497', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Payout completed', NULL, '2026-05-04 10:27:15', '2026-05-04 10:25:53', '2026-05-04 10:27:15'),
(12, 12, 3, 270.00, 1, 100.00, 'approved', 'SAMUEL EWERE KENEBI', '8071623699', 'bank_transfer', 'PALMPAY', '100033', NULL, 1, 'Payout completed', NULL, '2026-05-04 11:22:55', '2026-05-04 11:21:16', '2026-05-04 11:22:55'),
(13, 38, 10, 900.00, 1, 100.00, 'approved', 'PRAISE OGHENETEJIRI BILOTU', '7060617353', 'bank_transfer', 'Moniepoint Microfinance Bank', '090405', NULL, 1, 'Payout completed', NULL, '2026-05-05 20:37:15', '2026-05-04 13:13:24', '2026-05-05 20:37:15'),
(14, 31, 3, 270.00, 1, 100.00, 'approved', 'OGHENETEJIRI MELVIN IRHIRHI', '9114805398', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-08 07:39:00', '2026-05-08 05:23:27', '2026-05-08 07:39:00'),
(15, 45, 10, 900.00, 1, 100.00, 'approved', 'MIRACLE  JAFARU', '9030241746', 'bank_transfer', 'Opay', '100004', 'Testing ', 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-10 22:54:48', '2026-05-10 22:53:48', '2026-05-10 22:54:48'),
(16, 12, 10, 900.00, 1, 100.00, 'approved', 'SAMUEL EWERE KENEBI', '8071623699', 'bank_transfer', 'PALMPAY', '100033', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-11 19:38:01', '2026-05-11 19:36:57', '2026-05-11 19:38:01'),
(17, 2, 4, 360.00, 1, 100.00, 'approved', 'JOSHUA OCHUKO OKPAN', '8120675871', 'bank_transfer', 'Opay', '100004', 'My money ', 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-12 11:37:34', '2026-05-12 11:32:38', '2026-05-12 11:37:34'),
(18, 49, 3, 270.00, 1, 100.00, 'approved', 'MERCY ITOHAN OSAKUE', '9161596372', 'bank_transfer', 'PALMPAY', '100033', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-12 14:04:51', '2026-05-12 14:03:40', '2026-05-12 14:04:51'),
(19, 51, 3, 270.00, 1, 100.00, 'approved', 'MARY EKWETAKUFIA OSHARODE', '9129844869', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-12 14:31:44', '2026-05-12 14:29:31', '2026-05-12 14:31:44'),
(20, 52, 5, 450.00, 1, 100.00, 'approved', 'JOY OGHENERIEMU ODJIGHORO', '9124531602', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-12 15:48:11', '2026-05-12 15:47:01', '2026-05-12 15:48:11'),
(21, 40, 1, 90.00, 1, 100.00, 'approved', 'CHRISTABEL EBRUVWIYO AJINA', '7036548706', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-15 05:48:47', '2026-05-15 04:48:47', '2026-05-15 05:48:47'),
(22, 50, 4, 360.00, 1, 100.00, 'approved', 'EDITH OGHENEWAIRE ODILI', '7087311867', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-18 06:14:20', '2026-05-18 06:12:12', '2026-05-18 06:14:20'),
(23, 50, 5, 450.00, 1, 100.00, 'approved', 'EDITH OGHENEWAIRE ODILI', '7087311867', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-20 07:02:40', '2026-05-20 03:57:48', '2026-05-20 07:02:40'),
(24, 56, 15, 1350.00, 1, 100.00, 'approved', 'Chinwe Egomunuko', '2018359755', 'bank_transfer', 'Fairmoney Microfinance Bank Ltd', '090551', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-05-23 09:26:41', '2026-05-23 09:20:34', '2026-05-23 09:26:41'),
(25, 8, 5, 450.00, 1, 100.00, 'rejected', 'BRIAN OGHENEFEJIRO GEORGE-OKE', '9018535763', 'bank_transfer', 'Moniepoint Microfinance Bank', '090405', NULL, 1, 'Processed by Copupbid AI Review System', 'Declined by Copupbid AI Validation', '2026-06-14 18:50:33', '2026-06-09 04:59:54', '2026-06-14 18:50:33'),
(26, 8, 5, 450.00, 1, 100.00, 'rejected', 'BRIAN OGHENEFEJIRO GEORGE-OKE', '9018535763', 'bank_transfer', 'Moniepoint Microfinance Bank', '090405', NULL, 1, 'Processed by Copupbid AI Review System', 'Declined by Copupbid AI Validation', '2026-06-28 01:39:16', '2026-06-24 20:59:01', '2026-06-28 01:39:16'),
(27, 71, 9, 810.00, 1, 100.00, 'approved', 'GIDEON EWANISHA JIMOH', '8158500254', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-07-01 12:40:52', '2026-07-01 12:39:18', '2026-07-01 12:40:52'),
(28, 8, 2, 180.00, 1, 100.00, 'approved', 'BRIAN OGHENEFEJIRO GEORGE-OKE', '9018535763', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-07-10 08:17:37', '2026-07-10 08:16:59', '2026-07-10 08:17:37'),
(29, 69, 10, 900.00, 1, 100.00, 'approved', 'NOBLE CHIBUEYIM IHUTE', '7073660016', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Processed by Copupbid AI Review System', NULL, '2026-07-19 11:18:28', '2026-07-17 10:44:37', '2026-07-19 11:18:28'),
(30, 76, 3, 270.00, 1, 100.00, 'approved', 'LORDSON OCHUKO AJATITON', '7081744560', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Payout completed', NULL, '2026-08-31 01:23:40', '2026-08-31 01:22:41', '2026-08-31 01:23:40'),
(31, 77, 6, 540.00, 1, 100.00, 'approved', 'ROSEMARY  NWANKWO', '9169049183', 'Bank transfer', 'Opay', '100004', NULL, 1, 'Payout completed', NULL, '2026-08-31 10:14:00', '2026-08-31 10:13:01', '2026-08-31 10:14:00'),
(32, 3, 12, 1080.00, 1, 100.00, 'approved', 'ROSEMARY  NWANKWO', '9169049183', 'bank_transfer', 'Opay', '100004', 'From habibi', 1, 'Payout completed', NULL, '2026-08-31 10:18:41', '2026-08-31 10:17:42', '2026-08-31 10:18:41'),
(33, 3, 100, 9000.00, 1, 100.00, 'approved', 'BOMA MICHAEL KASIAKA', '8168679968', 'bank_transfer', 'Opay', '100004', 'From potato', 1, 'Payout completed', NULL, '2026-09-01 12:14:52', '2026-09-01 12:11:50', '2026-09-01 12:14:52'),
(34, 2, 50, 4500.00, 1, 100.00, 'approved', 'JOSHUA OCHUKO OKPAN', '8120675871', 'bank_transfer', 'Opay', '100004', NULL, 1, 'Payout completed', NULL, '2026-09-06 20:09:53', '2026-09-06 20:07:13', '2026-09-06 20:09:53');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(180) NOT NULL,
  `description` text DEFAULT NULL,
  `sku` varchar(80) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(500) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_win_entitlements`
--

CREATE TABLE `product_win_entitlements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `heist_id` int(11) NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('available','in_cart','ordered','cancelled') NOT NULL DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `promo_codes`
--

CREATE TABLE `promo_codes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(64) NOT NULL,
  `copup_jr_amount` int(11) NOT NULL,
  `max_redemptions` int(11) DEFAULT NULL,
  `redemption_count` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `expires_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `promo_codes`
--

INSERT INTO `promo_codes` (`id`, `code`, `copup_jr_amount`, `max_redemptions`, `redemption_count`, `is_active`, `expires_at`, `created_by`, `updated_by`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'COPUPFREE', 5, NULL, 13, 0, '2026-06-08 18:00:00', 1, 1, NULL, '2026-06-06 12:15:45', '2026-08-31 13:41:16'),
(2, 'COPUPBID', 2, 5, 1, 1, NULL, 1, 1, NULL, '2026-08-31 13:42:22', '2026-08-31 13:43:09');

-- --------------------------------------------------------

--
-- Table structure for table `promo_code_redemptions`
--

CREATE TABLE `promo_code_redemptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `promo_code_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `redeemed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `promo_code_redemptions`
--

INSERT INTO `promo_code_redemptions` (`id`, `promo_code_id`, `user_id`, `amount`, `redeemed_at`) VALUES
(1, 1, 2, 5, '2026-06-06 12:23:45'),
(2, 1, 4, 5, '2026-06-06 13:30:52'),
(3, 1, 17, 5, '2026-06-06 14:13:33'),
(4, 1, 59, 5, '2026-06-06 14:19:52'),
(5, 1, 8, 5, '2026-06-06 16:40:58'),
(6, 1, 60, 5, '2026-06-06 16:45:00'),
(7, 1, 61, 5, '2026-06-06 16:47:24'),
(8, 1, 62, 5, '2026-06-06 16:54:05'),
(9, 1, 63, 5, '2026-06-06 16:58:03'),
(10, 1, 64, 5, '2026-06-06 17:01:34'),
(11, 1, 65, 5, '2026-06-06 17:18:24'),
(12, 1, 66, 5, '2026-06-06 17:31:17'),
(13, 1, 67, 5, '2026-06-06 18:36:15'),
(14, 2, 80, 2, '2026-08-31 13:43:09');

-- --------------------------------------------------------

--
-- Table structure for table `push_device_tokens`
--

CREATE TABLE `push_device_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(512) NOT NULL,
  `platform` varchar(32) NOT NULL DEFAULT 'android',
  `app_version` varchar(64) DEFAULT NULL,
  `last_seen_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `push_device_tokens`
--

INSERT INTO `push_device_tokens` (`id`, `user_id`, `token`, `platform`, `app_version`, `last_seen_at`, `created_at`, `updated_at`) VALUES
(1, 3, 'fhK1HDoOSJ2z05FMsKYQxs:APA91bHTzzikzuB_XuWQQ4PvKuzio0RV2sq7g6jvZ24F5R4ow1Nfs-b9Sk17jeGAQHBHyGxbI-pL3SSo6xozwUKU8NMYrwhCOnP7Mpt-g9xQYRBYui6Etq8', 'android', 'android-capacitor', '2026-05-11 13:13:13', '2026-05-11 13:13:13', '2026-05-11 13:13:13'),
(3, 49, 'cEPP7XEpSC688WNwpkXaZs:APA91bHvX9h4CjVzTuNAeW45tIMkNonG1VWIoxLYdnumyOfxWL9c73rU2Vzztq2t5GBPv_sR35vfaydwenzZWW0qwaEX-YGNb4Axwa0EoIXvZNXPim3YNp8', 'android', 'android-capacitor', '2026-05-12 13:53:35', '2026-05-12 13:53:35', '2026-05-12 13:53:35'),
(5, 3, 'c9U9_2QvW4XWDnusR6NGx1:APA91bGiqW4oorn6fbsnD7QrYOkpMckf-MZWWYkC7frQx0CtTt1kfaDiuL0PTZESHpzVspmEbHqsXbYvYiFjfhqrLgn_4LdCkN-CUG2z-GuVZWP5OFTJcS0', 'web', 'web-browser', '2026-05-21 10:45:43', '2026-05-21 10:45:43', '2026-05-21 10:45:43'),
(8, 77, 'd4tKwe_B9mCk1aEp2mAgfF:APA91bHkSQvpElNZMqzriXeVprb_bEA9M5r_Iln9ykLm7yOe7HlErplIfV962CdRYoEup5AEb_utF9dbWsXB7aaG6atiY34f5vwTUFhrw0PHYNWBU1N02nw', 'web', 'web-browser', '2026-08-31 09:52:53', '2026-08-31 09:52:53', '2026-08-31 09:52:53'),
(9, 79, 'euuklYoWsLdzZND-HKHXCT:APA91bFbq5frZIdx6iW5dF8KRAO_8xMz6usc1ED2s1oRBFG7ASII5Tttzn5-AA-a7alPuTXjgLWvL0RO9eOviDB1LDiDhcjCPOVzCQg_AYridaaiyZWc3to', 'web', 'web-browser', '2026-09-02 19:59:01', '2026-09-02 19:59:01', '2026-09-02 19:59:01');

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
(3, 2, 8, '2026-04-18 17:28:49'),
(4, 2, 9, '2026-04-18 18:29:47'),
(5, 2, 10, '2026-04-19 09:57:26'),
(6, 3, 15, '2026-04-25 15:54:53'),
(7, 3, 16, '2026-04-25 19:43:32'),
(8, 3, 19, '2026-04-26 13:56:19'),
(9, 17, 21, '2026-04-28 08:01:16'),
(10, 15, 23, '2026-04-28 09:04:12'),
(11, 15, 25, '2026-04-28 12:18:14'),
(12, 15, 27, '2026-04-28 12:31:51'),
(13, 3, 28, '2026-05-04 10:07:36'),
(14, 3, 29, '2026-05-04 10:07:44'),
(15, 3, 30, '2026-05-04 10:16:03'),
(16, 12, 31, '2026-05-04 11:17:02'),
(17, 3, 32, '2026-05-04 11:18:40'),
(18, 3, 33, '2026-05-04 11:22:47'),
(19, 12, 34, '2026-05-04 11:45:14'),
(20, 3, 35, '2026-05-04 12:28:15'),
(21, 3, 36, '2026-05-04 13:01:54'),
(22, 3, 37, '2026-05-04 13:04:54'),
(23, 3, 38, '2026-05-04 13:05:40'),
(24, 29, 39, '2026-05-04 22:13:14'),
(25, 3, 41, '2026-05-06 16:43:36'),
(26, 40, 43, '2026-05-06 17:22:52'),
(27, 3, 45, '2026-05-10 22:31:02'),
(28, 45, 46, '2026-05-11 06:29:26'),
(29, 45, 47, '2026-05-11 11:07:39'),
(30, 3, 48, '2026-05-12 13:52:49'),
(31, 3, 49, '2026-05-12 13:53:12'),
(32, 3, 50, '2026-05-12 14:20:24'),
(33, 3, 51, '2026-05-12 14:21:27'),
(34, 8, 52, '2026-05-12 15:24:38'),
(35, 3, 53, '2026-05-14 10:23:35'),
(36, 3, 54, '2026-05-22 11:54:43'),
(37, 12, 55, '2026-05-22 22:07:24'),
(38, 7, 56, '2026-05-23 08:16:27'),
(41, 3, 70, '2026-07-01 12:29:40'),
(42, 3, 71, '2026-07-01 12:30:15'),
(43, 3, 72, '2026-08-11 20:56:11'),
(44, 72, 73, '2026-08-11 21:25:44'),
(45, 3, 77, '2026-08-31 09:31:24'),
(46, 77, 78, '2026-08-31 11:11:43'),
(47, 77, 79, '2026-08-31 12:26:18'),
(48, 3, 80, '2026-08-31 13:31:33'),
(49, 77, 81, '2026-08-31 16:34:00'),
(50, 3, 82, '2026-08-31 23:59:28'),
(51, 3, 83, '2026-09-12 14:00:00');

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
(1, 1, 15, 25, 1, NULL, 0, 8, '2026-04-30 02:04:44', '2026-04-30 06:04:44', '2026-04-30 06:04:44'),
(2, 1, 2, 8, 7, '2026-05-12 07:31:06', 1, 22, '2026-05-12 11:03:20', '2026-04-30 21:31:47', '2026-05-12 15:03:20'),
(4, 1, 3, 28, 1, NULL, 0, 10, '2026-05-04 06:15:20', '2026-05-04 10:15:20', '2026-05-04 10:15:20'),
(5, 1, 3, 30, 1, NULL, 0, 10, '2026-05-04 06:17:45', '2026-05-04 10:17:45', '2026-05-04 10:17:45'),
(6, 1, 3, 29, 1, NULL, 0, 10, '2026-05-04 06:21:36', '2026-05-04 10:21:36', '2026-05-04 10:21:36'),
(7, 1, 3, 36, 1, NULL, 0, 11, '2026-05-04 09:06:12', '2026-05-04 13:06:12', '2026-05-04 13:06:12'),
(8, 1, 3, 37, 1, NULL, 0, 11, '2026-05-04 09:08:50', '2026-05-04 13:08:50', '2026-05-04 13:08:50'),
(9, 1, 3, 38, 1, NULL, 0, 11, '2026-05-04 09:09:30', '2026-05-04 13:09:30', '2026-05-04 13:09:30'),
(10, 1, 12, 31, 2, '2026-05-06 13:02:11', 1, 13, '2026-05-06 13:06:45', '2026-05-05 20:36:09', '2026-05-06 17:06:45'),
(13, 1, 3, 41, 3, '2026-05-07 14:44:11', 1, 17, '2026-05-10 13:04:54', '2026-05-06 16:54:43', '2026-05-10 17:04:54'),
(17, 1, 3, 32, 2, NULL, 0, 15, '2026-05-07 14:46:20', '2026-05-06 18:32:02', '2026-05-07 18:46:20'),
(21, 1, 2, 3, 2, '2026-05-12 07:30:56', 1, 17, '2026-05-10 13:13:32', '2026-05-08 07:46:55', '2026-05-12 11:30:56'),
(23, 1, 3, 15, 1, NULL, 0, 16, '2026-05-10 12:45:39', '2026-05-10 16:45:39', '2026-05-10 16:45:39'),
(27, 1, 3, 45, 1, NULL, 0, 18, '2026-05-10 21:04:11', '2026-05-11 01:04:11', '2026-05-11 01:04:11'),
(28, 1, 29, 39, 1, NULL, 0, 18, '2026-05-12 08:04:26', '2026-05-12 12:04:26', '2026-05-12 12:04:26'),
(30, 1, 3, 48, 1, NULL, 0, 20, '2026-05-12 09:58:27', '2026-05-12 13:58:27', '2026-05-12 13:58:27'),
(31, 1, 3, 49, 2, NULL, 0, 19, '2026-05-12 10:50:38', '2026-05-12 14:00:19', '2026-05-12 14:50:38'),
(32, 1, 3, 50, 1, NULL, 0, 21, '2026-05-12 10:25:39', '2026-05-12 14:25:39', '2026-05-12 14:25:39'),
(33, 1, 3, 51, 1, NULL, 0, 21, '2026-05-12 10:27:06', '2026-05-12 14:27:06', '2026-05-12 14:27:06'),
(36, 2, 3, 49, 2, NULL, 0, 23, '2026-05-12 11:50:52', '2026-05-12 15:21:43', '2026-05-12 15:50:52'),
(37, 2, 8, 52, 1, NULL, 0, 22, '2026-05-12 11:40:46', '2026-05-12 15:40:46', '2026-05-12 15:40:46'),
(39, 2, 3, 50, 2, NULL, 0, 24, '2026-05-16 14:08:58', '2026-05-14 08:34:55', '2026-05-16 18:08:58'),
(41, 2, 2, 8, 4, NULL, 0, 30, '2026-07-04 19:51:40', '2026-05-22 14:16:23', '2026-07-04 23:51:40'),
(42, 2, 7, 56, 1, NULL, 0, 25, '2026-05-23 04:34:11', '2026-05-23 08:34:11', '2026-05-23 08:34:11'),
(44, 2, 3, 4, 1, NULL, 0, 28, '2026-06-06 09:30:58', '2026-06-06 13:30:58', '2026-06-06 13:30:58'),
(47, 2, 3, 71, 1, NULL, 0, 31, '2026-07-01 08:35:03', '2026-07-01 12:35:03', '2026-07-01 12:35:03'),
(48, 2, 3, 70, 1, NULL, 0, 31, '2026-07-01 08:36:25', '2026-07-01 12:36:25', '2026-07-01 12:36:25'),
(50, 2, 3, 72, 3, '2026-08-31 06:58:41', 1, 34, '2026-08-14 15:17:51', '2026-08-14 12:46:15', '2026-08-31 10:58:41'),
(51, 2, 2, 3, 7, NULL, 0, 43, '2026-09-12 11:47:27', '2026-08-14 12:56:09', '2026-09-12 15:47:27'),
(59, 2, 3, 77, 3, '2026-08-31 06:58:37', 1, 40, '2026-08-31 06:46:59', '2026-08-31 09:57:40', '2026-08-31 10:58:37'),
(62, 2, 77, 79, 3, NULL, 0, 43, '2026-09-02 15:51:39', '2026-08-31 13:08:46', '2026-09-02 19:51:39'),
(63, 2, 3, 80, 3, NULL, 0, 43, '2026-09-01 10:22:00', '2026-08-31 13:43:14', '2026-09-01 14:22:00'),
(67, 2, 3, 82, 1, NULL, 0, 43, '2026-09-01 22:16:30', '2026-09-02 02:16:30', '2026-09-02 02:16:30');

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
  `role` enum('user','affiliate','admin') NOT NULL DEFAULT 'user',
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `referral_code` varchar(50) DEFAULT NULL,
  `wallet_address` varchar(100) DEFAULT NULL,
  `game_id` varchar(50) DEFAULT NULL,
  `registration_ip` varchar(64) DEFAULT NULL,
  `registration_device_key` varchar(128) DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `last_seen_at` timestamp NULL DEFAULT NULL,
  `cop_point` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `username`, `full_name`, `password_hash`, `trade_pin_hash`, `trade_pin_changed`, `role`, `is_verified`, `is_blocked`, `referral_code`, `wallet_address`, `game_id`, `registration_ip`, `registration_device_key`, `last_login_at`, `last_seen_at`, `cop_point`, `created_at`, `updated_at`) VALUES
(1, 'copuptop@gmail.com', 'admin', 'Heist Admin', '$2b$12$tpYVufE/VQekDxpucV6meOf7SHtJXRh5iy.bXCNbajnUVpUsxfmle', NULL, 0, 'admin', 1, 0, 'ADMIN01', 'copADMINWALLET000001', 'ADMIN-GAME-001', NULL, NULL, '2026-09-12 15:43:08', '2026-09-12 15:45:33', 0, '2026-04-17 07:42:52', '2026-09-12 15:45:33'),
(2, 'jossycode0@gmail.com', 'Zed', 'Zed (zero)', '$2b$12$eHmw2ax2RpccXZT.QuEtcO92uk/JoHVaTiSZgkRdbPxoRlpMKL/qq', '$2b$12$eOB6g5wwSA2AMA9dcNKx/uDBngxcqT1D/Jm2AEA3DFZdWiL4xs/ly', 1, 'user', 1, 0, 'billions', 'coptg67Gv5Ep3Uk29IgEMwH', 'ZSDW-C5PZ-RN8K', NULL, NULL, '2026-09-05 11:06:32', '2026-09-06 20:06:03', 804, '2026-04-17 09:00:03', '2026-09-06 20:07:13'),
(3, '8amlight@gmail.com', 'light', 'Habibi', '$2b$12$6YpXM2xJkyu27NPcobfEf./UUDW1GAqw0DiBMh1/GlGONCL3.BJ5S', '$2b$12$gnfX5Oq6l06HkhPEkGoO0u74I3wFZLNo9gEYmlJq63Z.vgE5ToMCi', 1, 'user', 1, 0, 'light', 'copiOKpOlWoG1ofmEz0FBGR', 'VHA5-EGR2-H276', NULL, NULL, '2026-09-12 22:30:09', '2026-09-12 23:42:44', 286, '2026-04-17 10:35:32', '2026-09-12 23:42:44'),
(4, '8amjoker@gmail.com', 'joker', '8amjoker', '$2b$12$/McCefomtmThjCWl5NvsMONTsHUsVa69SuL.MO0tJPMe5Cu.soVR6', '$2b$12$6HWO.yc3vqIHctuU5kn3N.QZCZK56kp4MiHszfCDi.0/qpqDO0x9i', 1, 'user', 1, 0, '72vfko', 'coplwnYe2DDW5NynK6NxJB3', 'P6ZX-Q765-8BZ8', NULL, NULL, '2026-08-11 20:53:53', '2026-08-12 21:29:54', 5170, '2026-04-17 18:42:25', '2026-08-12 21:29:54'),
(5, 'dbillionnejay@gmail.com', 'DbillionneJay', 'Not again bro', '$2b$12$QqxpAWmZ30v/L.4a3fGnI.JC0B1YPVGVJlRLnb7jTM1oo4my.JS.q', NULL, 0, 'user', 1, 0, 'u9ghsr', 'copYNx3Ps8fZq4Yjdcyi2NU', '9AWQ-5VU3-8TD4', NULL, NULL, '2026-07-17 10:39:45', '2026-07-17 10:41:57', 0, '2026-04-17 21:49:45', '2026-07-17 10:41:57'),
(7, 'chinweegomunuko@gmail.com', 'D', 'Diamond', '$2b$12$fHl.kpSE54IfxDb82Xwifur8.Jau7q.NTpnR1Vk5NOmpyl3dpK40O', NULL, 0, 'affiliate', 1, 0, 'Diamond', 'copYNx3Ps8fZq4Yjdcyi2Np', '9AWQ-5VU3-8TD0', NULL, NULL, NULL, NULL, 0, '2026-04-17 21:49:45', '2026-05-22 13:12:29'),
(8, 'bgeorgeoke@gmail.com', 'hokage', NULL, '$2b$12$a3sYrftGC143QRD9q5j.WerBGAW4v0xH4DC9Ji4z9ryOhEwqd38Wi', NULL, 0, 'user', 1, 0, 'hokage', 'copT0A7kEoiE5KXJfKTZdUc', 'DEKE-P86S-E8RP', NULL, NULL, '2026-07-04 23:51:27', '2026-07-10 08:17:20', 0, '2026-04-18 17:28:49', '2026-07-10 08:17:20'),
(9, 'omoyibodestined@gmail.com', 'Destined', 'Devon Karo', '$2b$12$s7YlKgyYxsJMgQ.mkXkdg.eGdUwxrOAo2QWfF/E8s8FYXTL/irtPG', NULL, 0, 'user', 1, 0, 'u3jewv', 'copnB2rzaef5nqOtN4HCrrn', '75D6-3DZB-MERT', NULL, NULL, NULL, NULL, 0, '2026-04-18 18:29:47', '2026-04-18 18:29:47'),
(10, 'odomovopraise@gmail.com', 'Lord_movo', 'Praise Odomovo', '$2b$12$FGLcOhzS/SBwZCxG/8gtKunJ4fxo50mCOYZ1hQnq8xDeDhfLT8gq2', NULL, 0, 'user', 1, 0, 'prw2yk', 'copYZJqEZotRe6tybQvdbIQ', '5DJZ-EV27-6T8V', NULL, NULL, NULL, NULL, 0, '2026-04-19 09:57:26', '2026-04-19 09:57:26'),
(11, 'victoroyejola1@gmail.com', 'vicky2004', 'Victor Oyejola', '$2b$12$wp0Ag1DisFz8U/u.tTdWBubZ1XnTJTisfy7PJNTuGoSk5mRGKv04a', NULL, 0, 'user', 1, 0, '9yhlab', 'copfuo7sYvmU0c0JHYb7JLu', '2BHL-NUU7-2HJ9', NULL, NULL, '2026-06-10 03:54:22', '2026-06-10 03:56:15', 0, '2026-04-19 13:17:04', '2026-06-10 03:56:15'),
(12, 'kensamzey@gmail.com', 'Samzey', 'Kenebi Samuel Ewere', '$2b$12$FUar.JPiO1SQjrVNQe6OKuu4Z4viRHNTFaCQ2WjF1Dp4kbGSbyU2K', NULL, 0, 'user', 1, 0, 'Samzey', 'copVIfTehNGMpRxsaRkmqyp', 'RD7H-LBBQ-3WBU', NULL, NULL, '2026-08-16 11:30:33', '2026-08-16 11:30:33', 0, '2026-04-21 15:08:30', '2026-08-16 11:30:33'),
(13, 'chukwusunumnwachukwu@gmail.com', 'Tyson', 'Chukwusunum Tyson Nwachukwu', '$2b$12$Z66JzamXx7UqI.1n76ZUVueIpv9hbVx3N55.Y.7WngkI6RWmfmYLa', NULL, 0, 'user', 1, 0, 'p5inok', 'copeNMmcdQvzcMTB3LIk4sQ', 'GWTM-PASB-L9DV', NULL, NULL, NULL, NULL, 0, '2026-04-22 18:51:42', '2026-04-25 15:48:39'),
(14, 'youngjosh494@gmail.com', 'Joshua', 'Baby', '$2b$12$6HRTTWgC9SKq00SYZwEfTe/fKj.Kj7GE2KL97F.IsfP6szeDo/W8O', NULL, 0, 'user', 1, 0, 'porl6j', 'cop29Jr8K00rHTFHdBgjnQq', '6QHW-29LP-EV38', NULL, NULL, '2026-07-01 18:58:22', '2026-07-01 18:58:25', 0, '2026-04-24 22:27:56', '2026-07-01 18:58:25'),
(15, 'queenclaire015@gmail.com', 'Seraphclaire', 'Seraph Claire ✨🤍', '$2b$12$tJ6JPJJpijoslzMRguS5JeXUym6J1rEgB/I/G5xpZfE.RyUxlgk3u', '$2b$12$yjN7Md9Mr5SNi5G7vSiCRuf.InnSC8dUGRaqNoA6vK7PtTXLimqt2', 1, 'user', 1, 0, 'Seraphclaire', 'copLflkBY7W8AH9wg465i6q', 'UXYG-5L45-QT2R', NULL, NULL, NULL, NULL, 3, '2026-04-25 15:54:53', '2026-05-10 16:48:06'),
(16, 'jamesnwabuwa3@gmail.com', 'James', 'Nwabuwa james', '$2b$12$zI5qJ8cdWHcvMsAhJXIP.uNFG8n3v/xjzaN.nHwV8JqIeqho.YyRu', NULL, 0, 'user', 1, 0, '81odp7', 'copEnXQDW7aaCcGsYCw6TY2', 'NFUK-M5PU-PKL3', NULL, NULL, NULL, NULL, 0, '2026-04-25 19:43:32', '2026-04-25 19:43:32'),
(17, 'bekeeemmanuel2004@gmail.com', 'mrdomaincodm', 'Emmanuel Bekee', '$2b$12$wKcggTXw2/uvIfuliBwQsO40NIGZRP9b8APfIPP6vAegC6isDi8uS', NULL, 0, 'user', 1, 0, 'yldviz', 'copw1U8JYJfuNOOsb6ROsxL', '2GX8-P68E-A9TF', NULL, NULL, '2026-07-01 08:05:42', '2026-07-05 20:46:52', 0, '2026-04-25 19:46:05', '2026-07-05 20:46:52'),
(18, 'adeniyitomisinj@gmail.com', 'adeniyijohn6', NULL, '$2b$12$Qk8WHTYlEFgb3o0Ct3reG.nGqqjKPZL94OVc48zdyTVeYhxd2Hiwa', NULL, 0, 'user', 1, 0, 'ai7w8u', 'copZGwTuAX35QqtCt3CM51v', 'ZMTV-HNUQ-CVUR', NULL, NULL, NULL, NULL, 0, '2026-04-25 19:55:49', '2026-04-25 19:55:49'),
(19, 'shadowbtc730@gmail.com', 'Warrishadow', 'Oghenechovwe Steven omonefe', '$2b$12$47t6zGHBT9JtLscM.iF2j.iQnmSUp9on.auhTv/IeIoXbY17I5MSW', NULL, 0, 'user', 1, 0, 'z7knaw', 'copCu7OLX9xIeqfUM44yxUy', 'HSTK-DTQS-D37L', NULL, NULL, NULL, NULL, 0, '2026-04-26 13:56:19', '2026-04-26 14:01:14'),
(20, 'mercyanidi23@gmail.com', 'Tega', 'Oghenetega', '$2b$12$HlH9E8fHv7O4mmtAolqNBOAjLPw06/Fl6iHCN/MlDmsyOnhUUCEHC', NULL, 0, 'user', 1, 0, 'fex4y9', 'copkpv8qkELvDSeaHymQWW1', 'RVWE-EYXG-QAUK', NULL, NULL, NULL, NULL, 0, '2026-04-26 19:26:12', '2026-04-26 19:26:12'),
(21, 'nobleihute25@gmail.com', 'nobleihute25@gmail.com', 'Noble Chibueyim Ihute', '$2b$12$MS6tedtYXV0CoJypHGVh1uHNMegldw2L7z4NC3pfTzVjsShdMo0Hi', NULL, 0, 'user', 1, 0, '7ZET8WSS', 'cop7NAG2W7s7GEXUy49gfZe', 'SHBL-4HD3-7LDS', NULL, NULL, NULL, NULL, 0, '2026-04-28 08:01:16', '2026-04-28 08:01:16'),
(22, 'officialjj081@gmail.com', 'aj', 'Aj', '$2b$12$BLNL3jPHnB0jBgZl9YtnguGRn1f83bc.cpZL3/IcGj3D/IwfqMDN2', NULL, 0, 'user', 1, 0, 'NX77ESY6', 'copEgs16owKQH6tQYbU9HhM', 'XWGP-KA5A-LR9R', NULL, NULL, NULL, NULL, 0, '2026-04-28 08:50:39', '2026-04-28 08:50:39'),
(23, 'abigaelbidemioluwaleye07@gmail.com', 'Boluwatife.O✝️❤️‍🔥', 'Boluwatife.O✝️❤️‍🔥', '$2b$12$dkahOPg6vtu98H5W31bcnuZK0h5FvLcK0pN/lUcIm26FQKyNNmTbm', NULL, 0, 'user', 1, 0, 'ANH8QM3Y', 'copY2g1fxP3e7bLUonqgPEZ', 'WVWN-7CLM-J3A4', NULL, NULL, NULL, NULL, 0, '2026-04-28 09:04:12', '2026-04-28 09:04:12'),
(24, 'jenniferblackdairy@gmail.com', 'Jen', NULL, '$2b$12$W5SUdcva4tF1YJP6XqZwSexZB.E0CLPTDbDf.X6udYXlvvP/KIwVm', NULL, 0, 'user', 1, 0, '325LAHST', 'copvqC3ub4z5Xf5Oe8GdrAd', 'NPND-MBAQ-6BX3', NULL, NULL, NULL, NULL, 0, '2026-04-28 09:20:59', '2026-04-28 09:24:47'),
(25, 'dominionoghenemaro998@gmail.com', 'JUSTDOMINION', 'ULUEME DOMINION OGHENEMARO', '$2b$12$UO6keXLhuRirLoiJk9aVUeL.4njbaZxAogxLI9mcpRtz3V6O2s4p.', NULL, 0, 'user', 1, 0, 'KHVWSNP9', 'copwtFXudQzYswAmty10iip', 'KWGG-GFXL-U6JB', NULL, NULL, NULL, NULL, 6, '2026-04-28 12:18:14', '2026-04-30 06:04:44'),
(26, 'tegaogbeni39@gmail.com', 'Favour', 'Ogbeni oghenetega Favour', '$2b$12$u.gj79l53Bi5tNdoRLfvrO2e6BrPv7w8MlyvHCKl4AzV3VqpPICEe', NULL, 0, 'user', 1, 0, '47U8EXTD', 'copQ0s2g6Q3JxKH2DnfUkdJ', 'DA7V-FFT6-36KN', NULL, NULL, NULL, NULL, 0, '2026-04-28 12:29:55', '2026-04-28 12:29:55'),
(27, 'nazarethajereghele@gmail.com', 'nazarethajereghele@gmail.com', 'Nazareth Ajereghele', '$2b$12$4CK98U8EU65rL8QQ212AaO3qHqNLOniUxwTjRblwzFAljqgWk.0/.', NULL, 0, 'user', 1, 0, '3YXC5SCV', 'coppWj1VTTb8pDmnQ70nXgB', 'FKYF-4D58-E6Z6', NULL, NULL, NULL, NULL, 0, '2026-04-28 12:31:51', '2026-04-28 12:31:51'),
(28, 'osadinizulattysandra@gmail.com', 'Isabella', 'osadinizulatty Sandra', '$2b$12$jBfef3fz808s.xu9JRvGyuNJ/0yMcIj5hlbj5ohF8DO59jIdUzMm2', NULL, 0, 'user', 1, 0, 'R5PSVPMZ', 'copLAonJqGZJvy9a7SNRqO7', '2V7D-EYKT-M7X9', NULL, NULL, NULL, NULL, 0, '2026-05-04 10:07:36', '2026-05-04 10:25:53'),
(29, 'kingben2681@gmail.com', 'isaac Benjamin', 'Isaac Benjamin', '$2b$12$WKrXgqwsA3pcCF/.G29DMOQUQER4yZFEOUAb.OP/g19ld4mVdxAP.', NULL, 0, 'user', 1, 0, 'SUH7M54W', 'copcJHVZPjv9kXUwaxBLVGs', 'CXT7-79VC-EPBN', NULL, NULL, NULL, NULL, 0, '2026-05-04 10:07:44', '2026-05-04 10:21:36'),
(30, 'preciousxoxo520@gmail.com', 'precious', 'Peter precious', '$2b$12$gjW0md5SmaoPGCijtxDh.usEO01g8WYUyBFfMDbdaNvumIKvbeM5W', NULL, 0, 'user', 1, 0, 'K7LY8SM3', 'copINrZET7XDt8E1de3BzaV', 'Q3F5-M995-TXXP', NULL, NULL, NULL, NULL, 0, '2026-05-04 10:16:03', '2026-05-04 10:17:45'),
(31, 'irhirhimelvin@gmail.com', 'Tejiri', 'Irhirhi Melvin', '$2b$12$uOpHRArFNLeq2cNjNQ7t.uHWv.uPaGdds/N40ypnJNoKD9EYvVYJ2', NULL, 0, 'user', 1, 0, '7M9XTYXT', 'copkNVABuIuv1AC23uSZPRu', 'DNN2-N6BB-GKPP', NULL, NULL, NULL, NULL, 0, '2026-05-04 11:17:02', '2026-05-08 05:23:27'),
(32, 'ozimtestimony@gmail.com', 'AGENT', 'Testimony Victor', '$2b$12$2nwNJWMsY3R5bdz1I9H2sO1Il9lWgXFp79/fLvjNFJv9dRkY7/7Tm', NULL, 0, 'user', 1, 0, 'J2BURT3J', 'cop7c7oO3H2UvuALV7HrjA4', 'UJKY-HJH5-W37R', NULL, NULL, NULL, NULL, 6, '2026-05-04 11:18:40', '2026-05-08 07:49:12'),
(33, 'goodnessisaac315@gmail.com', 'Isaac Newton', 'Goodness Isaac', '$2b$12$1YthzaUckafFjyZNo9IpSOxXr796BucQZ8zqWBUPBZBD/NdKdT6ga', NULL, 0, 'user', 1, 0, 'BH3TY6VW', 'cop3DFbC5amyY2zito56h9y', '6QMW-ZHEN-6DNV', NULL, NULL, NULL, NULL, 0, '2026-05-04 11:22:47', '2026-05-04 11:22:47'),
(34, 'serenaedafe@gmail.com', 'Serena', 'Aghogho', '$2b$12$gfjC/IUZjCgUv6j1zLQZHOj7YS.FqcinaY3KDy7Elor9be.WzStwW', NULL, 0, 'user', 1, 0, 'KJ9R83PH', 'copiuVg9gbx1Lyh2uFRzCsx', 'S2X9-ZZEK-YS9N', NULL, NULL, NULL, NULL, 0, '2026-05-04 11:45:14', '2026-05-04 11:45:14'),
(35, 'amazingsarah583@gmail.com', 'amazing sarah', 'Sarah', '$2b$12$6kJ.GUKD5Tnw9msG5t.HMux0wa5wrTjXPAfjUKO.FhnUieU5ZBKyG', NULL, 0, 'user', 1, 0, 'S36H9NKT', 'copUqWl8ZVY1pkZUQOyefsP', 'X3WM-UCKW-2N62', NULL, NULL, NULL, NULL, 0, '2026-05-04 12:28:15', '2026-05-04 12:28:15'),
(36, 'ogbochisomsolomon2@gmail.com', 'ogbochisomsolomon@gmail.com', 'Solomon Ogbo Chisom', '$2b$12$jF2zx2x/.u3DAhuZT1iPP.lOzFgIx2bYfz7YcjTIrLa9f7s1VPc4O', NULL, 0, 'user', 1, 0, 'C8SYNGBT', 'cop1iCAsjBVtrXDqwFnrhe0', 'CJ98-ZVWF-SZAN', NULL, NULL, NULL, NULL, 0, '2026-05-04 13:01:54', '2026-05-04 13:06:12'),
(37, 'anitaamarachi335@gmail.com', 'Mike', 'Unique mike', '$2b$12$GLFZVgZ7wbOx3reyTurVruY2P9iEvdXvpccwYM7KCoITk1hwL7V7i', NULL, 0, 'user', 1, 0, 'TFD8U4UH', 'cop4VfjO1JY5KScLo61Hf9o', 'DC3D-UNN4-GDEJ', NULL, NULL, NULL, NULL, 0, '2026-05-04 13:04:54', '2026-05-04 13:08:50'),
(38, 'praisebilotu@gmail.com', 'praisebilotu@gmail.com', 'Bilotu Praise', '$2b$12$/lK1EbYhlQhb3E1ejbT1TeJ.HnQy/q3beI.l2kUvifHi6yj0paCuC', NULL, 0, 'user', 1, 0, 'L4744EMA', 'copbn1hKK5fBduJ5GUVhrrm', 'DG3S-WAYZ-4KLE', NULL, NULL, NULL, NULL, 0, '2026-05-04 13:05:40', '2026-05-04 13:13:24'),
(39, 'tosanekeleni@gmail.com', 'Ghost_0king', 'tosan ekeleni', '$2b$12$VsZL.gnUrB6NeY3rmo0f1.vigYZoXfnLf8g6lqhxKKlMgQbUGYvxa', NULL, 0, 'user', 1, 0, '6MRC6HMZ', 'copVOYburS4AlDRwUfSpsUe', 'LUBT-LYLF-B6CF', NULL, NULL, NULL, NULL, 0, '2026-05-04 22:13:14', '2026-05-12 12:04:26'),
(40, 'christabelajina84@gmail.com', 'ACE', 'Ajina Christabel', '$2b$12$RERy/mSRw8EwDXWE7y5FXOZUPl/KgKGM7f43o3tjSbBNAbiaXjtYS', NULL, 0, 'user', 1, 0, 'ACE', 'copkDKyhyRYawkR1nHgaLHD', 'RG6P-ARRH-5Y54', NULL, NULL, NULL, NULL, 0, '2026-05-06 16:39:48', '2026-05-15 04:48:47'),
(41, 'gloryakudiunor@gmail.com', 'glory', 'Glory akudiunor', '$2b$12$VoNNIYtSjCjR6UTD6vwdYukOUWe8zGLBBEFeqCLCPezwUUEtCtz7O', '$2b$12$cY/d.w4aGM7LUriCp7B87eaJkmQE/8ep4WasPdK.ili1SLsn7u/0q', 1, 'user', 1, 0, 'glory', 'copB9XuqBV0KT2ztjk5ayyT', 'VJJ9-Z5H8-7KQF', NULL, NULL, NULL, NULL, 0, '2026-05-06 16:43:36', '2026-05-10 17:04:54'),
(42, 'etekuwomaufuoma11@gmail.com', 'Savvy111', 'Etekuwoma Ufuoma Gideon', '$2b$12$2Rhl5u.SU7UzBH2c3VlmZeuCDHjB8MIIx8SviGrum.EkE58xXLCpy', '$2b$12$AXFMUXdM8LoBSntaBSRV5ea97D4xE1a8n3EIweAvzOArqIUrFcC.K', 1, 'user', 1, 0, 'VJAV5GVM', 'copO0aqF4IC02A1IuYnpxJs', 'NPBZ-EM4Y-MZTR', NULL, NULL, NULL, NULL, 3, '2026-05-06 16:55:38', '2026-05-06 17:53:10'),
(43, 'jahswillarthor@gmail.com', 'icekage', NULL, '$2b$12$ymWyWynefdMfyOe003apvO.JiGrIRPLp/KXx0XjyPnRypdOc6iAn.', NULL, 0, 'user', 1, 0, 'PSTL7STA', 'copKfuIP50ylXptMNslbFkf', '4NWA-W2HT-9TZ5', NULL, NULL, NULL, NULL, 0, '2026-05-06 17:22:52', '2026-05-06 17:22:52'),
(44, 'beckystyles003@gmail.com', 'Black 🖤', NULL, '$2b$12$MGPGMfllL3idFeZOvgULneWwQxGnMyg1HrlEFXxl/EmY8lhx5CK9q', NULL, 0, 'user', 1, 0, '7EU4SNXQ', 'copKB1ZgLqjICfHh0EPKZtY', 'FXYT-ZYBZ-2522', NULL, NULL, NULL, NULL, 0, '2026-05-06 18:53:37', '2026-05-06 18:53:37'),
(45, 'miraclejafaru586@gmail.com', 'Mich123', 'JAFARU MIRACLE', '$2b$12$dEOfLfGpgeTDUl3giNdx8.seVwvdAav4U1BcjhlO/EWBfc5AZVSvq', NULL, 0, 'user', 1, 0, 'CPA6N9BU', 'copCIbBG67vJEQ5VFM3B9nK', 'VDLJ-M864-YRZB', NULL, NULL, NULL, NULL, 0, '2026-05-10 22:31:02', '2026-05-11 01:04:11'),
(46, 'nwabueguchiomacourage@gmail.com', 'chioma', 'Chioma', '$2b$12$BELtJiF.9x3R5.CWmPw/sez5a99hpeTLGkX1M1FJDd6SRUx8M4q.2', NULL, 0, 'user', 1, 0, 'KH4DT8XK', 'copZp2wNSkLuqpZBWmU6tmf', '883S-9G56-NHWR', NULL, NULL, NULL, NULL, 0, '2026-05-11 06:29:26', '2026-05-11 06:29:26'),
(47, 'futureokpalefe@gmail.com', 'shiny shiny', 'Okpalefe Future', '$2b$12$E7IkyN7Re1.LzCnKK/8.meO7DrAEdJNE5EzVm0xcV9DID.we8ZvV6', NULL, 0, 'user', 1, 0, 'UCTKGFH2', 'copRZCFYEOZVjZswP564e0O', 'UUNA-5F3S-WAJT', NULL, NULL, NULL, NULL, 0, '2026-05-11 11:07:39', '2026-05-11 11:07:39'),
(48, 'grayw7341@gmail.com', 'williams', 'Will', '$2b$12$pLa5uXUUT6ku.kUnJfBFFOnrpVxKOw8nTcVD9/VbuhXbStMl89e4C', NULL, 0, 'user', 1, 0, 'UBSYB3RD', 'copm6t58lZSK0hsAM14PHp3', 'FG36-NKEZ-Y767', NULL, NULL, NULL, NULL, 0, '2026-05-12 13:52:49', '2026-05-12 13:58:27'),
(49, 'edwinjelly338@gmail.com', 'PO', 'Solwin', '$2b$12$3bNfGkaBwQLiJmkCGCD6terlPYXK88TBM2z2DKe27Sq4tx.O9Xrki', NULL, 0, 'user', 1, 0, 'WQYL5Y99', 'cop7jLAqufEooSbC8Qp3aaU', 'K5KE-PKES-X2A8', NULL, NULL, NULL, NULL, 1, '2026-05-12 13:53:12', '2026-05-12 15:50:52'),
(50, 'olisecyril60@gmail.com', 'olisecyril', 'Odili Cyril', '$2b$12$9WhOoAeHwn9us8vf4zd6qOVBFY5P.lIZIm9aroi6H2f1rwkWkLxDC', NULL, 0, 'user', 1, 0, 'CWS5RLNM', 'copHgs1hPDyk74wqfQZBwXO', 'W749-D22G-X56K', NULL, NULL, NULL, NULL, 0, '2026-05-12 14:20:24', '2026-05-20 03:57:48'),
(51, 'osharodebliss02@gmail.com', 'b💓', 'Bliss o', '$2b$12$PerWN6RXEdYgUFPUNDDkF.gtqZOzHZ2TNatZ3CTtLCiyzRi0R6Cy2', NULL, 0, 'user', 1, 0, '86NVHQKT', 'copzgEQZXI9FV5O0MBnMfox', 'XD9U-BH24-4GJ6', NULL, NULL, NULL, NULL, 2, '2026-05-12 14:21:27', '2026-05-15 10:02:24'),
(52, 'milampd2@gmail.com', 'milampd', NULL, '$2b$12$NZ6z73XDKE9ijJIRQ57.3eH4xVFuyS3g6XO26lDS/NVMWBvN8W7QC', NULL, 0, 'user', 1, 0, '7KAR4QZR', 'copdMD3Xk4nsPWVeBk3OqX6', 'CZJ8-PRWK-9BFW', NULL, NULL, NULL, NULL, 0, '2026-05-12 15:24:38', '2026-05-12 15:47:01'),
(53, 'popcornplug0@gmail.com', 'three', 'Three comma', '$2b$12$PGOu6/RjEFpDzuATms39e.bwa8Y4O63t0jnR7Txbc6modz2fnQjLW', NULL, 0, 'affiliate', 1, 0, 'Z5WDVGRS', 'copdiDnh3kfs4fc1HTB0Kjn', 'Q5B8-6B6P-KDBM', NULL, NULL, '2026-07-02 10:36:39', '2026-07-03 13:46:16', 0, '2026-05-14 10:23:35', '2026-07-03 13:46:16'),
(54, 'fitme.io.ai@gmail.com', 'fitme.io', 'Fitme.io', '$2b$12$.HKS9/y0GdQCB2tUp2.dUudtSDw2bNmIREB.qA6p03FpzFWNQX5xq', NULL, 0, 'affiliate', 1, 0, 'CCKJPKYF', 'copHyboqdXQZQjsZO3w4p27', 'VP8H-C95N-SARQ', NULL, NULL, NULL, NULL, 0, '2026-05-22 11:54:43', '2026-05-22 11:54:43'),
(55, 'kenebisamuelewere@gmail.com', 'Comrade', 'Kenebi Samuel', '$2b$12$oXaYROll6qEjJp2tdYRJruY5ZNzJzqSPCM2CQb9ejgJ9W.7ujo5Ia', NULL, 0, 'affiliate', 1, 0, 'Comrade', 'copUFGPFKVR5wvUXmAjvxOE', 'C28T-X9W6-AVB5', NULL, NULL, '2026-08-16 11:29:40', '2026-08-16 11:29:43', 0, '2026-05-22 22:07:24', '2026-08-16 11:29:43'),
(56, 'bbyb1228@gmail.com', 'Temi', NULL, '$2b$12$4rRAV6zI7nQVkFu2gpj8cu9Vy.PbQj86xOt8siosr8oteOLOrsur6', NULL, 0, 'user', 1, 0, '58G26AS4', 'copUvx6E1M3pNSl2WSrYoal', '9SG2-WFR2-U6PK', NULL, NULL, NULL, NULL, 0, '2026-05-23 08:16:27', '2026-05-23 09:20:34'),
(58, 'ebinumike6@gmail.com', 'fundz', 'Ike Ebinum', '$2b$12$G4uBVQXJtnyayEYQquqoVuSRp.VxXzQVec6tzoyxI3KlDlmaSXWwa', NULL, 0, 'user', 1, 0, 'LYZCPBB7', 'copaCxTmExpd2y7t1VISr4U', 'DL2V-PCXQ-3HUM', NULL, NULL, NULL, NULL, 0, '2026-06-01 18:41:03', '2026-06-01 18:41:03'),
(59, 'emmanuelbankxx@gmail.com', 'callmereddi', 'Chidiebere bekee', '$2b$12$x.NqJvAzABfoxuylhDQzVeTzKmgfn2dqkIzzdcW7r.Fg5YGYAFqii', NULL, 0, 'user', 1, 0, 'Y8BPNG2B', 'copWVZtPlby1W12UnZna6Fp', 'FQ9Y-BBG6-6JD4', NULL, NULL, NULL, NULL, 0, '2026-06-06 14:19:05', '2026-06-06 14:19:05'),
(61, 'narutouzumakiforfreefire@gmail.com', 'Uzumaki Naruto', NULL, '$2b$12$HhRqCWWq8AA79LTPmseEzOkku1Xl3OrfJutb1zFyrBwWbfS3y1X2S', NULL, 0, 'user', 1, 0, '8X5Q8HSY', 'copPU7h5Y6iZYeXJ4WRnSTN', 'RX32-JR5F-JG9Z', NULL, NULL, NULL, NULL, 0, '2026-06-06 16:46:59', '2026-06-06 16:46:59'),
(67, 'pugusaqo312@gmail.com', 'chidi fx', 'Chinatu ihute', '$2b$12$pY8JEWvPUBHp12/54yTEAecGFkSSvAM/1NA76Be17DRhxx4CU74nK', NULL, 0, 'user', 1, 0, 'VPMJCHWZ', 'cop97Kobiz7lc5DwpFJgRzd', 'MGN7-4KV7-XW3Q', NULL, NULL, NULL, NULL, 0, '2026-06-06 18:35:31', '2026-06-06 18:35:31'),
(68, 'nicocherki4@gmail.com', 'Stephanie', NULL, '$2b$12$9cIwMMYEZ/WRll/gTua0uOQNTQTLOdsyd0TwLNvHr11O7evDt0JkC', NULL, 0, 'user', 1, 0, 'F25GS4ZL', 'copMTnFXTChxYA2hFXldg9M', 'VUBY-A7W7-VQEE', '197.210.226.109', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '2026-06-22 19:29:43', '2026-06-22 20:06:53', 10, '2026-06-22 19:20:28', '2026-06-22 20:06:53'),
(69, 'chandlerneil886@gmail.com', 'tomitola', 'Tomi', '$2b$12$qTgHJOCiXZsOeWl9iSW7JuvdDkNtjRF2XCJ6mXIp1uAibEFfepTwm', NULL, 0, 'user', 1, 0, '59E35DKZ', 'copssBhvrTNfBtcy3XZ50Y3', '3AFR-A6LU-TB54', '102.90.103.193', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '2026-07-17 10:42:34', '2026-07-17 10:56:23', 0, '2026-07-01 08:16:24', '2026-07-17 10:56:23'),
(70, 'arinzekelvin111@gmail.com', 'Arinze', 'Kelvin', '$2b$12$DCmh3C2ntmQPXJyD/c0p1.w6DeBM7meF3gaBB36I8gttzmUY/3VLq', NULL, 0, 'user', 1, 0, '8LE7QSKY', 'copz5AMNoU5kZaImGJdB92y', 'U4J5-ZUUL-SSBV', '102.90.101.7', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '2026-07-01 12:31:18', '2026-07-01 12:37:14', 0, '2026-07-01 12:29:40', '2026-07-01 12:37:14'),
(71, 'gideonjiomh@gmail.com', 'him', 'gidoen', '$2b$12$dC/Y4E1QzSyJxKsAiTBwieTyG62hXwmpierJU71I8w.FV4Gt.iI1.', NULL, 0, 'user', 1, 0, 'TW7ED7HZ', 'cop3gGP53CO4XeR0Poo7mdO', 'SEWH-KU99-DPTH', '197.211.57.4', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '2026-07-01 12:34:29', '2026-07-01 12:41:01', 0, '2026-07-01 12:30:15', '2026-07-01 12:41:01'),
(72, 'edetanlenvictory261@gmail.com', 'Vicky', 'Edetanlen Victory', '$2b$12$A/tmqZl8290FhBG.MyOnQu2hOYimwLFbgDUCr4PZBjBQ3A3u30/VW', NULL, 0, 'user', 1, 0, 'R7C8YGY5', 'coptnOenvGQPp7temQJ8lRG', 'REWW-PT4C-6CWZ', '105.112.212.3', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '2026-08-11 20:56:31', '2026-08-15 16:58:53', 8, '2026-08-11 20:56:11', '2026-08-20 23:48:22'),
(73, 'nabiose8@gmail.com', 'Nabi', 'Nabi ose', '$2b$12$Ty4FEJaveMEzuSimDI2KAe2IawiukCAvieWH9Vhyn.vlGAySTk8hu', NULL, 0, 'user', 1, 0, 'GE9DLGAU', 'cop03HqJiZwM286IumZq8Qx', 'QXJA-A4L4-CMTG', '105.112.104.248', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '2026-08-11 21:27:35', '2026-08-16 07:38:32', 0, '2026-08-11 21:25:44', '2026-08-16 07:38:32'),
(74, 'ikpemiglorious@gmail.com', 'Jennifer', 'Glorious ikpemi', '$2b$12$Q3sPhbLk.py.qNWfQTUuJeO8h8w57OacsKsWgM5oazoMqdXgRkLaW', NULL, 0, 'user', 1, 0, '272P83RH', 'copkXaQ7QeCSMOHRpHVaslT', 'FMVK-HSXE-B9WU', '102.90.81.197', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '2026-08-12 21:28:03', '2026-08-14 13:32:55', 0, '2026-08-12 21:27:32', '2026-08-14 13:32:55'),
(75, 'uyovictory6@gmail.com', 'donvee177', 'Uyo Victory', '$2b$12$9tzpVwzXXrFxgLUWjOQe3OANcnc747aUyjx7DpM3rCFXtI3OA/E.q', NULL, 0, 'user', 1, 0, 'SVX6U566', 'copUJLwSrNfZxY7CQ2IA6YK', 'GBYH-7GM9-5XZP', '105.113.110.62', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '2026-08-16 12:27:16', '2026-08-16 12:31:42', 0, '2026-08-16 12:26:53', '2026-08-16 12:31:42'),
(76, 'lordsonochuko8@gmail.com', 'giant_silver', 'Lordson Ajatiton', '$2b$12$33YkV6nkC4f/NflSfEIrbeI7yukndsDtfS83ym73g3RmKMVLTfjxi', NULL, 0, 'user', 1, 0, '7PJX5CCX', 'copuH2EeFZPF3VrHdJm4dVW', 'P4ZA-8H24-3FQD', '195.242.214.21', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '2026-08-30 23:37:51', '2026-08-31 01:43:25', 0, '2026-08-30 22:40:16', '2026-08-31 01:43:25'),
(77, 'mercyanayo52@gmail.com', 'mercylove', 'Anayo mercy', '$2b$12$.QIEmjijI3oK4mey6KQoneE8Xg6rQIUA1wAM98AC7huL8GxrF6QA2', NULL, 0, 'affiliate', 1, 0, 'MERCY', 'copT5Q4sll4yAeR3bTBqTO5', 'UHUR-MTEL-MDMX', '102.91.4.210', 'web:Linux aarch64:360x800:Africa/Lagos:a7e3bfc1-6cbd-41ff-972b-b08c99b18af5', '2026-08-31 09:42:45', '2026-09-01 10:43:53', 0, '2026-08-31 09:31:24', '2026-09-01 10:43:53'),
(78, 'adebayodeborahadeyemi@gmail.com', 'Debbie', 'Deborah', '$2b$12$KbzdTfS5OdkZPc4jsYinL.LmuG9zkDVSeIvx5EF7E.WX/Qerv5DsS', NULL, 0, 'affiliate', 1, 0, 'EXTC8YEQ', 'copnHKcZVCm0SyCj7zQV2wP', '7PEM-466D-ZQZP', '102.91.98.215', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '2026-08-31 11:12:18', '2026-08-31 15:50:28', 0, '2026-08-31 11:11:43', '2026-08-31 15:50:28'),
(79, 'nwankworosemary990@gmail.com', 'Rosemary', NULL, '$2b$12$ijLSAya3/sCPike6i74CMuQOiA9.ecuBFQyX4X4y9/clGMBWwmDlO', NULL, 0, 'user', 1, 0, 'Z8TQWPBE', 'cop2vElzJofxEwWjDkRpdra', 'D9JZ-CGHN-Q4TL', '102.91.102.71', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '2026-08-31 12:27:06', '2026-09-05 06:47:13', 6, '2026-08-31 12:26:18', '2026-09-05 06:47:13'),
(80, 'ka3915186@gmail.com', 'ka3915186', 'Kelvin Anderson', '$2b$12$E8m2jaFbXsWpBAgfm/rO1OwwsZ2EdG3VrHeyl4EkfnM4aGka0uMPK', '$2b$12$1.wDjc8h7A371i54YPUWH.b8ES5ufVpslAb5uP8zvooSqGujXPcxS', 1, 'user', 1, 0, 'A9BHJ928', 'coppAntONgevBSgmgWzBQvQ', 'SGRC-KJK4-EWFX', '102.89.46.159', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '2026-09-01 14:16:34', '2026-09-03 00:47:03', 1, '2026-08-31 13:31:33', '2026-09-03 00:47:03'),
(81, 'valantineanidi5@gmail.com', 'Valentine', NULL, '$2b$12$KlqUAqeVTCytMAPQ81FVkuERZEniYOVBMaHgoMcjlL/2fUEyZA7Bm', NULL, 0, 'affiliate', 1, 0, 'CXXAG9Z7', 'copkHJwQVuH0CZCrVLSUCJY', '5FMR-3JGU-26VR', '105.112.106.91', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '2026-08-31 16:34:14', '2026-08-31 16:37:28', 0, '2026-08-31 16:34:00', '2026-08-31 16:37:28'),
(82, 'magnoliagroup293@gmail.com', 'magnolia', 'magnoliagroup293', '$2b$12$ugncCehs93YzPo8Rtemlqulvh5WH92qticUq87yq0n9cNluj4x4ea', NULL, 0, 'user', 1, 0, '94M9QN54', 'copGB2WePz5sIhQ5ysOmMz6', '45Z8-3C4P-WVJY', '102.89.41.128', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '2026-09-02 02:14:48', '2026-09-02 02:21:06', 0, '2026-08-31 23:59:28', '2026-09-02 02:21:06'),
(83, 'thomasblessing504@gmail.com', 'Beauty perry', 'thomasblessing504@gmail.com', '$2b$12$JRN93jb1f3nj.1fZWxiXgec1P6EUHvz87ovS40gH0dhAPHGt9tjye', NULL, 0, 'user', 1, 0, '74TLDEWR', 'copFFySaCjbF3THlERXPs3S', '4K8T-SLPV-GQTP', '185.26.181.66', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '2026-09-12 14:00:34', '2026-09-12 16:02:32', 0, '2026-09-12 14:00:00', '2026-09-12 16:02:32');

-- --------------------------------------------------------

--
-- Table structure for table `user_activity_events`
--

CREATE TABLE `user_activity_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `event_type` varchar(32) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `method` varchar(16) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `device_key` varchar(128) DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_activity_events`
--

INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:15:07'),
(2, 1, 'visit', '/admin/notifications', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:15:19'),
(3, 1, 'visit', '/admin/god-eyes', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:17:11'),
(4, 4, 'login', '/login', 'POST', '197.210.54.161', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36', NULL, NULL, '2026-06-07 13:17:41'),
(5, 1, 'visit', '/admin/god-eyes', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:17:51'),
(6, 1, 'visit', '/admin/god-eyes', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:17:51'),
(7, 1, 'visit', '/admin/notifications', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:18:43'),
(8, 1, 'login', '/login', 'POST', '197.210.54.161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', NULL, '2026-06-07 13:28:04'),
(9, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:28:06'),
(10, 1, 'visit', '/admin/god-eyes', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:28:08'),
(11, 1, 'visit', '/admin/god-eyes', 'VIEW', '197.210.54.161', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 13:28:26'),
(12, NULL, 'login_failed', '/login', 'POST', '38.114.120.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, '{\"identifier\":\"georgeokeu\",\"reason\":\"not_found_or_unverified\"}', '2026-06-07 13:34:08'),
(13, NULL, 'login_failed', '/login', 'POST', '38.114.120.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, '{\"identifier\":\"georgeokeu\",\"reason\":\"not_found_or_unverified\"}', '2026-06-07 13:34:11'),
(14, NULL, 'login_failed', '/login', 'POST', '38.114.120.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, '{\"identifier\":\"georgeokeu\",\"reason\":\"not_found_or_unverified\"}', '2026-06-07 13:34:12'),
(15, NULL, 'login_failed', '/login', 'POST', '38.114.120.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, '{\"identifier\":\"georgeokeu\",\"reason\":\"not_found_or_unverified\"}', '2026-06-07 13:34:19'),
(16, 8, 'login', '/login', 'POST', '38.114.120.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-07 13:34:45'),
(17, 1, 'visit', '/dashboard', 'VIEW', '102.90.102.181', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 19:30:50'),
(18, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.102.181', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 19:30:50'),
(19, 1, 'visit', '/admin/god-eyes', 'VIEW', '102.90.102.181', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 19:30:54'),
(20, 1, 'visit', '/admin/god-eyes', 'VIEW', '102.90.102.181', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 19:31:07'),
(21, 4, 'visit', '/login', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36', 'web:Linux aarch64:400x903:Africa/Lagos:ee22fceb-342d-46fb-9ab1-548b0662b457', '{\"title\":\"Login to CopUpBid\"}', '2026-06-07 19:48:30'),
(22, 4, 'visit', '/dashboard', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36', 'web:Linux aarch64:400x903:Africa/Lagos:ee22fceb-342d-46fb-9ab1-548b0662b457', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-07 19:48:30'),
(23, 4, 'visit', '/heist', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36', 'web:Linux aarch64:400x903:Africa/Lagos:ee22fceb-342d-46fb-9ab1-548b0662b457', '{\"title\":\"CopUpBid Heists\"}', '2026-06-07 19:48:33'),
(24, 4, 'visit', '/heist/28/leaderboard', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36', 'web:Linux aarch64:400x903:Africa/Lagos:ee22fceb-342d-46fb-9ab1-548b0662b457', '{\"title\":\"CopUpBid Heists\"}', '2026-06-07 19:49:00'),
(25, 3, 'login', '/login', 'POST', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', NULL, '2026-06-07 19:51:12'),
(26, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-06-07 19:51:13'),
(27, 3, 'visit', '/affiliate/referral', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-06-07 19:51:16'),
(28, 3, 'visit', '/affiliate/plans', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-06-07 19:51:25'),
(29, 3, 'visit', '/login', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', '{\"title\":\"Login to CopUpBid\"}', '2026-06-07 19:52:46'),
(30, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-06-07 19:52:47'),
(31, 3, 'visit', '/affiliate/plans', 'VIEW', '102.90.100.131', 'Mozilla/5.0 (Linux; Android 15; Infinix X6853 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.216 Mobile Safari/537.36 median', 'web:Linux aarch64:400x903:Africa/Lagos:fb273fda-b79a-4c15-8b9c-5e8e6e81c34e', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-06-07 19:52:55'),
(32, 55, 'login', '/login', 'POST', '102.90.118.195', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', NULL, '2026-06-07 21:22:38'),
(33, 55, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.118.195', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-06-07 21:22:40'),
(34, 55, 'visit', '/affiliate/referral', 'VIEW', '102.90.118.195', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-06-07 21:22:49'),
(35, 1, 'visit', '/', 'VIEW', '102.90.97.104', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-06-08 19:39:41'),
(36, 1, 'visit', '/', 'VIEW', '102.90.97.104', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-06-08 20:22:27'),
(37, 1, 'visit', '/', 'VIEW', '102.90.97.104', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'web:Linux armv81:400x903:Africa/Lagos:b89990b0-6e12-40a7-82af-aceef8f513ef', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-06-08 20:41:03'),
(38, 8, 'visit', '/heist', 'VIEW', '149.7.16.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-09 04:58:26'),
(39, 8, 'visit', '/heist/28/leaderboard', 'VIEW', '149.7.16.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-09 04:58:46'),
(40, 8, 'visit', '/heist', 'VIEW', '149.7.16.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-09 04:58:57'),
(41, 8, 'visit', '/dashboard', 'VIEW', '149.7.16.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-09 04:59:16'),
(42, 8, 'visit', '/account', 'VIEW', '149.7.16.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-09 04:59:18'),
(43, 8, 'visit', '/account?tab=withdraw', 'VIEW', '149.7.16.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-09 04:59:20'),
(44, 2, 'login', '/login', 'POST', '102.90.42.163', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-09 11:12:14'),
(45, 8, 'visit', '/heist', 'VIEW', '167.17.64.83', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-09 13:42:57'),
(46, 1, 'login', '/login', 'POST', '102.90.79.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-09 13:54:56'),
(47, 1, 'visit', '/admin/coins', 'VIEW', '102.90.82.119', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-09 15:13:10'),
(48, 8, 'visit', '/account', 'VIEW', '167.17.64.83', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-09 16:13:48'),
(49, 8, 'visit', '/account', 'VIEW', '167.17.64.83', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-09 16:15:27'),
(50, 11, 'login', '/login', 'POST', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', NULL, '2026-06-10 03:54:22'),
(51, 11, 'visit', '/dashboard', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-10 03:54:23'),
(52, 11, 'visit', '/dashboard', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-10 03:54:31'),
(53, 11, 'visit', '/', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-06-10 03:55:12'),
(54, 11, 'visit', '/login', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"Login to CopUpBid\"}', '2026-06-10 03:55:14'),
(55, 11, 'visit', '/dashboard', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-10 03:55:14'),
(56, 11, 'visit', '/heist', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"CopUpBid Heists\"}', '2026-06-10 03:55:38'),
(57, 11, 'visit', '/dashboard', 'VIEW', '102.90.96.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x820:Africa/Lagos:80fb0b69-c4ba-484f-ba0f-0202909d94d3', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-10 03:56:15'),
(58, 1, 'visit', '/admin/coins', 'VIEW', '102.90.117.52', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-11 06:11:36'),
(59, 1, 'visit', '/admin/coins', 'VIEW', '102.90.117.52', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-11 07:11:59'),
(60, 1, 'visit', '/admin/analytics', 'VIEW', '102.90.117.52', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-11 07:12:02'),
(61, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.117.52', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-11 07:12:26'),
(62, 1, 'visit', '/admin/heists', 'VIEW', '102.90.117.52', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-11 07:12:33'),
(63, 8, 'visit', '/heist', 'VIEW', '167.172.58.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-12 07:25:20'),
(64, 8, 'visit', '/heist/28/leaderboard', 'VIEW', '167.172.58.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-12 07:25:23'),
(65, 8, 'visit', '/heist/28', 'VIEW', '167.172.58.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-12 07:25:34'),
(66, 8, 'visit', '/heist/28/leaderboard', 'VIEW', '167.172.58.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-12 07:25:43'),
(67, 1, 'visit', '/admin/heists/question-bank', 'VIEW', '102.90.42.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-15 18:25:31'),
(68, 2, 'login', '/login', 'POST', '102.90.42.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-15 18:25:51'),
(69, 2, 'visit', '/dashboard', 'VIEW', '102.90.42.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-15 18:25:52'),
(70, 2, 'visit', '/account', 'VIEW', '102.90.42.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-15 18:26:23'),
(71, 2, 'visit', '/dashboard', 'VIEW', '102.90.42.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-15 18:26:23'),
(72, 2, 'visit', '/heist', 'VIEW', '102.90.42.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-15 18:26:24'),
(73, 1, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-17 08:47:15'),
(74, 2, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-17 08:52:20'),
(75, 1, 'login_failed', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, '{\"reason\":\"bad_password\"}', '2026-06-17 08:53:25'),
(76, 1, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-17 08:53:42'),
(77, 2, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-17 08:55:10'),
(78, 1, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-17 08:56:01'),
(79, 2, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-06-17 08:58:35'),
(80, 2, 'visit', '/heist/28/leaderboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-17 08:58:51'),
(81, 1, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-17 08:59:33'),
(82, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 08:59:34'),
(83, 1, 'visit', '/admin/god-eyes', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 08:59:45'),
(84, 1, 'visit', '/admin/users', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:00:21'),
(85, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:00:40'),
(86, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:00:44'),
(87, 1, 'visit', '/admin/heists/archive', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:01:18'),
(88, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:01:32'),
(89, 1, 'visit', '/admin/users', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:01:37'),
(90, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:01:55'),
(91, 1, 'visit', '/admin/users', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:01:59'),
(92, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:02:04'),
(93, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:02:08'),
(94, 2, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-17 09:02:48'),
(95, 2, 'visit', '/dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:02:49'),
(96, 2, 'visit', '/heist', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-17 09:02:51'),
(97, 2, 'visit', '/winners', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-17 09:03:05'),
(98, 2, 'visit', '/winners', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-17 09:03:29'),
(99, 1, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-17 09:04:03'),
(100, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:04:04'),
(101, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:04:12'),
(102, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:04:37'),
(103, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:04:59'),
(104, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:05:01'),
(105, 2, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-17 09:05:58'),
(106, 2, 'visit', '/dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:06:00'),
(107, 2, 'visit', '/heist', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-17 09:06:07'),
(108, 2, 'visit', '/winners', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-17 09:06:11'),
(109, 2, 'visit', '/winners', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-17 09:06:17'),
(110, 1, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-17 09:08:43'),
(111, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:08:45'),
(112, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:08:50'),
(113, 2, 'login', '/login', 'POST', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-17 09:10:53'),
(114, 2, 'visit', '/dashboard', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-17 09:10:55'),
(115, 2, 'visit', '/heist', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-17 09:10:58'),
(116, 2, 'visit', '/winners', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-17 09:11:02'),
(117, 2, 'visit', '/winners', 'VIEW', '102.90.100.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-17 09:11:37'),
(118, 2, 'visit', '/winners', 'VIEW', '197.210.54.52', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-18 07:08:55'),
(119, 2, 'visit', '/winners', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-19 15:04:55'),
(120, 2, 'visit', '/heist', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-19 15:05:28'),
(121, 2, 'visit', '/how-to-play', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-06-19 15:05:32'),
(122, 2, 'visit', '/heist-demo', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:05:35'),
(123, 2, 'visit', '/how-to-play', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-06-19 15:05:39'),
(124, 2, 'visit', '/heist-demo', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:05:53'),
(125, 2, 'visit', '/winners', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-19 15:07:31'),
(126, 2, 'visit', '/dashboard', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:09:00'),
(127, 2, 'visit', '/trade', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-06-19 15:09:08'),
(128, 2, 'visit', '/dashboard', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:09:40'),
(129, 2, 'visit', '/how-to-play', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-06-19 15:09:41'),
(130, 2, 'visit', '/heist-demo', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:09:48'),
(131, 2, 'visit', '/how-to-play', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-06-19 15:09:51'),
(132, 2, 'visit', '/dashboard', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:09:53'),
(133, 2, 'visit', '/profile', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:09:56'),
(134, 2, 'visit', '/dashboard', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:10:11'),
(135, 2, 'visit', '/account', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:10:15'),
(136, 2, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.98.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-19 15:11:03'),
(137, NULL, 'login_failed', '/login', 'POST', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"identifier\":\"Chidiebere bekee\",\"reason\":\"not_found_or_unverified\"}', '2026-06-21 09:59:48'),
(138, 17, 'login', '/login', 'POST', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', NULL, '2026-06-21 10:00:07'),
(139, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 10:00:09'),
(140, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 10:00:53'),
(141, 17, 'visit', '/trade', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-06-21 10:01:14'),
(142, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 10:01:14'),
(143, 17, 'visit', '/heist', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-06-21 10:01:15'),
(144, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 10:01:25'),
(145, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.72', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 10:27:35'),
(146, 2, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 11:31:14'),
(147, 2, 'visit', '/dashboard', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 11:31:27'),
(148, 2, 'visit', '/heist', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-21 11:31:29'),
(149, 1, 'login', '/login', 'POST', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-21 11:32:19'),
(150, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 11:32:29'),
(151, 1, 'visit', '/admin/users', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-21 11:32:58'),
(152, 53, 'login', '/login', 'POST', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-21 11:35:12'),
(153, 53, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-06-21 11:35:13'),
(154, 53, 'visit', '/affiliate/plans', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-06-21 11:35:44'),
(155, 53, 'visit', '/affiliate/plans', 'VIEW', '102.90.97.228', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-06-21 11:35:55'),
(156, 53, 'visit', '/affiliate/plans', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-06-22 11:50:07');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(157, 53, 'visit', '/affiliate/plans', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-06-22 11:50:10'),
(158, 2, 'login', '/login', 'POST', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 11:50:30'),
(159, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 11:50:32'),
(160, 2, 'visit', '/heist', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 11:50:42'),
(161, 2, 'visit', '/how-to-play', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-06-22 11:52:14'),
(162, 2, 'visit', '/heist-demo', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 11:52:25'),
(163, 2, 'visit', '/heist', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 12:05:25'),
(164, 1, 'login', '/login', 'POST', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 12:13:46'),
(165, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:13:48'),
(166, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:14:14'),
(167, 2, 'login', '/login', 'POST', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 12:15:26'),
(168, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:15:27'),
(169, 2, 'visit', '/heist', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 12:15:29'),
(170, 1, 'login', '/login', 'POST', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 12:24:06'),
(171, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:24:08'),
(172, 1, 'visit', '/admin/god-eyes', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:24:19'),
(173, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:26:17'),
(174, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:26:19'),
(175, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 12:42:46'),
(176, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.43', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 13:12:15'),
(177, 1, 'visit', '/admin/heists', 'VIEW', '102.90.101.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 15:14:16'),
(178, 1, 'visit', '/admin/heists', 'VIEW', '102.90.101.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 15:14:28'),
(179, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.69', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 16:17:02'),
(180, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 18:45:33'),
(181, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 18:47:49'),
(182, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 18:50:02'),
(183, 2, 'login', '/login', 'POST', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 18:50:48'),
(184, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 18:50:50'),
(185, 2, 'visit', '/heist', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 18:50:54'),
(186, 2, 'visit', '/winners', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-22 18:50:58'),
(187, 1, 'login', '/login', 'POST', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 18:52:14'),
(188, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 18:52:16'),
(189, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.44', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 18:52:37'),
(190, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:17:02'),
(191, 2, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:17:32'),
(192, 2, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:17:34'),
(193, 2, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:17:36'),
(194, 2, 'visit', '/winners', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-22 19:17:53'),
(195, 68, 'register', '/register', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"account_type\":\"user\",\"referral_code\":\"DbillionneJay\"}', '2026-06-22 19:20:28'),
(196, 68, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:20:42'),
(197, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:20:43'),
(198, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:20:51'),
(199, 68, 'visit', '/trade', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-06-22 19:21:48'),
(200, 2, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:22:13'),
(201, 2, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:22:14'),
(202, 2, 'visit', '/trade', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-06-22 19:22:16'),
(203, 68, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:23:59'),
(204, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:24:00'),
(205, 1, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:24:35'),
(206, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:24:36'),
(207, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:24:42'),
(208, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:25:04'),
(209, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:25:06'),
(210, 68, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:25:39'),
(211, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:25:41'),
(212, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:25:42'),
(213, 1, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:26:04'),
(214, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:26:06'),
(215, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:26:10'),
(216, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:26:24'),
(217, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:26:31'),
(218, 68, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:26:56'),
(219, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:26:58'),
(220, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:26:59'),
(221, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:27:02'),
(222, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:27:03'),
(223, 1, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:27:28'),
(224, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:27:30'),
(225, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:27:34'),
(226, 68, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:28:20'),
(227, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:28:21'),
(228, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:28:24'),
(229, 68, 'visit', '/heist', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-06-22 19:28:27'),
(230, 1, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:28:48'),
(231, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:28:49'),
(232, 1, 'visit', '/admin/heists', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:28:52'),
(233, 68, 'login', '/login', 'POST', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-06-22 19:29:43'),
(234, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:29:44'),
(235, 68, 'visit', '/account', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:29:46'),
(236, 68, 'visit', '/dashboard', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-22 19:29:57'),
(237, 68, 'visit', '/trade', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-06-22 19:29:58'),
(238, 68, 'visit', '/winners', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-22 19:30:15'),
(239, 68, 'visit', '/winners', 'VIEW', '197.210.226.109', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-06-22 20:06:53'),
(240, 8, 'login', '/login', 'POST', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', NULL, '2026-06-24 20:57:20'),
(241, 8, 'visit', '/dashboard', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 20:57:23'),
(242, 8, 'visit', '/heist', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-24 20:57:27'),
(243, 8, 'visit', '/heist', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-24 20:58:03'),
(244, 8, 'visit', '/dashboard', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 20:58:17'),
(245, 8, 'visit', '/account', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 20:58:19'),
(246, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 20:58:30'),
(247, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 20:59:10'),
(248, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 20:59:52'),
(249, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 21:00:10'),
(250, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 21:00:54'),
(251, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 21:01:49'),
(252, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-24 21:20:17'),
(253, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.252', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-25 20:20:24'),
(254, 8, 'visit', '/account?tab=withdraw', 'VIEW', '172.99.190.252', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-25 20:20:31'),
(255, 8, 'visit', '/heist', 'VIEW', '105.113.56.50', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-06-27 12:49:52'),
(256, 8, 'visit', '/', 'VIEW', '105.113.56.50', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-06-27 12:50:26'),
(257, 17, 'visit', '/dashboard', 'VIEW', '102.90.123.97', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-06-28 06:30:59'),
(258, 1, 'login', '/login', 'POST', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 08:00:23'),
(259, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:00:24'),
(260, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:00:36'),
(261, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:01:47'),
(262, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:01:48'),
(263, 2, 'login', '/login', 'POST', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 08:03:37'),
(264, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:03:39'),
(265, 2, 'visit', '/heist', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:03:41'),
(266, 2, 'visit', '/heist', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:03:58'),
(267, 1, 'login', '/login', 'POST', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 08:05:12'),
(268, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:05:14'),
(269, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:05:21'),
(270, 17, 'login', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', NULL, '2026-07-01 08:05:42'),
(271, 17, 'visit', '/dashboard', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:05:44'),
(272, 17, 'visit', '/account', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:05:47'),
(273, 2, 'login', '/login', 'POST', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 08:05:52'),
(274, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:05:54'),
(275, 2, 'visit', '/heist', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:05:56'),
(276, 17, 'visit', '/account', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:07:23'),
(277, 17, 'visit', '/account', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:07:24'),
(278, 17, 'visit', '/dashboard', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:07:27'),
(279, 17, 'visit', '/dashboard', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:07:32'),
(280, 2, 'visit', '/heist', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:08:02'),
(281, 17, 'visit', '/dashboard', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:10:19'),
(282, 17, 'visit', '/heist', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:10:23'),
(283, 17, 'visit', '/heist/30', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:10:31'),
(284, 17, 'visit', '/heist/30/result', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:11:08'),
(285, NULL, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"identifier\":\"mrdfx\",\"reason\":\"not_found_or_unverified\"}', '2026-07-01 08:12:07'),
(286, 59, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"reason\":\"bad_password\"}', '2026-07-01 08:12:52'),
(287, NULL, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"identifier\":\"beatricesunday2004@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-07-01 08:13:02'),
(288, NULL, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"identifier\":\"beatricesunday2004@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-07-01 08:13:07'),
(289, NULL, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"identifier\":\"beatricesunday2004@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-07-01 08:13:27'),
(290, NULL, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"identifier\":\"bekeechidiebere2007@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-07-01 08:14:03'),
(291, 59, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"reason\":\"bad_password\"}', '2026-07-01 08:14:34'),
(292, 59, 'login_failed', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"reason\":\"bad_password\"}', '2026-07-01 08:14:41'),
(293, 69, 'register', '/register', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"account_type\":\"user\",\"referral_code\":null}', '2026-07-01 08:16:24'),
(294, 69, 'login', '/login', 'POST', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', NULL, '2026-07-01 08:16:37'),
(295, 69, 'visit', '/dashboard', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:16:39'),
(296, 69, 'visit', '/account', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:16:43'),
(297, 69, 'visit', '/account?tab=topup', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:16:46'),
(298, 69, 'visit', '/dashboard', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:17:59'),
(299, 69, 'visit', '/heist', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:18:05'),
(300, 69, 'visit', '/heist/30', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:18:10'),
(301, 69, 'visit', '/heist/30/result', 'VIEW', '102.90.103.193', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:18:34'),
(302, 2, 'visit', '/heist', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 08:29:14'),
(303, 2, 'visit', '/', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-07-01 08:30:01'),
(304, 1, 'login', '/login', 'POST', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 08:30:41'),
(305, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:30:43'),
(306, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:31:08'),
(307, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 08:34:33');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(308, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.196', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 09:14:57'),
(309, 1, 'visit', '/admin/heists', 'VIEW', '102.90.116.124', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 10:33:43'),
(310, 1, 'visit', '/admin/heists', 'VIEW', '102.90.116.124', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 11:48:45'),
(311, 3, 'login', '/login', 'POST', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-07-01 12:29:27'),
(312, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-01 12:29:29'),
(313, 70, 'register', '/register', 'POST', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"account_type\":\"user\",\"referral_code\":\"Light\"}', '2026-07-01 12:29:40'),
(314, 70, 'login_failed', '/login', 'POST', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"reason\":\"bad_password\"}', '2026-07-01 12:30:04'),
(315, 70, 'login_failed', '/login', 'POST', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"reason\":\"bad_password\"}', '2026-07-01 12:30:09'),
(316, 70, 'login_failed', '/login', 'POST', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"reason\":\"bad_password\"}', '2026-07-01 12:30:11'),
(317, 71, 'register', '/register', 'POST', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"account_type\":\"affiliate\",\"referral_code\":\"light\"}', '2026-07-01 12:30:15'),
(318, 1, 'login', '/login', 'POST', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-07-01 12:30:17'),
(319, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:30:18'),
(320, 70, 'login_failed', '/login', 'POST', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"reason\":\"bad_password\"}', '2026-07-01 12:30:24'),
(321, 71, 'login', '/login', 'POST', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', NULL, '2026-07-01 12:30:37'),
(322, 71, 'visit', '/affiliate-dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-01 12:30:39'),
(323, 1, 'visit', '/admin/heists', 'VIEW', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:31:00'),
(324, 70, 'login', '/login', 'POST', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', NULL, '2026-07-01 12:31:18'),
(325, 71, 'visit', '/affiliate/plans', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-07-01 12:31:19'),
(326, 70, 'visit', '/dashboard', 'VIEW', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:31:19'),
(327, 71, 'visit', '/affiliate-dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-01 12:31:54'),
(328, 70, 'visit', '/heist', 'VIEW', '102.90.101.7', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:33:19'),
(329, 1, 'visit', '/admin/users', 'VIEW', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:33:43'),
(330, 71, 'visit', '/profile', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:33:52'),
(331, 71, 'visit', '/dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:34:04'),
(332, 71, 'visit', '/affiliate-dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-01 12:34:04'),
(333, 71, 'login', '/login', 'POST', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', NULL, '2026-07-01 12:34:29'),
(334, 71, 'visit', '/dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:34:30'),
(335, 71, 'visit', '/heist', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:34:37'),
(336, 71, 'visit', '/heist/31', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:35:03'),
(337, 71, 'visit', '/heist/31/result', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:36:00'),
(338, 70, 'visit', '/heist/31', 'VIEW', '102.90.99.128', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:36:26'),
(339, 70, 'visit', '/heist/31/result', 'VIEW', '102.90.99.128', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:37:05'),
(340, 70, 'visit', '/heist', 'VIEW', '102.90.99.128', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:37:12'),
(341, 70, 'visit', '/heist/31/leaderboard', 'VIEW', '102.90.99.128', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/420.4.909430193 Mobile/15E148 Safari/604.1', 'web:iPhone:430x932:Africa/Lagos:528ff4af-c686-43d2-9d70-71bfcbc6d76a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:37:14'),
(342, 71, 'visit', '/heist', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:37:31'),
(343, 71, 'visit', '/heist/31/leaderboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 12:37:37'),
(344, 1, 'visit', '/admin/heists', 'VIEW', '102.89.69.172', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:37:40'),
(345, 71, 'visit', '/profile', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:38:16'),
(346, 71, 'visit', '/dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:38:18'),
(347, 71, 'visit', '/account', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:38:23'),
(348, 71, 'visit', '/account?tab=withdraw', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:38:26'),
(349, 71, 'visit', '/dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:39:23'),
(350, 71, 'visit', '/account', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:39:58'),
(351, 71, 'visit', '/account?tab=withdraw', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:39:59'),
(352, 71, 'visit', '/dashboard', 'VIEW', '197.211.57.4', 'Mozilla/5.0 (Linux; Android 15; 25028RN03A Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7827.91 Mobile Safari/537.36', 'web:Linux armv8l:360x820:Africa/Lagos:26d615da-118b-48ce-8261-cb058e11e730', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 12:41:01'),
(353, 17, 'visit', '/heist/30/result', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 14:41:27'),
(354, 17, 'visit', '/', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-07-01 14:41:30'),
(355, 17, 'visit', '/register', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-07-01 14:41:42'),
(356, 17, 'visit', '/login', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"Login to CopUpBid\"}', '2026-07-01 14:41:44'),
(357, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 14:41:45'),
(358, 17, 'visit', '/heist', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 14:41:59'),
(359, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '197.211.52.77', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 14:42:05'),
(360, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '197.211.63.117', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 17:02:23'),
(361, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '197.211.63.117', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 17:02:28'),
(362, 1, 'login', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-07-01 18:47:11'),
(363, 2, 'login', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-07-01 18:50:20'),
(364, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '197.211.63.117', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 18:53:43'),
(365, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '102.90.123.51', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 18:53:52'),
(366, 17, 'visit', '/heist/30', 'VIEW', '102.90.123.51', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 18:54:17'),
(367, 17, 'visit', '/heist', 'VIEW', '197.211.63.117', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 18:54:27'),
(368, 17, 'visit', '/winners', 'VIEW', '197.211.63.117', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Winners\"}', '2026-07-01 18:54:35'),
(369, 14, 'login', '/login', 'POST', '197.210.55.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:80061d8c-46b3-470c-ab28-efbe1dbbf138', NULL, '2026-07-01 18:58:22'),
(370, 14, 'visit', '/dashboard', 'VIEW', '197.210.55.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:80061d8c-46b3-470c-ab28-efbe1dbbf138', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 18:58:25'),
(371, 2, 'visit', '/winners', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-01 18:59:49'),
(372, 2, 'visit', '/winners', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-01 19:01:54'),
(373, 2, 'visit', '/heist', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 19:02:03'),
(374, 2, 'visit', '/winners', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-01 19:03:36'),
(375, 1, 'login_failed', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"reason\":\"bad_password\"}', '2026-07-01 19:04:08'),
(376, 1, 'login', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 19:04:38'),
(377, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:04:39'),
(378, 1, 'visit', '/admin/heists', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:04:45'),
(379, 1, 'visit', '/admin/users', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:06:10'),
(380, 69, 'visit', '/account?tab=topup', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:06:21'),
(381, 69, 'visit', '/dashboard', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:06:22'),
(382, 69, 'visit', '/dashboard', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:06:26'),
(383, 69, 'visit', '/heist', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 19:06:28'),
(384, 69, 'visit', '/heist/30/leaderboard', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 19:06:35'),
(385, 53, 'login_failed', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"reason\":\"bad_password\"}', '2026-07-01 19:06:37'),
(386, 69, 'visit', '/heist/30', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 19:06:46'),
(387, 1, 'login', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 19:06:54'),
(388, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:06:55'),
(389, 1, 'visit', '/admin/users', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:06:58'),
(390, 69, 'visit', '/heist', 'VIEW', '102.90.96.166', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-01 19:07:13'),
(391, 53, 'login', '/login', 'POST', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-01 19:08:25'),
(392, 53, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-01 19:08:27'),
(393, 53, 'visit', '/affiliate/plans', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-07-01 19:08:33'),
(394, 53, 'visit', '/affiliate/how-it-works', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-07-01 19:09:04'),
(395, 53, 'visit', '/profile', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-01 19:09:24'),
(396, 53, 'visit', '/affiliate/plans', 'VIEW', '102.90.99.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-07-01 19:11:05'),
(397, 17, 'visit', '/winners', 'VIEW', '102.90.123.51', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Winners\"}', '2026-07-01 21:42:00'),
(398, 53, 'visit', '/', 'VIEW', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-07-02 08:55:44'),
(399, 53, 'visit', '/register', 'VIEW', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-07-02 08:55:46'),
(400, 53, 'visit', '/login', 'VIEW', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Login to CopUpBid\"}', '2026-07-02 08:55:48'),
(401, 53, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-02 08:55:48'),
(402, 2, 'login', '/login', 'POST', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-02 08:56:14'),
(403, 2, 'visit', '/dashboard', 'VIEW', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-02 08:56:16'),
(404, 2, 'visit', '/heist', 'VIEW', '102.90.103.36', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-02 08:56:19'),
(405, 53, 'login', '/login', 'POST', '197.210.55.5', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-02 10:36:39'),
(406, 53, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.55.5', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-02 10:36:41'),
(407, 53, 'visit', '/affiliate/referral', 'VIEW', '197.210.55.5', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-07-02 10:36:55'),
(408, 53, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.55.5', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-02 10:37:20'),
(409, 53, 'visit', '/affiliate/plans', 'VIEW', '197.210.55.5', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-07-02 10:37:21'),
(410, 53, 'visit', '/affiliate/how-it-works', 'VIEW', '197.210.55.5', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-07-02 10:37:55'),
(411, 69, 'visit', '/heist', 'VIEW', '102.90.103.38', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-02 17:23:58'),
(412, 69, 'visit', '/heist', 'VIEW', '102.90.103.38', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-02 17:24:00'),
(413, 69, 'visit', '/heist/30/leaderboard', 'VIEW', '102.90.103.38', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.7', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-02 17:24:06'),
(414, 53, 'visit', '/affiliate/how-it-works', 'VIEW', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-07-03 13:46:16'),
(415, 2, 'login', '/login', 'POST', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-03 13:46:37'),
(416, 2, 'visit', '/dashboard', 'VIEW', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-03 13:46:38'),
(417, 2, 'visit', '/heist', 'VIEW', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-03 13:46:43'),
(418, 1, 'login', '/login', 'POST', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-03 13:49:26'),
(419, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-03 13:49:27'),
(420, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-03 13:49:33'),
(421, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.223', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-03 16:31:38'),
(422, 1, 'visit', '/admin/heists', 'VIEW', '105.127.15.237', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-03 19:44:29'),
(423, 17, 'visit', '/winners', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Winners\"}', '2026-07-04 11:09:45'),
(424, 17, 'visit', '/', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-07-04 11:10:06'),
(425, 17, 'visit', '/dashboard', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-04 11:10:26'),
(426, 17, 'visit', '/heist', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 11:10:33'),
(427, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 11:10:44'),
(428, 17, 'visit', '/heist', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 11:10:44'),
(429, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '102.90.81.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 11:10:53'),
(430, 1, 'visit', '/admin/heists', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-04 12:06:36'),
(431, 1, 'visit', '/admin/heists', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-04 19:48:18'),
(432, 2, 'login', '/login', 'POST', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-04 19:48:33'),
(433, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-04 19:48:34'),
(434, 2, 'visit', '/heist', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 19:48:54'),
(435, 2, 'visit', '/how-to-play', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-07-04 19:49:10'),
(436, 2, 'visit', '/heist-demo', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-04 19:49:12'),
(437, 2, 'visit', '/winners', 'VIEW', '105.127.15.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-04 23:10:22'),
(438, 8, 'login', '/login', 'POST', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', NULL, '2026-07-04 23:51:27'),
(439, 8, 'visit', '/dashboard', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-04 23:51:29'),
(440, 8, 'visit', '/heist', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:51:32'),
(441, 8, 'visit', '/heist/30', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:51:41'),
(442, 8, 'visit', '/heist/30/result', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:52:50'),
(443, 8, 'visit', '/heist', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:52:55'),
(444, 8, 'visit', '/heist/30/leaderboard', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:52:58'),
(445, 8, 'visit', '/heist', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:53:07'),
(446, 8, 'visit', '/heist/30/result', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:53:10'),
(447, 8, 'visit', '/heist', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:53:12'),
(448, 8, 'visit', '/heist/30/result', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:53:22'),
(449, 8, 'visit', '/heist', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-04 23:53:24'),
(450, 8, 'visit', '/', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-07-04 23:53:28'),
(451, 8, 'visit', '/register', 'VIEW', '188.166.175.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-07-04 23:53:30'),
(452, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '197.211.52.73', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-05 20:45:55'),
(453, 17, 'visit', '/dashboard', 'VIEW', '197.211.52.73', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-05 20:46:23'),
(454, 17, 'visit', '/heist', 'VIEW', '197.211.52.73', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-05 20:46:27'),
(455, 17, 'visit', '/heist/30/leaderboard', 'VIEW', '197.211.52.73', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Heists\"}', '2026-07-05 20:46:40'),
(456, 17, 'visit', '/winners', 'VIEW', '197.211.52.73', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:62486a06-eb9b-416e-929e-29f2909c0e69', '{\"title\":\"CopUpBid Winners\"}', '2026-07-05 20:46:52'),
(457, 2, 'visit', '/winners', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-07 08:03:32'),
(458, 2, 'visit', '/heist', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-07 08:03:38');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(459, 1, 'login', '/login', 'POST', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-07 08:03:56'),
(460, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:03:58'),
(461, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:04:01'),
(462, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:06:39'),
(463, 2, 'login', '/login', 'POST', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-07 08:08:05'),
(464, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:08:07'),
(465, 2, 'visit', '/winners', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-07 08:08:14'),
(466, 2, 'visit', '/winners', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-07 08:08:24'),
(467, 1, 'login', '/login', 'POST', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-07 08:08:37'),
(468, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:08:39'),
(469, 1, 'visit', '/admin/heists', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:08:42'),
(470, 1, 'visit', '/admin/heists/archive', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:09:29'),
(471, 2, 'login', '/login', 'POST', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-07 08:11:22'),
(472, 2, 'visit', '/dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:11:26'),
(473, 2, 'visit', '/heist', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-07 08:11:29'),
(474, 2, 'visit', '/winners', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-07 08:11:36'),
(475, 2, 'visit', '/winners', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-07 08:11:50'),
(476, 1, 'login', '/login', 'POST', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-07 08:12:03'),
(477, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:12:04'),
(478, 1, 'visit', '/admin/users', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:12:11'),
(479, 1, 'visit', '/admin/users', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:12:48'),
(480, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 08:14:21'),
(481, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.55.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 09:05:12'),
(482, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.115.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 09:21:34'),
(483, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.115.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 09:21:39'),
(484, 1, 'visit', '/admin/heists', 'VIEW', '102.90.115.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 09:21:50'),
(485, 1, 'visit', '/admin/users', 'VIEW', '102.90.115.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 09:22:09'),
(486, 1, 'visit', '/admin/users', 'VIEW', '102.90.115.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 09:23:10'),
(487, 1, 'visit', '/admin/users', 'VIEW', '102.90.115.49', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-07 11:11:13'),
(488, 1, 'visit', '/admin/users', 'VIEW', '102.90.103.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-08 09:48:08'),
(489, 2, 'login', '/login', 'POST', '102.90.103.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-08 09:48:41'),
(490, 2, 'visit', '/dashboard', 'VIEW', '102.90.103.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-08 09:48:45'),
(491, 2, 'visit', '/heist', 'VIEW', '102.90.103.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-08 09:48:52'),
(492, 2, 'visit', '/winners', 'VIEW', '102.90.103.118', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-08 09:48:58'),
(493, 8, 'visit', '/heist', 'VIEW', '193.108.119.203', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid Heists\"}', '2026-07-10 08:15:35'),
(494, 8, 'visit', '/dashboard', 'VIEW', '193.108.119.203', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-10 08:15:44'),
(495, 8, 'visit', '/account', 'VIEW', '193.108.119.203', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-10 08:15:55'),
(496, 8, 'visit', '/account?tab=withdraw', 'VIEW', '193.108.119.203', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-10 08:16:17'),
(497, 8, 'visit', '/account?tab=withdraw', 'VIEW', '193.108.119.203', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:371x824:Africa/Lagos:b0f39e49-2fee-4b78-bf44-86a4a9edf32c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-10 08:17:20'),
(498, 2, 'visit', '/winners', 'VIEW', '102.90.103.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-10 21:20:29'),
(499, 2, 'visit', '/winners', 'VIEW', '102.90.103.160', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-07-10 21:20:42'),
(500, 2, 'login', '/login', 'POST', '197.210.54.150', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', NULL, NULL, '2026-07-11 10:02:26'),
(501, 2, 'visit', '/heist', 'VIEW', '197.210.54.150', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-11 10:02:48'),
(502, 2, 'visit', '/trade', 'VIEW', '197.210.54.150', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-07-11 10:03:09'),
(503, 3, 'login', '/login', 'POST', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', NULL, '2026-07-17 00:18:37'),
(504, 3, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-17 00:18:39'),
(505, 3, 'visit', '/my-clan', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:34:18'),
(506, 3, 'visit', '/my-clan', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:34:18'),
(507, 3, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-17 01:34:24'),
(508, 3, 'visit', '/dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:34:24'),
(509, 3, 'visit', '/heist', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid Heists\"}', '2026-07-17 01:34:31'),
(510, 3, 'visit', '/clans', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:34:38'),
(511, 3, 'visit', '/clans', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:37:15'),
(512, 3, 'visit', '/clans', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:75aa0bb2-9d34-4e7f-afd6-9c3099e95869', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:37:15'),
(513, 4, 'login', '/login', 'POST', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-07-17 01:45:22'),
(514, 4, 'visit', '/dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:45:24'),
(515, 4, 'visit', '/dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 01:45:32'),
(516, 4, 'visit', '/dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:02:17'),
(517, 4, 'visit', '/clans', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:02:21'),
(518, 4, 'visit', '/clans/1', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:03:29'),
(519, 4, 'visit', '/clans', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:04:11'),
(520, 4, 'visit', '/my-clan', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:04:15'),
(521, 1, 'login', '/login', 'POST', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-07-17 02:05:44'),
(522, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:05:45'),
(523, 1, 'visit', '/admin/clans', 'VIEW', '197.210.226.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 02:05:52'),
(524, 2, 'visit', '/trade', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-07-17 10:17:22'),
(525, 2, 'visit', '/my-clan', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:17:35'),
(526, 2, 'visit', '/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:17:41'),
(527, 2, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:33:02'),
(528, 2, 'visit', '/clans/1', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:33:15'),
(529, 2, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:33:24'),
(530, 2, 'visit', '/profile', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:33:27'),
(531, 2, 'visit', '/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:34:14'),
(532, 2, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:34:25'),
(533, 2, 'visit', '/clan-quests', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:38:08'),
(534, 2, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:38:18'),
(535, 2, 'visit', '/my-clan', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:38:23'),
(536, 2, 'visit', '/profile', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:39:04'),
(537, 5, 'login', '/login', 'POST', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-17 10:39:45'),
(538, 5, 'visit', '/dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:39:47'),
(539, 5, 'visit', '/my-clan', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:39:53'),
(540, 5, 'visit', '/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:39:56'),
(541, 5, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:39:59'),
(542, 5, 'visit', '/profile', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:40:16'),
(543, 5, 'visit', '/my-clan', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:41:57'),
(544, 69, 'login', '/login', 'POST', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', NULL, '2026-07-17 10:42:34'),
(545, 69, 'visit', '/heist/30/leaderboard', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid Heists\"}', '2026-07-17 10:42:36'),
(546, 2, 'login', '/login', 'POST', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-17 10:42:57'),
(547, 2, 'visit', '/dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:42:58'),
(548, 2, 'visit', '/my-clan', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:43:06'),
(549, 69, 'visit', '/dashboard', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:43:15'),
(550, 69, 'visit', '/account', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:43:18'),
(551, 69, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:43:32'),
(552, 69, 'visit', '/dashboard', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:44:57'),
(553, 69, 'visit', '/account', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:45:30'),
(554, 69, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:45:32'),
(555, 55, 'login', '/login', 'POST', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', NULL, '2026-07-17 10:45:42'),
(556, 55, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-17 10:45:45'),
(557, 55, 'visit', '/how-to-play', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"How to Play on CopUpBid\"}', '2026-07-17 10:46:11'),
(558, 55, 'visit', '/', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-07-17 10:46:22'),
(559, 55, 'visit', '/login', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"Login to CopUpBid\"}', '2026-07-17 10:46:48'),
(560, 55, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-17 10:46:51'),
(561, 55, 'visit', '/profile', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:47:27'),
(562, 55, 'visit', '/dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:47:48'),
(563, 55, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-07-17 10:47:48'),
(564, 1, 'login', '/login', 'POST', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-17 10:48:14'),
(565, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:48:15'),
(566, 1, 'visit', '/admin/transactions', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:48:29'),
(567, 12, 'login', '/login', 'POST', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', NULL, '2026-07-17 10:48:45'),
(568, 12, 'visit', '/dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:48:48'),
(569, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:48:55'),
(570, 1, 'visit', '/admin/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:48:56'),
(571, 12, 'visit', '/clans', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:49:37'),
(572, 12, 'visit', '/clans/1', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:50:27'),
(573, 12, 'visit', '/clan-quests', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:50:43'),
(574, 12, 'visit', '/clans/1', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:50:49'),
(575, 12, 'visit', '/dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:50:55'),
(576, 12, 'visit', '/trade', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-07-17 10:51:07'),
(577, 12, 'visit', '/dashboard', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:51:35'),
(578, 12, 'visit', '/heist', 'VIEW', '102.89.69.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Heists\"}', '2026-07-17 10:51:55'),
(579, 1, 'visit', '/admin/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:52:08'),
(580, 2, 'login', '/login', 'POST', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-17 10:52:24'),
(581, 2, 'visit', '/dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:52:26'),
(582, 2, 'visit', '/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:52:29'),
(583, 2, 'visit', '/clans', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:52:37'),
(584, 2, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:52:41'),
(585, 2, 'visit', '/clans/2', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:53:03'),
(586, 2, 'visit', '/dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:54:38'),
(587, 2, 'visit', '/dashboard', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:54:41'),
(588, 2, 'visit', '/account', 'VIEW', '102.90.103.21', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:54:44'),
(589, 69, 'visit', '/dashboard', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:56:14'),
(590, 69, 'visit', '/account', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:56:20'),
(591, 69, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.124.42', 'Mozilla/5.0 (Linux; U; Android 13; en-us; 23028RNCAG Build/TP1A.220624.014) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.164 Mobile Safari/537.36 PHX/21.8', 'web:Linux armv8l:360x800:Africa/Lagos:8ccc54eb-7835-4718-ac85-592803d9247a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-17 10:56:23'),
(592, 2, 'visit', '/account', 'VIEW', '102.90.103.80', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-18 19:37:19'),
(593, 2, 'visit', '/my-clan', 'VIEW', '102.90.103.80', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-18 19:37:22'),
(594, 2, 'visit', '/heist', 'VIEW', '102.90.81.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-22 21:17:57'),
(595, 2, 'visit', '/my-clan', 'VIEW', '102.90.81.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-22 21:18:02'),
(596, 2, 'visit', '/heist', 'VIEW', '102.90.81.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-22 21:18:12'),
(597, 2, 'visit', '/profile', 'VIEW', '102.90.81.154', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-22 21:18:13'),
(598, 2, 'login', '/login', 'POST', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-30 17:29:55'),
(599, 2, 'visit', '/dashboard', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:29:56'),
(600, 2, 'visit', '/clans', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:29:59'),
(601, 2, 'visit', '/heist', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-07-30 17:30:13'),
(602, 2, 'visit', '/dashboard', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:30:13'),
(603, 2, 'visit', '/dashboard', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:31:00'),
(604, 2, 'visit', '/trade', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-07-30 17:31:04'),
(605, 1, 'login', '/login', 'POST', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-07-30 17:35:21'),
(606, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:35:25'),
(607, 1, 'visit', '/admin/users', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:35:54'),
(608, 1, 'visit', '/admin/analytics', 'VIEW', '102.90.117.158', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-07-30 17:36:42');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(609, 2, 'login', '/login', 'POST', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-08-07 17:49:55'),
(610, 2, 'visit', '/dashboard', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-07 17:49:58'),
(611, 2, 'visit', '/heist', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-08-07 17:50:46'),
(612, 2, 'visit', '/how-to-play', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-07 17:50:54'),
(613, 2, 'visit', '/heist-demo', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-07 17:51:35'),
(614, 2, 'visit', '/how-to-play', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-07 17:53:13'),
(615, 2, 'visit', '/heist-demo', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-07 17:53:14'),
(616, 2, 'visit', '/winners', 'VIEW', '105.112.178.173', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-07 17:53:31'),
(617, 2, 'visit', '/winners', 'VIEW', '102.90.99.247', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-08 18:54:49'),
(618, 4, 'login', '/login', 'POST', '102.90.100.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', NULL, '2026-08-11 20:53:53'),
(619, 4, 'visit', '/dashboard', 'VIEW', '102.90.100.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 20:53:54'),
(620, 4, 'visit', '/profile', 'VIEW', '102.90.100.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 20:54:01'),
(621, 3, 'login', '/login', 'POST', '102.90.100.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-08-11 20:55:08'),
(622, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.100.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-11 20:55:10'),
(623, 3, 'visit', '/affiliate/referral', 'VIEW', '102.90.100.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-11 20:55:12'),
(624, 72, 'register', '/register', 'POST', '105.112.212.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"account_type\":\"user\",\"referral_code\":\"light\"}', '2026-08-11 20:56:11'),
(625, 72, 'login', '/login', 'POST', '105.112.212.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', NULL, '2026-08-11 20:56:31'),
(626, 72, 'visit', '/dashboard', 'VIEW', '105.112.212.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 20:56:34'),
(627, 72, 'visit', '/profile', 'VIEW', '105.112.212.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 20:57:28'),
(628, 72, 'visit', '/dashboard', 'VIEW', '105.112.212.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 20:59:09'),
(629, 72, 'visit', '/dashboard', 'VIEW', '105.112.212.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 20:59:20'),
(630, 72, 'visit', '/', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-11 21:22:09'),
(631, 72, 'visit', '/login', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-11 21:22:18'),
(632, 72, 'visit', '/dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:22:19'),
(633, 72, 'visit', '/profile', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:22:34'),
(634, 72, 'visit', '/dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:22:53'),
(635, 72, 'visit', '/referral', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-11 21:24:22'),
(636, 73, 'register', '/register', 'POST', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"account_type\":\"affiliate\",\"referral_code\":\"R7C8YGY5\"}', '2026-08-11 21:25:44'),
(637, 73, 'login', '/login', 'POST', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', NULL, '2026-08-11 21:27:35'),
(638, 73, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-11 21:27:39'),
(639, 72, 'visit', '/dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:27:50'),
(640, 72, 'visit', '/dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:27:54'),
(641, 72, 'visit', '/dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:28:02'),
(642, 73, 'visit', '/affiliate/trade', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:28:29'),
(643, 73, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-11 21:28:53'),
(644, 72, 'visit', '/my-clan', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:29:02'),
(645, 72, 'visit', '/dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-11 21:29:08'),
(646, 72, 'visit', '/heist', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-11 21:29:11'),
(647, 3, 'login', '/login', 'POST', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', NULL, '2026-08-12 01:19:34'),
(648, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:19:36'),
(649, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:19:42'),
(650, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:20:00'),
(651, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:20:19'),
(652, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:20:23'),
(653, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:20:27'),
(654, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:20:29'),
(655, 3, 'login', '/login', 'POST', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', NULL, '2026-08-12 01:22:08'),
(656, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:22:09'),
(657, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:22:18'),
(658, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:22:35'),
(659, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:22:52'),
(660, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:22:55'),
(661, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:23:04'),
(662, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:23:06'),
(663, 3, 'visit', '/my-clan', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:23:32'),
(664, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:23:34'),
(665, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:26:02'),
(666, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:26:02'),
(667, 3, 'visit', '/clans', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:10'),
(668, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:16'),
(669, 3, 'visit', '/my-clan', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:20'),
(670, 3, 'visit', '/clans', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:24'),
(671, 3, 'visit', '/clans/1', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:30'),
(672, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:42'),
(673, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 01:29:56'),
(674, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 01:29:56'),
(675, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:29:59'),
(676, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:29:59'),
(677, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 01:32:08'),
(678, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 01:32:08'),
(679, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:34:00'),
(680, 3, 'visit', '/heist', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 01:34:18'),
(681, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:34:31'),
(682, 3, 'visit', '/dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:51:23'),
(683, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:51:35'),
(684, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:52:26'),
(685, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:52:51'),
(686, 73, 'visit', '/affiliate/how-it-works', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-12 01:53:56'),
(687, 73, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 01:55:27'),
(688, 73, 'visit', '/affiliate/plans', 'VIEW', '105.112.104.248', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-12 01:55:29'),
(689, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 01:56:36'),
(690, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 01:56:36'),
(691, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 01:56:41'),
(692, 3, 'visit', '/', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 02:04:54'),
(693, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 02:04:55'),
(694, 3, 'visit', '/profile', 'VIEW', '102.90.117.189', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 02:05:02'),
(695, 72, 'visit', '/', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 08:01:38'),
(696, 72, 'visit', '/login', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-12 08:01:39'),
(697, 72, 'visit', '/dashboard', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:01:40'),
(698, 72, 'visit', '/dashboard', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:01:46'),
(699, 72, 'visit', '/heist', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 08:01:51'),
(700, 72, 'visit', '/dashboard', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:01:57'),
(701, 72, 'visit', '/winners', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Winners\"}', '2026-08-12 08:01:58'),
(702, 72, 'visit', '/dashboard', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:02:21'),
(703, 72, 'visit', '/heist', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 08:02:22'),
(704, 72, 'visit', '/heist', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 08:02:25'),
(705, 72, 'visit', '/dashboard', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:02:31'),
(706, 72, 'visit', '/how-to-play', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-12 08:02:34'),
(707, 72, 'visit', '/heist', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 08:03:24'),
(708, 72, 'visit', '/heist', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 08:03:36'),
(709, 72, 'visit', '/how-to-play', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-12 08:03:50'),
(710, 72, 'visit', '/how-to-play', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-12 08:04:47'),
(711, 72, 'visit', '/heist-demo', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:05:06'),
(712, 72, 'visit', '/how-to-play', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-12 08:06:20'),
(713, 72, 'visit', '/heist-demo', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 08:08:00'),
(714, 72, 'visit', '/heist', 'VIEW', '105.112.218.57', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 08:11:33'),
(715, 2, 'visit', '/winners', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-12 09:40:22'),
(716, 2, 'visit', '/profile', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 09:40:22'),
(717, 2, 'visit', '/profile', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 09:40:40'),
(718, 2, 'visit', '/profile', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 09:44:23'),
(719, 2, 'visit', '/profile', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 09:46:51'),
(720, 2, 'visit', '/profile', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 09:47:03'),
(721, 2, 'visit', '/affiliate-dashboard', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 09:47:35'),
(722, 2, 'visit', '/profile', 'VIEW', '105.113.113.11', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 09:47:56'),
(723, 72, 'visit', '/', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 11:25:35'),
(724, 72, 'visit', '/heist', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 11:25:35'),
(725, 72, 'visit', '/login', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-12 11:25:38'),
(726, 72, 'visit', '/dashboard', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 11:25:39'),
(727, 72, 'visit', '/trade', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-12 11:25:48'),
(728, 72, 'visit', '/dashboard', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 11:25:55'),
(729, 72, 'visit', '/heist', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 11:25:57'),
(730, 72, 'visit', '/dashboard', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 11:26:07'),
(731, 72, 'visit', '/how-to-play', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-12 11:26:11'),
(732, 72, 'visit', '/heist-demo', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 11:26:22'),
(733, 72, 'visit', '/heist', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 11:27:03'),
(734, 72, 'visit', '/heist', 'VIEW', '129.222.206.94', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 11:27:53'),
(735, 3, 'visit', '/profile', 'VIEW', '102.90.43.115', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 12:44:22'),
(736, 73, 'visit', '/affiliate/plans', 'VIEW', '143.105.174.37', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-12 14:19:46'),
(737, 4, 'visit', '/', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 21:20:22'),
(738, 4, 'visit', '/', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 21:20:54'),
(739, 74, 'register', '/register', 'POST', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"account_type\":\"user\",\"referral_code\":null}', '2026-08-12 21:27:32'),
(740, 74, 'login', '/login', 'POST', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', NULL, '2026-08-12 21:28:03'),
(741, 74, 'visit', '/dashboard', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:28:04'),
(742, 74, 'visit', '/how-to-play', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-12 21:29:42'),
(743, 4, 'visit', '/', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 21:29:54'),
(744, 3, 'visit', '/', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 21:30:13'),
(745, 1, 'login', '/login', 'POST', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-08-12 21:30:25'),
(746, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:30:26'),
(747, 74, 'visit', '/dashboard', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:30:35'),
(748, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:30:36'),
(749, 74, 'visit', '/dashboard', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:30:38'),
(750, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:30:39'),
(751, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:30:39'),
(752, 74, 'visit', '/dashboard', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:30:52'),
(753, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:31:02'),
(754, NULL, 'login_failed', '/login', 'POST', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"identifier\":\"potato\",\"reason\":\"not_found_or_unverified\"}', '2026-08-12 21:32:06'),
(755, 3, 'login', '/login', 'POST', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', NULL, '2026-08-12 21:32:27'),
(756, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-12 21:32:29'),
(757, 3, 'visit', '/profile', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:32:41');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(758, 3, 'visit', '/dashboard', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:32:47'),
(759, 3, 'visit', '/heist', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:32:49'),
(760, 3, 'visit', '/heist', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:34:16'),
(761, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:38:12'),
(762, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:38:12'),
(763, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:38:25'),
(764, 74, 'visit', '/heist', 'VIEW', '102.90.81.197', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-12 21:38:28'),
(765, 3, 'visit', '/', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-12 21:50:06'),
(766, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 21:52:16'),
(767, 1, 'visit', '/admin/heists', 'VIEW', '102.90.100.233', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-12 22:44:59'),
(768, 1, 'visit', '/', 'VIEW', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-13 10:07:30'),
(769, 1, 'visit', '/dashboard', 'VIEW', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-13 10:07:31'),
(770, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-13 10:07:31'),
(771, 3, 'login', '/login', 'POST', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-08-13 10:07:41'),
(772, 3, 'visit', '/dashboard', 'VIEW', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-13 10:07:43'),
(773, 3, 'visit', '/dashboard', 'VIEW', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-13 10:07:52'),
(774, 3, 'visit', '/heist', 'VIEW', '102.90.116.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-13 10:08:01'),
(775, 3, 'visit', '/', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 08:23:17'),
(776, 3, 'visit', '/', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 08:23:17'),
(777, 3, 'visit', '/', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 08:23:22'),
(778, 3, 'visit', '/register', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-08-14 08:23:25'),
(779, 3, 'visit', '/login', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 08:23:30'),
(780, 3, 'visit', '/dashboard', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 08:23:31'),
(781, 3, 'visit', '/dashboard', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 08:23:36'),
(782, 3, 'visit', '/heist', 'VIEW', '102.90.82.201', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 08:23:42'),
(783, 74, 'visit', '/', 'VIEW', '102.90.118.156', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 08:34:53'),
(784, 74, 'visit', '/login', 'VIEW', '102.90.118.156', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 08:34:53'),
(785, 74, 'visit', '/dashboard', 'VIEW', '102.90.118.156', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 08:34:57'),
(786, 74, 'visit', '/heist', 'VIEW', '102.90.118.156', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 08:35:21'),
(787, 74, 'visit', '/heist/32', 'VIEW', '102.90.118.156', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 08:35:25'),
(788, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 12:30:50'),
(789, 1, 'login', '/login', 'POST', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-08-14 12:34:57'),
(790, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:34:59'),
(791, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:35:21'),
(792, 1, 'visit', '/', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 12:42:36'),
(793, 72, 'visit', '/', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 12:44:23'),
(794, 72, 'visit', '/register', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-08-14 12:44:30'),
(795, 3, 'visit', '/', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 12:44:48'),
(796, 3, 'visit', '/profile', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:44:51'),
(797, 72, 'visit', '/', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 12:44:53'),
(798, 72, 'visit', '/login', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 12:44:59'),
(799, 72, 'visit', '/dashboard', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:44:59'),
(800, 1, 'login_failed', '/login', 'POST', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"reason\":\"bad_password\"}', '2026-08-14 12:45:03'),
(801, 1, 'login', '/login', 'POST', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', NULL, '2026-08-14 12:45:26'),
(802, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:45:28'),
(803, 72, 'visit', '/heist', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 12:46:12'),
(804, 72, 'visit', '/heist/32', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 12:46:16'),
(805, 1, 'login', '/login', 'POST', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-08-14 12:46:21'),
(806, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:46:22'),
(807, 3, 'login', '/login', 'POST', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', NULL, '2026-08-14 12:46:32'),
(808, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:46:33'),
(809, 3, 'visit', '/profile', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:46:38'),
(810, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:52:23'),
(811, 3, 'visit', '/account', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:53:35'),
(812, 3, 'visit', '/account?tab=withdraw', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:53:38'),
(813, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:53:55'),
(814, 3, 'visit', '/account', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:54:12'),
(815, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:54:12'),
(816, 3, 'visit', '/account', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:54:13'),
(817, 3, 'visit', '/account?tab=withdraw', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:54:34'),
(818, 3, 'visit', '/account?tab=topup', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:54:34'),
(819, 3, 'visit', '/account?tab=withdraw', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:54:37'),
(820, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:55:06'),
(821, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 12:56:03'),
(822, 3, 'visit', '/heist/32', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 12:56:10'),
(823, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 12:57:14'),
(824, 3, 'visit', '/heist/32', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 12:59:34'),
(825, 3, 'visit', '/heist/32/result', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:00:39'),
(826, 3, 'visit', '/heist/32/result', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:00:50'),
(827, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:00:51'),
(828, 3, 'visit', '/heist/32/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:00:56'),
(829, 3, 'visit', '/heist/32', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:01:13'),
(830, 3, 'visit', '/heist/32/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:01:18'),
(831, 3, 'visit', '/heist/32', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:01:21'),
(832, 3, 'visit', '/heist/32/result', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:01:24'),
(833, 3, 'visit', '/heist/32/result', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:01:26'),
(834, 72, 'visit', '/heist', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:04:20'),
(835, 72, 'visit', '/heist', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:04:26'),
(836, 72, 'visit', '/heist/32', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:04:28'),
(837, 72, 'visit', '/heist', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:05:11'),
(838, 72, 'visit', '/heist/32', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:05:18'),
(839, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:05:30'),
(840, 3, 'visit', '/heist/32/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:05:32'),
(841, 72, 'visit', '/heist/32/result', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:06:40'),
(842, 3, 'visit', '/heist/32/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:06:47'),
(843, 72, 'visit', '/heist/32/result', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:07:01'),
(844, 72, 'visit', '/heist/32', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:08:26'),
(845, 72, 'visit', '/heist', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:08:27'),
(846, 72, 'visit', '/heist/32/leaderboard', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:08:31'),
(847, 72, 'visit', '/dashboard', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 13:10:00'),
(848, 72, 'visit', '/dashboard', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 13:11:29'),
(849, 72, 'visit', '/dashboard', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 13:11:35'),
(850, 72, 'visit', '/heist', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:12:17'),
(851, 72, 'visit', '/heist/32/leaderboard', 'VIEW', '105.112.210.148', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:12:27'),
(852, 3, 'visit', '/heist/32/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:22:21'),
(853, 3, 'visit', '/heist/32', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:22:22'),
(854, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:22:24'),
(855, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:22:25'),
(856, 74, 'visit', '/heist', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:25:07'),
(857, 74, 'visit', '/heist/32', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:25:27'),
(858, 74, 'visit', '/heist', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:30:09'),
(859, 74, 'visit', '/heist/32', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:30:10'),
(860, 74, 'visit', '/heist/32/result', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:30:52'),
(861, 74, 'visit', '/heist', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:31:08'),
(862, 74, 'visit', '/heist', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:31:22'),
(863, 74, 'visit', '/heist', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:31:24'),
(864, 74, 'visit', '/heist', 'VIEW', '197.210.55.175', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:dc1494bf-c362-4ff4-b7ae-ab653b7ab788', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 13:32:55'),
(865, 72, 'visit', '/', 'VIEW', '105.118.5.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 14:33:36'),
(866, 72, 'visit', '/login', 'VIEW', '105.118.5.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 14:33:42'),
(867, 72, 'visit', '/dashboard', 'VIEW', '105.118.5.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 14:33:42'),
(868, 72, 'visit', '/heist', 'VIEW', '105.118.5.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:34:01'),
(869, 72, 'visit', '/heist/32/leaderboard', 'VIEW', '105.118.5.179', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:34:03'),
(870, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:35:28'),
(871, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:35:29'),
(872, 3, 'visit', '/heist/32/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:35:36'),
(873, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 14:35:39'),
(874, 3, 'visit', '/heist/32', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:36:45'),
(875, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:36:45'),
(876, 3, 'visit', '/heist/32/result', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:36:46'),
(877, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:36:47'),
(878, 72, 'visit', '/', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 14:40:36'),
(879, 72, 'visit', '/login', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 14:40:39'),
(880, 72, 'visit', '/dashboard', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 14:40:40'),
(881, 72, 'visit', '/heist', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:41:30'),
(882, 72, 'visit', '/heist/33', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:41:37'),
(883, 72, 'visit', '/heist/33/result', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:43:17'),
(884, 72, 'visit', '/heist/33', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:43:21'),
(885, 72, 'visit', '/heist', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:43:26'),
(886, 72, 'visit', '/heist/33/leaderboard', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 14:43:30'),
(887, 72, 'visit', '/', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 15:45:06'),
(888, 72, 'visit', '/login', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 15:45:10'),
(889, 72, 'visit', '/dashboard', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 15:45:11'),
(890, 72, 'visit', '/dashboard', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 15:45:19'),
(891, 72, 'visit', '/heist', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 15:45:22'),
(892, 72, 'visit', '/heist/33/leaderboard', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 15:45:26'),
(893, 72, 'visit', '/heist/33/leaderboard', 'VIEW', '105.112.106.121', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 15:46:02'),
(894, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 16:40:34'),
(895, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:42:26'),
(896, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:42:27'),
(897, 3, 'visit', '/heist/33', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:42:31'),
(898, 3, 'visit', '/heist/33/result', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:43:31'),
(899, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:43:37'),
(900, 3, 'visit', '/heist/33/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:43:41'),
(901, 3, 'visit', '/heist/33', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:44:35'),
(902, 3, 'visit', '/heist', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:44:35'),
(903, 3, 'visit', '/heist/33/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 16:52:29'),
(904, 72, 'visit', '/', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 18:36:14'),
(905, 72, 'visit', '/login', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 18:36:15'),
(906, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 18:36:15'),
(907, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 18:36:20');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(908, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 18:36:21'),
(909, 72, 'visit', '/heist/33/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 18:36:27'),
(910, 73, 'visit', '/affiliate/plans', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 18:36:52'),
(911, 73, 'visit', '/affiliate/plans', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 18:36:56'),
(912, 73, 'visit', '/affiliate/plans', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 18:36:59'),
(913, 73, 'visit', '/affiliate/referral', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-14 18:37:13'),
(914, 73, 'visit', '/affiliate/trade', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 18:37:17'),
(915, 73, 'visit', '/', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 18:37:24'),
(916, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 18:37:28'),
(917, 73, 'visit', '/affiliate/referral', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-14 18:37:57'),
(918, 73, 'visit', '/account', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 18:38:15'),
(919, 73, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 18:38:19'),
(920, 73, 'visit', '/affiliate/plans', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 18:38:29'),
(921, 73, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 18:39:02'),
(922, 73, 'visit', '/affiliate/plans', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 18:39:06'),
(923, 73, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 18:39:11'),
(924, 73, 'visit', '/account', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 18:39:15'),
(925, 3, 'visit', '/heist/33/leaderboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 18:41:13'),
(926, 1, 'visit', '/admin/heists', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 18:41:26'),
(927, 3, 'visit', '/', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 19:03:31'),
(928, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:03:39'),
(929, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:03:55'),
(930, 3, 'visit', '/trade', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-14 19:04:39'),
(931, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:04:48'),
(932, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:05:06'),
(933, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:05:14'),
(934, 72, 'visit', '/winners', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Winners\"}', '2026-08-14 19:13:49'),
(935, 72, 'visit', '/login', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-14 19:15:57'),
(936, 72, 'visit', '/', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-14 19:15:57'),
(937, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:15:59'),
(938, 72, 'visit', '/account', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:16:03'),
(939, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:16:42'),
(940, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:17:46'),
(941, 72, 'visit', '/heist/34', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:17:52'),
(942, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:18:59'),
(943, 3, 'visit', '/profile', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:19:04'),
(944, 3, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 19:19:10'),
(945, 3, 'visit', '/affiliate/plans', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 19:19:17'),
(946, 3, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 19:19:26'),
(947, 3, 'visit', '/affiliate/plans', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-14 19:19:31'),
(948, 72, 'visit', '/heist/34/result', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:19:44'),
(949, 3, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 19:20:03'),
(950, 72, 'visit', '/heist/34', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:20:20'),
(951, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:20:21'),
(952, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:20:28'),
(953, 72, 'visit', '/profile', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:20:38'),
(954, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:20:56'),
(955, 73, 'visit', '/account', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:22:22'),
(956, 73, 'visit', '/profile', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:22:47'),
(957, 73, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:23:18'),
(958, 73, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:23:28'),
(959, 73, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-14 19:23:28'),
(960, 3, 'visit', '/profile', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:24:22'),
(961, 3, 'visit', '/dashboard', 'VIEW', '197.210.54.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-14 19:24:26'),
(962, 2, 'login_failed', '/login', 'POST', '105.113.99.250', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"reason\":\"bad_password\"}', '2026-08-14 22:19:17'),
(963, 2, 'login', '/login', 'POST', '105.113.99.250', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-08-14 22:19:27'),
(964, 2, 'visit', '/affiliate-dashboard', 'VIEW', '105.113.99.250', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-14 22:19:29'),
(965, 72, 'visit', '/', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-15 06:32:00'),
(966, 72, 'visit', '/login', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-15 06:32:10'),
(967, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 06:32:11'),
(968, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 06:32:29'),
(969, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 06:32:32'),
(970, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 06:32:43'),
(971, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 06:32:52'),
(972, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 06:32:56'),
(973, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 06:33:02'),
(974, 2, 'visit', '/affiliate-dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-15 13:04:58'),
(975, 2, 'visit', '/profile', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:05:02'),
(976, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:05:12'),
(977, 2, 'visit', '/', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-15 13:09:07'),
(978, 2, 'visit', '/profile', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:09:11'),
(979, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:09:14'),
(980, 2, 'visit', '/how-to-play', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-15 13:09:23'),
(981, 2, 'visit', '/heist-demo', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:09:25'),
(982, 2, 'visit', '/how-to-play', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-15 13:09:34'),
(983, 2, 'visit', '/heist-demo', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:09:35'),
(984, 2, 'visit', '/profile', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:10:41'),
(985, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:10:44'),
(986, 2, 'visit', '/heist', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 13:10:47'),
(987, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:11:06'),
(988, 2, 'visit', '/account', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:11:07'),
(989, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:11:23'),
(990, 2, 'visit', '/account', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:11:26'),
(991, 2, 'visit', '/account?tab=withdraw', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:11:34'),
(992, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:11:44'),
(993, 2, 'visit', '/trade', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-15 13:11:54'),
(994, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:12:13'),
(995, 2, 'visit', '/account', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:12:13'),
(996, 2, 'visit', '/account?tab=withdraw', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:12:14'),
(997, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:12:36'),
(998, 2, 'visit', '/winners', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-15 13:12:37'),
(999, 2, 'visit', '/winners', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-15 13:13:26'),
(1000, 2, 'visit', '/profile', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:15:36'),
(1001, 2, 'visit', '/affiliate-dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-15 13:15:44'),
(1002, 2, 'visit', '/affiliate/plans', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-15 13:16:25'),
(1003, 2, 'visit', '/affiliate-dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-15 13:17:33'),
(1004, 2, 'visit', '/affiliate/referral', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-15 13:17:35'),
(1005, 2, 'visit', '/affiliate-dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-15 13:18:11'),
(1006, 2, 'visit', '/profile', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:18:19'),
(1007, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:18:33'),
(1008, 2, 'visit', '/how-to-play', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-15 13:18:46'),
(1009, 2, 'visit', '/heist-demo', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:18:49'),
(1010, 2, 'visit', '/how-to-play', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-15 13:18:52'),
(1011, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 13:20:17'),
(1012, 2, 'visit', '/dashboard', 'VIEW', '105.127.15.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 14:17:03'),
(1013, 72, 'visit', '/', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-15 16:57:58'),
(1014, 72, 'visit', '/login', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-15 16:58:01'),
(1015, 72, 'visit', '/dashboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 16:58:02'),
(1016, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:07'),
(1017, 72, 'visit', '/heist', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:16'),
(1018, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:21'),
(1019, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:29'),
(1020, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:32'),
(1021, 72, 'visit', '/heist/34', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:36'),
(1022, 72, 'visit', '/heist/34/leaderboard', 'VIEW', '105.112.208.35', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:385x854:Africa/Lagos:6f7982bf-8885-4b8d-bc75-fc3c40530f0d', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 16:58:53'),
(1023, 1, 'visit', '/admin/heists', 'VIEW', '197.210.29.207', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 19:12:54'),
(1024, 1, 'visit', '/heist', 'VIEW', '197.210.29.207', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 19:12:57'),
(1025, 1, 'visit', '/admin-dashboard', 'VIEW', '197.210.29.207', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 19:12:57'),
(1026, 73, 'visit', '/heist', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 22:55:49'),
(1027, 73, 'visit', '/heist', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 22:55:56'),
(1028, 73, 'visit', '/dashboard', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 22:55:58'),
(1029, 73, 'visit', '/dashboard', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 22:56:03'),
(1030, 73, 'visit', '/heist', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-15 22:56:04'),
(1031, 73, 'visit', '/dashboard', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-15 22:56:10'),
(1032, 73, 'visit', '/dashboard', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 07:07:42'),
(1033, 73, 'visit', '/dashboard', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 07:07:47'),
(1034, 73, 'visit', '/heist', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 07:07:48'),
(1035, 73, 'visit', '/heist', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 07:08:00'),
(1036, 73, 'visit', '/heist', 'VIEW', '105.112.108.198', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:f580ae9d-74a4-4312-96b9-ee19f5378c6f', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 07:38:32'),
(1037, 55, 'login', '/login', 'POST', '102.90.120.66', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', NULL, '2026-08-16 11:29:40'),
(1038, 55, 'visit', '/affiliate-dashboard', 'VIEW', '102.90.120.66', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-16 11:29:43'),
(1039, 12, 'login', '/login', 'POST', '102.90.120.66', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:47f2ab97-47ef-4c29-a0e3-6f5fc990f06b', NULL, '2026-08-16 11:30:33'),
(1040, 3, 'visit', '/', 'VIEW', '102.90.96.68', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-16 12:18:41'),
(1041, 75, 'register', '/register', 'POST', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"account_type\":\"user\",\"referral_code\":null}', '2026-08-16 12:26:53'),
(1042, 75, 'login', '/login', 'POST', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', NULL, '2026-08-16 12:27:16'),
(1043, 75, 'visit', '/dashboard', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:27:18'),
(1044, 75, 'visit', '/my-clan', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:27:38'),
(1045, 75, 'visit', '/clans', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:27:48'),
(1046, 75, 'visit', '/clans/2', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:27:56'),
(1047, 75, 'visit', '/clan-quests', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:28:38'),
(1048, 75, 'visit', '/', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-16 12:28:49'),
(1049, 2, 'visit', '/', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-16 12:29:04'),
(1050, 75, 'visit', '/dashboard', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:29:06'),
(1051, 75, 'visit', '/heist', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 12:29:11'),
(1052, 2, 'visit', '/my-clan', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:29:15'),
(1053, 75, 'visit', '/how-to-play', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-16 12:30:07'),
(1054, 75, 'visit', '/heist-demo', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:30:08'),
(1055, 75, 'visit', '/heist', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 12:30:42'),
(1056, 75, 'visit', '/heist-demo', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:31:05');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1057, 75, 'visit', '/how-to-play', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-16 12:31:29'),
(1058, 75, 'visit', '/heist', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 12:31:29'),
(1059, 75, 'visit', '/dashboard', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 12:31:36'),
(1060, 75, 'visit', '/winners', 'VIEW', '105.113.110.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x806:Africa/Lagos:1daadbb4-4289-4db1-889b-1a71a258a5a0', '{\"title\":\"CopUpBid Winners\"}', '2026-08-16 12:31:42'),
(1061, 2, 'visit', '/heist', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-08-16 12:32:44'),
(1062, 2, 'visit', '/trade', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-16 13:17:36'),
(1063, 2, 'visit', '/profile', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 13:17:43'),
(1064, 2, 'visit', '/dashboard', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 13:17:45'),
(1065, 2, 'visit', '/account', 'VIEW', '105.113.99.240', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-16 13:17:46'),
(1066, 2, 'visit', '/account', 'VIEW', '105.113.109.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-18 07:49:59'),
(1067, 2, 'visit', '/my-clan', 'VIEW', '105.113.109.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-18 07:50:05'),
(1068, 2, 'visit', '/heist', 'VIEW', '105.113.109.106', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-08-18 07:50:31'),
(1069, 3, 'visit', '/', 'VIEW', '102.90.96.39', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-18 17:17:14'),
(1070, 3, 'visit', '/profile', 'VIEW', '102.90.96.39', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-18 17:20:45'),
(1071, 3, 'visit', '/dashboard', 'VIEW', '102.90.96.39', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-18 17:20:48'),
(1072, 1, 'visit', '/admin/heists', 'VIEW', '98.97.79.245', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-20 20:58:52'),
(1073, 1, 'visit', '/', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-20 23:36:14'),
(1074, 1, 'login', '/login', 'POST', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', NULL, '2026-08-20 23:36:57'),
(1075, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-20 23:36:59'),
(1076, 1, 'login', '/login', 'POST', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', NULL, '2026-08-20 23:37:00'),
(1077, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-20 23:37:01'),
(1078, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-20 23:39:42'),
(1079, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-20 23:39:58'),
(1080, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-20 23:39:58'),
(1081, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:06:12'),
(1082, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:06:13'),
(1083, 1, 'visit', '/', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-21 00:11:05'),
(1084, 1, 'visit', '/', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-21 00:11:05'),
(1085, 1, 'visit', '/admin/heists/content-bank', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:15:39'),
(1086, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:15:51'),
(1087, 1, 'visit', '/profile', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:17:42'),
(1088, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:17:42'),
(1089, 1, 'visit', '/admin/analytics', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:18:10'),
(1090, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:18:21'),
(1091, 1, 'visit', '/admin/analytics', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:18:45'),
(1092, 1, 'visit', '/admin/analytics', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:29:42'),
(1093, 1, 'visit', '/admin/analytics', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:db72cde2-ac50-4826-a0de-39ee14209700', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:29:42'),
(1094, 1, 'visit', '/admin-dashboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:38:31'),
(1095, 1, 'visit', '/admin/heists', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:38:44'),
(1096, 3, 'visit', '/', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-21 00:45:03'),
(1097, 3, 'visit', '/profile', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:45:05'),
(1098, 3, 'visit', '/dashboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 00:45:11'),
(1099, 3, 'visit', '/heist', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:45:14'),
(1100, 3, 'visit', '/heist/35', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:45:17'),
(1101, 3, 'visit', '/heist/35/result', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:45:40'),
(1102, 3, 'visit', '/heist', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:45:44'),
(1103, 3, 'visit', '/heist', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:47:07'),
(1104, 3, 'visit', '/winners', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Winners\"}', '2026-08-21 00:47:14'),
(1105, 3, 'visit', '/heist', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:52:30'),
(1106, 3, 'visit', '/heist/36', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:52:33'),
(1107, 3, 'visit', '/heist/36/result', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:52:52'),
(1108, 3, 'visit', '/heist', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 00:52:57'),
(1109, 3, 'visit', '/heist', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 02:01:12'),
(1110, 3, 'visit', '/heist/36/leaderboard', 'VIEW', '102.90.118.252', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:3b119aa1-a079-4e03-b36a-2925f184e0b0', '{\"title\":\"CopUpBid Heists\"}', '2026-08-21 02:01:13'),
(1111, 1, 'visit', '/', 'VIEW', '102.93.11.130', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-21 22:37:43'),
(1112, 1, 'visit', '/', 'VIEW', '102.93.11.130', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-21 22:37:43'),
(1113, 1, 'visit', '/eg', 'VIEW', '102.93.11.130', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 22:37:47'),
(1114, 1, 'visit', '/', 'VIEW', '102.93.11.130', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-21 22:38:09'),
(1115, 1, 'visit', '/eg', 'VIEW', '102.93.11.130', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:46420a3a-bb41-4be0-b36e-ff7144588a28', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-21 22:38:11'),
(1116, 2, 'login_failed', '/login', 'POST', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"reason\":\"bad_password\"}', '2026-08-22 00:30:48'),
(1117, 2, 'login_failed', '/login', 'POST', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"reason\":\"bad_password\"}', '2026-08-22 00:30:49'),
(1118, 2, 'login', '/login', 'POST', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-08-22 00:31:08'),
(1119, 2, 'visit', '/dashboard', 'VIEW', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 00:31:10'),
(1120, 2, 'visit', '/heist', 'VIEW', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-08-22 00:31:18'),
(1121, 1, 'login', '/login', 'POST', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-08-22 00:32:29'),
(1122, 1, 'visit', '/admin-dashboard', 'VIEW', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 00:32:31'),
(1123, 1, 'visit', '/admin/analytics', 'VIEW', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 00:32:48'),
(1124, 1, 'visit', '/admin-dashboard', 'VIEW', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 00:33:18'),
(1125, 1, 'visit', '/admin/heists', 'VIEW', '105.113.82.54', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 00:33:39'),
(1126, 1, 'visit', '/admin/heists', 'VIEW', '105.113.109.254', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 10:56:41'),
(1127, 1, 'visit', '/admin/heists', 'VIEW', '105.113.109.254', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-22 12:13:05'),
(1128, 1, 'visit', '/admin/heists', 'VIEW', '105.113.98.115', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-24 15:41:41'),
(1129, 1, 'visit', '/admin/heists', 'VIEW', '105.113.98.115', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-24 15:44:44'),
(1130, 1, 'visit', '/admin/heists', 'VIEW', '105.113.98.115', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-24 15:47:07'),
(1131, 1, 'visit', '/admin/heists', 'VIEW', '105.113.98.115', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-24 16:34:29'),
(1132, 1, 'visit', '/admin/heists', 'VIEW', '105.113.98.115', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-24 16:34:32'),
(1133, 1, 'visit', '/admin/heists', 'VIEW', '105.113.114.139', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-24 17:20:23'),
(1134, NULL, 'login_failed', '/login', 'POST', '185.225.69.222', '\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36\"', 'web:Linux x86_64:1920x1080:Europe/Moscow:0f8710a2-0cd3-42d5-8d25-4b009fe0337a', '{\"identifier\":\"h.oxike.yu42.8@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-08-27 05:38:14'),
(1135, NULL, 'login_failed', '/login', 'POST', '185.225.69.222', '\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36\"', 'web:Linux x86_64:1920x1080:Europe/Moscow:0f8710a2-0cd3-42d5-8d25-4b009fe0337a', '{\"identifier\":\"h.oxike.yu42.8@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-08-27 05:38:18'),
(1136, NULL, 'login_failed', '/login', 'POST', '185.225.69.222', '\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36\"', 'web:Linux x86_64:1920x1080:Europe/Moscow:0f8710a2-0cd3-42d5-8d25-4b009fe0337a', '{\"identifier\":\"h.oxike.yu42.8@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-08-27 05:38:23'),
(1137, 1, 'visit', '/admin/heists', 'VIEW', '105.113.63.237', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-27 07:37:02'),
(1138, 2, 'login', '/login', 'POST', '105.113.63.237', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-08-27 07:37:22'),
(1139, 2, 'visit', '/dashboard', 'VIEW', '105.113.63.237', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-27 07:37:34'),
(1140, 2, 'visit', '/winners', 'VIEW', '105.113.63.237', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-27 07:37:50'),
(1141, 3, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', NULL, '2026-08-30 21:22:24'),
(1142, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 21:22:26'),
(1143, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', '{\"title\":\"CopUpBid Heists\"}', '2026-08-30 21:22:41'),
(1144, 3, 'visit', '/winners', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', '{\"title\":\"CopUpBid Winners\"}', '2026-08-30 21:25:57'),
(1145, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 21:26:54'),
(1146, 3, 'visit', '/profile', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 21:27:08'),
(1147, 3, 'visit', '/winners', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:26a1baf9-2043-469f-8068-b90d3b214227', '{\"title\":\"CopUpBid Winners\"}', '2026-08-30 21:31:45'),
(1148, 76, 'register', '/register', 'POST', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"account_type\":\"user\",\"referral_code\":null}', '2026-08-30 22:40:16'),
(1149, 76, 'login', '/login', 'POST', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', NULL, '2026-08-30 22:41:15'),
(1150, 76, 'visit', '/dashboard', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 22:41:17'),
(1151, 76, 'visit', '/profile', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 22:41:54'),
(1152, 3, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', NULL, '2026-08-30 23:22:24'),
(1153, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:22:26'),
(1154, 3, 'visit', '/levels', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:22:41'),
(1155, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:22:53'),
(1156, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:23:03'),
(1157, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:23:20'),
(1158, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:23:20'),
(1159, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:23:28'),
(1160, 76, 'visit', '/', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-30 23:35:51'),
(1161, 76, 'visit', '/dashboard', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:36:03'),
(1162, 76, 'visit', '/', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-30 23:36:19'),
(1163, 76, 'visit', '/how-to-play', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-30 23:36:36'),
(1164, 76, 'visit', '/dashboard', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:36:44'),
(1165, 76, 'login', '/login', 'POST', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', NULL, '2026-08-30 23:37:51'),
(1166, 76, 'visit', '/dashboard', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:37:52'),
(1167, 76, 'visit', '/', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-30 23:38:03'),
(1168, 76, 'visit', '/register', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-08-30 23:38:06'),
(1169, 76, 'visit', '/login', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"Login to CopUpBid\"}', '2026-08-30 23:38:09'),
(1170, 76, 'visit', '/dashboard', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:38:10'),
(1171, 76, 'visit', '/heist', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-30 23:39:14'),
(1172, 76, 'visit', '/clans', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:39:34'),
(1173, 76, 'visit', '/my-clan', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:39:55'),
(1174, 76, 'visit', '/trade', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-30 23:39:55'),
(1175, 76, 'visit', '/clan-quests', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:39:55'),
(1176, 76, 'visit', '/winners', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Winners\"}', '2026-08-30 23:40:07'),
(1177, 3, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', NULL, '2026-08-30 23:40:19'),
(1178, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:40:21'),
(1179, 76, 'visit', '/how-to-play', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-30 23:40:29'),
(1180, 76, 'visit', '/', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-30 23:40:34'),
(1181, 76, 'visit', '/', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-30 23:40:46'),
(1182, 76, 'visit', '/dashboard', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:40:50'),
(1183, 3, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:9f4014cf-abf6-4061-bc25-777491a38074', NULL, '2026-08-30 23:41:02'),
(1184, 3, 'visit', '/winners', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:9f4014cf-abf6-4061-bc25-777491a38074', '{\"title\":\"CopUpBid Winners\"}', '2026-08-30 23:41:03'),
(1185, 76, 'visit', '/levels', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:41:20'),
(1186, 3, 'visit', '/profile', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:9f4014cf-abf6-4061-bc25-777491a38074', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:41:21'),
(1187, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:9f4014cf-abf6-4061-bc25-777491a38074', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:41:33'),
(1188, 76, 'visit', '/rewards', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:41:57'),
(1189, 76, 'visit', '/rewards', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:42:11'),
(1190, 76, 'visit', '/rewards', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:42:13'),
(1191, 76, 'visit', '/levels', 'VIEW', '195.242.214.21', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:48:58'),
(1192, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:50:51'),
(1193, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:50:57'),
(1194, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:51:19'),
(1195, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:51:29'),
(1196, 3, 'visit', '/account', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:51:32'),
(1197, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:ec52269d-5b50-4172-a24f-5833258654b4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-30 23:51:34'),
(1198, 3, 'visit', '/', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 00:01:29'),
(1199, 3, 'visit', '/', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 00:01:29'),
(1200, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 00:01:34'),
(1201, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 00:01:43');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1202, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 00:02:14'),
(1203, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 00:02:29'),
(1204, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 00:02:29'),
(1205, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 00:04:15'),
(1206, 1, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', NULL, '2026-08-31 01:15:45'),
(1207, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:15:47'),
(1208, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:16:01'),
(1209, 76, 'visit', '/levels', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:17:00'),
(1210, 76, 'visit', '/', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 01:17:06'),
(1211, 76, 'visit', '/register', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-08-31 01:17:07'),
(1212, 76, 'visit', '/', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 01:17:09'),
(1213, 76, 'visit', '/heist', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:17:13'),
(1214, 76, 'visit', '/heist/37', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:17:20'),
(1215, 3, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', NULL, '2026-08-31 01:17:32'),
(1216, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:17:33'),
(1217, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:17:42'),
(1218, 3, 'visit', '/heist/37', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:17:46'),
(1219, 76, 'visit', '/heist/37/result', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:17:58'),
(1220, 3, 'visit', '/heist/37/result', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:18:20'),
(1221, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:18:35'),
(1222, 76, 'visit', '/heist/37', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:18:42'),
(1223, 3, 'visit', '/heist/37/leaderboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:18:45'),
(1224, 76, 'visit', '/heist/37/leaderboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:18:59'),
(1225, 76, 'visit', '/heist/37', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:19:20'),
(1226, 76, 'visit', '/heist/37', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:21:16'),
(1227, 76, 'visit', '/heist/37/result', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:21:17'),
(1228, 3, 'visit', '/heist/37', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:21:23'),
(1229, 3, 'visit', '/heist/37/result', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:21:24'),
(1230, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:21:25'),
(1231, 3, 'visit', '/', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 01:21:28'),
(1232, 76, 'visit', '/dashboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:21:32'),
(1233, 76, 'visit', '/account', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:21:34'),
(1234, 76, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:21:39'),
(1235, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:21:41'),
(1236, 1, 'visit', '/admin/transactions', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:22:03'),
(1237, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:22:18'),
(1238, 1, 'visit', '/admin/transactions', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:22:30'),
(1239, 1, 'visit', '/admin/transactions', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:22:56'),
(1240, 76, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:23:21'),
(1241, 76, 'visit', '/account?tab=withdraw', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:23:50'),
(1242, 1, 'visit', '/admin/users', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:24:10'),
(1243, 1, 'visit', '/admin/levels', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:24:33'),
(1244, 76, 'visit', '/rewards', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:25:06'),
(1245, 76, 'visit', '/rewards', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:25:11'),
(1246, 76, 'visit', '/rewards', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:25:16'),
(1247, 1, 'visit', '/admin/levels', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:25:35'),
(1248, 76, 'visit', '/dashboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:25:59'),
(1249, 76, 'visit', '/levels', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:26:11'),
(1250, 1, 'visit', '/admin/levels', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:26:28'),
(1251, 76, 'visit', '/rewards', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:26:31'),
(1252, 76, 'visit', '/dashboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:26:50'),
(1253, 1, 'visit', '/admin/users', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:26:54'),
(1254, 76, 'visit', '/account', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:27:15'),
(1255, 76, 'visit', '/dashboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:27:30'),
(1256, 76, 'visit', '/rewards', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:27:32'),
(1257, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:27:35'),
(1258, 3, 'visit', '/rewards', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:28:04'),
(1259, 76, 'visit', '/heist', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:28:21'),
(1260, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:28:23'),
(1261, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:30:52'),
(1262, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:30:59'),
(1263, 76, 'visit', '/xp-activity', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:36:09'),
(1264, 76, 'visit', '/heist', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:38:00'),
(1265, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:38:06'),
(1266, 76, 'visit', '/heist/38', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:38:06'),
(1267, 3, 'visit', '/heist/38', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:38:44'),
(1268, 76, 'visit', '/heist/38/result', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:38:59'),
(1269, 76, 'visit', '/heist', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:39:07'),
(1270, 3, 'visit', '/heist/38/result', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:39:14'),
(1271, 3, 'visit', '/heist', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:39:36'),
(1272, 76, 'visit', '/heist/38/leaderboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:40:01'),
(1273, 3, 'visit', '/heist/38/leaderboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:40:05'),
(1274, 76, 'visit', '/heist/38', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:40:08'),
(1275, 76, 'visit', '/xp-activity', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 01:40:19'),
(1276, 76, 'visit', '/winners', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Winners\"}', '2026-08-31 01:41:03'),
(1277, 76, 'visit', '/heist', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:41:41'),
(1278, 76, 'visit', '/heist/38/leaderboard', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:41:43'),
(1279, 76, 'visit', '/heist/38', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:43:23'),
(1280, 76, 'visit', '/heist', 'VIEW', '102.90.99.253', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.64 Mobile/15E148 Safari/604.1', 'web:iPhone:390x844:Africa/Lagos:361d95c0-0438-449c-8529-a0e1fce584ff', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 01:43:25'),
(1281, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:dd3a89b8-f93d-42cf-8875-d3069d619f65', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 02:00:18'),
(1282, 3, 'visit', '/heist/38/leaderboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:27:49'),
(1283, 3, 'visit', '/heist/38', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:28:37'),
(1284, 3, 'visit', '/profile', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:28:41'),
(1285, 3, 'visit', '/affiliate-dashboard', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 09:28:52'),
(1286, 3, 'visit', '/affiliate/referral', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 09:29:00'),
(1287, 77, 'register', '/register', 'POST', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 15; TECNO KM5 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 musical_ly_2024603030 AppName/musical_ly ByteLocale/en', 'web:Linux aarch64:360x800:Africa/Lagos:a7e3bfc1-6cbd-41ff-972b-b08c99b18af5', '{\"account_type\":\"affiliate\",\"referral_code\":\"light\"}', '2026-08-31 09:31:24'),
(1288, 77, 'login', '/login', 'POST', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 15; TECNO KM5 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 musical_ly_2024603030 AppName/musical_ly ByteLocale/en', 'web:Linux aarch64:360x800:Africa/Lagos:a7e3bfc1-6cbd-41ff-972b-b08c99b18af5', NULL, '2026-08-31 09:31:45'),
(1289, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 15; TECNO KM5 Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 musical_ly_2024603030 AppName/musical_ly ByteLocale/en', 'web:Linux aarch64:360x800:Africa/Lagos:a7e3bfc1-6cbd-41ff-972b-b08c99b18af5', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 09:31:47'),
(1290, 1, 'login', '/login', 'POST', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:42d7b14e-b1e7-4c01-91c0-b3f69a5bb4e2', NULL, '2026-08-31 09:36:14'),
(1291, 1, 'visit', '/admin-dashboard', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:42d7b14e-b1e7-4c01-91c0-b3f69a5bb4e2', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:36:15'),
(1292, 1, 'visit', '/admin/heists', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:42d7b14e-b1e7-4c01-91c0-b3f69a5bb4e2', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:36:51'),
(1293, 3, 'visit', '/profile', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:42:11'),
(1294, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:42:14'),
(1295, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:42:34'),
(1296, 77, 'login', '/login', 'POST', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', NULL, '2026-08-31 09:42:45'),
(1297, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 09:42:46'),
(1298, 3, 'visit', '/account', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:46:55'),
(1299, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:46:57'),
(1300, 3, 'visit', '/account', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:46:57'),
(1301, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:47:00'),
(1302, 3, 'visit', '/trade', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-31 09:47:06'),
(1303, 3, 'visit', '/heist', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:48:44'),
(1304, 3, 'visit', '/heist', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:49:08'),
(1305, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:49:12'),
(1306, 3, 'visit', '/heist', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:49:17'),
(1307, 3, 'visit', '/heist/38/leaderboard', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:49:23'),
(1308, 3, 'visit', '/heist/38', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:49:44'),
(1309, 3, 'visit', '/heist', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:49:44'),
(1310, 1, 'login', '/login', 'POST', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', NULL, '2026-08-31 09:50:18'),
(1311, 1, 'visit', '/admin-dashboard', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:50:20'),
(1312, 1, 'visit', '/admin/heists', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:50:30'),
(1313, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 09:51:48'),
(1314, 77, 'visit', '/affiliate/trade', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:52:23'),
(1315, 77, 'visit', '/affiliate/plans', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 09:52:30'),
(1316, 3, 'visit', '/heist/38/leaderboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:52:42'),
(1317, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 09:52:50'),
(1318, 77, 'visit', '/affiliate/plans', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 09:53:31'),
(1319, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 09:53:37'),
(1320, 3, 'visit', '/heist/38', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:55:11'),
(1321, 3, 'visit', '/heist', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:55:17'),
(1322, 3, 'visit', '/profile', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:55:25'),
(1323, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:55:32'),
(1324, 3, 'visit', '/levels', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:56:30'),
(1325, 3, 'visit', '/profile', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:56:41'),
(1326, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:57:12'),
(1327, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:57:34'),
(1328, 77, 'visit', '/heist/38', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:57:41'),
(1329, 77, 'visit', '/heist/38/result', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:58:55'),
(1330, 77, 'visit', '/levels', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 09:59:38'),
(1331, 77, 'visit', '/heist/38/result', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:59:50'),
(1332, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 09:59:53'),
(1333, 77, 'visit', '/heist/38/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:00:12'),
(1334, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:00:48'),
(1335, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:01:32'),
(1336, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:01:44'),
(1337, 77, 'visit', '/heist/39', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:01:51'),
(1338, 77, 'visit', '/heist/39/result', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:03:02'),
(1339, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:03:12'),
(1340, 77, 'visit', '/heist/39/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:03:14'),
(1341, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:04:21'),
(1342, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:04:54'),
(1343, 77, 'visit', '/heist/39/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:04:57'),
(1344, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:05:38'),
(1345, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:06:12'),
(1346, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:06:31');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1347, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:06:42'),
(1348, 1, 'visit', '/admin/heists', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:06:58'),
(1349, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:07:28'),
(1350, 3, 'visit', '/account', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:07:35'),
(1351, 77, 'visit', '/account', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:07:36'),
(1352, 77, 'visit', '/account?tab=withdraw', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:07:48'),
(1353, 3, 'visit', '/account?tab=withdraw', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:07:49'),
(1354, 3, 'visit', '/account?tab=withdraw', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:10:33'),
(1355, 1, 'visit', '/admin/transactions', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:13:21'),
(1356, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:13:45'),
(1357, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:14:22'),
(1358, 77, 'visit', '/account?tab=withdraw', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:14:31'),
(1359, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:14:41'),
(1360, 3, 'visit', '/account', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:17:06'),
(1361, 3, 'visit', '/account?tab=withdraw', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:17:07'),
(1362, 3, 'visit', '/account?tab=withdraw', 'VIEW', '45.67.99.57', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:19:44'),
(1363, 1, 'visit', '/admin/heists', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:21:04'),
(1364, 1, 'visit', '/admin/heists/promo-codes', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:21:50'),
(1365, 3, 'visit', '/account?tab=withdraw', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:31:33'),
(1366, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:31:33'),
(1367, 1, 'visit', '/admin/users', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:40:17'),
(1368, 1, 'visit', '/admin/notifications', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:41:06'),
(1369, 1, 'visit', '/admin/users', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:41:12'),
(1370, 1, 'visit', '/admin/notifications', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:1c349ac2-01d5-4935-b2dd-50b907fea7c4', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:41:24'),
(1371, 77, 'visit', '/', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 10:46:04'),
(1372, 77, 'visit', '/account?tab=withdraw', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:46:04'),
(1373, 77, 'visit', '/login', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 10:46:13'),
(1374, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:46:13'),
(1375, 77, 'visit', '/', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 10:46:40'),
(1376, 77, 'visit', '/login', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 10:46:41'),
(1377, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:46:42'),
(1378, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:46:55'),
(1379, 77, 'visit', '/heist/40', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:46:59'),
(1380, 77, 'visit', '/heist/40/result', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:48:01'),
(1381, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:48:10'),
(1382, 77, 'visit', '/heist/40/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:48:12'),
(1383, 77, 'visit', '/heist/40', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:48:20'),
(1384, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:48:31'),
(1385, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:50:04'),
(1386, 77, 'visit', '/heist/40/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:50:06'),
(1387, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 10:50:11'),
(1388, 3, 'login', '/login', 'POST', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:c25de3af-8de2-49f9-b94b-0c74137c1c34', NULL, '2026-08-31 10:52:21'),
(1389, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:c25de3af-8de2-49f9-b94b-0c74137c1c34', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:52:23'),
(1390, 3, 'login', '/login', 'POST', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', NULL, '2026-08-31 10:52:58'),
(1391, 3, 'visit', '/dashboard', 'VIEW', '45.67.99.62', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:53:00'),
(1392, 77, 'visit', '/login', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 10:54:10'),
(1393, 77, 'visit', '/', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 10:54:10'),
(1394, 3, 'visit', '/profile', 'VIEW', '45.67.99.56', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:54:10'),
(1395, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:54:15'),
(1396, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 10:54:26'),
(1397, 3, 'visit', '/affiliate-dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 10:54:40'),
(1398, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 10:54:50'),
(1399, 3, 'visit', '/affiliate/referral', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 10:54:52'),
(1400, 3, 'visit', '/affiliate-dashboard', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 10:54:55'),
(1401, 3, 'visit', '/affiliate/referral', 'VIEW', '45.67.99.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 10:54:59'),
(1402, 77, 'visit', '/affiliate/referral', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 10:55:17'),
(1403, 78, 'register', '/register', 'POST', '102.91.98.215', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"account_type\":\"affiliate\",\"referral_code\":\"MERCY\"}', '2026-08-31 11:11:43'),
(1404, NULL, 'login_failed', '/login', 'POST', '102.91.98.215', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"identifier\":\"411264\",\"reason\":\"not_found_or_unverified\"}', '2026-08-31 11:11:55'),
(1405, 78, 'login', '/login', 'POST', '102.91.98.215', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', NULL, '2026-08-31 11:12:18'),
(1406, 78, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.98.215', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 11:12:20'),
(1407, 2, 'visit', '/winners', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-31 12:00:47'),
(1408, 2, 'visit', '/profile', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:00:51'),
(1409, 2, 'visit', '/profile', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:01:06'),
(1410, 2, 'visit', '/dashboard', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:01:35'),
(1411, 2, 'visit', '/heist', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:01:57'),
(1412, 2, 'visit', '/dashboard', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:02:05'),
(1413, 2, 'visit', '/rewards', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:02:06'),
(1414, 2, 'visit', '/levels', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:02:21'),
(1415, 2, 'visit', '/dashboard', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:02:43'),
(1416, 2, 'visit', '/winners', 'VIEW', '105.112.76.26', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-08-31 12:02:48'),
(1417, 78, 'visit', '/login', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 12:03:43'),
(1418, 78, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:03:44'),
(1419, 78, 'visit', '/affiliate/how-it-works', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 12:03:53'),
(1420, 78, 'visit', '/account', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:04:25'),
(1421, 78, 'visit', '/account?tab=withdraw', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:04:57'),
(1422, 78, 'visit', '/affiliate/how-it-works', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 12:05:04'),
(1423, 78, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:05:06'),
(1424, 78, 'visit', '/', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 12:05:20'),
(1425, 78, 'visit', '/register', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-08-31 12:05:24'),
(1426, 79, 'register', '/register', 'POST', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"account_type\":\"affiliate\",\"referral_code\":\"MERCY\"}', '2026-08-31 12:26:18'),
(1427, 79, 'login', '/login', 'POST', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', NULL, '2026-08-31 12:27:06'),
(1428, 79, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:27:08'),
(1429, 79, 'visit', '/affiliate/how-it-works', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 12:27:48'),
(1430, 79, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:28:41'),
(1431, 79, 'visit', '/affiliate/plans', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 12:28:54'),
(1432, 79, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:29:34'),
(1433, 1, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:6605629e-136a-458d-8fbb-39ec29c8b9c6', NULL, '2026-08-31 12:37:31'),
(1434, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:6605629e-136a-458d-8fbb-39ec29c8b9c6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:37:32'),
(1435, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:6605629e-136a-458d-8fbb-39ec29c8b9c6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:37:52'),
(1436, 77, 'visit', '/', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 12:53:23'),
(1437, 77, 'visit', '/affiliate/referral', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 12:53:23'),
(1438, 77, 'visit', '/login', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 12:53:28'),
(1439, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:53:29'),
(1440, 77, 'visit', '/', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 12:53:43'),
(1441, 77, 'visit', '/login', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 12:53:44'),
(1442, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 12:53:45'),
(1443, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:53:55'),
(1444, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:54:01'),
(1445, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:06'),
(1446, 77, 'visit', '/heist/40/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:10'),
(1447, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:25'),
(1448, 77, 'visit', '/heist/40/leaderboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:32'),
(1449, 77, 'visit', '/heist/40', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:40'),
(1450, 77, 'visit', '/heist/40/result', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:48'),
(1451, 77, 'visit', '/heist/40', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:52'),
(1452, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:54:57'),
(1453, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:55:05'),
(1454, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 12:55:07'),
(1455, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 12:59:33'),
(1456, 3, 'visit', '/affiliate/referral', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 13:01:40'),
(1457, 3, 'visit', '/affiliate/trade', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:02:34'),
(1458, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:05:21'),
(1459, 79, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:05:40'),
(1460, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:05:50'),
(1461, 79, 'visit', '/login', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 13:06:02'),
(1462, 79, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:06:02'),
(1463, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:06:20'),
(1464, 79, 'visit', '/profile', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:06:25'),
(1465, 79, 'visit', '/dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:06:58'),
(1466, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:07:03'),
(1467, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:07:15'),
(1468, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:07:22'),
(1469, 77, 'visit', '/heist', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:07:32'),
(1470, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:07:38'),
(1471, 79, 'visit', '/heist', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:07:55'),
(1472, 79, 'visit', '/heist/40', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:08:47'),
(1473, 78, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:12:14'),
(1474, 79, 'visit', '/heist/40/result', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:12:20'),
(1475, 78, 'visit', '/dashboard', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:12:40'),
(1476, 78, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:12:40'),
(1477, 79, 'visit', '/heist', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:13:28'),
(1478, 79, 'visit', '/dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:13:54'),
(1479, 79, 'visit', '/heist', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:14:26'),
(1480, 79, 'visit', '/heist/40/leaderboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:14:42'),
(1481, 79, 'visit', '/heist/40', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:16:19'),
(1482, 79, 'visit', '/dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:16:38'),
(1483, 3, 'visit', '/profile', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:24:13'),
(1484, 3, 'visit', '/dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:24:13'),
(1485, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:24:13'),
(1486, 3, 'visit', '/affiliate/referral', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 13:24:16'),
(1487, 77, 'visit', '/', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 13:27:27'),
(1488, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:27:27'),
(1489, 77, 'visit', '/login', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 13:27:28'),
(1490, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:27:28'),
(1491, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:27:46'),
(1492, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:29:01'),
(1493, 77, 'visit', '/winners', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Winners\"}', '2026-08-31 13:29:01'),
(1494, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:29:18'),
(1495, 77, 'visit', '/rewards', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:29:48');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1496, 77, 'visit', '/rewards', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:30:02'),
(1497, 77, 'visit', '/dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:30:14'),
(1498, 77, 'visit', '/profile', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:30:52'),
(1499, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:30:58'),
(1500, 77, 'visit', '/affiliate/referral', 'VIEW', '102.91.4.210', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 13:31:06'),
(1501, 80, 'register', '/register', 'POST', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"account_type\":\"affiliate\",\"referral_code\":\"light\"}', '2026-08-31 13:31:33'),
(1502, 80, 'login', '/login', 'POST', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', NULL, '2026-08-31 13:31:51'),
(1503, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:32:09'),
(1504, 80, 'visit', '/affiliate/how-it-works', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 13:32:38'),
(1505, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:32:51'),
(1506, 80, 'visit', '/affiliate/plans', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 13:33:00'),
(1507, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 13:34:33'),
(1508, 80, 'visit', '/profile', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:35:00'),
(1509, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:35:05'),
(1510, 80, 'visit', '/how-to-play', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-31 13:35:13'),
(1511, 80, 'visit', '/heist-demo', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:37:45'),
(1512, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:39:14'),
(1513, 80, 'visit', '/heist-demo', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:40:05'),
(1514, 80, 'visit', '/how-to-play', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-31 13:40:05'),
(1515, 80, 'visit', '/profile', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:40:19'),
(1516, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:40:22'),
(1517, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:40:25'),
(1518, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:40:58'),
(1519, 80, 'visit', '/how-to-play', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-31 13:41:01'),
(1520, 1, 'visit', '/admin/heists/promo-codes', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:6605629e-136a-458d-8fbb-39ec29c8b9c6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:41:01'),
(1521, 80, 'visit', '/heist-demo', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:41:05'),
(1522, 79, 'visit', '/dashboard', 'VIEW', '102.91.102.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:41:39'),
(1523, 80, 'visit', '/how-to-play', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-31 13:42:46'),
(1524, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:42:53'),
(1525, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:43:01'),
(1526, 80, 'visit', '/heist/41', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:43:16'),
(1527, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:43:26'),
(1528, 80, 'visit', '/heist/41', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:43:37'),
(1529, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:43:52'),
(1530, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:43:57'),
(1531, 80, 'visit', '/how-to-play', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-31 13:44:01'),
(1532, 80, 'visit', '/heist-demo', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:44:05'),
(1533, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:44:46'),
(1534, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:44:48'),
(1535, 80, 'visit', '/heist/41', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:44:54'),
(1536, 80, 'visit', '/heist/41/result', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:45:31'),
(1537, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:46:11'),
(1538, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:46:15'),
(1539, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:46:29'),
(1540, 80, 'visit', '/heist/41/leaderboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:46:43'),
(1541, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:47:38'),
(1542, 80, 'visit', '/how-to-play', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-08-31 13:48:04'),
(1543, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:48:13'),
(1544, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:48:16'),
(1545, 80, 'visit', '/heist/41/leaderboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 13:48:20'),
(1546, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:6605629e-136a-458d-8fbb-39ec29c8b9c6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 13:51:20'),
(1547, 80, 'login_failed', '/login', 'POST', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"reason\":\"bad_password\"}', '2026-08-31 15:13:45'),
(1548, NULL, 'login_failed', '/login', 'POST', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"identifier\":\"ka3918156@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-08-31 15:13:55'),
(1549, 80, 'login_failed', '/login', 'POST', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"reason\":\"bad_password\"}', '2026-08-31 15:14:19'),
(1550, 80, 'login', '/login', 'POST', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', NULL, '2026-08-31 15:14:31'),
(1551, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:14:33'),
(1552, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:17:34'),
(1553, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 15:17:47'),
(1554, 80, 'visit', '/heist/41/leaderboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 15:17:53'),
(1555, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 15:18:44'),
(1556, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:18:47'),
(1557, 80, 'visit', '/rewards', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:19:01'),
(1558, 80, 'visit', '/rewards', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:19:12'),
(1559, 80, 'visit', '/rewards', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:19:43'),
(1560, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:19:53'),
(1561, 80, 'visit', '/account', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:19:59'),
(1562, 80, 'visit', '/account?tab=withdraw', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:20:29'),
(1563, 80, 'visit', '/account?tab=topup', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:20:31'),
(1564, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8080d06d-8df2-4529-a9e1-5dced064360b', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:20:42'),
(1565, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 15:37:39'),
(1566, 80, 'visit', '/heist/41/leaderboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 15:37:58'),
(1567, 80, 'visit', '/heist', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 15:38:23'),
(1568, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:38:23'),
(1569, 80, 'visit', '/account', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:38:33'),
(1570, 80, 'visit', '/dashboard', 'VIEW', '102.89.46.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:39:16'),
(1571, 78, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 15:50:09'),
(1572, 78, 'visit', '/register', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"Create Your CopUpBid Account\"}', '2026-08-31 15:50:09'),
(1573, 78, 'visit', '/login', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 15:50:28'),
(1574, 78, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.78.201', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:c3a82d03-b305-45da-af94-44d2a986a45d', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 15:50:28'),
(1575, 81, 'register', '/register', 'POST', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"account_type\":\"affiliate\",\"referral_code\":\"MERCY\"}', '2026-08-31 16:34:00'),
(1576, 81, 'login', '/login', 'POST', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', NULL, '2026-08-31 16:34:14'),
(1577, 81, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 16:34:16'),
(1578, 81, 'visit', '/affiliate/how-it-works', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 16:34:24'),
(1579, 81, 'visit', '/affiliate/how-it-works', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 16:34:47'),
(1580, 81, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 16:34:48'),
(1581, 81, 'visit', '/affiliate/plans', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 16:34:58'),
(1582, 81, 'visit', '/affiliate/plans', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 16:35:15'),
(1583, 81, 'visit', '/affiliate/referral', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 16:36:44'),
(1584, 81, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 16:36:53'),
(1585, 81, 'visit', '/affiliate/plans', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 16:36:55'),
(1586, 81, 'visit', '/affiliate-dashboard', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 16:37:03'),
(1587, 81, 'visit', '/affiliate/referral', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 16:37:07'),
(1588, 81, 'visit', '/affiliate/referral', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 16:37:11'),
(1589, 81, 'visit', '/affiliate/how-it-works', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"How CopUpBid Affiliate Earnings Work\"}', '2026-08-31 16:37:16'),
(1590, 81, 'visit', '/affiliate/referral', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 16:37:26'),
(1591, 81, 'visit', '/affiliate/plans', 'VIEW', '105.112.106.91', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:d7dad26d-ea04-45b2-9d61-4182e2c3d135', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-08-31 16:37:28'),
(1592, 1, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:33ee2528-c004-499e-9821-f29a57e408f2', NULL, '2026-08-31 18:30:08'),
(1593, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:33ee2528-c004-499e-9821-f29a57e408f2', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:30:09'),
(1594, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:33ee2528-c004-499e-9821-f29a57e408f2', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:30:39'),
(1595, 79, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:46:09'),
(1596, 79, 'visit', '/login', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 18:46:22'),
(1597, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:46:22'),
(1598, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:46:35'),
(1599, 79, 'visit', '/heist/42', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:48:09'),
(1600, 79, 'visit', '/heist/42/result', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:49:54'),
(1601, 79, 'visit', '/rewards', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:50:50'),
(1602, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:51:49'),
(1603, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:52:25'),
(1604, 79, 'visit', '/heist/42/leaderboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:52:39'),
(1605, 79, 'visit', '/heist/42', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:53:26'),
(1606, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 18:53:49'),
(1607, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:54:03'),
(1608, 79, 'visit', '/heist/42/leaderboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:54:22'),
(1609, 79, 'visit', '/heist/42', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:54:37'),
(1610, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 18:55:57'),
(1611, 77, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.91.71.224', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 19:09:54'),
(1612, 77, 'visit', '/', 'VIEW', '102.91.71.224', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-08-31 19:10:55'),
(1613, 77, 'visit', '/affiliate/referral', 'VIEW', '102.91.71.224', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 19:10:55'),
(1614, 77, 'visit', '/login', 'VIEW', '102.91.71.224', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-08-31 19:10:58'),
(1615, 77, 'visit', '/affiliate-dashboard', 'VIEW', '102.91.71.224', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-08-31 19:11:02'),
(1616, 77, 'visit', '/affiliate/referral', 'VIEW', '102.91.71.224', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 19:11:17'),
(1617, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 19:13:34'),
(1618, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 19:13:39'),
(1619, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 19:58:39'),
(1620, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 19:58:47'),
(1621, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 20:27:13'),
(1622, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 20:27:20'),
(1623, 79, 'visit', '/heist/42/leaderboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 20:27:26'),
(1624, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 20:27:49'),
(1625, 79, 'visit', '/winners', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Winners\"}', '2026-08-31 20:27:57'),
(1626, 79, 'visit', '/dashboard', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 20:28:15'),
(1627, 79, 'visit', '/heist', 'VIEW', '102.91.5.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 20:50:31'),
(1628, 79, 'visit', '/dashboard', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 21:38:30'),
(1629, 79, 'visit', '/heist', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 21:38:37'),
(1630, 79, 'visit', '/heist/42/leaderboard', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 21:43:35'),
(1631, 3, 'visit', '/affiliate/referral', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-08-31 23:17:25'),
(1632, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:25:19'),
(1633, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:41:41'),
(1634, 80, 'visit', '/heist', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:42:06'),
(1635, 80, 'visit', '/heist/42', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:42:10'),
(1636, 80, 'visit', '/heist/42/result', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:42:39'),
(1637, 80, 'visit', '/rewards', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:42:54'),
(1638, 80, 'visit', '/heist/42/result', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:48:59'),
(1639, 80, 'visit', '/heist/42', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:09'),
(1640, 80, 'visit', '/heist', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:16'),
(1641, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:49:19'),
(1642, 80, 'visit', '/heist', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:29'),
(1643, 80, 'visit', '/heist/42/leaderboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:35'),
(1644, 80, 'visit', '/heist/42', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:43'),
(1645, 80, 'visit', '/heist/42/leaderboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:56'),
(1646, 80, 'visit', '/heist', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:56'),
(1647, 80, 'visit', '/heist/42/leaderboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:49:59');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1648, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:50:28'),
(1649, 80, 'visit', '/heist', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-08-31 23:50:36'),
(1650, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:51:58'),
(1651, 80, 'visit', '/rewards', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:52:08'),
(1652, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:52:44'),
(1653, 80, 'visit', '/account', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:53:43'),
(1654, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:54:05'),
(1655, 80, 'visit', '/affiliate-register?ref=light', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:54:34'),
(1656, 80, 'visit', '/trade', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-08-31 23:57:19'),
(1657, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-08-31 23:57:44'),
(1658, 82, 'register', '/register', 'POST', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"account_type\":\"affiliate\",\"referral_code\":\"light\"}', '2026-08-31 23:59:28'),
(1659, NULL, 'login_failed', '/login', 'POST', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"identifier\":\"magnoliagroup292@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-09-01 00:00:02'),
(1660, 82, 'login', '/login', 'POST', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', NULL, '2026-09-01 00:00:14'),
(1661, 82, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 00:00:16'),
(1662, 82, 'visit', '/affiliate/plans', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-09-01 00:00:47'),
(1663, 82, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 00:00:52'),
(1664, 82, 'visit', '/profile', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:01:09'),
(1665, 82, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:01:40'),
(1666, 82, 'visit', '/account', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:01:57'),
(1667, 82, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:42580fed-ff1c-4a86-a933-c02def7f3bd6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:02:07'),
(1668, 80, 'visit', '/account', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:02:23'),
(1669, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:02:33'),
(1670, 80, 'visit', '/trade', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-09-01 00:02:47'),
(1671, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 00:05:15'),
(1672, 80, 'visit', '/dashboard', 'VIEW', '102.89.41.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 01:17:16'),
(1673, 79, 'visit', '/dashboard', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 02:03:47'),
(1674, 79, 'visit', '/heist', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 02:03:53'),
(1675, 79, 'visit', '/my-clan', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 02:04:52'),
(1676, 79, 'visit', '/trade', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-09-01 02:05:10'),
(1677, 79, 'visit', '/my-clan', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 02:05:37'),
(1678, 79, 'visit', '/how-to-play', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-01 02:06:05'),
(1679, 79, 'visit', '/dashboard', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 02:08:10'),
(1680, 79, 'visit', '/heist', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 02:08:18'),
(1681, 79, 'visit', '/dashboard', 'VIEW', '102.91.103.27', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 02:08:47'),
(1682, 79, 'visit', '/dashboard', 'VIEW', '102.91.4.104', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 10:09:54'),
(1683, 77, 'visit', '/', 'VIEW', '197.210.70.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-09-01 10:43:17'),
(1684, 77, 'visit', '/login', 'VIEW', '197.210.70.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"Login to CopUpBid\"}', '2026-09-01 10:43:19'),
(1685, 77, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.70.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 10:43:20'),
(1686, 77, 'visit', '/affiliate/referral', 'VIEW', '197.210.70.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-09-01 10:43:30'),
(1687, 77, 'visit', '/affiliate-dashboard', 'VIEW', '197.210.70.81', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bb9b1b44-c937-4d3f-bb5d-0cb26505b85e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 10:43:53'),
(1688, 80, 'visit', '/dashboard', 'VIEW', '102.88.112.81', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 11:32:06'),
(1689, 3, 'visit', '/', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-09-01 12:10:55'),
(1690, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 12:10:57'),
(1691, 3, 'visit', '/affiliate/plans', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Tile Earnings\"}', '2026-09-01 12:10:58'),
(1692, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 12:11:00'),
(1693, 3, 'visit', '/account', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 12:11:10'),
(1694, 3, 'visit', '/account?tab=withdraw', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 12:11:11'),
(1695, 1, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:422cdabe-1044-4a82-b83c-4ba2f3713706', NULL, '2026-09-01 12:14:31'),
(1696, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:422cdabe-1044-4a82-b83c-4ba2f3713706', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 12:14:32'),
(1697, 1, 'visit', '/admin/transactions', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:422cdabe-1044-4a82-b83c-4ba2f3713706', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 12:14:38'),
(1698, 3, 'visit', '/account?tab=withdraw', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 12:16:02'),
(1699, 1, 'login_failed', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"reason\":\"bad_password\"}', '2026-09-01 14:04:38'),
(1700, 1, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', NULL, '2026-09-01 14:05:18'),
(1701, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:05:20'),
(1702, 1, 'visit', '/admin/transactions', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:04'),
(1703, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:10'),
(1704, 1, 'visit', '/admin/analytics', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:15'),
(1705, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:19'),
(1706, 1, 'visit', '/admin/transactions', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:20'),
(1707, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:26'),
(1708, 1, 'visit', '/admin/receipts', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:06:40'),
(1709, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:07:37'),
(1710, 1, 'visit', '/admin/god-eyes', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:07:41'),
(1711, 1, 'visit', '/admin/receipts', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:09:51'),
(1712, 80, 'login', '/login', 'POST', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', NULL, '2026-09-01 14:16:34'),
(1713, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:16:37'),
(1714, 80, 'visit', '/', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-09-01 14:17:10'),
(1715, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:17:11'),
(1716, 80, 'visit', '/how-to-play', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-01 14:17:22'),
(1717, 80, 'visit', '/profile', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:17:24'),
(1718, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 14:17:32'),
(1719, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:17:32'),
(1720, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:19:19'),
(1721, 80, 'visit', '/heist', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:19:21'),
(1722, 80, 'visit', '/heist/42/leaderboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:19:28'),
(1723, 1, 'login', '/login', 'POST', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8ff4a375-147c-4c4b-9c40-9f10a9775afb', NULL, '2026-09-01 14:19:50'),
(1724, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8ff4a375-147c-4c4b-9c40-9f10a9775afb', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:19:51'),
(1725, 1, 'visit', '/admin/heists', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8ff4a375-147c-4c4b-9c40-9f10a9775afb', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:19:57'),
(1726, 80, 'visit', '/heist', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:20:29'),
(1727, 1, 'visit', '/admin-dashboard', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:8ff4a375-147c-4c4b-9c40-9f10a9775afb', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:20:37'),
(1728, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:21:19'),
(1729, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-01 14:21:19'),
(1730, 80, 'visit', '/profile', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:21:40'),
(1731, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:21:52'),
(1732, 80, 'visit', '/heist', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:21:55'),
(1733, 80, 'visit', '/heist/43', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:22:01'),
(1734, 80, 'visit', '/heist/43/result', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:22:32'),
(1735, 80, 'visit', '/heist', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:22:51'),
(1736, 80, 'visit', '/heist/43/result', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:22:59'),
(1737, 80, 'visit', '/heist/43', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:23:00'),
(1738, 80, 'visit', '/heist', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:23:02'),
(1739, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:23:16'),
(1740, 80, 'visit', '/heist', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 14:23:21'),
(1741, 80, 'visit', '/dashboard', 'VIEW', '102.88.110.132', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.5 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:cd7f65d9-8abd-478d-a727-47640a451fee', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:23:26'),
(1742, 1, 'visit', '/admin/receipts', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:25:38'),
(1743, 1, 'visit', '/admin/receipts', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 14:25:38'),
(1744, 3, 'visit', '/account?tab=withdraw', 'VIEW', '102.89.45.123', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 17:42:32'),
(1745, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 23:49:12'),
(1746, 80, 'visit', '/heist', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 23:49:27'),
(1747, 80, 'visit', '/heist/43/leaderboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 23:49:34'),
(1748, 80, 'visit', '/heist/43', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-01 23:49:48'),
(1749, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 23:49:58'),
(1750, 80, 'visit', '/how-to-play', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-01 23:50:10'),
(1751, 80, 'visit', '/heist-demo', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 23:50:14'),
(1752, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-01 23:53:24'),
(1753, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 00:47:19'),
(1754, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:11:07'),
(1755, 80, 'visit', '/heist', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:11:16'),
(1756, 80, 'visit', '/heist/43/leaderboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:11:20'),
(1757, 80, 'visit', '/heist/43', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:11:35'),
(1758, 80, 'visit', '/heist/43/leaderboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:11:37'),
(1759, 80, 'visit', '/heist', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:11:38'),
(1760, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:11:41'),
(1761, 80, 'visit', '/trade', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-09-02 02:11:52'),
(1762, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:11:57'),
(1763, 80, 'visit', '/account', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:12:00'),
(1764, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:12:19'),
(1765, 80, 'visit', '/trade', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-09-02 02:12:23'),
(1766, 82, 'login', '/login', 'POST', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', NULL, '2026-09-02 02:14:48'),
(1767, 82, 'visit', '/trade', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-09-02 02:14:50'),
(1768, 82, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:16:14'),
(1769, 82, 'visit', '/heist', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:16:24'),
(1770, 82, 'visit', '/heist/43', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:16:31'),
(1771, 82, 'visit', '/heist', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:17:06'),
(1772, 82, 'visit', '/heist/43', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:17:12'),
(1773, 82, 'visit', '/heist/43/result', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 02:17:26'),
(1774, 82, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:18:47'),
(1775, 82, 'visit', '/winners', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid Winners\"}', '2026-09-02 02:18:55'),
(1776, 82, 'visit', '/clans', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:20:24'),
(1777, 82, 'visit', '/clans/2', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:20:32'),
(1778, 82, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 OPR/135.0.0.0', 'web:Win32:1366x768:Europe/London:845d6a28-8c04-4746-a689-f0b9b61143e6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:21:06'),
(1779, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:21:30'),
(1780, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:21:43'),
(1781, 80, 'visit', '/rewards', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:22:00'),
(1782, 80, 'visit', '/dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:22:20'),
(1783, 80, 'visit', '/profile', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:22:47'),
(1784, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-02 02:23:46'),
(1785, 80, 'visit', '/affiliate/referral', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-09-02 02:24:02'),
(1786, 80, 'visit', '/affiliate-register?ref=light', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 02:40:48'),
(1787, 80, 'visit', '/affiliate/referral', 'VIEW', '102.89.32.146', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-09-02 02:41:02'),
(1788, 80, 'visit', '/affiliate-dashboard', 'VIEW', '102.88.111.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-02 11:03:00'),
(1789, 80, 'visit', '/profile', 'VIEW', '102.88.111.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 11:03:10'),
(1790, 80, 'visit', '/dashboard', 'VIEW', '102.88.111.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 11:03:14'),
(1791, 80, 'visit', '/winners', 'VIEW', '102.88.111.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid Winners\"}', '2026-09-02 11:03:37'),
(1792, 80, 'visit', '/dashboard', 'VIEW', '102.88.111.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 11:04:11'),
(1793, 79, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:48:23'),
(1794, 79, 'visit', '/login', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"Login to CopUpBid\"}', '2026-09-02 19:48:42'),
(1795, 79, 'visit', '/dashboard', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:48:42');
INSERT INTO `user_activity_events` (`id`, `user_id`, `event_type`, `path`, `method`, `ip_address`, `user_agent`, `device_key`, `metadata`, `created_at`) VALUES
(1796, 79, 'visit', '/heist', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:49:08'),
(1797, 79, 'visit', '/heist/43', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:51:39'),
(1798, 79, 'visit', '/heist/43/result', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:55:10'),
(1799, 79, 'visit', '/rewards', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:55:47'),
(1800, 79, 'visit', '/dashboard', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:56:56'),
(1801, 79, 'visit', '/heist', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:57:05'),
(1802, 79, 'visit', '/heist/43/leaderboard', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:57:11'),
(1803, 79, 'visit', '/heist/43', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:57:49'),
(1804, 79, 'visit', '/rewards', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:58:31'),
(1805, 79, 'visit', '/dashboard', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:58:58'),
(1806, 79, 'visit', '/heist', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:59:31'),
(1807, 79, 'visit', '/dashboard', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:59:36'),
(1808, 79, 'visit', '/rewards', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-02 19:59:38'),
(1809, 79, 'visit', '/heist/43', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:59:39'),
(1810, 79, 'visit', '/heist/43/leaderboard', 'VIEW', '102.89.46.152', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-02 19:59:43'),
(1811, 80, 'visit', '/dashboard', 'VIEW', '102.88.109.80', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'web:Win32:1366x768:Europe/London:473579d8-d0bd-4a14-8790-1a22bf7a9613', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-03 00:47:03'),
(1812, 79, 'visit', '/heist/43/leaderboard', 'VIEW', '197.210.8.71', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-03 09:26:37'),
(1813, 79, 'visit', '/affiliate-register?ref=MERCY', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-05 06:44:36'),
(1814, 79, 'visit', '/login', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"Login to CopUpBid\"}', '2026-09-05 06:44:38'),
(1815, 79, 'visit', '/dashboard', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-05 06:44:39'),
(1816, 79, 'visit', '/heist', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-05 06:45:10'),
(1817, 79, 'visit', '/heist/43/leaderboard', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-05 06:46:14'),
(1818, 79, 'visit', '/heist/43', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-05 06:46:45'),
(1819, 79, 'visit', '/dashboard', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-05 06:47:07'),
(1820, 79, 'visit', '/heist', 'VIEW', '102.91.103.220', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x812:Africa/Lagos:7be8eaa3-3484-414c-8817-c214e645543a', '{\"title\":\"CopUpBid Heists\"}', '2026-09-05 06:47:13'),
(1821, 2, 'login', '/login', 'POST', '105.127.15.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', NULL, '2026-09-05 11:06:32'),
(1822, 2, 'visit', '/winners', 'VIEW', '105.127.15.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-09-05 11:06:34'),
(1823, 2, 'visit', '/levels', 'VIEW', '105.127.15.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-05 11:07:04'),
(1824, 2, 'visit', '/heist', 'VIEW', '105.127.15.38', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-09-05 11:07:15'),
(1825, 2, 'visit', '/heist', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-09-06 18:50:35'),
(1826, 2, 'visit', '/dashboard', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 18:50:45'),
(1827, 2, 'visit', '/winners', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Winners\"}', '2026-09-06 18:51:09'),
(1828, 2, 'visit', '/dashboard', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 18:51:09'),
(1829, 2, 'visit', '/rewards', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 18:51:11'),
(1830, 2, 'visit', '/heist', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid Heists\"}', '2026-09-06 18:51:42'),
(1831, 2, 'visit', '/how-to-play', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-06 18:52:15'),
(1832, 2, 'visit', '/how-to-play', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-06 20:05:46'),
(1833, 2, 'visit', '/dashboard', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 20:05:56'),
(1834, 2, 'visit', '/account', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 20:05:59'),
(1835, 2, 'visit', '/account?tab=withdraw', 'VIEW', '105.112.199.19', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', 'web:Linux armv81:360x800:Africa/Lagos:bccfd374-757d-4d97-afed-23dd562ad207', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 20:06:03'),
(1836, 1, 'login', '/login', 'POST', '102.88.111.226', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:0f843f8e-7e01-4795-851a-dab56355db7f', NULL, '2026-09-06 20:08:35'),
(1837, 1, 'visit', '/admin-dashboard', 'VIEW', '102.88.111.226', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:0f843f8e-7e01-4795-851a-dab56355db7f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 20:08:36'),
(1838, 1, 'visit', '/admin/transactions', 'VIEW', '102.88.111.226', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:0f843f8e-7e01-4795-851a-dab56355db7f', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-06 20:09:34'),
(1839, NULL, 'login_failed', '/login', 'POST', '185.220.101.30', '\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36\"', 'web:Linux x86_64:1920x1080:Europe/Moscow:624c9888-4a67-4712-a329-e795b90e3454', '{\"identifier\":\"i.xe.re.w.o.k.86.1@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-09-11 23:32:38'),
(1840, NULL, 'login_failed', '/login', 'POST', '185.220.101.30', '\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36\"', 'web:Linux x86_64:1920x1080:Europe/Moscow:624c9888-4a67-4712-a329-e795b90e3454', '{\"identifier\":\"i.xe.re.w.o.k.86.1@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-09-11 23:32:41'),
(1841, NULL, 'login_failed', '/login', 'POST', '185.220.101.30', '\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36\"', 'web:Linux x86_64:1920x1080:Europe/Moscow:624c9888-4a67-4712-a329-e795b90e3454', '{\"identifier\":\"i.xe.re.w.o.k.86.1@gmail.com\",\"reason\":\"not_found_or_unverified\"}', '2026-09-11 23:32:46'),
(1842, 3, 'login', '/login', 'POST', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', NULL, '2026-09-12 13:51:19'),
(1843, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-12 13:51:21'),
(1844, 3, 'visit', '/affiliate/referral', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid Referral Tools\"}', '2026-09-12 13:51:37'),
(1845, 83, 'register', '/register', 'POST', '185.26.181.66', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"account_type\":\"affiliate\",\"referral_code\":\"light\"}', '2026-09-12 14:00:00'),
(1846, 83, 'login_failed', '/login', 'POST', '185.26.181.66', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"reason\":\"bad_password\"}', '2026-09-12 14:00:31'),
(1847, 83, 'login', '/login', 'POST', '185.26.181.66', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', NULL, '2026-09-12 14:00:34'),
(1848, 83, 'visit', '/affiliate-dashboard', 'VIEW', '185.26.181.66', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-12 14:00:38'),
(1849, 3, 'visit', '/affiliate-dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-12 14:05:15'),
(1850, 3, 'visit', '/profile', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 14:05:18'),
(1851, 3, 'visit', '/dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 14:05:25'),
(1852, 3, 'visit', '/winners', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid Winners\"}', '2026-09-12 14:05:26'),
(1853, 3, 'visit', '/dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 14:05:30'),
(1854, 3, 'visit', '/how-to-play', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:175d80c2-5011-4fda-acf7-68410430de0c', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 14:05:36'),
(1855, 3, 'login', '/login', 'POST', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:d6c1c1bf-407d-4d8f-aa79-f232ede03cca', NULL, '2026-09-12 14:06:59'),
(1856, 3, 'visit', '/how-to-play', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:d6c1c1bf-407d-4d8f-aa79-f232ede03cca', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 14:07:01'),
(1857, 83, 'visit', '/how-to-play', 'VIEW', '82.145.210.236', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:28:53'),
(1858, 83, 'visit', '/account', 'VIEW', '82.145.212.197', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:29:17'),
(1859, 83, 'visit', '/dashboard', 'VIEW', '82.145.210.236', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:30:06'),
(1860, 83, 'visit', '/affiliate-dashboard', 'VIEW', '82.145.212.197', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid Affiliate Dashboard\"}', '2026-09-12 15:30:06'),
(1861, 83, 'visit', '/account', 'VIEW', '82.145.210.236', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:30:21'),
(1862, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.122', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:39:43'),
(1863, 83, 'visit', '/heist-demo', 'VIEW', '82.145.210.100', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:40:48'),
(1864, 1, 'login', '/login', 'POST', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', NULL, '2026-09-12 15:43:08'),
(1865, 1, 'visit', '/admin-dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:43:09'),
(1866, 1, 'visit', '/admin/transactions', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:44:34'),
(1867, 1, 'visit', '/admin-dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:44:55'),
(1868, 1, 'visit', '/admin/users', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:44:59'),
(1869, 1, 'visit', '/admin-dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:45:14'),
(1870, 1, 'visit', '/admin/users', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:45:16'),
(1871, 1, 'visit', '/admin/heists', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1', 'web:iPhone:414x896:Africa/Lagos:25f755e7-d759-4d8a-88f8-c7e5d0301ab6', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:45:33'),
(1872, 3, 'login', '/login', 'POST', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', NULL, '2026-09-12 15:47:14'),
(1873, 3, 'visit', '/dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:47:15'),
(1874, 3, 'visit', '/heist', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:47:25'),
(1875, 3, 'visit', '/heist/43', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:47:28'),
(1876, 83, 'visit', '/how-to-play', 'VIEW', '141.0.12.54', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:48:20'),
(1877, 3, 'visit', '/heist/43/result', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:48:20'),
(1878, 3, 'visit', '/rewards', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:48:24'),
(1879, 83, 'visit', '/heist-demo', 'VIEW', '141.0.12.54', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:48:33'),
(1880, 83, 'visit', '/how-to-play', 'VIEW', '141.0.12.54', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:48:39'),
(1881, 3, 'visit', '/dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:48:50'),
(1882, 3, 'visit', '/heist', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:48:53'),
(1883, 3, 'visit', '/heist/43/leaderboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:49:05'),
(1884, 3, 'visit', '/heist/43', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:49:23'),
(1885, 3, 'visit', '/heist', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:49:26'),
(1886, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.43', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:49:59'),
(1887, 83, 'visit', '/heist-demo', 'VIEW', '185.26.181.43', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:50:03'),
(1888, 83, 'visit', '/heist', 'VIEW', '185.26.181.43', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:50:36'),
(1889, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.43', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:51:09'),
(1890, 83, 'visit', '/heist-demo', 'VIEW', '185.26.181.43', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:51:15'),
(1891, 3, 'visit', '/heist', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 15:51:28'),
(1892, 83, 'visit', '/account', 'VIEW', '185.26.181.43', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:52:05'),
(1893, 3, 'visit', '/winners', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid Winners\"}', '2026-09-12 15:52:15'),
(1894, 3, 'visit', '/dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:53:33'),
(1895, 83, 'visit', '/account', 'VIEW', '141.0.13.64', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 15:58:04'),
(1896, 83, 'visit', '/how-to-play', 'VIEW', '141.0.13.64', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 15:58:04'),
(1897, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.90', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 16:00:38'),
(1898, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.90', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 16:00:39'),
(1899, 83, 'visit', '/heist', 'VIEW', '185.26.181.87', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid Heists\"}', '2026-09-12 16:01:11'),
(1900, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.87', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 16:01:51'),
(1901, 83, 'visit', '/how-to-play', 'VIEW', '185.26.181.87', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"How to Play on CopUpBid\"}', '2026-09-12 16:01:56'),
(1902, 83, 'visit', '/account', 'VIEW', '185.26.181.87', 'Mozilla/5.0 (Linux; U; Android 12; Infinix X6516 Build/SP1A.210812.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.200 Mobile Safari/537.36 OPR/99.5.2254.2012', 'web:Linux armv8l:360x806:Africa/Lagos:a388dcd8-0ea3-47a4-9f95-ae4cf47c9849', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 16:02:32'),
(1903, 3, 'visit', '/dashboard', 'VIEW', '102.88.114.174', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/152.0.7977.53 Mobile/15E148 Safari/604.1', 'web:iPhone:393x852:Africa/Lagos:689365cd-0d19-4752-a2d3-2e3b5711f38e', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 16:14:31'),
(1904, 3, 'login_failed', '/login', 'POST', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"reason\":\"bad_password\"}', '2026-09-12 22:29:58'),
(1905, 3, 'login', '/login', 'POST', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', NULL, '2026-09-12 22:30:09'),
(1906, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 22:30:21'),
(1907, 3, 'visit', '/', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-09-12 22:30:39'),
(1908, 3, 'visit', '/', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-09-12 22:30:39'),
(1909, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 22:30:48'),
(1910, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 22:31:02'),
(1911, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 22:31:03'),
(1912, 3, 'visit', '/orders', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:29:57'),
(1913, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:29:59'),
(1914, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:31:20'),
(1915, 3, 'visit', '/orders', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:31:20'),
(1916, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:32:10'),
(1917, 3, 'visit', '/dashboard', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:32:11'),
(1918, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:33:53'),
(1919, 3, 'visit', '/', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Where Deals Meet Dreams\"}', '2026-09-12 23:33:56'),
(1920, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:34:01'),
(1921, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:35:05'),
(1922, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:35:05'),
(1923, 3, 'visit', '/orders', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:37:39'),
(1924, 3, 'visit', '/rewards', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:39:01'),
(1925, 3, 'visit', '/levels', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:39:15'),
(1926, 3, 'visit', '/xp-activity', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:39:25'),
(1927, 3, 'visit', '/trade', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"Trade CopUpCoin on CopUpBid\"}', '2026-09-12 23:40:51'),
(1928, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:40:53'),
(1929, 3, 'visit', '/winners', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid Winners\"}', '2026-09-12 23:41:03'),
(1930, 3, 'visit', '/cart', 'VIEW', '102.89.46.111', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'web:MacIntel:1440x900:America/Los_Angeles:81790622-b28d-4e54-a803-7f1971fb2572', '{\"title\":\"CopUpBid - Bid, Win, Trade, and Earn CopUpCoin\"}', '2026-09-12 23:42:44');

-- --------------------------------------------------------

--
-- Table structure for table `user_copup_jr_balances`
--

CREATE TABLE `user_copup_jr_balances` (
  `user_id` int(11) NOT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_copup_jr_balances`
--

INSERT INTO `user_copup_jr_balances` (`user_id`, `balance`, `updated_at`) VALUES
(2, 0, '2026-06-17 08:45:25'),
(3, 10, '2026-09-12 15:48:44'),
(4, 0, '2026-06-06 13:30:58'),
(8, 0, '2026-06-06 16:41:03'),
(17, 0, '2026-06-06 14:14:06'),
(59, 0, '2026-06-06 14:19:57'),
(61, 0, '2026-06-06 16:47:28'),
(67, 0, '2026-06-06 18:36:18'),
(69, 0, '2026-07-01 08:18:09'),
(70, 0, '2026-07-01 12:36:25'),
(71, 0, '2026-07-01 12:35:03'),
(72, 0, '2026-08-14 12:46:15'),
(74, 0, '2026-08-14 08:35:25'),
(76, 8, '2026-08-31 01:38:05'),
(77, 0, '2026-08-31 09:57:40'),
(79, 0, '2026-08-31 13:08:46'),
(80, 8, '2026-09-01 14:22:00'),
(82, 0, '2026-09-02 02:16:30');

-- --------------------------------------------------------

--
-- Table structure for table `user_copup_jr_ledger`
--

CREATE TABLE `user_copup_jr_ledger` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `promo_code_id` bigint(20) UNSIGNED DEFAULT NULL,
  `redemption_id` bigint(20) UNSIGNED DEFAULT NULL,
  `heist_id` int(11) DEFAULT NULL,
  `direction` enum('credit','debit') NOT NULL,
  `amount` int(11) NOT NULL,
  `balance_after` int(11) NOT NULL,
  `reason` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_copup_jr_ledger`
--

INSERT INTO `user_copup_jr_ledger` (`id`, `user_id`, `promo_code_id`, `redemption_id`, `heist_id`, `direction`, `amount`, `balance_after`, `reason`, `created_at`) VALUES
(1, 2, 1, 1, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 12:23:45'),
(2, 4, 1, 2, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 13:30:52'),
(3, 4, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-06 13:30:58'),
(4, 17, 1, 3, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 14:13:33'),
(5, 17, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-06 14:14:06'),
(6, 59, 1, 4, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 14:19:52'),
(7, 59, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-06 14:19:57'),
(8, 8, 1, 5, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 16:40:58'),
(9, 8, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-06 16:41:03'),
(12, 61, 1, 7, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 16:47:24'),
(13, 61, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-06 16:47:28'),
(24, 67, 1, 13, NULL, 'credit', 5, 5, 'promo_redeem', '2026-06-06 18:36:15'),
(25, 67, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-06 18:36:18'),
(26, 2, NULL, NULL, 28, 'debit', 5, 0, 'heist_join', '2026-06-17 08:45:25'),
(27, 76, NULL, NULL, NULL, 'credit', 10, 10, 'level_reward_redeem', '2026-08-31 01:25:35'),
(28, 76, NULL, NULL, 38, 'debit', 2, 8, 'heist_join', '2026-08-31 01:38:05'),
(29, 80, 2, 14, NULL, 'credit', 2, 2, 'promo_redeem', '2026-08-31 13:43:09'),
(30, 80, NULL, NULL, 41, 'debit', 2, 0, 'heist_join', '2026-08-31 13:43:14'),
(31, 80, NULL, NULL, NULL, 'credit', 10, 10, 'level_reward_redeem', '2026-08-31 23:52:22'),
(32, 80, NULL, NULL, 43, 'debit', 2, 8, 'heist_join', '2026-09-01 14:22:00'),
(33, 3, NULL, NULL, NULL, 'credit', 10, 10, 'level_reward_redeem', '2026-09-12 15:48:44');

-- --------------------------------------------------------

--
-- Table structure for table `user_delivery_addresses`
--

CREATE TABLE `user_delivery_addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `phone_number` varchar(32) NOT NULL,
  `detailed_address` varchar(1000) NOT NULL,
  `state` varchar(80) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `location_accuracy` decimal(10,2) DEFAULT NULL,
  `location_captured_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_level_rewards`
--

CREATE TABLE `user_level_rewards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `level_definition_id` int(11) NOT NULL,
  `code` varchar(80) NOT NULL,
  `copup_jr_amount` int(11) NOT NULL DEFAULT 0,
  `status` enum('earned','claimed','redeemed','expired') NOT NULL DEFAULT 'earned',
  `earned_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `claimed_at` datetime DEFAULT NULL,
  `redeemed_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_level_rewards`
--

INSERT INTO `user_level_rewards` (`id`, `user_id`, `level_definition_id`, `code`, `copup_jr_amount`, `status`, `earned_at`, `claimed_at`, `redeemed_at`, `expires_at`, `metadata`) VALUES
(1, 76, 4, 'LVL2-76-Q2KBSP56', 10, 'redeemed', '2026-08-31 01:21:08', '2026-08-30 21:25:20', '2026-08-30 21:25:35', NULL, '{\"reason\":\"level_up\"}'),
(2, 77, 4, 'LVL2-77-9SECF4XA', 10, 'earned', '2026-08-31 10:00:29', NULL, NULL, NULL, '{\"reason\":\"level_up\"}'),
(3, 77, 3, 'LVL3-77-EDRTSJXB', 15, 'earned', '2026-08-31 10:05:31', NULL, NULL, NULL, '{\"reason\":\"level_up\"}'),
(4, 3, 4, 'LVL2-3-SCNH9X6T', 10, 'redeemed', '2026-08-31 10:58:37', '2026-09-12 11:48:29', '2026-09-12 11:48:44', NULL, '{\"reason\":\"level_up\"}'),
(5, 79, 4, 'LVL2-79-HDP5HNSP', 10, 'claimed', '2026-08-31 13:22:45', '2026-09-02 15:56:04', NULL, NULL, '{\"reason\":\"level_up\"}'),
(6, 80, 4, 'LVL2-80-PW39HR5E', 10, 'redeemed', '2026-08-31 18:30:49', '2026-08-31 19:42:57', '2026-08-31 19:52:22', NULL, '{\"reason\":\"level_up\"}'),
(7, 79, 3, 'LVL3-79-F4F9X2GH', 15, 'claimed', '2026-09-01 14:20:09', '2026-09-02 15:56:07', NULL, NULL, '{\"reason\":\"level_up\"}');

-- --------------------------------------------------------

--
-- Table structure for table `user_notices`
--

CREATE TABLE `user_notices` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(64) NOT NULL DEFAULT 'admin_notice',
  `title` varchar(160) NOT NULL,
  `message` text NOT NULL,
  `path` varchar(255) DEFAULT '/dashboard',
  `priority` enum('normal','important') NOT NULL DEFAULT 'important',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_notices`
--

INSERT INTO `user_notices` (`id`, `user_id`, `type`, `title`, `message`, `path`, `priority`, `created_by`, `created_at`) VALUES
(1, 5, 'admin_notice', 'Alert check', 'Alert DbillionneJay', '/dashboard', 'important', 1, '2026-05-15 14:57:40'),
(2, 2, 'Greettings', 'Good day ?', 'Let farm some funds ? today ?', '/dashboard', 'normal', 1, '2026-05-21 10:45:02'),
(3, 2, 'admin_notice', 'Hello jnr', 'Let farm let win', '/dashboard', 'important', 1, '2026-05-21 10:48:37'),
(4, 4, 'admin_notice', 'Alert', 'Let test if you are a winner ??', '/dashboard', 'important', 1, '2026-05-21 10:50:00'),
(5, 4, 'admin_notice', 'Hello world', 'coplwnYe2DDW5NynK6NxJB3', '/dashboard', 'important', 1, '2026-05-21 10:50:50'),
(6, 4, 'admin_notice', 'Hello', 'https://copupbid.top/dashboard', '/dashboard', 'important', 1, '2026-05-21 10:51:45'),
(7, 3, 'affiliate_payout', 'Affiliate payout paid', '1 CopUpCoin was added for April 2026 Tile earnings.', '/affiliate-dashboard', 'important', NULL, '2026-05-22 13:11:58'),
(8, 8, 'admin_notice', '?? Account Alert', 'Our system has detected suspicious activity linked to multiple accounts attempting to abuse the Gift Coin and Heist system.\n\nTo ensure fairness for all users, your account has been flagged for review. During this period, certain features may be temporarily restricted.\n\nIf you believe this was flagged in error, please contact support for assistance.\n\nThank you for helping keep CopUpBid fair and secure.', '/dashboard', 'important', 1, '2026-06-06 18:30:23'),
(10, 2, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(11, 3, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(12, 4, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(13, 5, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(14, 8, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(15, 9, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(16, 10, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(17, 11, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(18, 12, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(19, 13, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(20, 14, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(21, 15, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(22, 16, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(23, 17, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(24, 18, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(25, 19, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(26, 20, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(27, 21, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(28, 22, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(29, 23, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(30, 24, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(31, 25, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(32, 26, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(33, 27, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(34, 28, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(35, 29, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(36, 30, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(37, 31, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(38, 32, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(39, 33, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(40, 34, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(41, 35, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(42, 36, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(43, 37, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(44, 38, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(45, 39, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(46, 40, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(47, 41, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(48, 42, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(49, 43, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(50, 44, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(51, 45, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(52, 46, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(53, 47, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(54, 48, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(55, 49, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(56, 50, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(57, 51, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(58, 52, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(59, 56, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(60, 58, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(61, 59, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(62, 61, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(63, 67, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(64, 68, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(65, 69, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(66, 70, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(67, 71, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(68, 72, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(69, 73, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(70, 74, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(71, 75, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(72, 76, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(73, 77, 'Copupbid update', 'New update.', 'The leveling up system is now available.', '/dashboard', 'important', 1, '2026-08-31 10:42:16'),
(74, 3, 'affiliate_payout', 'Affiliate payout paid', '4 CopUpCoin was added for August 2026 Tile earnings.', '/affiliate-dashboard', 'important', NULL, '2026-09-01 10:43:21');

-- --------------------------------------------------------

--
-- Table structure for table `user_xp_events`
--

CREATE TABLE `user_xp_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `source` varchar(40) NOT NULL,
  `source_id` varchar(120) NOT NULL,
  `xp_amount` int(11) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_xp_events`
--

INSERT INTO `user_xp_events` (`id`, `user_id`, `source`, `source_id`, `xp_amount`, `metadata`, `created_by`, `created_at`) VALUES
(1, 3, 'daily_login', '2026-08-30', 10, '{\"path\":\"/login\",\"rule_label\":\"Daily login\"}', NULL, '2026-08-30 23:22:24'),
(2, 76, 'daily_login', '2026-08-30', 10, '{\"path\":\"/login\",\"rule_label\":\"Daily login\"}', NULL, '2026-08-30 23:37:51'),
(5, 76, 'heist_play', 'submission:108', 15, '{\"heist_id\":37,\"correct_count\":4,\"score_percent\":80,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 01:17:58'),
(6, 3, 'heist_play', 'submission:109', 15, '{\"heist_id\":37,\"correct_count\":4,\"score_percent\":80,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 01:18:19'),
(7, 76, 'heist_win', 'heist:37', 100, '{\"heist_id\":37,\"prize_cop_points\":3,\"submission_id\":\"108\",\"rule_label\":\"Win a heist\"}', NULL, '2026-08-31 01:21:08'),
(8, 76, 'withdrawal', 'payout:30', 1, '{\"cop_points\":3,\"amount_ngn\":\"270.00\",\"rule_label\":\"Completed withdrawal\"}', 1, '2026-08-31 01:23:40'),
(9, 76, 'heist_play', 'submission:110', 15, '{\"heist_id\":38,\"correct_count\":3,\"score_percent\":60,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 01:38:58'),
(10, 3, 'heist_play', 'submission:111', 15, '{\"heist_id\":38,\"correct_count\":4,\"score_percent\":80,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 01:39:14'),
(11, 3, 'daily_login', '2026-08-31', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-08-31 09:42:25'),
(12, 77, 'heist_play', 'submission:112', 15, '{\"heist_id\":38,\"correct_count\":5,\"score_percent\":100,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 09:58:54'),
(13, 77, 'heist_win', 'heist:38', 100, '{\"heist_id\":38,\"prize_cop_points\":5,\"submission_id\":\"112\",\"rule_label\":\"Win a heist\"}', NULL, '2026-08-31 10:00:29'),
(14, 77, 'heist_play', 'submission:113', 15, '{\"heist_id\":39,\"correct_count\":4,\"score_percent\":80,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 10:03:01'),
(15, 77, 'heist_win', 'heist:39', 100, '{\"heist_id\":39,\"prize_cop_points\":5,\"submission_id\":\"113\",\"rule_label\":\"Win a heist\"}', NULL, '2026-08-31 10:05:31'),
(16, 77, 'withdrawal', 'payout:31', 1, '{\"cop_points\":6,\"amount_ngn\":\"540.00\",\"rule_label\":\"Completed withdrawal\"}', 1, '2026-08-31 10:14:00'),
(17, 3, 'withdrawal', 'payout:32', 1, '{\"cop_points\":12,\"amount_ngn\":\"1080.00\",\"rule_label\":\"Completed withdrawal\"}', 1, '2026-08-31 10:18:41'),
(18, 77, 'heist_play', 'submission:114', 15, '{\"heist_id\":40,\"correct_count\":3,\"score_percent\":60,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 10:48:00'),
(19, 3, 'referral_signup', 'referral:59', 50, '{\"referred_user_id\":77,\"joined_heists\":3,\"awarded_cop_points\":1,\"rule_label\":\"Referral signup\"}', NULL, '2026-08-31 10:58:37'),
(20, 3, 'referral_signup', 'referral:50', 50, '{\"referred_user_id\":72,\"joined_heists\":3,\"awarded_cop_points\":1,\"rule_label\":\"Referral signup\"}', NULL, '2026-08-31 10:58:41'),
(21, 2, 'daily_login', '2026-08-31', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-08-31 12:01:46'),
(22, 79, 'heist_play', 'submission:115', 15, '{\"heist_id\":40,\"correct_count\":5,\"score_percent\":100,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 13:12:20'),
(23, 79, 'heist_win', 'heist:40', 100, '{\"heist_id\":40,\"prize_cop_points\":5,\"submission_id\":\"115\",\"rule_label\":\"Win a heist\"}', NULL, '2026-08-31 13:22:45'),
(24, 80, 'daily_login', '2026-08-31', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-08-31 13:42:57'),
(25, 80, 'heist_play', 'submission:116', 15, '{\"heist_id\":41,\"correct_count\":5,\"score_percent\":100,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 13:45:29'),
(26, 80, 'heist_win', 'heist:41', 100, '{\"heist_id\":41,\"prize_cop_points\":5,\"submission_id\":\"116\",\"rule_label\":\"Win a heist\"}', NULL, '2026-08-31 18:30:49'),
(27, 79, 'heist_play', 'submission:117', 15, '{\"heist_id\":42,\"correct_count\":3,\"score_percent\":100,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 18:49:53'),
(28, 79, 'daily_login', '2026-08-31', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-08-31 18:52:01'),
(29, 80, 'heist_play', 'submission:118', 15, '{\"heist_id\":42,\"correct_count\":2,\"score_percent\":66.67,\"rule_label\":\"Play a heist\"}', NULL, '2026-08-31 23:42:37'),
(30, 82, 'daily_login', '2026-08-31', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-01 00:01:45'),
(31, 3, 'withdrawal', 'payout:33', 1, '{\"cop_points\":100,\"amount_ngn\":\"9000.00\",\"rule_label\":\"Completed withdrawal\"}', 1, '2026-09-01 12:14:52'),
(32, 80, 'daily_login', '2026-09-01', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-01 14:17:15'),
(33, 79, 'heist_win', 'heist:42', 100, '{\"heist_id\":42,\"prize_cop_points\":5,\"submission_id\":\"117\",\"rule_label\":\"Win a heist\"}', NULL, '2026-09-01 14:20:09'),
(34, 80, 'heist_play', 'submission:119', 15, '{\"heist_id\":43,\"correct_count\":3,\"score_percent\":100,\"rule_label\":\"Play a heist\"}', NULL, '2026-09-01 14:22:31'),
(35, 82, 'daily_login', '2026-09-01', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-02 02:16:17'),
(36, 82, 'heist_play', 'submission:120', 15, '{\"heist_id\":43,\"correct_count\":2,\"score_percent\":66.67,\"rule_label\":\"Play a heist\"}', NULL, '2026-09-02 02:17:25'),
(37, 80, 'daily_login', '2026-09-02', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-02 11:03:24'),
(38, 79, 'daily_login', '2026-09-02', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-02 19:48:56'),
(39, 79, 'heist_play', 'submission:121', 15, '{\"heist_id\":43,\"correct_count\":3,\"score_percent\":100,\"rule_label\":\"Play a heist\"}', NULL, '2026-09-02 19:55:08'),
(40, 79, 'daily_login', '2026-09-05', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-05 06:44:57'),
(41, 2, 'daily_login', '2026-09-06', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-06 18:50:48'),
(42, 2, 'withdrawal', 'payout:34', 1, '{\"cop_points\":50,\"amount_ngn\":\"4500.00\",\"rule_label\":\"Completed withdrawal\"}', 1, '2026-09-06 20:09:53'),
(43, 3, 'daily_login', '2026-09-12', 10, '{\"reason\":\"daily_check_in\",\"rule_label\":\"Daily check-in\"}', NULL, '2026-09-12 15:47:17'),
(44, 3, 'heist_play', 'submission:122', 15, '{\"heist_id\":43,\"correct_count\":1,\"score_percent\":33.33,\"rule_label\":\"Play a heist\"}', NULL, '2026-09-12 15:48:20');

-- --------------------------------------------------------

--
-- Table structure for table `user_xp_totals`
--

CREATE TABLE `user_xp_totals` (
  `user_id` int(11) NOT NULL,
  `total_xp` int(11) NOT NULL DEFAULT 0,
  `current_level_definition_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_xp_totals`
--

INSERT INTO `user_xp_totals` (`user_id`, `total_xp`, `current_level_definition_id`, `updated_at`) VALUES
(2, 21, 5, '2026-09-06 20:09:53'),
(3, 177, 4, '2026-09-12 15:48:20'),
(76, 141, 4, '2026-08-31 01:38:58'),
(77, 246, 3, '2026-08-31 10:48:00'),
(78, 0, NULL, '2026-08-31 11:12:19'),
(79, 275, 3, '2026-09-05 06:44:57'),
(80, 175, 4, '2026-09-02 11:03:24'),
(81, 0, NULL, '2026-08-31 16:34:15'),
(82, 35, 5, '2026-09-02 02:17:25'),
(83, 0, NULL, '2026-09-12 14:00:35');

-- --------------------------------------------------------

--
-- Table structure for table `xp_source_rules`
--

CREATE TABLE `xp_source_rules` (
  `source` varchar(40) NOT NULL,
  `xp_amount` int(11) NOT NULL DEFAULT 0,
  `label` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `xp_source_rules`
--

INSERT INTO `xp_source_rules` (`source`, `xp_amount`, `label`, `is_active`, `updated_by`, `created_at`, `updated_at`) VALUES
('admin_adjustment', 0, 'Admin adjustment', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
('daily_login', 10, 'Daily check-in', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:44:07'),
('deposit', 1, 'Completed deposit', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
('heist_play', 15, 'Play a heist', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
('heist_win', 100, 'Win a heist', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
('referral_signup', 50, 'Referral signup', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:06:05'),
('withdrawal', 1, 'Completed withdrawal', 1, NULL, '2026-08-30 23:06:05', '2026-08-30 23:06:05');

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
-- Indexes for table `affiliate_tiles`
--
ALTER TABLE `affiliate_tiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_affiliate_tiles_active` (`is_active`,`tile_level`,`required_affiliates`,`target_tickets`),
  ADD KEY `idx_affiliate_tiles_created_by` (`created_by`),
  ADD KEY `idx_affiliate_tiles_updated_by` (`updated_by`);

--
-- Indexes for table `affiliate_tile_memberships`
--
ALTER TABLE `affiliate_tile_memberships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_affiliate_tile_user_tile` (`user_id`,`tile_id`),
  ADD KEY `idx_affiliate_tile_memberships_user` (`user_id`,`status`),
  ADD KEY `idx_affiliate_tile_memberships_tile` (`tile_id`,`status`);

--
-- Indexes for table `affiliate_tile_payouts`
--
ALTER TABLE `affiliate_tile_payouts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_affiliate_tile_payout_period` (`user_id`,`tile_id`,`period_start`),
  ADD KEY `idx_affiliate_tile_payout_period` (`period_start`,`period_end`),
  ADD KEY `idx_affiliate_tile_payout_user` (`user_id`,`paid_at`),
  ADD KEY `fk_affiliate_tile_payouts_tile` (`tile_id`),
  ADD KEY `fk_affiliate_tile_payouts_paid_by` (`paid_by`);

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
-- Indexes for table `auto_heist_settings`
--
ALTER TABLE `auto_heist_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_carts_user_status` (`user_id`,`status`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_cart_entitlement` (`entitlement_id`),
  ADD KEY `idx_cart_items_cart` (`cart_id`);

--
-- Indexes for table `clans`
--
ALTER TABLE `clans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clans_name` (`name`),
  ADD UNIQUE KEY `uniq_clans_slug` (`slug`),
  ADD KEY `idx_clans_status_created` (`status`,`created_at`),
  ADD KEY `idx_clans_leader` (`leader_user_id`),
  ADD KEY `idx_clans_created_by` (`created_by`),
  ADD KEY `fk_clans_updated_by` (`updated_by`);

--
-- Indexes for table `clan_activity_events`
--
ALTER TABLE `clan_activity_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_clan_activity_clan_created` (`clan_id`,`created_at`),
  ADD KEY `idx_clan_activity_actor_created` (`actor_user_id`,`created_at`),
  ADD KEY `idx_clan_activity_type_created` (`event_type`,`created_at`),
  ADD KEY `fk_clan_activity_target` (`target_user_id`);

--
-- Indexes for table `clan_chat_messages`
--
ALTER TABLE `clan_chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_clan_chat_clan_created` (`clan_id`,`created_at`),
  ADD KEY `idx_clan_chat_user_created` (`user_id`,`created_at`);

--
-- Indexes for table `clan_coin_ledger`
--
ALTER TABLE `clan_coin_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_clan_coin_ledger_clan_created` (`clan_id`,`created_at`),
  ADD KEY `idx_clan_coin_ledger_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_clan_coin_ledger_reference` (`reference_type`,`reference_id`),
  ADD KEY `fk_clan_coin_ledger_created_by` (`created_by`);

--
-- Indexes for table `clan_invites`
--
ALTER TABLE `clan_invites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_invite` (`clan_id`,`invited_user_id`,`status`),
  ADD KEY `idx_clan_invites_user_status` (`invited_user_id`,`status`),
  ADD KEY `idx_clan_invites_clan_status` (`clan_id`,`status`,`created_at`),
  ADD KEY `fk_clan_invites_invited_by` (`invited_by`);

--
-- Indexes for table `clan_join_requests`
--
ALTER TABLE `clan_join_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_join_request` (`clan_id`,`user_id`,`status`),
  ADD KEY `idx_clan_join_requests_user_status` (`user_id`,`status`),
  ADD KEY `idx_clan_join_requests_clan_status` (`clan_id`,`status`,`created_at`),
  ADD KEY `fk_clan_join_requests_reviewed_by` (`reviewed_by`);

--
-- Indexes for table `clan_members`
--
ALTER TABLE `clan_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_members_clan_user` (`clan_id`,`user_id`),
  ADD KEY `idx_clan_members_user_status` (`user_id`,`status`),
  ADD KEY `idx_clan_members_clan_status_role` (`clan_id`,`status`,`role`),
  ADD KEY `idx_clan_members_joined_left` (`clan_id`,`joined_at`,`left_at`),
  ADD KEY `fk_clan_members_invited_by` (`invited_by`),
  ADD KEY `fk_clan_members_approved_by` (`approved_by`),
  ADD KEY `fk_clan_members_role_updated_by` (`role_updated_by`);

--
-- Indexes for table `clan_quests`
--
ALTER TABLE `clan_quests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_clan_quests_status_dates` (`status`,`starts_at`,`ends_at`),
  ADD KEY `idx_clan_quests_type_status` (`quest_type`,`status`),
  ADD KEY `idx_clan_quests_created_by` (`created_by`),
  ADD KEY `fk_clan_quests_updated_by` (`updated_by`),
  ADD KEY `fk_clan_quests_completed_by` (`completed_by`);

--
-- Indexes for table `clan_quest_heist_wins`
--
ALTER TABLE `clan_quest_heist_wins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_quest_heist_win` (`quest_id`,`heist_id`,`winner_user_id`),
  ADD KEY `idx_clan_quest_heist_wins_score` (`quest_id`,`clan_id`,`points`),
  ADD KEY `idx_clan_quest_heist_wins_user` (`winner_user_id`,`won_at`),
  ADD KEY `fk_clan_quest_heist_wins_clan` (`clan_id`),
  ADD KEY `fk_clan_quest_heist_wins_heist` (`heist_id`);

--
-- Indexes for table `clan_quest_participants`
--
ALTER TABLE `clan_quest_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_quest_participant` (`quest_id`,`clan_id`),
  ADD KEY `idx_clan_quest_participants_clan_status` (`clan_id`,`status`),
  ADD KEY `idx_clan_quest_participants_quest_status` (`quest_id`,`status`),
  ADD KEY `fk_clan_quest_participants_joined_by` (`joined_by`);

--
-- Indexes for table `clan_quest_rewards`
--
ALTER TABLE `clan_quest_rewards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_quest_reward` (`quest_id`),
  ADD KEY `idx_clan_quest_rewards_clan_status` (`winning_clan_id`,`status`),
  ADD KEY `fk_clan_quest_rewards_distributed_by` (`distributed_by`);

--
-- Indexes for table `clan_quest_reward_distributions`
--
ALTER TABLE `clan_quest_reward_distributions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_quest_reward_user` (`reward_id`,`user_id`),
  ADD KEY `idx_clan_reward_distributions_user` (`user_id`,`created_at`),
  ADD KEY `idx_clan_reward_distributions_quest_clan` (`quest_id`,`clan_id`,`status`),
  ADD KEY `fk_clan_reward_distributions_clan` (`clan_id`);

--
-- Indexes for table `clan_quest_scores`
--
ALTER TABLE `clan_quest_scores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_clan_quest_score` (`quest_id`,`clan_id`),
  ADD KEY `idx_clan_quest_scores_rank` (`quest_id`,`rank_position`,`score`),
  ADD KEY `idx_clan_quest_scores_clan` (`clan_id`);

--
-- Indexes for table `clan_settings`
--
ALTER TABLE `clan_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_clan_settings_updated_by` (`updated_by`);

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
  ADD KEY `idx_heist_created_by` (`created_by`),
  ADD KEY `idx_heist_winner_demo` (`winner_demo_submission_id`),
  ADD KEY `idx_heist_product` (`product_id`);

--
-- Indexes for table `heist_content_bank`
--
ALTER TABLE `heist_content_bank`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_heist_content_bank_active_created` (`is_active`,`created_at`),
  ADD KEY `idx_heist_content_bank_created_by` (`created_by`);

--
-- Indexes for table `heist_demo_submissions`
--
ALTER TABLE `heist_demo_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_heist_demo_submissions_rank` (`heist_id`,`correct_count`,`total_time_seconds`,`submitted_at`),
  ADD KEY `idx_heist_demo_submissions_demo_user` (`demo_user_id`),
  ADD KEY `idx_heist_demo_submissions_created_by` (`created_by`);

--
-- Indexes for table `heist_demo_users`
--
ALTER TABLE `heist_demo_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_heist_demo_users_display_name` (`display_name`),
  ADD KEY `idx_heist_demo_users_active_created` (`is_active`,`created_at`),
  ADD KEY `idx_heist_demo_users_created_by` (`created_by`);

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
-- Indexes for table `level_admin_audit_logs`
--
ALTER TABLE `level_admin_audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_level_admin_audit_admin` (`admin_user_id`,`created_at`),
  ADD KEY `idx_level_admin_audit_target` (`target_user_id`,`created_at`);

--
-- Indexes for table `level_badges`
--
ALTER TABLE `level_badges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_level_badges_order` (`badge_order`),
  ADD UNIQUE KEY `uniq_level_badges_name` (`name`);

--
-- Indexes for table `level_definitions`
--
ALTER TABLE `level_definitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_level_definitions_order` (`level_order`),
  ADD UNIQUE KEY `uniq_level_definitions_badge_level` (`badge_id`,`badge_level`),
  ADD KEY `idx_level_definitions_xp` (`xp_required`);

--
-- Indexes for table `manual_payin_requests`
--
ALTER TABLE `manual_payin_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_manual_payin_user` (`user_id`),
  ADD KEY `idx_manual_payin_status` (`status`,`created_at`),
  ADD KEY `idx_manual_payin_admin` (`admin_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_orders_reference` (`order_reference`),
  ADD KEY `idx_orders_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_orders_status_created` (`status`,`created_at`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_order_item_entitlement` (`entitlement_id`),
  ADD KEY `idx_order_items_order` (`order_id`),
  ADD KEY `fk_order_items_heist` (`heist_id`),
  ADD KEY `fk_order_items_product` (`product_id`);

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
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_products_sku` (`sku`),
  ADD KEY `idx_products_active_name` (`is_active`,`name`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_images_order` (`product_id`,`is_primary`,`sort_order`);

--
-- Indexes for table `product_win_entitlements`
--
ALTER TABLE `product_win_entitlements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_product_win_heist` (`heist_id`),
  ADD KEY `idx_product_win_user_status` (`user_id`,`status`),
  ADD KEY `fk_product_win_product` (`product_id`);

--
-- Indexes for table `promo_codes`
--
ALTER TABLE `promo_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_promo_codes_code` (`code`),
  ADD KEY `idx_promo_codes_status` (`is_active`,`expires_at`,`deleted_at`),
  ADD KEY `idx_promo_codes_created_by` (`created_by`);

--
-- Indexes for table `promo_code_redemptions`
--
ALTER TABLE `promo_code_redemptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_promo_redemptions_code_user` (`promo_code_id`,`user_id`),
  ADD KEY `idx_promo_redemptions_user` (`user_id`);

--
-- Indexes for table `push_device_tokens`
--
ALTER TABLE `push_device_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_push_device_token` (`token`),
  ADD KEY `idx_push_device_tokens_user` (`user_id`);

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
  ADD UNIQUE KEY `uniq_users_game_id` (`game_id`),
  ADD KEY `idx_users_registration_device` (`registration_device_key`),
  ADD KEY `idx_users_registration_ip` (`registration_ip`);

--
-- Indexes for table `user_activity_events`
--
ALTER TABLE `user_activity_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_activity_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_user_activity_event_created` (`event_type`,`created_at`),
  ADD KEY `idx_user_activity_ip_created` (`ip_address`,`created_at`),
  ADD KEY `idx_user_activity_device_created` (`device_key`,`created_at`);

--
-- Indexes for table `user_copup_jr_balances`
--
ALTER TABLE `user_copup_jr_balances`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `user_copup_jr_ledger`
--
ALTER TABLE `user_copup_jr_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_copup_jr_ledger_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_copup_jr_ledger_heist` (`heist_id`),
  ADD KEY `idx_copup_jr_ledger_promo` (`promo_code_id`),
  ADD KEY `fk_copup_jr_ledger_redemption` (`redemption_id`);

--
-- Indexes for table `user_delivery_addresses`
--
ALTER TABLE `user_delivery_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_delivery_addresses_user` (`user_id`,`updated_at`);

--
-- Indexes for table `user_level_rewards`
--
ALTER TABLE `user_level_rewards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_level_reward` (`user_id`,`level_definition_id`),
  ADD UNIQUE KEY `uniq_user_level_reward_code` (`code`),
  ADD KEY `idx_user_level_rewards_user_status` (`user_id`,`status`),
  ADD KEY `idx_user_level_rewards_level` (`level_definition_id`);

--
-- Indexes for table `user_notices`
--
ALTER TABLE `user_notices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_notices_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_user_notices_created_by` (`created_by`);

--
-- Indexes for table `user_xp_events`
--
ALTER TABLE `user_xp_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_xp_event_source` (`user_id`,`source`,`source_id`),
  ADD KEY `idx_user_xp_events_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_user_xp_events_source` (`source`);

--
-- Indexes for table `user_xp_totals`
--
ALTER TABLE `user_xp_totals`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `idx_user_xp_totals_level` (`current_level_definition_id`);

--
-- Indexes for table `xp_source_rules`
--
ALTER TABLE `xp_source_rules`
  ADD PRIMARY KEY (`source`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `affiliate_tasks`
--
ALTER TABLE `affiliate_tasks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `affiliate_task_progress`
--
ALTER TABLE `affiliate_task_progress`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `affiliate_tiles`
--
ALTER TABLE `affiliate_tiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `affiliate_tile_memberships`
--
ALTER TABLE `affiliate_tile_memberships`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `affiliate_tile_payouts`
--
ALTER TABLE `affiliate_tile_payouts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `affiliate_user_links`
--
ALTER TABLE `affiliate_user_links`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `affiliate_user_referrals`
--
ALTER TABLE `affiliate_user_referrals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clans`
--
ALTER TABLE `clans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clan_activity_events`
--
ALTER TABLE `clan_activity_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `clan_chat_messages`
--
ALTER TABLE `clan_chat_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clan_coin_ledger`
--
ALTER TABLE `clan_coin_ledger`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clan_invites`
--
ALTER TABLE `clan_invites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clan_join_requests`
--
ALTER TABLE `clan_join_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clan_members`
--
ALTER TABLE `clan_members`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `clan_quests`
--
ALTER TABLE `clan_quests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clan_quest_heist_wins`
--
ALTER TABLE `clan_quest_heist_wins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clan_quest_participants`
--
ALTER TABLE `clan_quest_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clan_quest_rewards`
--
ALTER TABLE `clan_quest_rewards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clan_quest_reward_distributions`
--
ALTER TABLE `clan_quest_reward_distributions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clan_quest_scores`
--
ALTER TABLE `clan_quest_scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coin_rate`
--
ALTER TABLE `coin_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cop_point_transfers`
--
ALTER TABLE `cop_point_transfers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `heist`
--
ALTER TABLE `heist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `heist_content_bank`
--
ALTER TABLE `heist_content_bank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `heist_demo_submissions`
--
ALTER TABLE `heist_demo_submissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `heist_demo_users`
--
ALTER TABLE `heist_demo_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `heist_participants`
--
ALTER TABLE `heist_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT for table `heist_questions`
--
ALTER TABLE `heist_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=641;

--
-- AUTO_INCREMENT for table `heist_submissions`
--
ALTER TABLE `heist_submissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT for table `heist_submission_answers`
--
ALTER TABLE `heist_submission_answers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=503;

--
-- AUTO_INCREMENT for table `heist_submission_questions`
--
ALTER TABLE `heist_submission_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=444;

--
-- AUTO_INCREMENT for table `level_admin_audit_logs`
--
ALTER TABLE `level_admin_audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `level_badges`
--
ALTER TABLE `level_badges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=457;

--
-- AUTO_INCREMENT for table `level_definitions`
--
ALTER TABLE `level_definitions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2304;

--
-- AUTO_INCREMENT for table `manual_payin_requests`
--
ALTER TABLE `manual_payin_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT for table `payment_accounts`
--
ALTER TABLE `payment_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `payout_requests`
--
ALTER TABLE `payout_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_win_entitlements`
--
ALTER TABLE `product_win_entitlements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promo_codes`
--
ALTER TABLE `promo_codes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `promo_code_redemptions`
--
ALTER TABLE `promo_code_redemptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `push_device_tokens`
--
ALTER TABLE `push_device_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `referrals`
--
ALTER TABLE `referrals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `referral_reward_progress`
--
ALTER TABLE `referral_reward_progress`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `user_activity_events`
--
ALTER TABLE `user_activity_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1931;

--
-- AUTO_INCREMENT for table `user_copup_jr_ledger`
--
ALTER TABLE `user_copup_jr_ledger`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `user_delivery_addresses`
--
ALTER TABLE `user_delivery_addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_level_rewards`
--
ALTER TABLE `user_level_rewards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user_notices`
--
ALTER TABLE `user_notices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `user_xp_events`
--
ALTER TABLE `user_xp_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cart_items_entitlement` FOREIGN KEY (`entitlement_id`) REFERENCES `product_win_entitlements` (`id`);

--
-- Constraints for table `heist`
--
ALTER TABLE `heist`
  ADD CONSTRAINT `fk_heist_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `level_definitions`
--
ALTER TABLE `level_definitions`
  ADD CONSTRAINT `fk_level_definitions_badge` FOREIGN KEY (`badge_id`) REFERENCES `level_badges` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_entitlement` FOREIGN KEY (`entitlement_id`) REFERENCES `product_win_entitlements` (`id`),
  ADD CONSTRAINT `fk_order_items_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`),
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_win_entitlements`
--
ALTER TABLE `product_win_entitlements`
  ADD CONSTRAINT `fk_product_win_heist` FOREIGN KEY (`heist_id`) REFERENCES `heist` (`id`),
  ADD CONSTRAINT `fk_product_win_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_product_win_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_delivery_addresses`
--
ALTER TABLE `user_delivery_addresses`
  ADD CONSTRAINT `fk_delivery_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_level_rewards`
--
ALTER TABLE `user_level_rewards`
  ADD CONSTRAINT `fk_user_level_rewards_level` FOREIGN KEY (`level_definition_id`) REFERENCES `level_definitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_level_rewards_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_xp_events`
--
ALTER TABLE `user_xp_events`
  ADD CONSTRAINT `fk_user_xp_events_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_xp_totals`
--
ALTER TABLE `user_xp_totals`
  ADD CONSTRAINT `fk_user_xp_totals_level` FOREIGN KEY (`current_level_definition_id`) REFERENCES `level_definitions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_xp_totals_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
