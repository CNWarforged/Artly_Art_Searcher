--Citation for AI use
--On: 5/13/2025
--For: sp_delete_artwork
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_delete_artwork.
--The prompt used was: 
--“Please write a stored procedure for Artworks from the above schema called sp_delete_artwork 
--that will take an artwork ID and will delete the artwork from the ArtistArtworks table, 
--and then will delete the artwork from the Artworks table. Please put these queries inside of 
--a transaction so that if any of the queries fail they rollback.
--If successful return "Artwork deleted". Otherwise return "Error, artwork not deleted". 
--Please also write tests to verify the stored procedure functioned correctly. Thank you!”

--CALL sp_delete_artwork(@testArtworkID, @resultMsg);
--SELECT @resultMsg;
--Expected result:

--@resultMsg = 'Artwork deleted'

DROP PROCEDURE IF EXISTS sp_insert_artist;

DELIMITER $$

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
END$$

DELIMITER ;




