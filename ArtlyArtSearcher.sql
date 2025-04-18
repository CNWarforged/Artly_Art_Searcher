-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_phillj26
-- ------------------------------------------------------
-- Server version	5.5.5-10.11.11-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ArtPeriods`
--

DROP TABLE IF EXISTS `ArtPeriods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ArtPeriods` (
  `periodID` varchar(10) NOT NULL,
  `century` varchar(45) NOT NULL,
  `centuryPart` varchar(45) NOT NULL,
  PRIMARY KEY (`periodID`),
  UNIQUE KEY `periodID_UNIQUE` (`periodID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ArtPeriods`
--

LOCK TABLES `ArtPeriods` WRITE;
/*!40000 ALTER TABLE `ArtPeriods` DISABLE KEYS */;
INSERT INTO `ArtPeriods` VALUES ('18e','1700','early'),('18l','1700','late'),('18m','1700','mid'),('19e','1800','early'),('19l','1800','late'),('19m','1800','mid'),('20e','1900','early'),('20l','1900','late'),('20m','1900','mid'),('21e','2000','early'),('21l','2000','late'),('21m','2000','mid');
/*!40000 ALTER TABLE `ArtPeriods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Artists`
--

DROP TABLE IF EXISTS `Artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Artists` (
  `artistID` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(300) NOT NULL,
  `genderCode` varchar(10) NOT NULL,
  `queer` tinyint(2) DEFAULT NULL,
  `countryResidence` varchar(100) DEFAULT NULL,
  `stateResidence` varchar(10) DEFAULT NULL,
  `cityResidence` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`artistID`),
  UNIQUE KEY `artistID_UNIQUE` (`artistID`),
  KEY `genderID_idx` (`genderCode`),
  CONSTRAINT `genderID` FOREIGN KEY (`genderCode`) REFERENCES `GenderCodes` (`genderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artists`
--

LOCK TABLES `Artists` WRITE;
/*!40000 ALTER TABLE `Artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `Artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Artworks`
--

DROP TABLE IF EXISTS `Artworks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Artworks` (
  `artworkID` int(11) NOT NULL AUTO_INCREMENT,
  `digitalArt` tinyint(3) NOT NULL,
  `artistID` int(11) NOT NULL,
  `dateCreated` date NOT NULL,
  `artPeriodCode` varchar(10) NOT NULL,
  `artMediumCode` varchar(25) NOT NULL,
  PRIMARY KEY (`artworkID`),
  UNIQUE KEY `artworkID_UNIQUE` (`artworkID`),
  KEY `mediumID_idx` (`artMediumCode`),
  KEY `periodID_idx` (`artPeriodCode`),
  CONSTRAINT `mediumID` FOREIGN KEY (`artMediumCode`) REFERENCES `Mediums` (`mediumID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `periodID` FOREIGN KEY (`artPeriodCode`) REFERENCES `ArtPeriods` (`periodID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artworks`
--

LOCK TABLES `Artworks` WRITE;
/*!40000 ALTER TABLE `Artworks` DISABLE KEYS */;
/*!40000 ALTER TABLE `Artworks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GenderCodes`
--

DROP TABLE IF EXISTS `GenderCodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GenderCodes` (
  `genderID` varchar(10) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`genderID`),
  UNIQUE KEY `genderID_UNIQUE` (`genderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GenderCodes`
--

LOCK TABLES `GenderCodes` WRITE;
/*!40000 ALTER TABLE `GenderCodes` DISABLE KEYS */;
INSERT INTO `GenderCodes` VALUES ('F','Cis Female'),('IS','Intersex'),('M','Cis Male'),('NB','Non-Binary'),('TF','Trans Female'),('TM','Trans Male'),('TS','Two Spirit'),('U','Unknown');
/*!40000 ALTER TABLE `GenderCodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Mediums`
--

DROP TABLE IF EXISTS `Mediums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Mediums` (
  `mediumID` varchar(25) NOT NULL,
  `mediumDescription` varchar(50) NOT NULL,
  PRIMARY KEY (`mediumID`),
  UNIQUE KEY `mediumID_UNIQUE` (`mediumID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mediums`
--

LOCK TABLES `Mediums` WRITE;
/*!40000 ALTER TABLE `Mediums` DISABLE KEYS */;
INSERT INTO `Mediums` VALUES ('A','Acrylic'),('CG','Computer Graphics or Digital Art'),('MM','Mixed Media'),('O','Oil'),('P','Photography');
/*!40000 ALTER TABLE `Mediums` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-18 14:39:45
