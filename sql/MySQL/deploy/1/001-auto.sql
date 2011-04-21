-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Thu Apr 21 22:13:11 2011
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
-- Table: `tbl_session`
--
CREATE TABLE `tbl_session` (
  `session_id` char(72) NOT NULL,
  `session_data` text,
  `expires` integer,
  PRIMARY KEY (`session_id`)
);
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
-- Table: `tbl_user`
--
CREATE TABLE `tbl_user` (
  `user_id` integer NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `real_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE `tbl_user_real_name` (`real_name`),
  UNIQUE `tbl_user_username` (`username`)
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
  `season` integer NOT NULL,
  `round` integer NOT NULL,
  `venue_id` integer NOT NULL,
  `start_time_utc` timestamp NOT NULL,
  `has_ended` enum('0','1') NOT NULL DEFAULT '0',
  INDEX `tbl_game_idx_venue_id` (`venue_id`),
  PRIMARY KEY (`game_id`),
  CONSTRAINT `tbl_game_fk_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `tbl_venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table: `tbl_competition_user`
--
CREATE TABLE `tbl_competition_user` (
  `user_id` integer NOT NULL,
  `competition_id` integer NOT NULL,
  `can_submit_tips_for_others` enum('0','1') NOT NULL DEFAULT '0',
  `can_change_closed_tips` enum('0','1') NOT NULL DEFAULT '0',
  `can_grant_powers` enum('0','1') NOT NULL DEFAULT '0',
  `screen_name` varchar(255),
  INDEX `tbl_competition_user_idx_competition_id` (`competition_id`),
  INDEX `tbl_competition_user_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `competition_id`),
  UNIQUE `tbl_competition_user_competition_id_screen_name` (`competition_id`, `screen_name`),
  CONSTRAINT `tbl_competition_user_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `tbl_competition` (`competition_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_competition_user_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_team_supporter`
--
CREATE TABLE `tbl_team_supporter` (
  `user_id` integer NOT NULL,
  `team_id` integer NOT NULL,
  INDEX `tbl_team_supporter_idx_user_id` (`user_id`),
  INDEX `tbl_team_supporter_idx_team_id` (`team_id`),
  PRIMARY KEY (`user_id`, `team_id`),
  UNIQUE `tbl_team_supporter_user_id` (`user_id`),
  CONSTRAINT `tbl_team_supporter_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `tbl_team_supporter_fk_team_id` FOREIGN KEY (`team_id`) REFERENCES `tbl_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  CONSTRAINT `tbl_game_team_fk_game_id` FOREIGN KEY (`game_id`) REFERENCES `tbl_game` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_game_team_fk_team_id` FOREIGN KEY (`team_id`) REFERENCES `tbl_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tbl_tip`
--
CREATE TABLE `tbl_tip` (
  `tipper_id` integer NOT NULL,
  `submitter_id` integer NOT NULL,
  `competition_id` integer NOT NULL,
  `game_id` integer NOT NULL,
  `home_team_to_win` enum('0','1') NOT NULL,
  `timestamp` timestamp NOT NULL,
  INDEX `tbl_tip_idx_competition_id` (`competition_id`),
  INDEX `tbl_tip_idx_game_id` (`game_id`),
  INDEX `tbl_tip_idx_submitter_id` (`submitter_id`),
  INDEX `tbl_tip_idx_tipper_id` (`tipper_id`),
  PRIMARY KEY (`tipper_id`, `competition_id`, `game_id`, `timestamp`),
  CONSTRAINT `tbl_tip_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `tbl_competition` (`competition_id`),
  CONSTRAINT `tbl_tip_fk_game_id` FOREIGN KEY (`game_id`) REFERENCES `tbl_game` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_tip_fk_submitter_id` FOREIGN KEY (`submitter_id`) REFERENCES `tbl_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_tip_fk_tipper_id` FOREIGN KEY (`tipper_id`) REFERENCES `tbl_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1