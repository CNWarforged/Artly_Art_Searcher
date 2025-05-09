
-- READ 
-- Get all artist IDs, names, gender codes, sexualities, residence IDs, birthplace IDs, the country and state 
-- Join the locations table to get the details for the location
SELECT Artists.artistID, Artists.fullName AS 'Name', Artists.genderCode AS 'Gender', Artists.queer AS 'Queer',
            Artists.residenceLocID AS 'ResidenceID', Artists.birthLocID AS 'BirthplaceID', 
			Locations.country AS 'Country', Locations.state AS 'State' 
			FROM Artists 
            LEFT JOIN Locations ON Artists.birthLocID = Locations.locationID;

-- Query 2 for the Artists table
-- Get all locations from the Locations table to fill in the locations drop downs for the update tables
SELECT * FROM Locations;';



