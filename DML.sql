

-- READ -- 

-- For artists.hbs 
-- Get all artist IDs, names, gender codes, sexualities, residence IDs, birthplace IDs, the country and state 
-- Join the locations table to get the details for the location
SELECT Artists.artistID as 'ID', Artists.fullName AS 'Name', 
            GenderCodes.description AS 'Gender', Artists.queer, 
            CASE 
            WHEN Artists.queer = 1 THEN 'Yes' 
            WHEN Artists.queer = 0 THEN 'No' 
            END AS Queer, 
            Locations.country AS 'Country', Locations.state AS 'State', Locations.city AS 'City' 
            FROM Artists 
            LEFT JOIN Locations ON Artists.birthLocID = Locations.locationID 
            JOIN GenderCodes on Artists.genderCode = GenderCodes.genderID 
            ORDER BY Artists.fullName ASC;
-- Query 2 for the Artists table
-- Get all locations from the Locations table to fill in the locations drop downs for the Artist updates
SELECT * FROM Locations;
-- Query 3 for the Artists table
-- Get all gender codes from the GenderCodes table to fill in the gender drop downs for the Artist updates
SELECT * FROM GenderCodes;

-- For artworks.hbs
-- Get all info from the Artworks table, join on ArtistArtworks and Artists to get the Artist name for the Artworks update table
SELECT Artworks.artworkID, Artworks.digitalArt, 
            CASE 
            WHEN Artworks.digitalArt = 1 THEN 'Yes' 
            WHEN Artworks.digitalArt = 0 THEN 'No' 
            END AS digitalArt, 
            DATE_FORMAT(Artworks.dateCreated, '%Y-%m-%d') AS dateCreated, ArtPeriods.century, 
            ArtPeriods.centuryPart, Mediums.mediumDescription, Artworks.artName, 
            Artists.fullName 
            FROM Artworks 
            JOIN ArtPeriods ON Artworks.artPeriodCode = ArtPeriods.periodID 
            JOIN Mediums ON Artworks.artMediumCode = Mediums.mediumID 
            JOIN ArtistArtworks ON Artworks.artworkID = ArtistArtworks.artworkID 
            JOIN Artists ON ArtistArtworks.artistID = Artists.artistID 
            ORDER BY Artworks.artName ASC;
-- Query2 for Artworks to get art periods for the Artwork updates
SELECT * FROM ArtPeriods;
-- Query3 for Artworks to get all the medium descriptions for Artwork updates 
SELECT * FROM Mediums;
-- Query4 for Artworks to get all the Artist names for the Artwork updates
SELECT * FROM Artists;

-- For artperiods.hbs
-- Get all the data from this table but formatted to be easier to read
SELECT periodID AS 'Period', century AS 'Century', centuryPart AS 'Century_Part' FROM ArtPeriods;

-- for locations.hbs
-- Get all the data from this table but formatted to be easier to read
SELECT locationID AS 'ID', country AS 'Country', state AS 'State', city AS 'City' FROM Locations;

-- for gendercodes.hbs
-- Get all the data from this table but formatted to be easier to read
SELECT genderID AS 'ID', description AS 'Description' FROM GenderCodes;

-- for mediums.hbs
-- Get all the data from this table but formatted to be easier to read
SELECT mediumID AS 'ID', mediumDescription AS 'Description' FROM Mediums;

-- for artist-summary.hbs
-- This selects everything from a table View that counts the number of artworks attached to an artist
SELECT artistID AS 'ID', fullName AS 'Artist_Name', artworkCount AS 'Artwork_Count' 
            FROM v_artistartcount 
            ORDER BY fullName ASC;

-- for edit-artist.hbs
-- This one requires multiple queries to allow for updates and also drop downs
-- It fills the edit-artist form for updates
-- It uses a passed id from another form
SELECT artistID AS 'ID', fullName AS 'Artist_Name', genderCode AS 'Gender', queer AS 'Queer', 
			residenceLocID AS 'Residence', birthLocID AS 'Birthplace' 
            FROM Artists WHERE artistID = @artistID;
-- Query 2 for this page:
SELECT Artworks.artworkID AS 'Artwork_ID', Artworks.artName AS 'Artwork_Name', Artworks.digitalArt AS 'Digital_Art', 
            DATE_FORMAT(Artworks.dateCreated, '%Y-%m-%d') AS 'Date', Artworks.artPeriodCode AS 'Period', 
			Artworks.artMediumCode AS 'Medium' 
            FROM Artworks 
            JOIN ArtistArtworks ON Artworks.artworkID = ArtistArtworks.artworkID 
            WHERE ArtistArtworks.artistID = @artistID;
-- Query 3 for this page:
SELECT locationID AS 'Location', country AS 'Country', state AS 'State', city AS 'City'
            FROM Locations;
-- Query 4 for this page:
SELECT periodID AS 'Period', century AS 'Century', centuryPart AS 'Century_Part'
            FROM ArtPeriods;
-- Query 5 for this page:
SELECT mediumID AS 'Medium', mediumDescription AS 'Description' 
            FROM Mediums;
-- Query 6 for this page:
SELECT * FROM GenderCodes;


-- --------------------------------------------


-- CREATE --
-- add a new artist
INSERT INTO Artists (fullName, genderCode, queer, residenceLocID, birthLocID) 
VALUES (@create_artist_fullname, @create_artist_gender, @create_artist_queer, @create_artist_res_loc, @create_artist_birth_loc);

-- add a new artwork
INSERT INTO Artworks (digitalArt, dateCreated, artPeriodCode, artMediumCode, artName) 
VALUES (@digitalArt, @dateCreated, @artPeriodCode, @artMediumCode, @artName);

-- add connection to ArtistArtworks
INSERT INTO ArtistArtworks (artistID, artworkID) 
VALUES ((SELECT artistID FROM Artists WHERE fullName = @artistName), (SELECT artworkID FROM Artworks WHERE artName = @artName));


-- --------------------------------------------


-- UPDATE --
-- update an artist's info based on the form choices
UPDATE Artists SET artistID = @artistID, fullName = @update_artist_name, genderCode = @update_artist_gender, residenceLocID = @update_artist_res_location, birthLocID = @update_artist_birth_location WHERE artistID = @update_artist_id;

-- update artwork info based on form choices
UPDATE Artworks SET artworkID = @artworkID, digitalArt = @digitalArt, dateCreated = @dateCreated, artPeriodCode = @artPeriodCode, artMediumCode = @artMediumCode, artname = @artName;

-- update ArtistArtworks with new artist ID
UPDATE ArtistArtworks SET artistID = @new_artistID WHERE (artistID = @old_artistID);

-- update ArtistArtworks with new artwork ID
UPDATE ArtistArtworks SET artworkID = @new_artworkID WHERE (artworkID = @old_artworkID);

-- --------------------------------------------


-- DELETE --
-- To DELETE an ARTIST: (Without any associated artworks we remove the artist entirely)
-- delete their artworks first
-- These are all stored in sp_delete_artist
DELETE FROM ArtistArtworks 
	WHERE artistID = @in_artistID;

-- Then, delete artworks with no remaining artist links
DELETE FROM Artworks
    WHERE artworkID NOT IN (SELECT DISTINCT artworkID FROM ArtistArtworks);

-- Finally, delete the artist
DELETE FROM Artists
    WHERE artistID = @in_artistID;


-- To DELETE an ARTWORK: (We'll leave the artist alone in this case)
-- These are all stored in sp_delete_artwork
-- First delete the artist/artwork connection
DELETE FROM ArtistArtworks
    WHERE artworkID = @in_artworkID;

    -- Delete artwork from Artworks
DELETE FROM Artworks
    WHERE artworkID = @in_artworkID;