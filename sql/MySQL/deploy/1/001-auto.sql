-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Thu Mar 31 17:22:31 2011
-- 
;
SET foreign_key_checks=0;
--
-- Table: `competition`
--
CREATE TABLE `competition` (
  `competition_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `password` varchar(255),
  PRIMARY KEY (`competition_id`),
  UNIQUE `competition_name` (`name`)
) ENGINE=InnoDB;
--
-- Table: `team`
--
CREATE TABLE `team` (
  `team_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE `team_name` (`name`),
  UNIQUE `team_nickname` (`nickname`)
) ENGINE=InnoDB;
--
-- Table: `user_`
--
CREATE TABLE `user_` (
  `user_id` integer NOT NULL auto_increment,
  `user_name` varchar(255) NOT NULL,
  `real_name` varchar(255) NOT NULL,
  `screen_name` varchar(255),
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE `user__real_name` (`real_name`),
  UNIQUE `user__screen_name` (`screen_name`),
  UNIQUE `user__user_name` (`user_name`)
) ENGINE=InnoDB;
--
-- Table: `venue`
--
CREATE TABLE `venue` (
  `venue_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `sponsor_name` varchar(255) NOT NULL,
  PRIMARY KEY (`venue_id`),
  UNIQUE `venue_name` (`name`),
  UNIQUE `venue_sponsor_name` (`sponsor_name`)
) ENGINE=InnoDB;
--
-- Table: `competition_admin`
--
CREATE TABLE `competition_admin` (
  `user_id` integer NOT NULL,
  `competition_id` integer NOT NULL,
  INDEX `competition_admin_idx_competition_id` (`competition_id`),
  INDEX `competition_admin_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `competition_id`),
  CONSTRAINT `competition_admin_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `competition` (`competition_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `competition_admin_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user_` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `competition_tipper`
--
CREATE TABLE `competition_tipper` (
  `user_id` integer NOT NULL,
  `competition_id` integer NOT NULL,
  INDEX `competition_tipper_idx_competition_id` (`competition_id`),
  INDEX `competition_tipper_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `competition_id`),
  CONSTRAINT `competition_tipper_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `competition` (`competition_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `competition_tipper_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user_` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `game`
--
CREATE TABLE `game` (
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
  `has_ended` enum('0','1') NOT NULL DEFAULT 'false',
  INDEX `game_idx_away_team_id` (`away_team_id`),
  INDEX `game_idx_home_team_id` (`home_team_id`),
  INDEX `game_idx_venue_id` (`venue_id`),
  PRIMARY KEY (`game_id`),
  UNIQUE `game_season_round_away_team_id` (`season`, `round`, `away_team_id`),
  UNIQUE `game_season_round_home_team_id` (`season`, `round`, `home_team_id`),
  CONSTRAINT `game_fk_away_team_id` FOREIGN KEY (`away_team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `game_fk_home_team_id` FOREIGN KEY (`home_team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `game_fk_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `team_supporter`
--
CREATE TABLE `team_supporter` (
  `user_id` integer NOT NULL,
  `team_id` integer NOT NULL,
  INDEX `team_supporter_idx_user_id` (`user_id`),
  INDEX `team_supporter_idx_team_id` (`team_id`),
  PRIMARY KEY (`user_id`, `team_id`),
  UNIQUE `team_supporter_user_id` (`user_id`),
  CONSTRAINT `team_supporter_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user_` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `team_supporter_fk_team_id` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tip`
--
CREATE TABLE `tip` (
  `tipper_id` integer NOT NULL,
  `submitter_id` integer NOT NULL,
  `competition_id` integer NOT NULL,
  `game_id` integer NOT NULL,
  `home_team_to_win` enum('0','1') NOT NULL,
  `timestamp` timestamp NOT NULL,
  INDEX `tip_idx_competition_id` (`competition_id`),
  INDEX `tip_idx_game_id` (`game_id`),
  INDEX `tip_idx_submitter_id` (`submitter_id`),
  INDEX `tip_idx_tipper_id` (`tipper_id`),
  PRIMARY KEY (`tipper_id`, `competition_id`, `game_id`, `timestamp`),
  CONSTRAINT `tip_fk_competition_id` FOREIGN KEY (`competition_id`) REFERENCES `competition` (`competition_id`),
  CONSTRAINT `tip_fk_game_id` FOREIGN KEY (`game_id`) REFERENCES `game` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tip_fk_submitter_id` FOREIGN KEY (`submitter_id`) REFERENCES `user_` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tip_fk_tipper_id` FOREIGN KEY (`tipper_id`) REFERENCES `user_` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1