--Citation for AI use:
--On: 5/13/2025
--For: sp_insert_artwork
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a view sp_insert_artwork.
--The prompt used was: 
--“Could you also create a stored procedure called sp_insert_artwork that 
--will use MariaDB and will insert an artwork into the Artworks table and then 
--return the newly created ID?”
--It returned a suggestion to use this to call the proc:
--CALL sp_insert_artwork(
--    1,
--    '2023-10-15',
--    '21e',
--    'CG',
--    'Digital Dreams',
--    @new_artwork_id
--);

--SELECT @new_artwork_id;

DROP PROCEDURE IF EXISTS sp_insert_artwork;

DELIMITER $$

CREATE PROCEDURE sp_insert_artwork (
    IN p_digitalArt TINYINT,
    IN p_dateCreated DATE,
    IN p_artPeriodCode VARCHAR(10),
    IN p_artMediumCode VARCHAR(25),
    IN p_artName VARCHAR(150),
    OUT p_artworkID INT
)
BEGIN
    INSERT INTO Artworks (digitalArt, dateCreated, artPeriodCode, artMediumCode, artName)
    VALUES (p_digitalArt, p_dateCreated, p_artPeriodCode, p_artMediumCode, p_artName);

    SET p_artworkID = LAST_INSERT_ID();
END $$

DELIMITER ;