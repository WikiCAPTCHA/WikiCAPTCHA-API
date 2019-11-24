-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Creato il: Nov 23, 2019 alle 23:04
-- Versione del server: 10.3.18-MariaDB-0+deb10u1
-- Versione PHP: 7.3.11-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wikicaptcha`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_app`
--

CREATE TABLE `wcaptcha_app` (
  `app_ID` int(10) UNSIGNED NOT NULL,
  `app_name` varchar(11) NOT NULL,
  `app_minquestions` int(11) NOT NULL DEFAULT 2 COMMENT 'Minimum number of good questions'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='A CAPTCHA configuration for a specific website' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_appuser`
--

CREATE TABLE `wcaptcha_appuser` (
  `app_ID` int(10) UNSIGNED NOT NULL,
  `user_ID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Set the App ownership to some User(s)' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_challenge`
--

CREATE TABLE `wcaptcha_challenge` (
  `challenge_ID` int(10) UNSIGNED NOT NULL,
  `challenge_type` enum('img','text','option') NOT NULL,
  `challenge_text` text DEFAULT NULL COMMENT 'Rendered text of the question (if needed)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_challenge_connotation`
--

CREATE TABLE `wcaptcha_challenge_connotation` (
  `challenge_ID` int(10) UNSIGNED NOT NULL,
  `connotation_ID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='A Challenge can have multiple Connotations (what are the instance of pig of color red?)' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_connotation`
--

CREATE TABLE `wcaptcha_connotation` (
  `connotation_ID` int(10) UNSIGNED NOT NULL,
  `connotation_type` enum('positive','negative') NOT NULL,
  `wikidata_property` varchar(32) NOT NULL COMMENT 'Wikidata property',
  `wikidata_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Statements in the form of subject–predicate–object' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_image`
--

CREATE TABLE `wcaptcha_image` (
  `image_ID` int(10) UNSIGNED NOT NULL,
  `image_src` text NOT NULL,
  `commons_pageid` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_image_connotation`
--

CREATE TABLE `wcaptcha_image_connotation` (
  `image_ID` int(10) UNSIGNED NOT NULL,
  `connotation_ID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='An Image can have multiple Connotations (this image depicts a toaster and Barack Obama)' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_question`
--

CREATE TABLE `wcaptcha_question` (
  `question_ID` int(10) UNSIGNED NOT NULL,
  `question_image` int(10) UNSIGNED DEFAULT NULL COMMENT 'If the Challenge was of kind Image',
  `question_answer` text DEFAULT NULL COMMENT '1 if yes, -1 if no, 0 if maybe no, string if Challenge kind is text',
  `challenge_ID` int(10) UNSIGNED NOT NULL COMMENT 'The Challenge gives the meaning of this Question',
  `session_ID` int(10) UNSIGNED NOT NULL COMMENT 'This Question is connected to a precise Session'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='A precise Question, but also its Answer' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_session`
--

CREATE TABLE `wcaptcha_session` (
  `session_ID` int(10) UNSIGNED NOT NULL,
  `session_ip` varchar(16) DEFAULT NULL,
  `app_ID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_taxonomy`
--

CREATE TABLE `wcaptcha_taxonomy` (
  `connotation_generic` int(10) UNSIGNED NOT NULL,
  `connotation_specific` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='A Connotation may have a more generic Connotation (like an instance of Human is a generic form of instance of Mammal)' ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struttura della tabella `wcaptcha_user`
--

CREATE TABLE `wcaptcha_user` (
  `user_ID` int(10) UNSIGNED NOT NULL,
  `user_uid` varchar(128) NOT NULL,
  `user_email` varchar(128) NOT NULL,
  `user_password` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `wcaptcha_app`
--
ALTER TABLE `wcaptcha_app`
  ADD PRIMARY KEY (`app_ID`);

--
-- Indici per le tabelle `wcaptcha_appuser`
--
ALTER TABLE `wcaptcha_appuser`
  ADD PRIMARY KEY (`app_ID`,`user_ID`),
  ADD KEY `user_ID` (`user_ID`);

--
-- Indici per le tabelle `wcaptcha_challenge`
--
ALTER TABLE `wcaptcha_challenge`
  ADD PRIMARY KEY (`challenge_ID`);

--
-- Indici per le tabelle `wcaptcha_challenge_connotation`
--
ALTER TABLE `wcaptcha_challenge_connotation`
  ADD PRIMARY KEY (`challenge_ID`,`connotation_ID`),
  ADD KEY `challenge_connotation_ibfk_1` (`connotation_ID`);

--
-- Indici per le tabelle `wcaptcha_connotation`
--
ALTER TABLE `wcaptcha_connotation`
  ADD KEY `image_ID` (`connotation_ID`);

--
-- Indici per le tabelle `wcaptcha_image`
--
ALTER TABLE `wcaptcha_image`
  ADD UNIQUE KEY `image_ID` (`image_ID`),
  ADD UNIQUE KEY `commons_pageid` (`commons_pageid`);

--
-- Indici per le tabelle `wcaptcha_image_connotation`
--
ALTER TABLE `wcaptcha_image_connotation`
  ADD PRIMARY KEY (`connotation_ID`),
  ADD KEY `image_ID` (`image_ID`);

--
-- Indici per le tabelle `wcaptcha_question`
--
ALTER TABLE `wcaptcha_question`
  ADD PRIMARY KEY (`question_ID`),
  ADD KEY `session_ID` (`session_ID`),
  ADD KEY `challenge_ID` (`challenge_ID`),
  ADD KEY `question_image` (`question_image`);

--
-- Indici per le tabelle `wcaptcha_session`
--
ALTER TABLE `wcaptcha_session`
  ADD PRIMARY KEY (`session_ID`),
  ADD KEY `app_ID` (`app_ID`);

--
-- Indici per le tabelle `wcaptcha_taxonomy`
--
ALTER TABLE `wcaptcha_taxonomy`
  ADD PRIMARY KEY (`connotation_generic`,`connotation_specific`),
  ADD KEY `connotation_specific` (`connotation_specific`);

--
-- Indici per le tabelle `wcaptcha_user`
--
ALTER TABLE `wcaptcha_user`
  ADD PRIMARY KEY (`user_ID`),
  ADD UNIQUE KEY `user_uid` (`user_uid`),
  ADD KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `wcaptcha_image`
--
ALTER TABLE `wcaptcha_image`
  MODIFY `image_ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `wcaptcha_app`
--
ALTER TABLE `wcaptcha_app`
  ADD CONSTRAINT `wcaptcha_app_ibfk_1` FOREIGN KEY (`app_ID`) REFERENCES `wcaptcha_appuser` (`app_ID`);

--
-- Limiti per la tabella `wcaptcha_appuser`
--
ALTER TABLE `wcaptcha_appuser`
  ADD CONSTRAINT `wcaptcha_appuser_ibfk_1` FOREIGN KEY (`app_ID`) REFERENCES `wcaptcha_app` (`app_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `wcaptcha_appuser_ibfk_2` FOREIGN KEY (`user_ID`) REFERENCES `wcaptcha_user` (`user_ID`) ON DELETE CASCADE;

--
-- Limiti per la tabella `wcaptcha_challenge_connotation`
--
ALTER TABLE `wcaptcha_challenge_connotation`
  ADD CONSTRAINT `wcaptcha_challenge_connotation_ibfk_1` FOREIGN KEY (`connotation_ID`) REFERENCES `wcaptcha_connotation` (`connotation_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `wcaptcha_challenge_connotation_ibfk_2` FOREIGN KEY (`challenge_ID`) REFERENCES `wcaptcha_challenge` (`challenge_ID`) ON DELETE CASCADE;

--
-- Limiti per la tabella `wcaptcha_image_connotation`
--
ALTER TABLE `wcaptcha_image_connotation`
  ADD CONSTRAINT `wcaptcha_image_connotation_ibfk_1` FOREIGN KEY (`image_ID`) REFERENCES `wcaptcha_image` (`image_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `wcaptcha_image_connotation_ibfk_2` FOREIGN KEY (`connotation_ID`) REFERENCES `wcaptcha_connotation` (`connotation_ID`) ON DELETE CASCADE;

--
-- Limiti per la tabella `wcaptcha_question`
--
ALTER TABLE `wcaptcha_question`
  ADD CONSTRAINT `wcaptcha_question_ibfk_1` FOREIGN KEY (`challenge_ID`) REFERENCES `wcaptcha_challenge` (`challenge_ID`),
  ADD CONSTRAINT `wcaptcha_question_ibfk_2` FOREIGN KEY (`session_ID`) REFERENCES `wcaptcha_session` (`session_ID`);

--
-- Limiti per la tabella `wcaptcha_session`
--
ALTER TABLE `wcaptcha_session`
  ADD CONSTRAINT `wcaptcha_session_ibfk_1` FOREIGN KEY (`app_ID`) REFERENCES `wcaptcha_app` (`app_ID`) ON DELETE CASCADE;

--
-- Limiti per la tabella `wcaptcha_taxonomy`
--
ALTER TABLE `wcaptcha_taxonomy`
  ADD CONSTRAINT `wcaptcha_taxonomy_ibfk_1` FOREIGN KEY (`connotation_generic`) REFERENCES `wcaptcha_connotation` (`connotation_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `wcaptcha_taxonomy_ibfk_2` FOREIGN KEY (`connotation_specific`) REFERENCES `wcaptcha_connotation` (`connotation_ID`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
