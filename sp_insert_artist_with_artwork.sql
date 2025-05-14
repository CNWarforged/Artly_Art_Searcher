--Citation for AI USEOn: 5/13/2025
--For: sp_insert_artist_with_artwork
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_insert_artist_with_artwork.
--The prompt used was: 
--“I would love a version that inserts into the ArtistArtworks version, and 
--also a version that uses the validation logic”
--It suggested this as a call:
---- Declare the output variable
--SET @new_artwork_id = 0;
---- Call the procedure
--CALL sp_insert_artwork_with_artist(
--    1,                       -- digitalArt
--    '2024-05-01',            -- dateCreated
--    '21e',                   -- artPeriodCode
--    'CG',                    -- artMediumCode
--    'Quantum Horizons',      -- artName
--    1,                       -- artistID
--    @new_artwork_id          -- output var
--);
---- Get the new artwork ID
--SELECT @new_artwork_id;

DROP PROCEDURE IF EXISTS sp_insert_artwork_with_artist;

DELIMITER $$

CREATE PROCEDURE sp_insert_artwork_with_artist (
    IN p_digitalArt TINYINT,
    IN p_dateCreated DATE,
    IN p_artPeriodCode VARCHAR(10),
    IN p_artMediumCode VARCHAR(25),
    IN p_artName VARCHAR(150),
    IN p_artistID INT,
    OUT p_artworkID INT
)
BEGIN
    DECLARE v_period_exists INT DEFAULT 0;
    DECLARE v_medium_exists INT DEFAULT 0;
    DECLARE v_artist_exists INT DEFAULT 0;

    -- Validate Art Period
    SELECT COUNT(*) INTO v_period_exists
    FROM ArtPeriods
    WHERE periodID = p_artPeriodCode;

    -- Validate Medium
    SELECT COUNT(*) INTO v_medium_exists
    FROM Mediums
    WHERE mediumID = p_artMediumCode;

    -- Validate Artist
    SELECT COUNT(*) INTO v_artist_exists
    FROM Artists
    WHERE artistID = p_artistID;

    -- If any reference is invalid, signal an error
    IF v_period_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid artPeriodCode: does not exist in ArtPeriods';
    ELSEIF v_medium_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid artMediumCode: does not exist in Mediums';
    ELSEIF v_artist_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid artistID: does not exist in Artists';
    ELSE
        -- Insert artwork
        INSERT INTO Artworks (digitalArt, dateCreated, artPeriodCode, artMediumCode, artName)
        VALUES (p_digitalArt, p_dateCreated, p_artPeriodCode, p_artMediumCode, p_artName);

        SET p_artworkID = LAST_INSERT_ID();

        -- Insert into ArtistArtworks relationship table
        INSERT INTO ArtistArtworks (artistID, artworkID)
        VALUES (p_artistID, p_artworkID);
    END IF;
END $$

DELIMITER ;