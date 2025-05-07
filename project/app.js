// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 41121;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

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
        const query1 = `SELECT Artists.artistID, Artists.fullName AS 'Name', \
            Artists.genderCode AS 'Gender', Artists.queer AS 'Queer', \
            Artists.residenceLocID AS 'ResidenceID', \
            Artists.birthLocID AS 'BirthplaceID', \
            Locations.country AS 'Country', Locations.state AS 'State' FROM Artists \
            LEFT JOIN Locations ON Artists.birthLocID = Locations.locationID;`;
        const query2 = 'SELECT * FROM Locations;';
        const [Artists] = await db.query(query1);
        const [Locations] = await db.query(query2);

        // Render the artists.hbs file, and also send the renderer
        //  an object that contains our artsts and locations information
        res.render('artists', { Artists: Artists, Locations: Locations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
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