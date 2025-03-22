import cookieParser from 'cookie-parser';
import { Router } from 'express';
import pg from 'pg';
import axios from 'axios';
import { VerifyTokens } from './auth.js';
import dotenv from 'dotenv';

const { Pool } = pg;

dotenv.config();

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
    let user_id;
    try { // Retrieve user's id
        user_id = await getUserID(req.cookies.access_token);
        console.log("user_id:" + user_id);
    } catch(error) {
        console.error(error);
        return res.status(500).send("Failed to retrieve user's id.");
    }
    
    try {
        console.log("connect")
        const result = await pool.query(`SELECT Votelists.* FROM Votelists
                                         JOIN Collaborators ON Collaborators.playlist_id = Votelists.playlist_id
                                         WHERE Collaborators.user_id = $1`,
            [user_id]
        );
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        return res.status(500).send('Server error getting votelists');
    }
});

async function getUserID(access_token) {
    const response = await axios.get('https://api.spotify.com/v1/me', {
        headers: { Authorization: `Bearer ${access_token}` }
    });
    return response.data.id;
}

// Create a new Spotify playlist
router.post('/create', VerifyTokens, async (req, res) => {
    // Create a new Spotify playlist
    // Register the new votelist
    const access_token = req.cookies.access_token;
    const { name } = req.body;
    if (!name) {
        return res.status(400).send("Playlist name is required.");
    }
    let user_id;
    try { // Retrieve user's id
        user_id = await getUserID(access_token);
        console.log("user_id:" + user_id);
    } catch(error) {
        console.error(error);
        return res.status(500).send("Failed to retrieve user's id.");
    }

    try { // Get response from playlist creation
        const response = await axios.post(`https://api.spotify.com/v1/users/${user_id}/playlists`, {
            "name": name,
            "public": true,
            "collaborative": false
        }, {
            headers: { Authorization: `Bearer ${access_token}` }
        });
        
        try { // Use playlist id in response to register as votelist.
            const result = await registerVotelist(await response.data.id, name);
            res.json(result.rows[0]);
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
    // TODO VerifyTokens
    const { id, name } = req.body;
    try {
        const result = await registerVotelist(id, name);
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        return res.status(500).send('Error registering votelist');
    }
});

async function registerVotelist(id, name) {
    const result = await pool.query(
        'INSERT INTO Votelist (playlist_id, name) VALUES ($1, $2) RETURNING *',
        [id, name]
    );
    return result.rows[0];
}

// Get user's Spotify playlists
router.get('/votelists/playlists', async (req, res) => {
    // TODO VerifyTokens
    const access_token = req.cookies.access_token;
    try {
        const response = await axios.get(`https://api.spotify.com/v1/me/playlists`, {
            headers: { Authorization: `Bearer ${access_token}` }
        })
        res.json(response.data)
    } catch (error) {
        console.error(error);
        res.status.send("Error requesting user's playlists from Spotify.");
    }
})

export default router;
