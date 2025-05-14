--Citation for use of AI
--On: 5/13/2025
--For: sp_update_artist
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_update_artist.
--The prompt used was: 
--“Could you now write me an update stored procedure for the schema for Maria DB to 
--update any field in the Artist table, including the artist ID? It will also need 
--to make sure that if the artist ID is updated to update the corresponding data in 
--the ArtistArtworks table.”
--Update artist info without changing ID
--CALL sp_update_artist(
--  2,  -- in_old_artistID
--  2,  -- in_new_artistID (same as old, no ID change)
--  'Vincent van Gogh',  -- updated name
--  'M',
--  NULL,
--  NULL,
--  (SELECT locationID FROM Locations WHERE city = 'Mexico City'),
--  @msg
--);
--SELECT @msg;

--Update artist ID (e.g. from 3 to 30)
--CALL sp_update_artist(
--  3,   -- old ID
--  30,  -- new ID
--  'Frida Kahlo',
--  'F',
--  NULL,
--  NULL,
--  (SELECT locationID FROM Locations WHERE city = 'Mexico City'),
--  @msg
--);
--SELECT @msg;

DROP PROCEDURE IF EXISTS sp_update_artist;

DELIMITER $$

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
    -- If artistID is being updated
    IF in_old_artistID != in_new_artistID THEN
      -- Update ArtistArtworks first
      UPDATE ArtistArtworks
      SET artistID = in_new_artistID
      WHERE artistID = in_old_artistID;

      -- Update the Artists table
      UPDATE Artists
      SET artistID = in_new_artistID,
          fullName = in_fullName,
          genderCode = in_genderCode,
          queer = in_queer,
          residenceLocID = in_residenceLocID,
          birthLocID = in_birthLocID
      WHERE artistID = in_old_artistID;
    ELSE
      -- Just update the fields if artistID is not changing
      UPDATE Artists
      SET fullName = in_fullName,
          genderCode = in_genderCode,
          queer = in_queer,
          residenceLocID = in_residenceLocID,
          birthLocID = in_birthLocID
      WHERE artistID = in_old_artistID;
    END IF;

    COMMIT;
    SET statusMessage = 'Artist updated successfully';
  END IF;
END$$

DELIMITER ;

