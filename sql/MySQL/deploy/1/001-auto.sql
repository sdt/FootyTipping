-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Mar 19 22:36:29 2011
-- 
;
SET foreign_key_checks=0;
--
-- Table: `team`
--
CREATE TABLE `team` (
  `team_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  PRIMARY KEY (`team_id`)
) ENGINE=InnoDB;
--
-- Table: `venue`
--
CREATE TABLE `venue` (
  `venue_id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `sponsor_name` varchar(255) NOT NULL,
  PRIMARY KEY (`venue_id`)
) ENGINE=InnoDB;
--
-- Table: `game`
--
CREATE TABLE `game` (
  `round` integer NOT NULL,
  `home_team_id` integer NOT NULL,
  `away_team_id` integer NOT NULL,
  `venue_id` integer NOT NULL,
  `start_time` timestamp with time zone NOT NULL,
  `home_team_goals` integer NOT NULL,
  `home_team_behinds` integer NOT NULL,
  `away_team_goals` integer NOT NULL,
  `away_team_behinds` integer NOT NULL,
  INDEX `game_idx_away_team_id` (`away_team_id`),
  INDEX `game_idx_home_team_id` (`home_team_id`),
  INDEX `game_idx_venue_id` (`venue_id`),
  PRIMARY KEY (`venue_id`, `start_time`),
  CONSTRAINT `game_fk_away_team_id` FOREIGN KEY (`away_team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `game_fk_home_team_id` FOREIGN KEY (`home_team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `game_fk_venue_id` FOREIGN KEY (`venue_id`) REFERENCES `venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1