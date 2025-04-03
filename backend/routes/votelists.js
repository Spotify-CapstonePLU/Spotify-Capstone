import cookieParser from 'cookie-parser';
import { Router } from 'express';
import pg from 'pg';
import { VerifyTokens } from './auth.js';
import dotenv from 'dotenv';
import { SpotifyClient } from '../clients/spotify_client.js';

dotenv.config();

const { Pool } = pg;
const router = Router();
const pool = new Pool({ 
    host: process.env.DB_HOST,
    user: process.env.DB_USER, 
    port: process.env.DB_PORT,
    password: process.env.DB_PASSWORD,
    database: "postgres",
    ssl: { rejectUnauthorized: false } 
});

router.use(cookieParser());

// Get all user's votelists
router.get('/', VerifyTokens, async (req, res) => {
    let userId;
    const spotifyClient = new SpotifyClient(req.cookies.access_token);
    try { // Retrieve user's id
        const userData = await spotifyClient.getUserData();
        userId = userData.id;
        console.log("/ route, userId:" + userId);
        if (!userId) {
            throw new Error("userId is undefined.")
        }
    } catch(error) {
        console.error(error);
        return res.status(500).send("Failed to retrieve user's id.");
    }
    
    try {
        console.log("attempt connection")
        const result = await pool.query(`
            SELECT * FROM Votelists
            WHERE owner_id = $1
            UNION
            SELECT Votelists.* FROM Votelists
            JOIN Collaborators ON Collaborators.playlist_id = Votelists.playlist_id
            WHERE Collaborators.user_id = $1`,
            [userId]
        );
        console.log(result.rows)
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        return res.status(500).send('Server error getting votelists');
    }
});



// Create a new Spotify playlist
router.post('/create', VerifyTokens, async (req, res) => {
    const access_token = req.cookies.access_token;
    const { playlist_name: playlistName } = req.body;
    const spotifyClient = new SpotifyClient(access_token);

    if (!playlistName) {
        return res.status(400).send("Playlist name is required.");
    }

    let userId;
    try { // Retrieve user's id
        const userData = await spotifyClient.getUserData();
        userId = userData.id;
        console.log("/create route, userId:" + userId);
        if (!userId) {
            throw new Error("userId is undefined.")
        }
    } catch(error) {
        console.error(error);
        return res.status(500).send("Failed to retrieve user's id.");
    }

    try { // Get response from playlist creation
        const playlistData = await spotifyClient.createPlaylist(playlistName, userId);
        
        console.log('playlist data:' + await playlistData.id);

        if (!playlistData.id) {
            throw new Error('Missing required field: id.')
        }
        
        try { // Use playlist id in response to register as votelist.
            const result = await registerVotelist(await playlistData.id, playlistName, userId);
            res.json(result);
        } catch (error) {
            console.error(error);
            return res.status(500).send('Error registering votelist');
        }

    } catch(error) {
        console.error(error)
        return res.status(500).send("Failed to create Spotify playlist.")
    }

})

// Register an existing playlist as a votelist
router.post('/register', VerifyTokens, async (req, res) => {
    const access_token = req.cookies.access_token;
    const spotifyClient = new SpotifyClient(access_token);
    let userId;
    try { // Retrieve user's id
        const userData = await spotifyClient.getUserData();
        userId = userData.id;
        console.log("/register route, userId:" + userId);
    } catch(error) {
        console.error(error);
        return res.status(500).send("Failed to retrieve user's id.");
    }

    const { playlist_id: playlistID, playlist_name: playlistName } = req.body;
    try { //register votelist
        const result = await registerVotelist(playlistID, playlistName, userId);
        res.json(result);
    } catch (error) {
        console.error(error);
        return res.status(500).send('Error registering votelist');
    }
});

async function registerVotelist(playlistID, playlistName, userId) {
    const pgClient = await pool.connect();

    try {
        await pgClient.query('BEGIN');
        // Insert into Votelists
        const votelistResult = await pgClient.query(
            `INSERT INTO Votelists (playlist_id, playlist_name, owner_id) 
             VALUES ($1, $2, $3) RETURNING *;`,
            [playlistID, playlistName, userId]
        );

        // // Insert into Collaborators
        // const collaboratorResult = await pgClient.query(
        //     `INSERT INTO Collaborators (playlist_id, user_id) 
        //      VALUES ($1, $2) RETURNING *;`,
        //     [playlistID, userId]
        // );

        await pgClient.query('COMMIT'); // Commit transaction
        // console.log(votelistResult.rows, collaboratorResult.rows);
        // return { votelist: votelistResult.rows[0], collaborator: collaboratorResult.rows[0] };
        return votelistResult.rows[0];
    } catch (error) {
        await pgClient.query('ROLLBACK'); // Rollback if any error occurs
        console.error('Error in registerVotelist:', error);
        throw error;
    } finally {
        pgClient.release(); // Release the client back to the pool
    }
}

// Get user's Spotify playlists
router.get('/playlists', VerifyTokens, async (req, res) => {
    const access_token = req.cookies.access_token;
    const spotifyClient = new SpotifyClient(access_token);
    try {
        res.json(await spotifyClient.getUserPlaylists())
    } catch (error) {
        console.error(error);
        return res.status(500).send("Error requesting user's playlists from Spotify.");
    }
})

export default router;
