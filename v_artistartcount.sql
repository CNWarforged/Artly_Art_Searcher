--Citation for AI use
--On: 5/13/2025
--For: v_artistartcount
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a view v_artistartcount.
--The prompt used was: 
--“Using the schema I just sent for Maria DB, could you create a view called v_artistartcount for me that shows the artists (their name and residence location) and a count showing each of their artwork numbers in our database?”
--The results required a few round with the AI since we accidentally asked for residence location and not birth location, and also because the AI tried to concatenate all location data into one string.

DROP VIEW IF EXISTS v_artistartcount;

CREATE OR REPLACE VIEW v_artistartcount AS
SELECT a.artistID, a.fullName, COUNT(aa.artworkID) AS artworkCount
FROM Artists a
LEFT JOIN ArtistArtworks aa ON a.artistID = aa.artistID
GROUP BY a.artistID;

SELECT * FROM v_artistartcount;