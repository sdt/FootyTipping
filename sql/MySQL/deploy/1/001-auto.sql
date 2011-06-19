-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Jun 19 11:53:26 2011
-- 
;
SET foreign_key_checks=0;
--
-- Table: `tbl_competition`
--
CREATE TABLE `tbl_competition` (
  `competition_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `password` varchar(255),
  PRIMARY KEY (`competition_id`),
  UNIQUE `tbl_competition_name` (`name`)
) ENGINE=InnoDB;
--
-- Table: `tbl_team`
--
CREATE TABLE `tbl_team` (
  `team_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE `tbl_team_name` (`name`),
  UNIQUE `tbl_team_nickname` (`nickname`)
) ENGINE=InnoDB;
--
-- Table: `tbl_venue`
--
CREATE TABLE `tbl_venue` (
  `venue_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `time_zone` varchar(255) NOT NULL,
  PRIMARY KEY (`venue_id`),
  UNIQUE `tbl_venue_name` (`name`)
) ENGINE=InnoDB;
--
-- Table: `tbl_game`
--
CREATE TABLE `tbl_game` (
  `game_id` integer NOT NULL auto_increment,
  `round` integer NOT NULL,
  `venue_id` integer NOT NULL,
  `start_time_utc` datetime NOT NULL,
  `has_ended` enum('0','1') NOT NULL DEFAULT '0',
  INDEX `tbl_game_idx_venue_id` (`venue_id`),
  PRIMARY KEY (`game_id`),
  CONSTRAINT `tbl_game_fk_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `tbl_venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_round_result_timestamp`
--
CREATE TABLE `tbl_round_result_timestamp` (
  `competition_id` integer NOT NULL,
  `round` integer NOT NULL,
  `timestamp` datetime NOT NULL,
  INDEX `tbl_round_result_timestamp_idx_competition_id` (`competition_id`),
  PRIMARY KEY (`competition_id`, `round`),
  CONSTRAINT `tbl_round_result_timestamp_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `tbl_competition` (`competition_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_user`
--
CREATE TABLE `tbl_user` (
  `user_id` integer NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `real_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `team_id` integer,
  `password` char(50) NOT NULL,
  `is_superuser` enum('0','1') NOT NULL DEFAULT '0',
  INDEX `tbl_user_idx_team_id` (`team_id`),
  PRIMARY KEY (`user_id`),
  UNIQUE `tbl_user_real_name` (`real_name`),
  UNIQUE `tbl_user_username` (`username`),
  CONSTRAINT `tbl_user_fk_team_id` FOREIGN KEY (`team_id`) REFERENCES `tbl_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_venue_sponsorname`
--
CREATE TABLE `tbl_venue_sponsorname` (
  `venue_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `start_year` integer,
  `end_year` integer,
  INDEX `tbl_venue_sponsorname_idx_venue_id` (`venue_id`),
  PRIMARY KEY (`venue_id`, `name`),
  CONSTRAINT `tbl_venue_sponsorname_fk_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `tbl_venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_game_team`
--
CREATE TABLE `tbl_game_team` (
  `game_id` integer NOT NULL,
  `behinds` integer NOT NULL DEFAULT 0,
  `is_home_team` enum('0','1') NOT NULL,
  `team_id` integer NOT NULL,
  `goals` integer NOT NULL DEFAULT 0,
  INDEX `tbl_game_team_idx_game_id` (`game_id`),
  INDEX `tbl_game_team_idx_team_id` (`team_id`),
  PRIMARY KEY (`game_id`, `team_id`),
  UNIQUE `tbl_game_team_game_id_is_home_team` (`game_id`, `is_home_team`),
  CONSTRAINT `tbl_game_team_fk_game_id` FOREIGN KEY (`game_id`) REFERENCES `tbl_game` (`game_id`) ON DELETE CASCADE,
  CONSTRAINT `tbl_game_team_fk_team_id` FOREIGN KEY (`team_id`) REFERENCES `tbl_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_membership`
--
CREATE TABLE `tbl_membership` (
  `membership_id` integer NOT NULL auto_increment,
  `user_id` integer NOT NULL,
  `competition_id` integer NOT NULL,
  `screen_name` varchar(255),
  `can_submit_tips_for_others` enum('0','1') NOT NULL DEFAULT '0',
  `can_change_closed_tips` enum('0','1') NOT NULL DEFAULT '0',
  `can_change_permissions` enum('0','1') NOT NULL DEFAULT '0',
  INDEX `tbl_membership_idx_competition_id` (`competition_id`),
  INDEX `tbl_membership_idx_user_id` (`user_id`),
  PRIMARY KEY (`membership_id`),
  UNIQUE `tbl_membership_competition_id_screen_name` (`competition_id`, `screen_name`),
  UNIQUE `tbl_membership_user_id_competition_id` (`user_id`, `competition_id`),
  CONSTRAINT `tbl_membership_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `tbl_competition` (`competition_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_membership_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_round_result`
--
CREATE TABLE `tbl_round_result` (
  `membership_id` integer NOT NULL,
  `round` integer NOT NULL,
  `score` integer NOT NULL,
  INDEX `tbl_round_result_idx_membership_id` (`membership_id`),
  PRIMARY KEY (`membership_id`, `round`),
  CONSTRAINT `tbl_round_result_fk_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `tbl_membership` (`membership_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_tip`
--
CREATE TABLE `tbl_tip` (
  `membership_id` integer NOT NULL,
  `submitter_id` integer NOT NULL,
  `game_id` integer NOT NULL,
  `home_team_to_win` enum('0','1') NOT NULL,
  `timestamp` datetime NOT NULL,
  INDEX `tbl_tip_idx_game_id` (`game_id`),
  INDEX `tbl_tip_idx_membership_id` (`membership_id`),
  INDEX `tbl_tip_idx_submitter_id` (`submitter_id`),
  PRIMARY KEY (`membership_id`, `game_id`, `timestamp`),
  CONSTRAINT `tbl_tip_fk_game_id` FOREIGN KEY (`game_id`) REFERENCES `tbl_game` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_tip_fk_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `tbl_membership` (`membership_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_tip_fk_submitter_id` FOREIGN KEY (`submitter_id`) REFERENCES `tbl_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1