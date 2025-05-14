--Citation for AI use:
--For: sp_insert_artist 
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a stored proc sp_insert_artist.
--The prompt used was: 
--“Could you write me a stored proc for MariaDB called sp_insert_artist that will insert 
--an artist into the db schema I gave, and will return the newly created ID?”
--It also returned this suggested use for calling the proc:
--CALL sp_insert_artist(
--   'Georgia O’Keeffe',
--    'F',
--    NULL,
--    NULL,
--    5,
--    @new_artist_id
--);
--SELECT @new_artist_id;

DROP PROCEDURE IF EXISTS sp_insert_artist;

DELIMITER $$

CREATE PROCEDURE sp_insert_artist (
    IN p_fullName VARCHAR(300),
    IN p_genderCode VARCHAR(10),
    IN p_queer TINYINT,
    IN p_residenceLocID INT,
    IN p_birthLocID INT,
    OUT p_artistID INT
)
BEGIN
    INSERT INTO Artists (fullName, genderCode, queer, residenceLocID, birthLocID)
    VALUES (p_fullName, p_genderCode, p_queer, p_residenceLocID, p_birthLocID);

    -- Return the newly generated artistID
    SET p_artistID = LAST_INSERT_ID();
END $$

DELIMITER ;