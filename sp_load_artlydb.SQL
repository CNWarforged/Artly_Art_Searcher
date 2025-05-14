--Citation for AI use:
--On: 5/13/2025
--For: sp_load_artlydb
--Source: https://chatgpt.com/
--AI was used for our stored proc “sp_load_artlydb” as per instructions. We chose ChatGPT.
--The prompt we used was: 
--“Hi! For an assignment I was told to give you my DDL schema for MariaDB and ask you to make a stored proc for me to use to be able to load our database queries and our sample data. 
--Here's the DDL data we made:
--[DDL.SQL was provided from our project here]”
--It was then edited for style and useability.

-- This is our stored proc to load the db for our ArtlyArtSearcher project!
-- The database serves as the backend for an archive of artists and their art.
-- ArtistArtworks serves as the connection table between Artists and Artworks.
-- Most of the other tables are category tables to handle the details 
-- we need for the artists or artworks.
-- 
-- Project Name: Artly Art Searcher
-- Admins/devs: Allessandra Bakker and Jennifer Phillips

DROP PROCEDURE IF EXISTS sp_load_artlydb;
DELIMITER //
CREATE PROCEDURE sp_load_artlydb()
BEGIN
    -- Disable foreign key checks and auto-commit
    SET FOREIGN_KEY_CHECKS = 0;
    SET AUTOCOMMIT = 0;

	-- -----------------------------------------------------------------
    -- Drop tables if they exist
	-- -----------------------------------------------------------------
	
    DROP TABLE IF EXISTS ArtistArtworks;
    DROP TABLE IF EXISTS Locations;
    DROP TABLE IF EXISTS GenderCodes;
    DROP TABLE IF EXISTS Mediums;
    DROP TABLE IF EXISTS ArtPeriods;
	DROP TABLE IF EXISTS Artworks;
    DROP TABLE IF EXISTS Artists;

	-- -----------------------------------------------------------------
    -- Table 'ArtPeriods'
	-- -----------------------------------------------------------------
	
    CREATE TABLE ArtPeriods (
        periodID varchar(10) NOT NULL UNIQUE,
        century varchar(45) NOT NULL,
        centuryPart varchar(45) NOT NULL,
        PRIMARY KEY (periodID)
    );

    INSERT INTO ArtPeriods VALUES 
        ('18e','1700','early'),('18l','1700','late'),('18m','1700','mid'),
        ('19e','1800','early'),('19l','1800','late'),('19m','1800','mid'),
        ('20e','1900','early'),('20l','1900','late'),('20m','1900','mid'),
        ('21e','2000','early'),('21l','2000','late'),('21m','2000','mid');

	-- -----------------------------------------------------------------
    -- Table 'GenderCodes'
	-- -----------------------------------------------------------------
	
    CREATE TABLE GenderCodes (
        genderID varchar(10) NOT NULL UNIQUE,
        description varchar(100) NOT NULL,
        PRIMARY KEY (genderID)
    );

    INSERT INTO GenderCodes VALUES 
        ('F','Cis Female'),('IS','Intersex'),('M','Cis Male'),
        ('NB','Non-Binary'),('TF','Trans Female'),('TM','Trans Male'),
        ('TS','Two Spirit'),('U','Unknown');

	-- -----------------------------------------------------------------
    -- Table 'Mediums'
	-- -----------------------------------------------------------------
	
    CREATE TABLE Mediums (
        mediumID varchar(25) NOT NULL UNIQUE,
        mediumDescription varchar(50) NOT NULL,
        PRIMARY KEY (mediumID)
    );

    INSERT INTO Mediums VALUES 
        ('A','Acrylic'),('CG','Computer Graphics or Digital Art'),
        ('MM','Mixed Media'),('O','Oil'),('P','Photography');

    -- -----------------------------------------------------------------
	-- Table 'Locations'
	-- -----------------------------------------------------------------
	
    CREATE TABLE Locations (
        locationID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
        country varchar(100) NOT NULL,
        state varchar(5),
        city varchar(150),
        PRIMARY KEY (locationID)
    );

    INSERT INTO Locations VALUES 
        (1,'USA','CA',NULL), (2,'Mexico',NULL,'Mexico City');

	-- -----------------------------------------------------------------
    -- Table 'Artists'
	-- -----------------------------------------------------------------
    CREATE TABLE Artists (
        artistID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
        fullName varchar(300) NOT NULL,
        genderCode varchar(10) NOT NULL,
        queer tinyint(2) DEFAULT NULL,
        residenceLocID int(11) DEFAULT NULL,
        birthLocID int(11) DEFAULT NULL,
        PRIMARY KEY (artistID),
        CONSTRAINT genderID FOREIGN KEY (genderCode) REFERENCES GenderCodes (genderID) ON DELETE CASCADE,
        CONSTRAINT resLocID FOREIGN KEY (residenceLocID) REFERENCES Locations (locationID) ON DELETE CASCADE,
        CONSTRAINT birthLocID FOREIGN KEY (birthLocID) REFERENCES Locations (locationID) ON DELETE CASCADE
    );

    INSERT INTO Artists VALUES 
        (1,'Michael Whelan','M',NULL,NULL,1),
        (2,'Vincent Van Gogh','M',NULL,NULL,2),
        (3,'Frida Kahlo','F',NULL,NULL,2);

	-- -----------------------------------------------------------------
    -- Table 'Artworks'
	-- -----------------------------------------------------------------
	
    CREATE TABLE Artworks (
        artworkID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
        digitalArt tinyint(3) NOT NULL,
        dateCreated date NOT NULL,
        artPeriodCode varchar(10) NOT NULL,
        artMediumCode varchar(25) NOT NULL,
        artName varchar(150) NOT NULL,
        PRIMARY KEY (artworkID),
        CONSTRAINT mediumID FOREIGN KEY (artMediumCode) REFERENCES Mediums (mediumID) ON DELETE CASCADE,
        CONSTRAINT periodID FOREIGN KEY (artPeriodCode) REFERENCES ArtPeriods (periodID) ON DELETE CASCADE
    );

    INSERT INTO Artworks VALUES 
        (1,0,'1889-06-01','19l','O','Starry Night'),
        (2,0,'1888-08-01','19l','O','Vase With Fifteen Sunflowers'),
        (3,0,'1988-01-01','20l','A','Catspaw'),
        (4,0,'1939-01-01','20m','O','The Two Fridas'),
        (5,0,'1944-01-01','20m','O','The Broken Column');

	-- -----------------------------------------------------------------
    -- Table 'ArtistArtworks'
	-- -----------------------------------------------------------------
	
    CREATE TABLE ArtistArtworks (
        artistArtworkID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
        artistID int(11) NOT NULL,
        artworkID int(11) NOT NULL,
        PRIMARY KEY (artistArtworkID),
        CONSTRAINT fkArtists FOREIGN KEY (artistID) REFERENCES Artists (artistID) ON DELETE CASCADE,
        CONSTRAINT fkArtworks FOREIGN KEY (artworkID) REFERENCES Artworks (artworkID) ON DELETE CASCADE
    );

    INSERT INTO ArtistArtworks (artistID, artworkID) VALUES 
        (1, 3), 
        (2, 1), 
        (2, 2), 
        (3, 4), 
        (3, 5);

    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;
END //

DELIMITER ;