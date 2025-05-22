-- This is our database for our ArtlyArtSearcher project!
-- The database serves as the backend for an archive of artists and their art.
-- ArtistArtworks serves as the connection table between Artists and Artworks.
-- Most of the other tables are category tables to handle the details 
-- we need for the artists or artworks.
-- No AI art will be included in our database.
-- 
-- Project Name: Artly Art Searcher
-- Admins/devs: Allessandra Bakker and Jennifer Phillips

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

DROP TABLE IF EXISTS `Locations`;
DROP TABLE IF EXISTS `GenderCodes`;
DROP TABLE IF EXISTS `Mediums`;
DROP TABLE IF EXISTS `ArtPeriods`;
DROP TABLE IF EXISTS `ArtistArtworks`;
DROP TABLE IF EXISTS `Artists`;
DROP TABLE IF EXISTS `Artworks`;

--
-- Table: `ArtPeriods`
-- This table holds different art periods so the artworks are also searchable by the general 
-- period of time they were created in. The periods are represented by codes  for consistency, 
-- representing a century and then clarifying which part of the century: Early, Mid, or Late.
--

CREATE TABLE `ArtPeriods` (
  `periodID` varchar(10) NOT NULL UNIQUE,
  `century` varchar(45) NOT NULL,
  `centuryPart` varchar(45) NOT NULL,
  PRIMARY KEY (`periodID`)
);

INSERT INTO `ArtPeriods` 
	VALUES ('18e','1700','early'),('18l','1700','late'),('18m','1700','mid'),
	('19e','1800','early'),('19l','1800','late'),('19m','1800','mid'),
	('20e','1900','early'),('20l','1900','late'),('20m','1900','mid'),
	('21e','2000','early'),('21l','2000','late'),('21m','2000','mid');

--
-- Table: `GenderCodes`
-- This is to allow a user to search for artists of a certain gender on our website. The genders 
-- are represented by codes for consistency.
--

CREATE TABLE `GenderCodes` (
  `genderID` varchar(10) NOT NULL UNIQUE,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`genderID`)
);

INSERT INTO `GenderCodes` 
VALUES ('F','Cis Female'),
('IS','Intersex'),
('M','Cis Male'),
('NB','Non-Binary'),
('TF','Trans Female'),
('TM','Trans Male'),
('TS','Two Spirit'),
('U','Unknown');

--
-- Table: `Mediums`
-- These are codes to represent different artistic mediums (like acrylic, oil, photography, mixed media, etc.).
--

CREATE TABLE `Mediums` (
  `mediumID` varchar(25) NOT NULL UNIQUE,
  `mediumDescription` varchar(50) NOT NULL,
  PRIMARY KEY (`mediumID`)
);

INSERT INTO `Mediums` 
VALUES ('A','Acrylic'),
('CG','Computer Graphics or Digital Art'),
('MM','Mixed Media'),
('O','Oil'),
('P','Photography');

--
-- Table: `Locations`
-- This table holds locations associated with the artists. We’ll use these locations to hold the artist’s birth 
-- location and main residence as far as the information is known.
--

CREATE TABLE `Locations` (
  `locationID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
  `country` varchar(100) NOT NULL,
  `state` varchar(5) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`locationID`)
);

INSERT INTO `Locations` 
VALUES (1,'USA','AL',NULL),(2,'USA','AK',NULL),(3,'USA','AR',NULL),(4,'USA','AZ',NULL),(5,'USA','CA',NULL),(6,'USA','CO',NULL),(7,'USA','CT',NULL),(8,'USA','DE',NULL),(9,'USA','FL',NULL),(10,'USA','GA',NULL),(11,'USA','HI',NULL),(12,'USA','ID',NULL),(13,'USA','IL',NULL),(14,'USA','IN',NULL),(15,'USA','IA',NULL),(16,'USA','KS',NULL),(17,'USA','KY',NULL),(18,'USA','LA',NULL),(19,'USA','ME',NULL),(20,'USA','MD',NULL),(21,'USA','MA',NULL),(22,'USA','MI',NULL),(23,'USA','MN',NULL),(24,'USA','MS',NULL),(25,'USA','MO',NULL),(26,'USA','MT',NULL),(27,'USA','NE',NULL),(28,'USA','NV',NULL),(29,'USA','NH',NULL),(30,'USA','NJ',NULL),(31,'USA','NM',NULL),(32,'USA','NY',NULL),(33,'USA','NC',NULL),(34,'USA','ND',NULL),(35,'USA','OH',NULL),(36,'USA','OK',NULL),(37,'USA','OR',NULL),(38,'USA','PA',NULL),(39,'USA','RI',NULL),(40,'USA','SC',NULL),(41,'USA','SD',NULL),(42,'USA','TN',NULL),(43,'USA','TX',NULL),(44,'USA','UT',NULL),(45,'USA','VT',NULL),(46,'USA','VA',NULL),(47,'USA','WA',NULL),(48,'USA','WV',NULL),(49,'USA','WI',NULL),(50,'USA','WY',NULL),(51,'USA','DC',NULL),(52,'USA','AS',NULL),(53,'USA','GU',NULL),(54,'USA','MP',NULL),(55,'USA','PR',NULL),(56,'USA','UM',NULL),(57,'USA','VI',NULL),(58,'The Netherlands',NULL,NULL),(59,'Mexico',NULL,'Mexico City');

--
-- Table: `Artists`
-- This holds the names and information of the artists we’re tracking.
--

CREATE TABLE `Artists` (
  `artistID` int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  `fullName` varchar(300) NOT NULL,
  `genderCode` varchar(10) NOT NULL,
  `queer` tinyint(2) DEFAULT NULL,
  `residenceLocID` int(11) DEFAULT NULL,
  `birthLocID` int(11) DEFAULT NULL,
  PRIMARY KEY (`artistID`),
  CONSTRAINT `genderID` FOREIGN KEY (`genderCode`) REFERENCES `GenderCodes` (`genderID`) ON DELETE CASCADE,
  CONSTRAINT `resLocID` FOREIGN KEY (`residenceLocID`) REFERENCES `Locations` (`locationID`) ON DELETE CASCADE,
  CONSTRAINT `birthLocID` FOREIGN KEY (`birthLocID`) REFERENCES `Locations` (`locationID`) ON DELETE CASCADE
);

INSERT INTO Artists VALUES 
    (1, "Michael Whelan",'M',0,NULL, (SELECT locationID FROM Locations WHERE state = "CA")),
    (2, "Vincent Van Gogh",'M',0,NULL,(SELECT locationID FROM Locations WHERE country = "The Netherlands")),
    (3, "Frida Kahlo",'F',0,NULL, (SELECT locationID FROM Locations WHERE city = "Mexico City")),
	(4, "Andy Warhol", "M", 1, NULL, (SELECT locationID FROM Locations WHERE state = "PA")),
	(5, "Jean-Michel Basquiat", "M", 1, NULL, (SELECT locationID FROM Locations WHERE state = "NY"));

--
-- Table: `Artworks`
-- This table records the names and information of the artworks for the artists we have the search available for.
--

CREATE TABLE `Artworks` (
  `artworkID` int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  `digitalArt` tinyint(3) NOT NULL,
  `dateCreated` date NOT NULL,
  `artPeriodCode` varchar(10) NOT NULL,
  `artMediumCode` varchar(25) NOT NULL,
  `artName` varchar(150) NOT NULL,
  PRIMARY KEY (`artworkID`),
  CONSTRAINT `mediumID` FOREIGN KEY (`artMediumCode`) REFERENCES `Mediums` (`mediumID`) ON DELETE CASCADE,
  CONSTRAINT `periodID` FOREIGN KEY (`artPeriodCode`) REFERENCES `ArtPeriods` (`periodID`) ON DELETE CASCADE
);

  INSERT INTO Artworks VALUES 
    (1,0,'1889-06-01','19l','O','Starry Night'),
    (2,0,'1888-08-01','19l','O','Vase With Fifteen Sunflowers'),
    (3,0,'1988-01-01','20l','A','Catspaw'),
    (4,0,'1939-01-01','20m','O','The Two Fridas'),
    (5,0,'1944-01-01','20m','O','The Broken Column'),
	(6,0,'1985-01-01','20l','A','Olympic Rings');

--
-- Table: `ArtistArtworks`
-- Intersection table between Artists and Artworks
--

CREATE TABLE `ArtistArtworks` (
  `artistArtworkID` int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  `artistID` int(11) NOT NULL,
  `artworkID` int(11) NOT NULL,
  PRIMARY KEY (`artistArtworkID`),
  CONSTRAINT `fkArtists` FOREIGN KEY (`artistID`) REFERENCES `Artists` (`artistID`) ON DELETE CASCADE,
  CONSTRAINT `fkArtworks` FOREIGN KEY (`artworkID`) REFERENCES `Artworks` (`artworkID`) ON DELETE CASCADE
);

INSERT INTO ArtistArtworks VALUES 
    (1, (SELECT artistID FROM Artists WHERE fullName = "Michael Whelan"), (SELECT artworkID FROM Artworks WHERE artName = "Catspaw")), 
    (2, (SELECT artistID FROM Artists WHERE fullName = "Vincent Van Gogh"), (SELECT artworkID FROM Artworks WHERE artName = "Starry Night")), 
    (3, (SELECT artistID FROM Artists WHERE fullName = "Vincent Van Gogh"), (SELECT artworkID FROM Artworks WHERE artName = "Vase With Fifteen Sunflowers")), 
    (4, (SELECT artistID FROM Artists WHERE fullName = "Frida Kahlo"), (SELECT artworkID FROM Artworks WHERE artName = "The Broken Column")), 
    (5, (SELECT artistID FROM Artists WHERE fullName = "Frida Kahlo"), (SELECT artworkID FROM Artworks WHERE artName = "The Two Fridas")),
	(6, (SELECT artistID FROM Artists WHERE fullName = "Andy Warhol"), (SELECT artworkID FROM Artworks WHERE artName = "Olympic Rings")),
	(7, (SELECT artistID FROM Artists WHERE fullName = "Jean-Michel Basquiat"), (SELECT artworkID FROM Artworks WHERE artName = "Olympic Rings"));

SET FOREIGN_KEY_CHECKS=1;
COMMIT;