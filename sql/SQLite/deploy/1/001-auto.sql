-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue Apr 12 10:44:15 2011
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
  password varchar NOT NULL,
  real_name varchar NOT NULL,
  email varchar NOT NULL
);
CREATE UNIQUE INDEX tbl_user_real_name ON tbl_user (real_name);
CREATE UNIQUE INDEX tbl_user_user_name ON tbl_user (user_name);
--
-- Table: tbl_venue
--
CREATE TABLE tbl_venue (
  venue_id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  time_zone varchar NOT NULL
);
CREATE UNIQUE INDEX tbl_venue_name ON tbl_venue (name);
--
-- Table: tbl_game
--
CREATE TABLE tbl_game (
  game_id INTEGER PRIMARY KEY NOT NULL,
  season integer NOT NULL,
  round integer NOT NULL,
  venue_id integer NOT NULL,
  start_time_utc timestamp NOT NULL,
  has_ended boolean NOT NULL DEFAULT '0'
);
CREATE INDEX tbl_game_idx_venue_id ON tbl_game (venue_id);
--
-- Table: tbl_venue_sponsorname
--
CREATE TABLE tbl_venue_sponsorname (
  venue_id integer NOT NULL,
  name varchar NOT NULL,
  start_year integer,
  end_year integer,
  PRIMARY KEY (venue_id, name)
);
CREATE INDEX tbl_venue_sponsorname_idx_venue_id ON tbl_venue_sponsorname (venue_id);
--
-- Table: tbl_competition_user
--
CREATE TABLE tbl_competition_user (
  user_id integer NOT NULL,
  competition_id integer NOT NULL,
  can_submit_tips_for_others boolean NOT NULL DEFAULT '0',
  can_change_closed_tips boolean NOT NULL DEFAULT '0',
  can_grant_powers boolean NOT NULL DEFAULT '0',
  screen_name varchar,
  PRIMARY KEY (user_id, competition_id)
);
CREATE INDEX tbl_competition_user_idx_competition_id ON tbl_competition_user (competition_id);
CREATE INDEX tbl_competition_user_idx_user_id ON tbl_competition_user (user_id);
CREATE UNIQUE INDEX tbl_competition_user_competition_id_screen_name ON tbl_competition_user (competition_id, screen_name);
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
-- Table: tbl_game_team
--
CREATE TABLE tbl_game_team (
  game_id integer NOT NULL,
  behinds integer NOT NULL DEFAULT 0,
  is_home_team boolean NOT NULL,
  team_id integer NOT NULL,
  goals integer NOT NULL DEFAULT 0,
  PRIMARY KEY (game_id, team_id)
);
CREATE INDEX tbl_game_team_idx_game_id ON tbl_game_team (game_id);
CREATE INDEX tbl_game_team_idx_team_id ON tbl_game_team (team_id);
CREATE UNIQUE INDEX tbl_game_team_game_id_is_home_team ON tbl_game_team (game_id, is_home_team);
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