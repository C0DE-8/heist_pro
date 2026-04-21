ALTER TABLE `payout_requests`
  ADD COLUMN `bank_code` varchar(30) DEFAULT NULL AFTER `bank_name`;
