-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Apr  2 17:34:43 2011
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
-- Table: `tbl_user`
--
CREATE TABLE `tbl_user` (
  `user_id` integer NOT NULL auto_increment,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `real_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE `tbl_user_real_name` (`real_name`),
  UNIQUE `tbl_user_user_name` (`user_name`)
) ENGINE=InnoDB;
--
-- Table: `tbl_venue`
--
CREATE TABLE `tbl_venue` (
  `venue_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `sponsor_name` varchar(255) NOT NULL,
  `time_zone` varchar(255) NOT NULL,
  PRIMARY KEY (`venue_id`),
  UNIQUE `tbl_venue_name` (`name`),
  UNIQUE `tbl_venue_sponsor_name` (`sponsor_name`)
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
-- Table: `tbl_game`
--
CREATE TABLE `tbl_game` (
  `game_id` integer NOT NULL auto_increment,
  `season` integer NOT NULL,
  `round` integer NOT NULL,
  `home_team_id` integer NOT NULL,
  `away_team_id` integer NOT NULL,
  `venue_id` integer NOT NULL,
  `home_team_goals` integer NOT NULL DEFAULT 0,
  `home_team_behinds` integer NOT NULL DEFAULT 0,
  `away_team_goals` integer NOT NULL DEFAULT 0,
  `away_team_behinds` integer NOT NULL DEFAULT 0,
  `has_ended` enum('0','1') NOT NULL DEFAULT '0',
  INDEX `tbl_game_idx_away_team_id` (`away_team_id`),
  INDEX `tbl_game_idx_home_team_id` (`home_team_id`),
  INDEX `tbl_game_idx_venue_id` (`venue_id`),
  PRIMARY KEY (`game_id`),
  UNIQUE `tbl_game_season_round_away_team_id` (`season`, `round`, `away_team_id`),
  UNIQUE `tbl_game_season_round_home_team_id` (`season`, `round`, `home_team_id`),
  CONSTRAINT `tbl_game_fk_away_team_id` FOREIGN KEY (`away_team_id`) REFERENCES `tbl_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_game_fk_home_team_id` FOREIGN KEY (`home_team_id`) REFERENCES `tbl_team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tbl_game_fk_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `tbl_venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
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