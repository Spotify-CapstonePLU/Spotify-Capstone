import { Router } from 'express';
import { Pool } from 'pg';
import { Axios } from 'axios';

const axios = new Axios();
const router = Router();
const pool = new Pool({ connectionString: process.env.DB_HOST, ssl: { rejectUnauthorized: false } });

// Get all polls for votelist
router.get('/voting/:playlist_id', async (req, res) => {
    // TODO VerifyTokens
    const { playlist_id } = req.params;
    try {
        const result = await pool.query(`SELECT * from Poll
                                         WHERE playlist_id = $1`,
            [playlist_id]
        );
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Server error');
    }
});

// Update a poll's votes
router.patch('/voting', async (req, res) => {
    // TODO VerifyTokens
    const { poll_id, vote } = req.body;
    try {
        const result = vote ? await pool.query(
            `UPDATE Poll SET upvotes = upvotes + 1
             WHERE poll_id = $1
             RETURNING *`,
            [poll_id]
        ) :
        await pool.query(
            `UPDATE Poll SET downvotes = downvotes + 1
             WHERE poll_id = $1
             RETURNING *`,
            [poll_id]
        );
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error updating poll.');
    }
});

// Search songs on Spotify
router.post('/voting/spotify/:query', async (req, res) => {
    // TODO VerifyTokens
    const access_token = req.cookies.access_token
    const { query } = req.params
    try {
        const response = await axios.get(`https://api.spotify.com/v1/search?q=${query}&type=track`, {
            headers: { Authorization: `Bearer ${access_token}` }
        });
        
        res.json(response.data);
    } catch (error) {
        console.error(error);
        res.status.send('Error requesting from Spotify.');
    }

})

export default router;
