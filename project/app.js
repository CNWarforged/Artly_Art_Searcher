// NOTE: The citations for the individual stored procs and view are included with the respective 
// code in our PL.SQL and DDL.SQL files
// These are the additional citations for the app.js.
// All citations also included in the README file for our project in a consolidated format.

// Citation for AI use:
// On 5/22/2025
// For: The POST app.js statements to call the stored procedures for our deletes
// Source: chatgpt.com
// ChatGPT was used to figure out the format for the post statements for our deletes
// The prompt used was: 
// “What should the app.js side look like for using a "delete" button on the artists 
// page to call the sp_delete_artist stored procedure?”

// Citation for AI use
// On: 6/2/2025
// For: sp_update_artwork called from our app.js
// Source: https://chatgpt.com/
// ChatGPT AI was used to make the app.js connection to sp_update_artwork
// The prompt used was: 
// "How would I connect that to my app.js so it can be called from artworks.hbs?"

// Citation for AI use
// On: 6/2/2025
// For: sp_update_artist called from our app.js
// Source: https://chatgpt.com/
// ChatGPT AI was used to make the app.js connection to sp_update_artist
// The prompt used was: 
// “Could you help me connect that stored procedure to be called from app.js?”

// Citation for AI use
// On: 6/2/2025
// For: sp_insert_artwork called from our app.js
// Source: https://chatgpt.com/
// ChatGPT AI was used to make the app.js connection to sp_insert_artwork
// The prompt used was: 
// “[ asked for similar help for app.js as with the artists.hbs page ] This is my stored 
// procedure for sp_insert_artwork. When I made that originally each artwork could only 
// have one artist, but now multiple artists are allowed per artwork too. That will mean 
// that someone is allowed to add a new artist to an existing artwork but not necessarily 
// replace the old listed artist. Also, while we let an artist get added without an artwork, 
// we require an artwork to have at least one artist to get added, so the artist name is a requirement.”

// Citation for AI use:
// On: 5/13/2025
// For: sp_insert_artwork
// Source: https://chatgpt.com/
/// ChatGPT AI was used to help fix the artwork insert on the app.js 
// The prompt used was: 
// Could you make me a new stored procedure to insert into the Artist_Artworks table, 
// then give me an updated version of app.js that will call sp_insert_artwork to add an 
// artwork and then will call the new sp_insert_artist_artwork to take care of that?

// Citation for AI use:
// On: 5/13/2025
// For: edit-artist.hbs and its app.js connection
// Source: https://chatgpt.com/
// ChatGPT AI was used to help fix the edit-artist insert on the app.js 
// The prompt used was: 
// Is there a quick way to connect this page to our app.js? I don't know if it needs a new 
// call to sp_update_artist or sp_update_artwork or if it's okay using another call.

// On: 5/21/2025 
// For: Code and placement for Reset Button on artist-summary.hbs page
// Source: chatgpt.com
// ChatGPT AI was use to figure out what we were doing wrong with our code to make a reset button for our form.
// The prompt used was: 
// I'm still getting the hang of javascript! My next immediate task is to implement a button on 
// one of the webpages to allow a user to reset the database. I have the stored procedure already with 
// my DDL in it, so that part is good. I added a reset button on this page, but would like to know if
//  that seems like the right sort of button.”
// [ Code for the artist-summary.hbs page ]

// Citation for AI use:
// On: 5/13/2025
/// For: sp_insert_artwork
// Source: https://chatgpt.com/
// ChatGPT AI was used to help fix the artwork insert on the app.js 
// The prompt used was: 
// Could you make me a new stored procedure to insert into the Artist_Artworks table, 
// then give me an updated version of app.js that will call sp_insert_artwork to add an 
// artwork and then will call the new sp_insert_artist_artwork to take care of that?

// Citation for AI use:
// On: 5/13/2025
// For: edit-artist.hbs and its app.js connection
// Source: https://chatgpt.com/
// ChatGPT AI was used to help fix the edit-artist insert on the app.js 
// The prompt used was: 
// Is there a quick way to connect this page to our app.js? I don't know if it needs a new cal to sp_update_artist or sp_update_artwork or if it's okay using another call.


// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 62728;

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
            GenderCodes.description AS 'Gender', Artists.queer, \
            CASE \
            WHEN Artists.queer = 1 THEN 'Yes' \
            WHEN Artists.queer = 0 THEN 'No' \
            END AS Queer, \
            Locations.country AS 'Country', Locations.state AS 'State', Locations.city AS 'City' \
            FROM Artists \
            LEFT JOIN Locations ON Artists.birthLocID = Locations.locationID \
            JOIN GenderCodes on Artists.genderCode = GenderCodes.genderID 
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
        const query1 = `SELECT Artworks.artworkID, Artworks.digitalArt, \
            CASE \
            WHEN Artworks.digitalArt = 1 THEN 'Yes' \
            WHEN Artworks.digitalArt = 0 THEN 'No' \
            END AS digitalArt, \
            DATE_FORMAT(Artworks.dateCreated, '%Y-%m-%d') AS dateCreated, ArtPeriods.century, \
            ArtPeriods.centuryPart, Mediums.mediumDescription, Artworks.artName, \
            Artists.fullName \
            FROM Artworks \
            JOIN ArtPeriods ON Artworks.artPeriodCode = ArtPeriods.periodID \ 
            JOIN Mediums ON Artworks.artMediumCode = Mediums.mediumID \
            JOIN ArtistArtworks ON Artworks.artworkID = ArtistArtworks.artworkID \
            JOIN Artists ON ArtistArtworks.artistID = Artists.artistID \
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

app.post('/update-artist/:id', async (req, res) => {
  const oldID = parseInt(req.params.id);
  const {
    new_artistID,
    fullName,
    update_artist_gender,
    queer,
    residenceLocID,
    birthLocID
  } = req.body;

  try {
    const [rows] = await db.query('SELECT * FROM Artists WHERE artistID = ?', [oldID]);
    if (rows.length === 0) {
      return res.status(404).send('Artist not found.');
    }

    const current = rows[0];
    const finalNewID = new_artistID && new_artistID.trim() !== ''
      ? parseInt(new_artistID)
      : oldID;

    const finalName = fullName || current.fullName;
    const finalGender = update_artist_gender || current.genderCode;
    const finalQueer = queer === '1' ? 1 : 0;
    const finalRes = residenceLocID || current.residenceLocID;
    const finalBirth = birthLocID || current.birthLocID;

    await db.query(
      `CALL sp_update_artist(?, ?, ?, ?, ?, ?, ?, @msg);`,
      [oldID, finalNewID, finalName, finalGender, finalQueer, finalRes, finalBirth]
    );

    const [[{ statusMessage }]] = await db.query('SELECT @msg AS statusMessage;');
    console.log('Update Status:', statusMessage);

    res.redirect('/artist-summary');
  } catch (err) {
    console.error('Error updating artist (edit-artist route):', err);
    res.status(500).send('An error occurred while updating the artist.');
  }
});

app.post('/reset-database', async (req, res) => {
    try {
      const [result] = await db.query('CALL sp_load_artlydb();');
      console.log('Reset result:', result);
      res.redirect('/artist-summary');
    } catch (err) {
      console.error('Error resetting database:', err);
      res.status(500).send(`Database reset failed. ${err.message}`);
    }
});
  
app.post('/artists/delete/:id', async function (req, res) {
    const artistID = parseInt(req.params.id);
    try {
      await db.query('CALL sp_delete_artist(?, @statusMessage)', [artistID]);
      const [[{ statusMessage }]] = await db.query('SELECT @statusMessage AS statusMessage');
  
      console.log('Delete status:', statusMessage); // optional
  
      res.redirect('/artists'); // Refresh artists page
    } catch (error) {
      console.error('Error deleting artist:', error);
      res.status(500).send('Error deleting artist.');
    }
});

app.post('/artworks/delete/:id', async function (req, res) {
    const artworkID = parseInt(req.params.id);
  
    try {
      // Call the stored procedure
      await db.query('CALL sp_delete_artwork(?, @statusMessage)', [artworkID]);
  
      // Get the output message from the procedure
      const [[{ statusMessage }]] = await db.query('SELECT @statusMessage AS statusMessage');
  
      console.log('Delete status:', statusMessage); 
  
      res.redirect('/artworks');
    } catch (error) {
      console.error('Error deleting artwork:', error);
      res.status(500).send('Failed to delete artwork.');
    }
});

app.post('/artworks/update', async (req, res) => {
  const {
    old_artworkID,
    new_artworkID,
    artName,
    dateCreated,
    artPeriodCode,
    artMediumCode,
    digitalArt
  } = req.body;

  try {
    const [rows] = await db.query(
      'SELECT * FROM Artworks WHERE artworkID = ?',
      [old_artworkID]
    );

    if (rows.length === 0) {
      return res.status(404).send('Artwork not found.');
    }

    const current = rows[0];

    const parsedOldID = parseInt(old_artworkID);
    const finalID = new_artworkID && new_artworkID.trim() !== ''
      ? parseInt(new_artworkID)
      : parsedOldID;
    const finalName = artName || current.artName;
    const finalDate = dateCreated || current.dateCreated;
    const finalPeriod = artPeriodCode || current.artPeriodCode;
    const finalMedium = artMediumCode || current.artMediumCode;
    const finalDigital = digitalArt === '1' ? 1 : 0;

    await db.query(
      `CALL sp_update_artwork(?, ?, ?, ?, ?, ?, ?, @msg);`,
      [
        parsedOldID,
        finalID,
        finalDigital,
        finalDate,
        finalPeriod,
        finalMedium,
        finalName
      ]
    );

    const [[{ statusMessage }]] = await db.query(`SELECT @msg AS statusMessage;`);
    console.log('Update Status:', statusMessage);

    res.redirect('/artworks');
  } catch (err) {
    console.error('Error updating artwork:', err);
    res.status(500).send('An error occurred while updating the artwork.');
  }
});

app.post('/artists/update', async (req, res) => {
  const {
    old_artistID,
    new_artistID,
    fullName,
    genderCode,
    queer,
    residenceLocID,
    birthLocID
  } = req.body;

  try {
    const [rows] = await db.query('SELECT * FROM Artists WHERE artistID = ?', [old_artistID]);
    if (rows.length === 0) {
      return res.status(404).send('Artist not found.');
    }

    const current = rows[0];

    const finalOldID = parseInt(old_artistID);
    const finalNewID = new_artistID && new_artistID.trim() !== ''
      ? parseInt(new_artistID)
      : finalOldID;

    const finalName = fullName || current.fullName;
    const finalGender = genderCode || current.genderCode;
    const finalQueer = queer === '1' ? 1 : 0;
    const finalRes = residenceLocID || current.residenceLocID;
    const finalBirth = birthLocID || current.birthLocID;

    await db.query(
      `CALL sp_update_artist(?, ?, ?, ?, ?, ?, ?, @msg);`,
      [
        finalOldID,
        finalNewID,
        finalName,
        finalGender,
        finalQueer,
        finalRes,
        finalBirth
      ]
    );

    const [[{ statusMessage }]] = await db.query('SELECT @msg AS statusMessage;');
    console.log('Update Status:', statusMessage);

    res.redirect('/artists');
  } catch (err) {
    console.error('Error updating artist:', err);
    res.status(500).send('An error occurred while updating the artist.');
  }
});

app.post('/artists/create', async (req, res) => {
  const {
    create_artist_fullname,
    create_artist_gender,
    create_artist_queer,
    create_artist_res_loc,
    create_artist_birth_loc
  } = req.body;

  const queer = create_artist_queer === '1' ? 1 : 0;
  const resLoc = create_artist_res_loc === 'NULL' ? null : create_artist_res_loc;
  const birthLoc = create_artist_birth_loc === 'NULL' ? null : create_artist_birth_loc;

  try {
    // Step 1: Call the stored procedure
    await db.query(
      'CALL sp_insert_artist(?, ?, ?, ?, ?, @new_id);',
      [
        create_artist_fullname,
        create_artist_gender,
        queer,
        resLoc,
        birthLoc
      ]
    );

    // Step 2: Retrieve the output artist ID
    const [[{ artistID }]] = await db.query('SELECT @new_id AS artistID;');

    console.log('New Artist Inserted, ID:', artistID);
    res.redirect('/artists');
  } catch (err) {
    console.error('Error inserting artist:', err);
    res.status(500).send('An error occurred while inserting the artist.');
  }
});

app.post('/artworks/create', async (req, res) => {
  const {
    create_artwork_name,
    create_artwork_digitalArt,
    create_artwork_datecreated,
    create_artwork_artPeriodCode,
    create_artwork_artmediumcode,
    create_artwork_artist
  } = req.body;

  const digital = create_artwork_digitalArt === '1' ? 1 : 0;
  const dateCreated = create_artwork_datecreated || null;
  const period = create_artwork_artPeriodCode || null;
  const medium = create_artwork_artmediumcode || null;
  const name = create_artwork_name || null;
  const artistID = create_artwork_artist;

  if (artistID === 'NULL' || !artistID) {
    return res.status(400).send('Artwork must have an associated artist.');
  }

  try {
    // 1. Insert the artwork and get the new ID
    await db.query(
      'CALL sp_insert_artwork(?, ?, ?, ?, ?, @new_artwork_id);',
      [digital, dateCreated, period, medium, name]
    );

    const [[{ artworkID }]] = await db.query('SELECT @new_artwork_id AS artworkID;');

    if (!artworkID) {
      return res.status(500).send('Failed to retrieve new artwork ID.');
    }

    // 2. Link the artist to the artwork
    await db.query(
      'CALL sp_insert_artist_artwork(?, ?, @link_msg);',
      [artistID, artworkID]
    );

    const [[{ linkMessage }]] = await db.query('SELECT @link_msg AS linkMessage;');
    console.log('Link Status:', linkMessage);

    res.redirect('/artworks');
  } catch (err) {
    console.error('Error creating artwork with artist link:', err);
    res.status(500).send('An error occurred while creating the artwork.');
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