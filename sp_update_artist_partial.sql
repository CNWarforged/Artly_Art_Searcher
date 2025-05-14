--Citation for use of AI
--On: 5/13/2025
--For: sp_update_artist_partial
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_update_artist_partial.
--The prompt used was: 
--“a version that allows partial updates would be helpful!”
--Partial update (only name and gender)
--CALL sp_update_artist_partial(
--  2,  -- old artistID
--  NULL,  -- keep same ID
--  'Vincent V. Gogh',  -- update name
--  'M',                -- update gender
--  NULL,               -- don't update queer
--  NULL,               -- don't update residence
--  NULL,               -- don't update birth
--  @msg
--);
--SELECT @msg;

--Change artist id and update one field
--CALL sp_update_artist_partial(
--  30,    -- current ID
--  33,    -- change to new ID
--  NULL,  -- don't update name
--  NULL,
--  1,     -- set queer = true
--  NULL,
--  NULL,
--  @msg
--);
--SELECT @msg;

DROP PROCEDURE IF EXISTS sp_update_artist_partial;

DELIMITER $$

CREATE PROCEDURE sp_update_artist_partial(
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET statusMessage = 'Error, artist not updated';
    END;

    START TRANSACTION;

    -- Check if artist exists
    SELECT COUNT(*) INTO artist_exists
    FROM Artists
    WHERE artistID = in_old_artistID;

    IF artist_exists = 0 THEN
        ROLLBACK;
        SET statusMessage = 'Error, artist ID not found';
    ELSE
        -- If artistID changes, update ArtistArtworks and use new ID in UPDATE
        IF in_new_artistID IS NOT NULL AND in_new_artistID != in_old_artistID THEN
            -- Update ArtistArtworks
            UPDATE ArtistArtworks
            SET artistID = in_new_artistID
            WHERE artistID = in_old_artistID;

            -- Update artistID in Artists first
            UPDATE Artists
            SET artistID = in_new_artistID
            WHERE artistID = in_old_artistID;

            SET in_old_artistID = in_new_artistID;  -- now use new ID for remaining updates
        END IF;

        -- Dynamically update only non-null fields
        IF in_fullName IS NOT NULL THEN
            UPDATE Artists SET fullName = in_fullName WHERE artistID = in_old_artistID;
        END IF;

        IF in_genderCode IS NOT NULL THEN
            UPDATE Artists SET genderCode = in_genderCode WHERE artistID = in_old_artistID;
        END IF;

        IF in_queer IS NOT NULL THEN
            UPDATE Artists SET queer = in_queer WHERE artistID = in_old_artistID;
        END IF;

        IF in_residenceLocID IS NOT NULL THEN
            UPDATE Artists SET residenceLocID = in_residenceLocID WHERE artistID = in_old_artistID;
        END IF;

        IF in_birthLocID IS NOT NULL THEN
            UPDATE Artists SET birthLocID = in_birthLocID WHERE artistID = in_old_artistID;
        END IF;

        COMMIT;
        SET statusMessage = 'Artist updated successfully';
    END IF;
END$$

DELIMITER ;

