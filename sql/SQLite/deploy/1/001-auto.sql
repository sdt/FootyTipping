-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri Apr  1 22:23:15 2011
-- 

;
BEGIN TRANSACTION;
--
-- Table: tbl_competition
--
CREATE TABLE tbl_competition (
  competition_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  password varchar
);
CREATE UNIQUE INDEX tbl_competition_name ON tbl_competition (name);
--
-- Table: tbl_team
--
CREATE TABLE tbl_team (
  team_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  nickname varchar NOT NULL
);
CREATE UNIQUE INDEX tbl_team_name ON tbl_team (name);
CREATE UNIQUE INDEX tbl_team_nickname ON tbl_team (nickname);
--
-- Table: tbl_user
--
CREATE TABLE tbl_user (
  user_id INTEGER PRIMARY KEY NOT NULL,
  user_name varchar NOT NULL,
  real_name varchar NOT NULL,
  screen_name varchar,
  password varchar NOT NULL
);
CREATE UNIQUE INDEX tbl_user_real_name ON tbl_user (real_name);
CREATE UNIQUE INDEX tbl_user_screen_name ON tbl_user (screen_name);
CREATE UNIQUE INDEX tbl_user_user_name ON tbl_user (user_name);
--
-- Table: tbl_venue
--
CREATE TABLE tbl_venue (
  venue_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  sponsor_name varchar NOT NULL,
  time_zone varchar NOT NULL
);
CREATE UNIQUE INDEX tbl_venue_name ON tbl_venue (name);
CREATE UNIQUE INDEX tbl_venue_sponsor_name ON tbl_venue (sponsor_name);
--
-- Table: tbl_competition_user
--
CREATE TABLE tbl_competition_user (
  user_id integer NOT NULL,
  competition_id integer NOT NULL,
  can_submit_tips_for_others boolean NOT NULL DEFAULT '0',
  can_change_closed_tips boolean NOT NULL DEFAULT '0',
  can_grant_powers boolean NOT NULL DEFAULT '0',
  PRIMARY KEY (user_id, competition_id)
);
CREATE INDEX tbl_competition_user_idx_competition_id ON tbl_competition_user (competition_id);
CREATE INDEX tbl_competition_user_idx_user_id ON tbl_competition_user (user_id);
--
-- Table: tbl_game
--
CREATE TABLE tbl_game (
  game_id INTEGER PRIMARY KEY NOT NULL,
  season integer NOT NULL,
  round integer NOT NULL,
  home_team_id integer NOT NULL,
  away_team_id integer NOT NULL,
  venue_id integer NOT NULL,
  home_team_goals integer NOT NULL DEFAULT 0,
  home_team_behinds integer NOT NULL DEFAULT 0,
  away_team_goals integer NOT NULL DEFAULT 0,
  away_team_behinds integer NOT NULL DEFAULT 0,
  has_ended boolean NOT NULL DEFAULT 'false'
);
CREATE INDEX tbl_game_idx_away_team_id ON tbl_game (away_team_id);
CREATE INDEX tbl_game_idx_home_team_id ON tbl_game (home_team_id);
CREATE INDEX tbl_game_idx_venue_id ON tbl_game (venue_id);
CREATE UNIQUE INDEX tbl_game_season_round_away_team_id ON tbl_game (season, round, away_team_id);
CREATE UNIQUE INDEX tbl_game_season_round_home_team_id ON tbl_game (season, round, home_team_id);
--
-- Table: tbl_team_supporter
--
CREATE TABLE tbl_team_supporter (
  user_id integer NOT NULL,
  team_id integer NOT NULL,
  PRIMARY KEY (user_id, team_id)
);
CREATE INDEX tbl_team_supporter_idx_user_id ON tbl_team_supporter (user_id);
CREATE INDEX tbl_team_supporter_idx_team_id ON tbl_team_supporter (team_id);
CREATE UNIQUE INDEX tbl_team_supporter_user_id ON tbl_team_supporter (user_id);
--
-- Table: tbl_tip
--
CREATE TABLE tbl_tip (
  tipper_id integer NOT NULL,
  submitter_id integer NOT NULL,
  competition_id integer NOT NULL,
  game_id integer NOT NULL,
  home_team_to_win boolean NOT NULL,
  timestamp timestamp NOT NULL,
  PRIMARY KEY (tipper_id, competition_id, game_id, timestamp)
);
CREATE INDEX tbl_tip_idx_competition_id ON tbl_tip (competition_id);
CREATE INDEX tbl_tip_idx_game_id ON tbl_tip (game_id);
CREATE INDEX tbl_tip_idx_submitter_id ON tbl_tip (submitter_id);
CREATE INDEX tbl_tip_idx_tipper_id ON tbl_tip (tipper_id);
COMMIT