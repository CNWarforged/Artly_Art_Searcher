
-- READ 
-- Get all artist IDs, names, gender codes, sexualities, residence IDs, birthplace IDs, the country and state 
-- Join the locations table to get the details for the location
SELECT Artists.artistID, Artists.fullName AS 'Name', Artists.genderCode AS 'Gender', Artists.queer AS 'Queer',
            Artists.residenceLocID AS 'ResidenceID', Artists.birthLocID AS 'BirthplaceID', 
			Locations.country AS 'Country', Locations.state AS 'State' 
			FROM Artists 
            LEFT JOIN Locations ON Artists.birthLocID = Locations.locationID;

-- Query 2 for the Artists table
-- Get all locations from the Locations table to fill in the locations drop downs for the location update tables
SELECT * FROM Locations;

------

-- CREATE
-- add a new artist
INSERT INTO Artist (fullName, genderCode, queer, residenceLocID, birthLocID) VALUES (@create_artist_fullname, @create_artist_gender, @create_artist_queer, @create_artist_birth_loc, @create_artist_res_loc)

------

-- UPDATE
-- update an artist's info based on the form choices
UPDATE Artist SET fullName = @update_artist_name, genderCode = @update_artist_gender, residenceLocID = @update_artist_res_location, birthLocID = @update_artist_birth_location WHERE artistID = @update_artist_id

------

-- DELETE
-- delete their artworks first
DELETE FROM Artworks WHERE artworkID = SELECT (artworkID FROM ArtistArtworks WHERE artistID = @delete_artist_id)

-- Then delete the artist/artwork connection
DELETE FROM ArtistArtworks WHERE artistID = @delete_artist_id

-- Finally delete the artist
DELETE FROM Artists WHERE artistID = @delete_artist_id
