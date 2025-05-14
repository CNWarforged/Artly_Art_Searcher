--Citation for use of AI
--On: 5/13/2025
--For: sp_update_artwork_partial
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_update_artwork_partial.
--The prompt used was: 
--“Could you now write me an update stored procedure for the schema for Maria DB to update any 
--field in the Artwork table, including the artwork ID? It will also need to make sure that 
--if the artwork ID is updated to update the corresponding data in the ArtistArtworks table.”

--Update only name and medium
--CALL sp_update_artwork_partial(
--  1,         -- original artworkID
--  NULL,      -- keep same ID
--  NULL,      -- no change to digitalArt
--  NULL,
--  NULL,
--  'A',       -- update to Acrylic
--  'Starry Night Revised', -- new name
--  @msg
--);
--SELECT @msg;

--Change artwork id and date
--CALL sp_update_artwork_partial(
--  2,  -- old ID
--  22, -- new ID
--  NULL,
--  '1888-09-01',
--  NULL,
--  NULL,
--  NULL,
--  @msg
--);
--SELECT @msg;


DROP PROCEDURE IF EXISTS sp_update_artwork_partial;

DELIMITER $$

CREATE PROCEDURE sp_update_artwork_partial(
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

        -- Conditionally update each field if a value is provided
        IF in_digitalArt IS NOT NULL THEN
            UPDATE Artworks SET digitalArt = in_digitalArt WHERE artworkID = in_old_artworkID;
        END IF;

        IF in_dateCreated IS NOT NULL THEN
            UPDATE Artworks SET dateCreated = in_dateCreated WHERE artworkID = in_old_artworkID;
        END IF;

        IF in_artPeriodCode IS NOT NULL THEN
            UPDATE Artworks SET artPeriodCode = in_artPeriodCode WHERE artworkID = in_old_artworkID;
        END IF;

        IF in_artMediumCode IS NOT NULL THEN
            UPDATE Artworks SET artMediumCode = in_artMediumCode WHERE artworkID = in_old_artworkID;
        END IF;

        IF in_artName IS NOT NULL THEN
            UPDATE Artworks SET artName = in_artName WHERE artworkID = in_old_artworkID;
        END IF;

        COMMIT;
        SET statusMessage = 'Artwork updated successfully';
    END IF;
END$$

DELIMITER ;
