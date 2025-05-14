--Citation for use of AI
--On: 5/13/2025
--For: sp_update_artwork
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_update_artwork.
--The prompt used was: 
--“Thanks! Could I have a version of that procedure for fully updating a row in Artwork?”

--Update all fields (changing artwork ID)
--CALL sp_update_artwork(
--  1,          -- old artworkID
--  10,         -- new artworkID
--  0,          -- digitalArt
--  '1889-06-01', -- dateCreated
--  '19l',       -- artPeriodCode (19th century, late)
--  'O',         -- artMediumCode (Oil)
--  'Starry Night Revised', -- artName
--  @msg
--);
--SELECT @msg;

--Fully update but keep the same ID
--CALL sp_update_artwork(
--  2,          -- old artworkID
--  NULL,       -- keep the same ID
--  0,          -- digitalArt
--  '1888-08-01', -- dateCreated
--  '19l',       -- artPeriodCode
--  'O',         -- artMediumCode
--  'Vase With Fifteen Sunflowers Revised', -- artName
--  @msg
--);
--SELECT @msg;


DROP PROCEDURE IF EXISTS sp_update_artwork;

DELIMITER $$

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

    -- Check if artwork exists
    SELECT COUNT(*) INTO artwork_exists
    FROM Artworks
    WHERE artworkID = in_old_artworkID;

    IF artwork_exists = 0 THEN
        ROLLBACK;
        SET statusMessage = 'Error, artwork ID not found';
    ELSE
        -- If artworkID is changing, update ArtistArtworks and Artworks table first
        IF in_new_artworkID IS NOT NULL AND in_new_artworkID != in_old_artworkID THEN
            -- Update ArtistArtworks
            UPDATE ArtistArtworks
            SET artworkID = in_new_artworkID
            WHERE artworkID = in_old_artworkID;

            -- Update artworkID in Artworks table
            UPDATE Artworks
            SET artworkID = in_new_artworkID
            WHERE artworkID = in_old_artworkID;

            -- Use new ID for remaining updates
            SET in_old_artworkID = in_new_artworkID;
        END IF;

        -- Fully update all fields
        UPDATE Artworks
        SET 
            digitalArt = in_digitalArt,
            dateCreated = in_dateCreated,
            artPeriodCode = in_artPeriodCode,
            artMediumCode = in_artMediumCode,
            artName = in_artName
        WHERE artworkID = in_old_artworkID;

        COMMIT;
        SET statusMessage = 'Artwork updated successfully';
    END IF;
END$$

DELIMITER ;
