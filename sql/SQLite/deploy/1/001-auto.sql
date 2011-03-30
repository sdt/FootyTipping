-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Wed Mar 30 15:43:18 2011
-- 

;
BEGIN TRANSACTION;
--
-- Table: competition
--
CREATE TABLE competition (
  competition_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  password varchar
);
CREATE UNIQUE INDEX competition_name ON competition (name);
--
-- Table: team
--
CREATE TABLE team (
  team_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  nickname varchar NOT NULL
);
CREATE UNIQUE INDEX team_name ON team (name);
CREATE UNIQUE INDEX team_nickname ON team (nickname);
--
-- Table: user
--
CREATE TABLE user (
  user_id INTEGER PRIMARY KEY NOT NULL,
  user_name varchar NOT NULL,
  real_name varchar NOT NULL,
  screen_name varchar,
  password varchar NOT NULL
);
CREATE UNIQUE INDEX user_real_name ON user (real_name);
CREATE UNIQUE INDEX user_screen_name ON user (screen_name);
CREATE UNIQUE INDEX user_user_name ON user (user_name);
--
-- Table: venue
--
CREATE TABLE venue (
  venue_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  sponsor_name varchar NOT NULL
);
CREATE UNIQUE INDEX venue_name ON venue (name);
CREATE UNIQUE INDEX venue_sponsor_name ON venue (sponsor_name);
--
-- Table: competition_admin
--
CREATE TABLE competition_admin (
  user_id integer NOT NULL,
  competition_id integer NOT NULL,
  PRIMARY KEY (user_id, competition_id)
);
CREATE INDEX competition_admin_idx_competition_id ON competition_admin (competition_id);
CREATE INDEX competition_admin_idx_user_id ON competition_admin (user_id);
--
-- Table: competition_user
--
CREATE TABLE competition_user (
  user_id integer NOT NULL,
  competition_id integer NOT NULL,
  PRIMARY KEY (user_id, competition_id)
);
CREATE INDEX competition_user_idx_competition_id ON competition_user (competition_id);
CREATE INDEX competition_user_idx_user_id ON competition_user (user_id);
--
-- Table: game
--
CREATE TABLE game (
  game_id INTEGER PRIMARY KEY NOT NULL,
  season integer NOT NULL,
  round integer NOT NULL,
  home_team_id integer NOT NULL,
  away_team_id integer NOT NULL,
  venue_id integer NOT NULL,
  home_team_goals integer NOT NULL DEFAULT 0,
  home_team_behinds integer NOT NULL DEFAULT 0,
  away_team_goals integer NOT NULL DEFAULT 0,
  away_team_behinds integer NOT NULL DEFAULT 0
);
CREATE INDEX game_idx_away_team_id ON game (away_team_id);
CREATE INDEX game_idx_home_team_id ON game (home_team_id);
CREATE INDEX game_idx_venue_id ON game (venue_id);
CREATE UNIQUE INDEX game_season_round_away_team_id ON game (season, round, away_team_id);
CREATE UNIQUE INDEX game_season_round_home_team_id ON game (season, round, home_team_id);
--
-- Table: team_user
--
CREATE TABLE team_user (
  user_id integer NOT NULL,
  team_id integer NOT NULL,
  PRIMARY KEY (user_id, team_id)
);
CREATE INDEX team_user_idx_team_id ON team_user (team_id);
CREATE INDEX team_user_idx_user_id ON team_user (user_id);
CREATE UNIQUE INDEX team_user_user_id ON team_user (user_id);
--
-- Table: tip
--
CREATE TABLE tip (
  user_id integer NOT NULL,
  game_id integer NOT NULL,
  home_team_to_win boolean NOT NULL,
  PRIMARY KEY (user_id, game_id)
);
CREATE INDEX tip_idx_game_id ON tip (game_id);
CREATE INDEX tip_idx_user_id ON tip (user_id);
COMMIT