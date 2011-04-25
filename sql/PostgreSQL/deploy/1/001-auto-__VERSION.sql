-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Mon Apr 25 20:22:19 2011
-- 
;
--
-- Table: dbix_class_deploymenthandler_versions
--
DROP TABLE "dbix_class_deploymenthandler_versions" CASCADE;
CREATE TABLE "dbix_class_deploymenthandler_versions" (
  "id" serial NOT NULL,
  "version" character varying(50) NOT NULL,
  "ddl" text,
  "upgrade_sql" text,
  PRIMARY KEY ("id"),
  CONSTRAINT "dbix_class_deploymenthandler_versions_version" UNIQUE ("version")
);

