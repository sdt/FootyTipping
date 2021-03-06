-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sun Jun 19 11:53:26 2011
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
-- Table: tbl_game
--
CREATE TABLE "tbl_game" (
  "game_id" serial NOT NULL,
  "round" integer NOT NULL,
  "venue_id" integer NOT NULL,
  "start_time_utc" timestamp NOT NULL,
  "has_ended" boolean DEFAULT '0' NOT NULL,
  PRIMARY KEY ("game_id")
);
CREATE INDEX "tbl_game_idx_venue_id" on "tbl_game" ("venue_id");

;
--
-- Table: tbl_round_result_timestamp
--
CREATE TABLE "tbl_round_result_timestamp" (
  "competition_id" integer NOT NULL,
  "round" integer NOT NULL,
  "timestamp" timestamp NOT NULL,
  PRIMARY KEY ("competition_id", "round")
);
CREATE INDEX "tbl_round_result_timestamp_idx_competition_id" on "tbl_round_result_timestamp" ("competition_id");

;
--
-- Table: tbl_user
--
CREATE TABLE "tbl_user" (
  "user_id" serial NOT NULL,
  "username" character varying NOT NULL,
  "real_name" character varying NOT NULL,
  "email" character varying NOT NULL,
  "team_id" integer,
  "password" character(50) NOT NULL,
  "is_superuser" boolean DEFAULT '0' NOT NULL,
  PRIMARY KEY ("user_id"),
  CONSTRAINT "tbl_user_real_name" UNIQUE ("real_name"),
  CONSTRAINT "tbl_user_username" UNIQUE ("username")
);
CREATE INDEX "tbl_user_idx_team_id" on "tbl_user" ("team_id");

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
-- Table: tbl_game_team
--
CREATE TABLE "tbl_game_team" (
  "game_id" integer NOT NULL,
  "behinds" integer DEFAULT 0 NOT NULL,
  "is_home_team" boolean NOT NULL,
  "team_id" integer NOT NULL,
  "goals" integer DEFAULT 0 NOT NULL,
  PRIMARY KEY ("game_id", "team_id"),
  CONSTRAINT "tbl_game_team_game_id_is_home_team" UNIQUE ("game_id", "is_home_team")
);
CREATE INDEX "tbl_game_team_idx_game_id" on "tbl_game_team" ("game_id");
CREATE INDEX "tbl_game_team_idx_team_id" on "tbl_game_team" ("team_id");

;
--
-- Table: tbl_membership
--
CREATE TABLE "tbl_membership" (
  "membership_id" serial NOT NULL,
  "user_id" integer NOT NULL,
  "competition_id" integer NOT NULL,
  "screen_name" character varying,
  "can_submit_tips_for_others" boolean DEFAULT '0' NOT NULL,
  "can_change_closed_tips" boolean DEFAULT '0' NOT NULL,
  "can_change_permissions" boolean DEFAULT '0' NOT NULL,
  PRIMARY KEY ("membership_id"),
  CONSTRAINT "tbl_membership_competition_id_screen_name" UNIQUE ("competition_id", "screen_name"),
  CONSTRAINT "tbl_membership_user_id_competition_id" UNIQUE ("user_id", "competition_id")
);
CREATE INDEX "tbl_membership_idx_competition_id" on "tbl_membership" ("competition_id");
CREATE INDEX "tbl_membership_idx_user_id" on "tbl_membership" ("user_id");

;
--
-- Table: tbl_round_result
--
CREATE TABLE "tbl_round_result" (
  "membership_id" integer NOT NULL,
  "round" integer NOT NULL,
  "score" integer NOT NULL,
  PRIMARY KEY ("membership_id", "round")
);
CREATE INDEX "tbl_round_result_idx_membership_id" on "tbl_round_result" ("membership_id");

;
--
-- Table: tbl_tip
--
CREATE TABLE "tbl_tip" (
  "membership_id" integer NOT NULL,
  "submitter_id" integer NOT NULL,
  "game_id" integer NOT NULL,
  "home_team_to_win" boolean NOT NULL,
  "timestamp" timestamp NOT NULL,
  PRIMARY KEY ("membership_id", "game_id", "timestamp")
);
CREATE INDEX "tbl_tip_idx_game_id" on "tbl_tip" ("game_id");
CREATE INDEX "tbl_tip_idx_membership_id" on "tbl_tip" ("membership_id");
CREATE INDEX "tbl_tip_idx_submitter_id" on "tbl_tip" ("submitter_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "tbl_game" ADD FOREIGN KEY ("venue_id")
  REFERENCES "tbl_venue" ("venue_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_round_result_timestamp" ADD FOREIGN KEY ("competition_id")
  REFERENCES "tbl_competition" ("competition_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_user" ADD FOREIGN KEY ("team_id")
  REFERENCES "tbl_team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_venue_sponsorname" ADD FOREIGN KEY ("venue_id")
  REFERENCES "tbl_venue" ("venue_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_game_team" ADD FOREIGN KEY ("game_id")
  REFERENCES "tbl_game" ("game_id") ON DELETE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_game_team" ADD FOREIGN KEY ("team_id")
  REFERENCES "tbl_team" ("team_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_membership" ADD FOREIGN KEY ("competition_id")
  REFERENCES "tbl_competition" ("competition_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_membership" ADD FOREIGN KEY ("user_id")
  REFERENCES "tbl_user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_round_result" ADD FOREIGN KEY ("membership_id")
  REFERENCES "tbl_membership" ("membership_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("game_id")
  REFERENCES "tbl_game" ("game_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("membership_id")
  REFERENCES "tbl_membership" ("membership_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tbl_tip" ADD FOREIGN KEY ("submitter_id")
  REFERENCES "tbl_user" ("user_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

