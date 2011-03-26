-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Mar 26 20:57:47 2011
-- 
;
--
-- Table: competition
--
CREATE TABLE "competition" (
  "competition_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "password" character varying,
  PRIMARY KEY ("competition_id"),
  CONSTRAINT "competition_name" UNIQUE ("name")
);

;
--
-- Table: team
--
CREATE TABLE "team" (
  "team_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "nickname" character varying NOT NULL,
  PRIMARY KEY ("team_id"),
  CONSTRAINT "team_name" UNIQUE ("name"),
  CONSTRAINT "team_nickname" UNIQUE ("nickname")
);

;
--
-- Table: user
--
CREATE TABLE "user" (
  "user_id" serial NOT NULL,
  "user_name" character varying NOT NULL,
  "real_name" character varying NOT NULL,
  "screen_name" character varying,
  "password" character varying NOT NULL,
  PRIMARY KEY ("user_id"),
  CONSTRAINT "user_real_name" UNIQUE ("real_name"),
  CONSTRAINT "user_screen_name" UNIQUE ("screen_name"),
  CONSTRAINT "user_user_name" UNIQUE ("user_name")
);

;
--
-- Table: venue
--
CREATE TABLE "venue" (
  "venue_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "sponsor_name" character varying NOT NULL,
  PRIMARY KEY ("venue_id"),
  CONSTRAINT "venue_name" UNIQUE ("name"),
  CONSTRAINT "venue_sponsor_name" UNIQUE ("sponsor_name")
);

;
--
-- Table: competition_user
--
CREATE TABLE "competition_user" (
  "user_id" integer NOT NULL,
  "competition_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "competition_id")
);
CREATE INDEX "competition_user_idx_competition_id" on "competition_user" ("competition_id");
CREATE INDEX "competition_user_idx_user_id" on "competition_user" ("user_id");

;
--
-- Table: game
--
CREATE TABLE "game" (
  "game_id" serial NOT NULL,
  "season" integer NOT NULL,
  "round" integer NOT NULL,
  "home_team_id" integer NOT NULL,
  "away_team_id" integer NOT NULL,
  "venue_id" integer NOT NULL,
  "home_team_goals" integer DEFAULT 0 NOT NULL,
  "home_team_behinds" integer DEFAULT 0 NOT NULL,
  "away_team_goals" integer DEFAULT 0 NOT NULL,
  "away_team_behinds" integer DEFAULT 0 NOT NULL,
  PRIMARY KEY ("game_id"),
  CONSTRAINT "game_season_round_away_team_id" UNIQUE ("season", "round", "away_team_id"),
  CONSTRAINT "game_season_round_home_team_id" UNIQUE ("season", "round", "home_team_id")
);
CREATE INDEX "game_idx_away_team_id" on "game" ("away_team_id");
CREATE INDEX "game_idx_home_team_id" on "game" ("home_team_id");
CREATE INDEX "game_idx_venue_id" on "game" ("venue_id");

;
--
-- Table: team_user
--
CREATE TABLE "team_user" (
  "user_id" integer NOT NULL,
  "team_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "team_id"),
  CONSTRAINT "team_user_user_id" UNIQUE ("user_id")
);
CREATE INDEX "team_user_idx_team_id" on "team_user" ("team_id");
CREATE INDEX "team_user_idx_user_id" on "team_user" ("user_id");

;
--
-- Table: tip
--
CREATE TABLE "tip" (
  "user_id" integer NOT NULL,
  "game_id" integer NOT NULL,
  "home_team_to_win" boolean NOT NULL,
  PRIMARY KEY ("user_id", "game_id")
);
CREATE INDEX "tip_idx_game_id" on "tip" ("game_id");
CREATE INDEX "tip_idx_user_id" on "tip" ("user_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "competition_user" ADD FOREIGN KEY ("competition_id")
  REFERENCES "competition" ("competition_id") DEFERRABLE;

;
ALTER TABLE "competition_user" ADD FOREIGN KEY ("user_id")
  REFERENCES "user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "game" ADD FOREIGN KEY ("away_team_id")
  REFERENCES "team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "game" ADD FOREIGN KEY ("home_team_id")
  REFERENCES "team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "game" ADD FOREIGN KEY ("venue_id")
  REFERENCES "venue" ("venue_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "team_user" ADD FOREIGN KEY ("team_id")
  REFERENCES "team" ("team_id") DEFERRABLE;

;
ALTER TABLE "team_user" ADD FOREIGN KEY ("user_id")
  REFERENCES "user" ("user_id") ON DELETE CASCADE DEFERRABLE;

;
ALTER TABLE "tip" ADD FOREIGN KEY ("game_id")
  REFERENCES "game" ("game_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tip" ADD FOREIGN KEY ("user_id")
  REFERENCES "user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

