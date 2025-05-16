// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 41124;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

app.engine('.hbs',engine({
    extname: '.hbs',
    helpers: {
        eq: (a, b) => a === b
    }
}));

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/artists', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the locations
        const query1 = `SELECT Artists.artistID as 'ID', Artists.fullName AS 'Name', \
            Artists.genderCode AS 'Gender', Artists.queer AS 'Queer', \
            Artists.residenceLocID AS 'Residence', \
            Artists.birthLocID AS 'Birthplace', \
            Locations.country AS 'Country', Locations.state AS 'State' FROM Artists \
            LEFT JOIN Locations ON Artists.birthLocID = Locations.locationID 
            ORDER BY Artists.fullName ASC;`;
        const query2 = 'SELECT * FROM Locations;';
        const query3 = "SELECT * FROM GenderCodes;";
        const [Artists] = await db.query(query1);
        const [Locations] = await db.query(query2);
        const [GenderCodes] = await db.query(query3);
        // Render the artists.hbs file, and also send the renderer
        //  an object that contains our artsts and locations information
        res.render('artists', { Artists: Artists, Locations: Locations, GenderCodes: GenderCodes });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/artperiods', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT periodID AS 'Period', century AS 'Century', \
            centuryPart AS 'Century_Part' FROM ArtPeriods;`;
        const [ArtPeriods] = await db.query(query1);

        // Render the artperiods.hbs file, and also send the renderer
        //  an object that contains our art periods
        res.render('artperiods', { ArtPeriods: ArtPeriods });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/artworks', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the name of the artist
        const query1 = `SELECT Artworks.artworkID AS 'Artwork_ID', Artworks.digitalArt AS 'Digital_Art', \
            DATE_FORMAT(Artworks.dateCreated, '%Y-%m-%d') AS 'Date', Artworks.artPeriodCode AS 'Period', \
            Artworks.artMediumCode AS 'Medium', Artworks.artName AS 'Artwork_Name', \
            Artists.fullName AS 'Artist_Name' \
            FROM Artworks \
            JOIN Artists ON Artists.artistID = (SELECT artistID FROM ArtistArtworks \
            WHERE ArtistArtworks.artworkID = Artworks.artworkID)
            ORDER BY Artworks.artName ASC;`;
        const query2 = 'SELECT * FROM ArtPeriods;';
        const query3 = 'SELECT * FROM Mediums;';
        const query4 = 'SELECT * FROM Artists;';
        const [Artworks] = await db.query(query1);
        const [ArtPeriods] = await db.query(query2);
        const [Mediums] = await db.query(query3);
        const [Artists] = await db.query(query4);
        // Render the artworks.hbs file, and also send the renderer
        // an object that contains our artworks and periods and medium information
        res.render('artworks', { Artworks: Artworks, ArtPeriods: ArtPeriods, Mediums: Mediums, Artists: Artists });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/locations', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT locationID AS 'ID', country AS 'Country', \
            state AS 'State', city AS 'City' \
            FROM Locations;`;
        const [Locations] = await db.query(query1);

        // Render the locations.hbs file, and also send the renderer
        //  an object that contains our locations
        res.render('locations', { Locations: Locations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/gendercodes', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT genderID AS 'ID', description AS 'Description' \
            FROM GenderCodes;`;
        const [GenderCodes] = await db.query(query1);

        // Render the gendercodes.hbs file, and also send the renderer
        //  an object that contains our gender codes
        res.render('gendercodes', { GenderCodes: GenderCodes });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/mediums', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT mediumID AS 'ID', mediumDescription AS 'Description' \
            FROM Mediums;`;
        const [Mediums] = await db.query(query1);

        // Render the mediums.hbs file, and also send the renderer
        //  an object that contains our medium codes
        res.render('mediums', { Mediums: Mediums });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/artist-summary', async function (req, res) {
    try {
        const query = `SELECT artistID AS 'ID', fullName AS 'Artist_Name', \
            artworkCount AS 'Artwork_Count' \
            FROM v_artistartcount 
            ORDER BY fullName ASC;`;
        const [Summary] = await db.query(query);
        res.render('artist-summary', { Summary: Summary });
    } catch (err) {
        console.error('Error loading artist summary:', err);
        res.status(500).send('Error loading artist summary.');
    }
});

app.get('/edit-artist/:ID', async function (req, res) {
    const ID = req.params.ID;

    try {
        const [[Artist]] = await db.query(`
            SELECT artistID AS 'ID', fullName AS 'Artist_Name', genderCode AS 'Gender', \
                queer AS 'Queer', residenceLocID AS 'Residence', birthLocID AS 'Birthplace' \
            FROM Artists WHERE artistID = ?;`, [ID]);
        const [Artworks] = await db.query(`
            SELECT Artworks.artworkID AS 'Artwork_ID', Artworks.artName AS 'Artwork_Name', Artworks.digitalArt AS 'Digital_Art', \
            DATE_FORMAT(Artworks.dateCreated, '%Y-%m-%d') AS 'Date', Artworks.artPeriodCode AS 'Period', \
			Artworks.artMediumCode AS 'Medium' \
            FROM Artworks \
            JOIN ArtistArtworks ON Artworks.artworkID = ArtistArtworks.artworkID \
            WHERE ArtistArtworks.artistID = ?;`, [ID]);
        const [Locations] = await db.query(`
            SELECT locationID AS 'Location', country AS 'Country', state AS 'State', \
                city AS 'City'
            FROM Locations;
        `);
        const [Periods] = await db.query(`
            SELECT periodID AS 'Period', century AS 'Century', centuryPart AS 'Century_Part'
            FROM ArtPeriods;
        `);
        const [Mediums] = await db.query(`
            SELECT mediumID AS 'Medium', mediumDescription AS 'Description' \
            FROM Mediums;
        `);
        const [GenderCodes] = await db.query(`
            SELECT * FROM GenderCodes;
        `);
        res.render('edit-artist', {
            Artist: Artist,
            Artworks: Artworks,
            Locations: Locations,
            ArtPeriods: Periods,
            Mediums: Mediums,
            GenderCodes: GenderCodes
        });
    } catch (err) {
        console.error('Error loading edit artist page:', err);
        res.status(500).send('Failed to load artist data.');
    }
});

app.post('/update-artist/:ID', async function (req, res) {
    const { fullName, genderCode, queer, birthLocID, residenceLocID } = req.body;
    const ID = req.params.ID;

    try {
        await db.query(
            `CALL UpdateArtistFull(?, ?, ?, ?, ?, ?, ?)`,
            [artistID, artistID, fullName, genderCode, queer, birthLocID, residenceLocID]
        );
        res.redirect('/artist-summary');
    } catch (err) {
        console.error('Error updating artist:', err);
        res.status(500).send('Failed to update artist.');
    }
});

app.post('/update-artwork/:Artwork_ID', async function (req, res) {
    const { artworkID, artName, digitalArt, dateCreated, artPeriodCode, artMediumCode } = req.body;

    try {
        await db.query(
            `CALL UpdateArtworkFull(?, ?, ?, ?, ?, ?, ?)`,
            [artworkID, artworkID, artName, digitalArt ? 1 : 0, dateCreated, artPeriodCode, artMediumCode]
        );
        res.redirect('back'); // This sends the user back to the edit-artist page
    } catch (err) {
        console.error('Error updating artwork:', err);
        res.status(500).send('Failed to update artwork.');
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});