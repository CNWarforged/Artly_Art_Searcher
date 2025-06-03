-- These are the current PL/SQL we have to run the working steps of our website

-- ------------------------

-- Citation for AI use:
-- On: 5/13/2025
-- For: sp_load_artlydb
-- Source: https://chatgpt.com/
-- AI was used for our stored proc “sp_load_artlydb” as per instructions. We chose ChatGPT.
-- The prompt we used was: 
-- “Hi! For an assignment I was told to give you my DDL schema for MariaDB and ask you to make a stored proc for me to use to be able to load our database queries and our sample data. 
-- Here's the DDL data we made:
-- [DDL.SQL was provided from our project here]”
-- It was then edited for style and useability.

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
	
	DROP TABLE IF EXISTS `Locations`;
	DROP TABLE IF EXISTS `GenderCodes`;
	DROP TABLE IF EXISTS `Mediums`;
	DROP TABLE IF EXISTS `ArtPeriods`;
	DROP TABLE IF EXISTS `ArtistArtworks`;
	DROP TABLE IF EXISTS `Artists`;
	DROP TABLE IF EXISTS `Artworks`;

	-- -----------------------------------------------------------------
    -- Table: `ArtPeriods`
	-- This table holds different art periods so the artworks are also searchable by the general 
	-- period of time they were created in. The periods are represented by codes  for consistency, 
	-- representing a century and then clarifying which part of the century: Early, Mid, or Late.
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
    -- Table: `GenderCodes`
	-- This is to allow a user to search for artists of a certain gender on our website. The genders 
	-- are represented by codes for consistency.
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
    -- Table: `Mediums`
	-- These are codes to represent different artistic mediums (like acrylic, oil, photography, mixed media, etc.).
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
	-- Table: `Locations`
	-- This table holds locations associated with the artists. We’ll use these locations to hold the artist’s birth 
	-- location and main residence as far as the information is known.
	-- -----------------------------------------------------------------
	
	CREATE TABLE `Locations` (
	`locationID` int(11) NOT NULL UNIQUE AUTO_INCREMENT,
	`country` varchar(100) NOT NULL,
	`state` varchar(5) DEFAULT NULL,
	`city` varchar(150) DEFAULT NULL,
	PRIMARY KEY (`locationID`)
	);

	INSERT INTO `Locations` 
	VALUES (1,'USA','AL',NULL),(2,'USA','AK',NULL),(3,'USA','AR',NULL),(4,'USA','AZ',NULL),(5,'USA','CA',NULL),(6,'USA','CO',NULL),(7,'USA','CT',NULL),(8,'USA','DE',NULL),(9,'USA','FL',NULL),(10,'USA','GA',NULL),(11,'USA','HI',NULL),(12,'USA','ID',NULL),(13,'USA','IL',NULL),(14,'USA','IN',NULL),(15,'USA','IA',NULL),(16,'USA','KS',NULL),(17,'USA','KY',NULL),(18,'USA','LA',NULL),(19,'USA','ME',NULL),(20,'USA','MD',NULL),(21,'USA','MA',NULL),(22,'USA','MI',NULL),(23,'USA','MN',NULL),(24,'USA','MS',NULL),(25,'USA','MO',NULL),(26,'USA','MT',NULL),(27,'USA','NE',NULL),(28,'USA','NV',NULL),(29,'USA','NH',NULL),(30,'USA','NJ',NULL),(31,'USA','NM',NULL),(32,'USA','NY',NULL),(33,'USA','NC',NULL),(34,'USA','ND',NULL),(35,'USA','OH',NULL),(36,'USA','OK',NULL),(37,'USA','OR',NULL),(38,'USA','PA',NULL),(39,'USA','RI',NULL),(40,'USA','SC',NULL),(41,'USA','SD',NULL),(42,'USA','TN',NULL),(43,'USA','TX',NULL),(44,'USA','UT',NULL),(45,'USA','VT',NULL),(46,'USA','VA',NULL),(47,'USA','WA',NULL),(48,'USA','WV',NULL),(49,'USA','WI',NULL),(50,'USA','WY',NULL),(51,'USA','DC',NULL),(52,'USA','AS',NULL),(53,'USA','GU',NULL),(54,'USA','MP',NULL),(55,'USA','PR',NULL),(56,'USA','UM',NULL),(57,'USA','VI',NULL),(58,'The Netherlands',NULL,NULL),(59,'Mexico',NULL,'Mexico City');

	-- -----------------------------------------------------------------
    -- Table 'Artists'
	-- This holds the names and information of the artists we’re tracking.
	-- -----------------------------------------------------------------
	
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

	-- -----------------------------------------------------------------
    -- Table 'Artworks'
	-- This table records the names and information of the artworks for the artists we have the search available for.
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
        (5,0,'1944-01-01','20m','O','The Broken Column'),
		(6,0,'1985-01-01','20l','A','Olympic Rings');

	-- -----------------------------------------------------------------
    -- Table 'ArtistArtworks'
	-- Intersection table between Artists and Artworks
	-- -----------------------------------------------------------------
	
    CREATE TABLE ArtistArtworks (
        artistArtworkID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
        artistID int(11) NOT NULL,
        artworkID int(11) NOT NULL,
        PRIMARY KEY (artistArtworkID),
        CONSTRAINT fkArtists FOREIGN KEY (artistID) REFERENCES Artists (artistID) ON DELETE CASCADE,
        CONSTRAINT fkArtworks FOREIGN KEY (artworkID) REFERENCES Artworks (artworkID) ON DELETE CASCADE
    );

    INSERT INTO ArtistArtworks VALUES 
        (1, (SELECT artistID FROM Artists WHERE fullName = "Michael Whelan"), (SELECT artworkID FROM Artworks WHERE artName = "Catspaw")), 
        (2, (SELECT artistID FROM Artists WHERE fullName = "Vincent Van Gogh"), (SELECT artworkID FROM Artworks WHERE artName = "Starry Night")), 
        (3, (SELECT artistID FROM Artists WHERE fullName = "Vincent Van Gogh"), (SELECT artworkID FROM Artworks WHERE artName = "Vase With Fifteen Sunflowers")), 
        (4, (SELECT artistID FROM Artists WHERE fullName = "Frida Kahlo"), (SELECT artworkID FROM Artworks WHERE artName = "The Broken Column")), 
        (5, (SELECT artistID FROM Artists WHERE fullName = "Frida Kahlo"), (SELECT artworkID FROM Artworks WHERE artName = "The Two Fridas")),
		(6, (SELECT artistID FROM Artists WHERE fullName = "Andy Warhol"), (SELECT artworkID FROM Artworks WHERE artName = "Olympic Rings")),
		(7, (SELECT artistID FROM Artists WHERE fullName = "Jean-Michel Basquiat"), (SELECT artworkID FROM Artworks WHERE artName = "Olympic Rings"));

    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;
END //

DELIMITER ;

-- ------------------------------

-- On: 5/13/2025
-- For: v_artistartcount
-- Source: https://chatgpt.com/
-- ChatGPT AI was used to make a view v_artistartcount.
-- The prompt used was: 
-- “Using the schema I just sent for Maria DB, could you create a view called v_artistartcount for me that shows the artists (their name and residence location) and a count showing each of their artwork numbers in our database?”
-- The results required a few round with the AI since we accidentally asked for residence location and not birth location, and also because the AI tried to concatenate all location data into one string.

DROP VIEW IF EXISTS v_artistartcount;

CREATE OR REPLACE VIEW v_artistartcount AS
SELECT a.artistID, a.fullName, COUNT(aa.artworkID) AS artworkCount
FROM Artists a
LEFT JOIN ArtistArtworks aa ON a.artistID = aa.artistID
GROUP BY a.artistID;

SELECT * FROM v_artistartcount;

-- ------------------------------------

-- Citation for AI use
-- On: 5/13/2025
-- For: sp_delete_artwork
-- Source: https://chatgpt.com/
-- ChatGPT AI was used to make a stored proc sp_delete_artwork.
-- The prompt used was: 
-- “Please write a stored procedure for Artists from the above schema called sp_delete_artist 
-- that will take an artist ID and will delete the artist from the ArtistArtworks table, and 
-- then will delete the artist from the Artists table, as well as deleting any associated artworks 
-- they had in the Artworks table. Please put these queries inside of a transaction so that if any 
-- of the queries fail they rollback.
-- If successful return "Artist and artworks deleted". Otherwise return "Error, artist not deleted". 
-- Please also write tests to verify the stored procedure functioned correctly. Thank you!”

-- CALL sp_delete_artist(@in_artistID, @statusMessage);
-- SELECT @statusMessage;
-- Expected result:
-- @statusMessage = 'Artist deleted. Orphaned artworks removed.'

DROP PROCEDURE IF EXISTS sp_delete_artist;

DELIMITER //

CREATE PROCEDURE sp_delete_artist(IN in_artistID INT, OUT statusMessage VARCHAR(100))
BEGIN
  DECLARE artist_exists INT DEFAULT 0;

  -- Error handling
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    ROLLBACK;
    SET statusMessage = 'Error, artist not deleted';
  END;

  START TRANSACTION;

  -- Check if artist exists
  SELECT COUNT(*) INTO artist_exists
  FROM Artists
  WHERE artistID = in_artistID;

  IF artist_exists = 0 THEN
    ROLLBACK;
    SET statusMessage = 'Error, artist ID not found';
  ELSE
    -- First, delete entries from ArtistArtworks for this artist
    DELETE FROM ArtistArtworks
    WHERE artistID = in_artistID;

    -- Then, delete artworks with no remaining artist links
    DELETE FROM Artworks
    WHERE artworkID NOT IN (
      SELECT DISTINCT artworkID FROM ArtistArtworks
    );

    -- Finally, delete the artist
    DELETE FROM Artists
    WHERE artistID = in_artistID;

    COMMIT;
    SET statusMessage = 'Artist deleted. Orphaned artworks removed.';
  END IF;
END //

DELIMITER ;

-- ------------------------------------

-- Citation for AI use
-- On: 5/13/2025
-- For: sp_delete_artwork
-- Source: https://chatgpt.com/
-- ChatGPT AI was used to make a stored proc sp_delete_artwork.
-- The prompt used was: 
-- “Please write a stored procedure for Artworks from the above schema called sp_delete_artwork 
-- that will take an artwork ID and will delete the artwork from the ArtistArtworks table, 
-- and then will delete the artwork from the Artworks table. Please put these queries inside of 
-- a transaction so that if any of the queries fail they rollback.
-- If successful return "Artwork deleted". Otherwise return "Error, artwork not deleted". 
-- Please also write tests to verify the stored procedure functioned correctly. Thank you!”

-- CALL sp_delete_artwork(@testArtworkID, @resultMsg);
-- SELECT @resultMsg;
-- Expected result:

-- @resultMsg = 'Artwork deleted'

DROP PROCEDURE IF EXISTS sp_delete_artwork;

DELIMITER //

CREATE PROCEDURE sp_delete_artwork(IN in_artworkID INT, OUT statusMessage VARCHAR(100))
BEGIN
  DECLARE artwork_exists INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    ROLLBACK;
    SET statusMessage = 'Error, artwork not deleted';
  END;

  START TRANSACTION;

  -- Check if the artwork exists
  SELECT COUNT(*) INTO artwork_exists
  FROM Artworks
  WHERE artworkID = in_artworkID;

  IF artwork_exists = 0 THEN
    ROLLBACK;
    SET statusMessage = 'Error, artwork ID not found';
  ELSE
    -- Delete artwork from ArtistArtworks
    DELETE FROM ArtistArtworks
    WHERE artworkID = in_artworkID;

    -- Delete artwork from Artworks
    DELETE FROM Artworks
    WHERE artworkID = in_artworkID;

    COMMIT;
    SET statusMessage = 'Artwork deleted';
  END IF;
END //

DELIMITER ;

-- ------------------------------------

-- Citation for AI use
-- On: 6/2/2025
-- For: sp_update_artwork
-- Source: https://chatgpt.com/
-- ChatGPT AI was used to make a stored proc sp_update_artwork.
-- The prompt used was: 
-- "Okay, I had this for a stored proc to update the Artworks field. I need it to also be able to 
-- update Artwork ID, and if that's updated to also update the Artist_Artworks table with the new Artwork ID."
-- [ Basic stored proc I made ]

DROP PROCEDURE IF EXISTS sp_update_artwork;
DELIMITER //

CREATE PROCEDURE sp_update_artwork(
    IN in_old_artworkID INT,
    IN in_new_artworkID INT,
    IN in_digitalArt TINYINT,
    IN in_dateCreated DATE,
    IN in_artPeriodCode VARCHAR(10),
    IN in_artMediumCode VARCHAR(25),
    IN in_artName VARCHAR(150),
    OUT statusMessage VARCHAR(100)
)
BEGIN
    DECLARE artwork_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET statusMessage = 'Error, artwork not updated';
    END;

    START TRANSACTION;

    -- Check if old artwork exists
    SELECT COUNT(*) INTO artwork_exists
    FROM Artworks
    WHERE artworkID = in_old_artworkID;

    IF artwork_exists = 0 THEN
        ROLLBACK;
        SET statusMessage = 'Error, artwork ID not found';
    ELSE
        -- If changing the ID
        IF in_new_artworkID IS NOT NULL AND in_new_artworkID != in_old_artworkID THEN

            -- Insert new record with updated ID and data
            INSERT INTO Artworks (artworkID, digitalArt, dateCreated, artPeriodCode, artMediumCode, artName)
            VALUES (in_new_artworkID, in_digitalArt, in_dateCreated, in_artPeriodCode, in_artMediumCode, in_artName);

            -- Update all references in ArtistArtworks
            UPDATE ArtistArtworks
            SET artworkID = in_new_artworkID
            WHERE artworkID = in_old_artworkID;

            -- Delete the old record
            DELETE FROM Artworks
            WHERE artworkID = in_old_artworkID;

        ELSE
            -- Simple field update without ID change
            UPDATE Artworks
            SET 
                digitalArt = in_digitalArt,
                dateCreated = in_dateCreated,
                artPeriodCode = in_artPeriodCode,
                artMediumCode = in_artMediumCode,
                artName = in_artName
            WHERE artworkID = in_old_artworkID;
        END IF;

        COMMIT;
        SET statusMessage = 'Artwork updated successfully';
    END IF;
END //

DELIMITER ;

-- ------------------------------------

-- Citation for AI use
-- On: 6/2/2025
-- For: sp_update_artist
-- Source: https://chatgpt.com/
-- ChatGPT AI was used to make a stored proc sp_update_artist.
-- The prompt used was: 
-- “Okay, next could you help me with the general artists.hbs update page? 
-- For that it'll have a similar thing where it needs to be able to update the 
-- artist ID and also update the Artist_Artworks table with that ID as well. “

DROP PROCEDURE IF EXISTS sp_update_artist;
DELIMITER //

CREATE PROCEDURE sp_update_artist(
  IN in_old_artistID INT,
  IN in_new_artistID INT,
  IN in_fullName VARCHAR(300),
  IN in_genderCode VARCHAR(10),
  IN in_queer TINYINT,
  IN in_residenceLocID INT,
  IN in_birthLocID INT,
  OUT statusMessage VARCHAR(100)
)
BEGIN
  DECLARE artist_exists INT DEFAULT 0;
  DECLARE conflict_exists INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    ROLLBACK;
    SET statusMessage = 'Error, artist not updated';
  END;

  START TRANSACTION;

  -- Confirm artist exists
  SELECT COUNT(*) INTO artist_exists
  FROM Artists
  WHERE artistID = in_old_artistID;

  IF artist_exists = 0 THEN
    ROLLBACK;
    SET statusMessage = 'Error, artist ID not found';
  ELSE
    -- Check for conflict if ID is changing
    IF in_old_artistID != in_new_artistID THEN
      SELECT COUNT(*) INTO conflict_exists
      FROM Artists
      WHERE artistID = in_new_artistID;

      IF conflict_exists > 0 THEN
        ROLLBACK;
        SET statusMessage = 'Error, new artist ID already exists. Choose a different ID';
      ELSE
        -- Insert new record
        INSERT INTO Artists (
          artistID, fullName, genderCode, queer, residenceLocID, birthLocID
        ) VALUES (
          in_new_artistID, in_fullName, in_genderCode, in_queer, in_residenceLocID, in_birthLocID
        );

        -- Reassign related artworks
        UPDATE ArtistArtworks
        SET artistID = in_new_artistID
        WHERE artistID = in_old_artistID;

        -- Delete old artist
        DELETE FROM Artists
        WHERE artistID = in_old_artistID;

        COMMIT;
        SET statusMessage = 'Artist updated successfully';
      END IF;
    ELSE
      -- Just update artist fields if ID is not changing
      UPDATE Artists
      SET fullName = in_fullName,
          genderCode = in_genderCode,
          queer = in_queer,
          residenceLocID = in_residenceLocID,
          birthLocID = in_birthLocID
      WHERE artistID = in_old_artistID;

      COMMIT;
      SET statusMessage = 'Artist updated successfully';
    END IF;
  END IF;
END //

DELIMITER ;


-- ------------------------------------









-- ------------------------------------







-- ------------------------------------





-- ------------------------------------






-- ------------------------------------