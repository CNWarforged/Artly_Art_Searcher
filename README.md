Citations:

Source code was used and adapted from: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948
Used for: Creating the Node.JS starting code and the CRUD pages for our "Artists" page and home page
Date: 5/6/2025

Adobe Colors was used to create a color theme for our website. Source: https://color.adobe.com/create/image
Used For: We used Van Gogh's Sunflowers to sample colors for the theme and used the hex code colors provided by Adobe for our web page.
Date: 5/6/2025

Background image for our website is Van Gogh's Sunflowers.
Used for: Background image and color theme
Date: 5/6/2025

The feedback from other users on our project for the Step 1 draft was found on the Ed_Discussion board, on the topic page: https://edstem.org/us/courses/76857/discussion/6537789
The feedback from other users on our project for the Step 2 draft was found on the Ed_Discussion board, on the topic page: 
https://edstem.org/us/courses/76857/discussion/6638303
The feedback from other users on our project for the Step 3 draft was found on the Ed_Discussion board, on the topic page: 
https://edstem.org/us/courses/76857/discussion/6677618

The TA’s feedback was from the rubric and grading board.
On: 5/13/2025:
For: home.hbs, artists.hbs, artworks.hbs, locations.hbs, gendercodes.hbs, mediums.hbs, CSS
Source: Class exploration - Web Application Technology
Starter code from class was used to model our basic webpages and the start of our CSS

On: 5/13/2025
For: sp_load_artlydb
Source: https://chatgpt.com/
AI was used for our stored proc “sp_load_artlydb” as per instructions. We chose ChatGPT.
The prompt we used was: 
“Hi! For an assignment I was told to give you my DDL schema for MariaDB and ask you to make a stored proc for me to use to be able to load our database queries and our sample data. 
Here's the DDL data we made:
[DDL.SQL was provided from our project here]”
It was then edited for style and useability.

On: 5/13/2025
For: v_artistartcount
Source: https://chatgpt.com/
ChatGPT AI was used to make a view v_artistartcount.
The prompt used was: 
“Using the schema I just sent for Maria DB, could you create a view called v_artistartcount for me that shows the artists (their name and residence location) and a count showing each of their artwork numbers in our database?”
The results required a few round with the AI since we accidentally asked for residence location and not birth location, and also because the AI tried to concatenate all location data into one string.

On: 5/13/2025
For: sp_insert_artist 
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_insert_artist.
The prompt used was: 
“Could you write me a stored proc for MariaDB called sp_insert_artist that will insert an artist into the db schema I gave, and will return the newly created ID?”

On: 5/13/2025
For: sp_insert_artwork
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_insert_artwork.
The prompt used was: 
“Could you also create a stored procedure called sp_insert_artwork that will use MariaDB and will insert an artwork into the Artworks table and then return the newly created ID?”

On: 5/13/2025
For: sp_insert_artist_with_artwork
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_insert_artist_with_artwork.
The prompt used was: 
“I would love a version that inserts into the ArtistArtworks version, and also a version that uses the validation logic”

On: 5/13/2025
For: sp_delete_artist
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_delete_artist.
The prompt used was: 
“Please write a stored procedure for Artists from the above schema called sp_delete_artist that will take an artist ID and will delete the artist from the ArtistArtworks table, and then will delete the artist from the Artists table, as well as deleting any associated artworks they had in the Artworks table. Please put these queries inside of a transaction so that if any of the queries fail they rollback.
If successful return "Artist and artworks deleted". Otherwise return "Error, artist not deleted". Please also write tests to verify the stored procedure functioned correctly. Thank you!”

Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_delete_artwork.
The prompt used was: 
“That's perfect! Please write a stored procedure for Artworks from the above schema called sp_delete_artwork that will take an artwork ID and will delete the artwork from the ArtistArtworks table, and then will delete the artwork from the Artworks table. Please put these queries inside of a transaction so that if any of the queries fail they rollback.
If successful return "Artwork deleted". Otherwise return "Error, artwork not deleted". Please also write tests to verify the stored procedure functioned correctly. Thank you!”

On: 5/13/2025
For: sp_update_artist
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_update_artist.
The prompt used was: 
“Could you now write me an update stored procedure for the schema for Maria DB to update any field in the Artist table, including the artist ID? It will also need to make sure that if the artist ID is updated to update the corresponding data in the ArtistArtworks table.”

On: 5/13/2025
For: sp_update_artist_partial
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_update_artist_partial.
The prompt used was: 
“a version that allows partial updates would be helpful!”

On: 5/13/2025
For: sp_update_artwork
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_update_artwork.
The prompt used was: 
“Thanks! Could I have a version of that procedure for fully updating a row in Artwork?”

On: 5/13/2025
For: sp_update_artwork_partial
Source: https://chatgpt.com/
ChatGPT AI was used to make a stored proc sp_update_artwork_partial.
The prompt used was: 
“Could you now write me an update stored procedure for the schema for Maria DB to update any field in the Artwork table, including the artwork ID? It will also need to make sure that if the artwork ID is updated to update the corresponding data in the ArtistArtworks table.”

On: 5/14/2025
For: New page: artist-summary (We had the other pages but wanted a page to make updating the table easy to see), edit-artists
Source: https://chatgpt.com/
ChatGPT AI was used to help with the artist-summary page.
The prompt used was: 
“That DDL (and eventually the stored procs I had you make) is the backend database for my class webpage, which is called Artly Art Searcher and is meant to be a developer-side archive for artists and art. I have some of the skeletons for the pages using Node.JS with Handlebars. I have a few pages, but want to make a combination page where Artists will be shown using the view I had you make that had a count of each artist's number of artworks. I want to have that query be its own page, with a button in the table for "Update" that will take the user to a page where a new query would only show the selected artist and then a list of each of their artworks. That page would be where the user can edit the artist, their artworks, or the connection between them. Here's what I have so far (very rough so far I know! I just started this part.)”
As a part of this prompt result the edit-artists page was also created initially by AI and then edited.

On: 5/21/2025 
For: Code and placement for Reset Button on artist-summary.hbs page
Source: chatgpt.com
ChatGPT AI was use to figure out what we were doing wrong with our code to make a reset button for our form.
The prompt used was: 
I'm still getting the hang of javascript! My next immediate task is to implement a button on one of the webpages to allow a user to reset the database. I have the stored procedure already with my DDL in it, so that part is good. I added a reset button on this page, but would like to know if that seems like the right sort of button.”
[ Code for the artist-summary.hbs page ]

Citation for AI use:
On 5/22/2025
For: The POST app.js statements to call the stored procedures for our deletes
Source: chatgpt.com
ChatGPT was used to figure out the format for the post statements for our deletes
The prompt used was: 
“What should the app.js side look like for using a "delete" button on the artists page to call the sp_delete_artist stored procedure?”
