--Citation for AI use
--On: 5/13/2025
--For: v_artistartcount
--Source: https://chatgpt.com/
--ChatGPT AI was used to make a view v_artistartcount.
--The prompt used was: 
--“Using the schema I just sent for Maria DB, could you create a view called v_artistartcount for me that shows the artists (their name and residence location) and a count showing each of their artwork numbers in our database?”
--The results required a few round with the AI since we accidentally asked for residence location and not birth location, and also because the AI tried to concatenate all location data into one string.

CREATE OR REPLACE VIEW v_artistartcount AS
SELECT 
    a.fullName AS artist_name,
    l.city AS birth_city,
    l.state AS birth_state,
    l.country AS birth_country,
    COUNT(aa.artworkID) AS artwork_count
FROM Artists a
LEFT JOIN Locations l ON a.birthLocID = l.locationID
LEFT JOIN ArtistArtworks aa ON a.artistID = aa.artistID
GROUP BY a.artistID, a.fullName, l.city, l.state, l.country;

SELECT * FROM v_artistartcount;