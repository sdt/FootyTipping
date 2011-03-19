-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Mar 19 22:36:29 2011
-- 
;
--
-- Table: team
--
CREATE TABLE "team" (
  "team_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "nickname" character varying NOT NULL,
  PRIMARY KEY ("team_id")
);

;
--
-- Table: venue
--
CREATE TABLE "venue" (
  "venue_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "sponsor_name" character varying NOT NULL,
  PRIMARY KEY ("venue_id")
);

;
--
-- Table: game
--
CREATE TABLE "game" (
  "round" integer NOT NULL,
  "home_team_id" integer NOT NULL,
  "away_team_id" integer NOT NULL,
  "venue_id" integer NOT NULL,
  "start_time" timestamp with time zone NOT NULL,
  "home_team_goals" integer NOT NULL,
  "home_team_behinds" integer NOT NULL,
  "away_team_goals" integer NOT NULL,
  "away_team_behinds" integer NOT NULL,
  PRIMARY KEY ("venue_id", "start_time")
);
CREATE INDEX "game_idx_away_team_id" on "game" ("away_team_id");
CREATE INDEX "game_idx_home_team_id" on "game" ("home_team_id");
CREATE INDEX "game_idx_venue_id" on "game" ("venue_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "game" ADD FOREIGN KEY ("away_team_id")
  REFERENCES "team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "game" ADD FOREIGN KEY ("home_team_id")
  REFERENCES "team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "game" ADD FOREIGN KEY ("venue_id")
  REFERENCES "venue" ("venue_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

