-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Mar 19 22:36:29 2011
-- 

;
BEGIN TRANSACTION;
--
-- Table: team
--
CREATE TABLE team (
  team_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  nickname varchar NOT NULL
);
--
-- Table: venue
--
CREATE TABLE venue (
  venue_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  sponsor_name varchar NOT NULL
);
--
-- Table: game
--
CREATE TABLE game (
  round integer NOT NULL,
  home_team_id integer NOT NULL,
  away_team_id integer NOT NULL,
  venue_id integer NOT NULL,
  start_time timestamp with time zone NOT NULL,
  home_team_goals integer NOT NULL,
  home_team_behinds integer NOT NULL,
  away_team_goals integer NOT NULL,
  away_team_behinds integer NOT NULL,
  PRIMARY KEY (venue_id, start_time)
);
CREATE INDEX game_idx_away_team_id ON game (away_team_id);
CREATE INDEX game_idx_home_team_id ON game (home_team_id);
CREATE INDEX game_idx_venue_id ON game (venue_id);
COMMIT