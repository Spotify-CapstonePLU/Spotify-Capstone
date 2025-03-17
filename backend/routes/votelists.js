import cookieParser from 'cookie-parser';
import { Router } from 'express';
import { Pool } from 'pg';
import { Axios } from 'axios';

require("dotenv").config

const axios = new Axios();
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
// Register an existing playlist as a votelist
router.post('/votelists/register', async (req, res) => {
    // TODO VerifyTokens
    const { id, name } = req.body;
    try {
        const result = await pool.query(
            'INSERT INTO Votelist (playlist_id, name) VALUES ($1, $2) RETURNING *',
            [id, name]
        );
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error adding votelist');
    }
});

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
