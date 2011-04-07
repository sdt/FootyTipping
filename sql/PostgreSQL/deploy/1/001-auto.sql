-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Thu Apr  7 17:07:38 2011
-- 
;
--
-- Table: tbl_competition
--
CREATE TABLE "tbl_competition" (
  "competition_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "password" character varying,
  PRIMARY KEY ("competition_id"),
  CONSTRAINT "tbl_competition_name" UNIQUE ("name")
);

;
--
-- Table: tbl_team
--
CREATE TABLE "tbl_team" (
  "team_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "nickname" character varying NOT NULL,
  PRIMARY KEY ("team_id"),
  CONSTRAINT "tbl_team_name" UNIQUE ("name"),
  CONSTRAINT "tbl_team_nickname" UNIQUE ("nickname")
);

;
--
-- Table: tbl_user
--
CREATE TABLE "tbl_user" (
  "user_id" serial NOT NULL,
  "user_name" character varying NOT NULL,
  "password" character varying NOT NULL,
  "real_name" character varying NOT NULL,
  "email" character varying NOT NULL,
  PRIMARY KEY ("user_id"),
  CONSTRAINT "tbl_user_real_name" UNIQUE ("real_name"),
  CONSTRAINT "tbl_user_user_name" UNIQUE ("user_name")
);

;
--
-- Table: tbl_venue
--
CREATE TABLE "tbl_venue" (
  "venue_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "time_zone" character varying NOT NULL,
  PRIMARY KEY ("venue_id"),
  CONSTRAINT "tbl_venue_name" UNIQUE ("name")
);

;
--
-- Table: tbl_venue_sponsorname
--
CREATE TABLE "tbl_venue_sponsorname" (
  "venue_id" serial NOT NULL,
  "name" character varying NOT NULL,
  "start_year" integer,
  "end_year" integer,
  PRIMARY KEY ("venue_id", "name")
);
CREATE INDEX "tbl_venue_sponsorname_idx_venue_id" on "tbl_venue_sponsorname" ("venue_id");

;
--
-- Table: tbl_competition_user
--
CREATE TABLE "tbl_competition_user" (
  "user_id" integer NOT NULL,
  "competition_id" integer NOT NULL,
  "can_submit_tips_for_others" boolean DEFAULT '0' NOT NULL,
  "can_change_closed_tips" boolean DEFAULT '0' NOT NULL,
  "can_grant_powers" boolean DEFAULT '0' NOT NULL,
  "screen_name" character varying,
  PRIMARY KEY ("user_id", "competition_id"),
  CONSTRAINT "tbl_competition_user_competition_id_screen_name" UNIQUE ("competition_id", "screen_name")
);
CREATE INDEX "tbl_competition_user_idx_competition_id" on "tbl_competition_user" ("competition_id");
CREATE INDEX "tbl_competition_user_idx_user_id" on "tbl_competition_user" ("user_id");

;
--
-- Table: tbl_game
--
CREATE TABLE "tbl_game" (
  "game_id" serial NOT NULL,
  "season" integer NOT NULL,
  "round" integer NOT NULL,
  "home_team_id" integer NOT NULL,
  "away_team_id" integer NOT NULL,
  "venue_id" integer NOT NULL,
  "start_time_utc" timestamp NOT NULL,
  "home_team_goals" integer DEFAULT 0 NOT NULL,
  "home_team_behinds" integer DEFAULT 0 NOT NULL,
  "away_team_goals" integer DEFAULT 0 NOT NULL,
  "away_team_behinds" integer DEFAULT 0 NOT NULL,
  "has_ended" boolean DEFAULT '0' NOT NULL,
  PRIMARY KEY ("game_id"),
  CONSTRAINT "tbl_game_season_round_away_team_id" UNIQUE ("season", "round", "away_team_id"),
  CONSTRAINT "tbl_game_season_round_home_team_id" UNIQUE ("season", "round", "home_team_id")
);
CREATE INDEX "tbl_game_idx_away_team_id" on "tbl_game" ("away_team_id");
CREATE INDEX "tbl_game_idx_home_team_id" on "tbl_game" ("home_team_id");
CREATE INDEX "tbl_game_idx_venue_id" on "tbl_game" ("venue_id");

;
--
-- Table: tbl_team_supporter
--
CREATE TABLE "tbl_team_supporter" (
  "user_id" integer NOT NULL,
  "team_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "team_id"),
  CONSTRAINT "tbl_team_supporter_user_id" UNIQUE ("user_id")
);
CREATE INDEX "tbl_team_supporter_idx_user_id" on "tbl_team_supporter" ("user_id");
CREATE INDEX "tbl_team_supporter_idx_team_id" on "tbl_team_supporter" ("team_id");

;
--
-- Table: tbl_tip
--
CREATE TABLE "tbl_tip" (
  "tipper_id" integer NOT NULL,
  "submitter_id" integer NOT NULL,
  "competition_id" integer NOT NULL,
  "game_id" integer NOT NULL,
  "home_team_to_win" boolean NOT NULL,
  "timestamp" timestamp NOT NULL,
  PRIMARY KEY ("tipper_id", "competition_id", "game_id", "timestamp")
);
CREATE INDEX "tbl_tip_idx_competition_id" on "tbl_tip" ("competition_id");
CREATE INDEX "tbl_tip_idx_game_id" on "tbl_tip" ("game_id");
CREATE INDEX "tbl_tip_idx_submitter_id" on "tbl_tip" ("submitter_id");
CREATE INDEX "tbl_tip_idx_tipper_id" on "tbl_tip" ("tipper_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "tbl_venue_sponsorname" ADD FOREIGN KEY ("venue_id")
  REFERENCES "tbl_venue" ("venue_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_competition_user" ADD FOREIGN KEY ("competition_id")
  REFERENCES "tbl_competition" ("competition_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_competition_user" ADD FOREIGN KEY ("user_id")
  REFERENCES "tbl_user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_game" ADD FOREIGN KEY ("away_team_id")
  REFERENCES "tbl_team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_game" ADD FOREIGN KEY ("home_team_id")
  REFERENCES "tbl_team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_game" ADD FOREIGN KEY ("venue_id")
  REFERENCES "tbl_venue" ("venue_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_team_supporter" ADD FOREIGN KEY ("user_id")
  REFERENCES "tbl_user" ("user_id") ON DELETE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_team_supporter" ADD FOREIGN KEY ("team_id")
  REFERENCES "tbl_team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("competition_id")
  REFERENCES "tbl_competition" ("competition_id") DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("game_id")
  REFERENCES "tbl_game" ("game_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("submitter_id")
  REFERENCES "tbl_user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("tipper_id")
  REFERENCES "tbl_user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

