-- MySQL dump 10.17  Distrib 10.3.17-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: wikicaptcha
-- ------------------------------------------------------
-- Server version	10.3.17-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wcaptcha_app`
--

DROP TABLE IF EXISTS `wcaptcha_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_app` (
  `app_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_name` varchar(128) NOT NULL,
  `app_minquestions` int(11) NOT NULL DEFAULT 2 COMMENT 'Minimum number of good questions',
  PRIMARY KEY (`app_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='A CAPTCHA configuration for a specific website';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_appdomain`
--

DROP TABLE IF EXISTS `wcaptcha_appdomain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_appdomain` (
  `app_ID` int(10) unsigned NOT NULL,
  `domain_ID` int(10) unsigned NOT NULL,
  `appdomain_creationdate` datetime NOT NULL,
  PRIMARY KEY (`app_ID`,`domain_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_appuser`
--

DROP TABLE IF EXISTS `wcaptcha_appuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_appuser` (
  `app_ID` int(10) unsigned NOT NULL,
  `user_ID` int(10) unsigned NOT NULL,
  `appuser_creationdate` datetime NOT NULL,
  PRIMARY KEY (`app_ID`,`user_ID`),
  KEY `user_ID` (`user_ID`),
  CONSTRAINT `wcaptcha_appuser_ibfk_1` FOREIGN KEY (`app_ID`) REFERENCES `wcaptcha_app` (`app_ID`) ON DELETE CASCADE,
  CONSTRAINT `wcaptcha_appuser_ibfk_2` FOREIGN KEY (`user_ID`) REFERENCES `wcaptcha_user` (`user_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='Set the App ownership to some User(s)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_challenge`
--

DROP TABLE IF EXISTS `wcaptcha_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_challenge` (
  `challenge_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `challenge_type` enum('img','text','option') NOT NULL,
  `challenge_text` text DEFAULT NULL COMMENT 'Rendered text of the question (if needed)',
  PRIMARY KEY (`challenge_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_challenge_connotation`
--

DROP TABLE IF EXISTS `wcaptcha_challenge_connotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_challenge_connotation` (
  `challenge_ID` int(10) unsigned NOT NULL,
  `connotation_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`challenge_ID`,`connotation_ID`),
  KEY `challenge_connotation_ibfk_1` (`connotation_ID`),
  CONSTRAINT `wcaptcha_challenge_connotation_ibfk_1` FOREIGN KEY (`challenge_ID`) REFERENCES `wcaptcha_challenge` (`challenge_ID`) ON DELETE CASCADE,
  CONSTRAINT `wcaptcha_challenge_connotation_ibfk_2` FOREIGN KEY (`connotation_ID`) REFERENCES `wcaptcha_connotation` (`connotation_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='A Challenge can have multiple Connotations (what are the instance of pig of color red?)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_connotation`
--

DROP TABLE IF EXISTS `wcaptcha_connotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_connotation` (
  `connotation_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `connotation_comment` varchar(128) DEFAULT NULL,
  `wikidata_property` varchar(32) NOT NULL COMMENT 'Wikidata property',
  `wikidata_value` text NOT NULL,
  PRIMARY KEY (`connotation_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='Statements in the form of subject–predicate–object';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_domain`
--

DROP TABLE IF EXISTS `wcaptcha_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_domain` (
  `domain_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain_name` varchar(254) NOT NULL,
  PRIMARY KEY (`domain_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_image`
--

DROP TABLE IF EXISTS `wcaptcha_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_image` (
  `image_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `image_src` text NOT NULL,
  `commons_pageid` int(10) unsigned DEFAULT NULL,
  UNIQUE KEY `image_ID` (`image_ID`),
  UNIQUE KEY `commons_pageid` (`commons_pageid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_image_connotation`
--

DROP TABLE IF EXISTS `wcaptcha_image_connotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_image_connotation` (
  `image_ID` int(10) unsigned NOT NULL,
  `connotation_ID` int(10) unsigned NOT NULL,
  `image_connotation_positive` enum('positive','negative') NOT NULL,
  PRIMARY KEY (`image_ID`,`connotation_ID`),
  KEY `image_ID` (`image_ID`),
  KEY `connotation_ID` (`connotation_ID`),
  CONSTRAINT `wcaptcha_image_connotation_ibfk_1` FOREIGN KEY (`connotation_ID`) REFERENCES `wcaptcha_connotation` (`connotation_ID`) ON DELETE CASCADE,
  CONSTRAINT `wcaptcha_image_connotation_ibfk_2` FOREIGN KEY (`image_ID`) REFERENCES `wcaptcha_image` (`image_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='An Image can have multiple Connotations (this image depicts a toaster and Barack Obama)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_question`
--

DROP TABLE IF EXISTS `wcaptcha_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_question` (
  `question_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `question_image` int(10) unsigned DEFAULT NULL COMMENT 'If the Challenge was of kind Image',
  `question_answer` text DEFAULT NULL COMMENT '1 if yes, -1 if no, 0 if maybe no, string if Challenge kind is text',
  `challenge_ID` int(10) unsigned NOT NULL COMMENT 'The Challenge gives the meaning of this Question',
  `session_ID` int(10) unsigned NOT NULL COMMENT 'This Question is connected to a precise Session',
  PRIMARY KEY (`question_ID`),
  KEY `session_ID` (`session_ID`),
  KEY `challenge_ID` (`challenge_ID`),
  KEY `question_image` (`question_image`),
  CONSTRAINT `wcaptcha_question_ibfk_2` FOREIGN KEY (`session_ID`) REFERENCES `wcaptcha_session` (`session_ID`),
  CONSTRAINT `wcaptcha_question_ibfk_3` FOREIGN KEY (`challenge_ID`) REFERENCES `wcaptcha_challenge` (`challenge_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='A precise Question, but also its Answer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_session`
--

DROP TABLE IF EXISTS `wcaptcha_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_session` (
  `session_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_ip` blob DEFAULT NULL,
  `app_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`session_ID`),
  KEY `app_ID` (`app_ID`),
  CONSTRAINT `wcaptcha_session_ibfk_1` FOREIGN KEY (`app_ID`) REFERENCES `wcaptcha_app` (`app_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_taxonomy`
--

DROP TABLE IF EXISTS `wcaptcha_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_taxonomy` (
  `connotation_generic` int(10) unsigned NOT NULL,
  `connotation_specific` int(10) unsigned NOT NULL,
  PRIMARY KEY (`connotation_generic`,`connotation_specific`),
  KEY `connotation_specific` (`connotation_specific`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='A Connotation may have a more generic Connotation (like an instance of Human is a generic form of instance of Mammal)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wcaptcha_user`
--

DROP TABLE IF EXISTS `wcaptcha_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wcaptcha_user` (
  `user_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_uid` varchar(128) NOT NULL,
  `user_role` enum('user','analist') NOT NULL,
  `user_active` int(11) NOT NULL DEFAULT 0,
  `user_email` varchar(128) NOT NULL,
  `user_password` varchar(64) NOT NULL,
  PRIMARY KEY (`user_ID`),
  UNIQUE KEY `user_uid` (`user_uid`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-29 20:25:52
