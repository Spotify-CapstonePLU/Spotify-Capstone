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
        const userId = userData.id;
        // console.log("/ route, userId:" + userId);

        if (!userId) {
            return res.status(404).send("User ID not found.");
        }
    } catch (error) {
        console.error(error);
        if (error.response?.status === 401) {
            return res.status(401).send("Invalid or expired Spotify access token.");
        }
        return res.status(500).send("Failed to retrieve user's id.");
    }

    try {
        console.log("attempt connection")
        const result = await pool.query(`SELECT Votelists.* FROM Votelists
                                         LEFT JOIN Collaborators ON collaborators.user_id = votelists.owner_id
                                         WHERE Votelists.owner_id = $1`,
            [userId]
        );
        console.log(result.rows)
        res.json(result.rows);
    } catch (error) {
        console.error("Server error getting votelists:", {
            message: error.message,
            code: error.code,
            detail: error.detail,
            stack: error.stack
        });
        return res.status(500).send('Server error getting votelists.');
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
        // console.log("/create route, userId:" + userId);
        if (!userId) {
            return res.status(404).send("User ID not found.");
        }
    } catch (error) {
        console.error(error);
        if (error.response?.status === 401) {
            return res.status(401).send("Invalid or expired Spotify access token.");
        }
        return res.status(500).send("Failed to retrieve user's id.");
    }

    try { // Get response from playlist creation
        const playlistData = await spotifyClient.createPlaylist(playlistName, userId);

        console.log('playlist data:' + await playlistData.id);

        if (!playlistData.id) {
            return res.status(502).send("Invalid response from Spotify API - playlist id missing.");
        }

        const playlistId = playlistData.id
        try { //register votelist
            const result = await registerVotelist(playlistId, playlistName, userId);
        } catch (error) {
            // console.error('Error registering votelist:', error);

            // Default status code
            let status = 500;
            let message = 'Internal Server Error';

            // Handle specific Postgres error codes
            if (error.code === '23505') {
                // Unique constraint violation
                status = 409;
                message = 'A votelist with this playlist already exists.';
            } else if (error.code === '23503') {
                // Foreign key violation
                status = 400;
                message = 'Invalid user or playlist ID.';
            } else if (error.message) {
                // Fallback to error message if available
                message = error.message;
            }

            return res.status(status).send(message);
        }

    } catch (error) {
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
        // console.log("/create route, userId:" + userId);
        if (!userId) {
            return res.status(404).send("User ID not found.");
        }
    } catch (error) {
        console.error(error);
        if (error.response?.status === 401) {
            return res.status(401).send("Invalid or expired Spotify access token.");
        }
        return res.status(500).send("Failed to retrieve user's id.");
    }

    const { playlist_id: playlistId, playlist_name: playlistName } = req.body;
    try { //register votelist
        const result = await registerVotelist(playlistId, playlistName, userId);
    } catch (error) {
        // console.error('Error registering votelist:', error);

        // Default status code
        let status = 500;
        let message = 'Internal Server Error';

        // Handle specific Postgres error codes
        if (error.code === '23505') {
            // Unique constraint violation
            status = 409;
            message = 'A votelist with this playlist already exists.';
        } else if (error.code === '23503') {
            // Foreign key violation
            status = 400;
            message = 'Invalid user or playlist ID.';
        } else if (error.message) {
            // Fallback to error message if available
            message = error.message;
        }

        return res.status(status).send(message);
    }

    let tracks;
    try {
        const playlist = await spotifyClient.getUserPlaylistSongs(playlistId)
        // console.log("after getUserPlaylistSongs")
        tracks = playlist.tracks.items;
    } catch (error) {
        console.error(error);
        return res.status(500).send('Error getting playlist tracks');
    }

    let songsVals = tracks.map(track => {
        const songId = track.track.id;
        const title = track.track.name.replace(/'/g, "''");  // Escape single quotes
        const album = track.track.album.name.replace(/'/g, "''");
        const artists = JSON.stringify(track.track.artists); // Convert to JSON string
        const duration = track.track.duration_ms;

        return `('${songId}', '${title}', '${album}', '${artists}'::jsonb, ${duration})`;
    }).join(',');

    let votelistSongsVals = tracks.map(track =>
        `('${track.track.id}', '${playlistId}')`
    ).join(',');

    const songsQuery = `
        INSERT INTO Songs (song_id, title, album, artists, duration) 
        VALUES ${songsVals} 
        ON CONFLICT DO NOTHING 
        RETURNING *;
    `;

    const votelistSongsQuery = `
        INSERT INTO Votelist_Songs (song_id, playlist_id) 
        VALUES ${votelistSongsVals} 
        ON CONFLICT DO NOTHING
        RETURNING *;
    `;

    console.log("songsVals:", songsVals)
    console.log("votelist songs: ", votelistSongsVals)

    try {
        const result = await pool.query(songsQuery);
        console.log(result.rows[0])
    } catch (error) {
        console.error("Error inserting songs into Songs table:", {
            message: error.message,
            code: error.code,
            detail: error.detail,
            stack: error.stack
        });
        return res.status(500).send('Error inserting songs into Songs table.');
    }

    try {
        const result = await pool.query(votelistSongsQuery);
        console.log(result)
        res.json(result)
    } catch (error) {
        console.error("Error registering pre-existing playlist songs:", {
            message: error.message,
            code: error.code,
            detail: error.detail,
            stack: error.stack
        });
        return res.status(500).send('Error registering pre-existing playlist songs.');
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

        await pgClient.query('COMMIT'); // Commit transaction
        console.log(votelistResult.rows);
        return { votelist: votelistResult.rows[0] };
    } catch (error) {
        await pgClient.query('ROLLBACK'); // Rollback if any error occurs
        console.error('Error registering votelist:', error);
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
        const playlistData = await spotifyClient.getUserPlaylists();
        // const nextUrl = playlistData.next
        const playlistsJson = playlistData.items.map((playlist) => {
            const imageUrl = playlist.images?.[0]?.url ?? null;

            return {
                id: playlist.id, 
                name: playlist.name, 
                imageUrl
            };
        })
        console.log("playlistsJson:", playlistsJson)
        res.json(await playlistsJson)
    } catch (error) {
        console.error(error);
        return res.status(500).send("Error requesting user's playlists from Spotify.");
    }
})

export default router;
