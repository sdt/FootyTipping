-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon May 23 09:29:51 2011
-- 
;
SET foreign_key_checks=0;
--
-- Table: `dbix_class_deploymenthandler_versions`
--
CREATE TABLE `dbix_class_deploymenthandler_versions` (
  `id` integer NOT NULL auto_increment,
  `version` varchar(50) NOT NULL,
  `ddl` text,
  `upgrade_sql` text,
  PRIMARY KEY (`id`),
  UNIQUE `dbix_class_deploymenthandler_versions_version` (`version`)
);
SET foreign_key_checks=1