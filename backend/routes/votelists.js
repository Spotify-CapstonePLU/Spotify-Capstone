import cookieParser from 'cookie-parser';
import { Router } from 'express';
import pg from 'pg';
import axios from 'axios';
import { VerifyTokens } from './auth.js';
import dotenv from 'dotenv';

const { Pool } = pg;

dotenv.config();

const router = Router();
const pool = new Pool({ connectionString: process.env.DB_HOST, ssl: { rejectUnauthorized: false } });

router.use(cookieParser());

// Get all user's votelists
router.get('/votelists', async (req, res) => {
    // TODO VerifyTokens
    // TODO get user id from spotify
    const { id } = req.params;
    try {
        const result = await pool.query(`SELECT Votelist.* FROM Votelist
                                         JOIN Collaborators ON Collaborators.playlist_id = Votelist.playlist_id
                                         WHERE Collaborators.user_id = $1`,
            [id]
        );
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Server error');
    }
});

// Create a new Spotify playlist
router.post('/votelists/create', async (req, res) => {
    // Create a new Spotify playlist
    // Register the new votelist
    const { name } = req.body;
    var user_id;
    try { // Retrieve user's id
        const response = await axios.get('https://api.spotify.com/v1/me', {
            headers: { Authorization: `Bearer ${access_token}` }
        });
        user_id = await response.data.id;
        console.log("user_id:" + user_id);
    } catch(error) {
        console.error(error);
        res.status(500).send("Failed to retrieve user's id.");
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
            const result = registerVotelist(await response.data.id, name);
            res.json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).send('Error registering votelist');
        }

    } catch(error) {
        console.error(error)
        res.status(500).send("Failed to create Spotify playlist.")
    }

})

// Register an existing playlist as a votelist
router.post('/votelists/register', async (req, res) => {
    // TODO VerifyTokens
    const { id, name } = req.body;
    try {
        const result = registerVotelist(id, name);
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error registering votelist');
    }
});

async function registerVotelist(id, name) {
    const result = await pool.query(
        'INSERT INTO Votelist (playlist_id, name) VALUES ($1, $2) RETURNING *',
        [id, name]
    );
    return result
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
