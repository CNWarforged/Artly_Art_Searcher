--Citation for AI use
--On: 5/13/2025
--For: sp_delete_artwork
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_delete_artwork.
--The prompt used was: 
--“Please write a stored procedure for Artists from the above schema called sp_delete_artist 
--that will take an artist ID and will delete the artist from the ArtistArtworks table, and 
--then will delete the artist from the Artists table, as well as deleting any associated artworks 
--they had in the Artworks table. Please put these queries inside of a transaction so that if any 
--of the queries fail they rollback.
--If successful return "Artist and artworks deleted". Otherwise return "Error, artist not deleted". 
--Please also write tests to verify the stored procedure functioned correctly. Thank you!”

--CALL sp_delete_artist(@testArtistID, @resultMsg);
--SELECT @resultMsg;
--Expected result:
--@resultMsg = 'Artist and artworks deleted'

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