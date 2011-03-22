-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue Mar 22 21:29:59 2011
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
  home_team_goals integer NOT NULL DEFAULT 0,
  home_team_behinds integer NOT NULL DEFAULT 0,
  away_team_goals integer NOT NULL DEFAULT 0,
  away_team_behinds integer NOT NULL DEFAULT 0,
  PRIMARY KEY (round, home_team_id, away_team_id)
);
CREATE INDEX game_idx_away_team_id ON game (away_team_id);
CREATE INDEX game_idx_home_team_id ON game (home_team_id);
CREATE INDEX game_idx_venue_id ON game (venue_id);
COMMIT