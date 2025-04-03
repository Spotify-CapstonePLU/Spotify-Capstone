import { Router } from 'express';
import cookieParser from 'cookie-parser';
import pg from 'pg';
import { SpotifyClient } from '../clients/spotify_client.js';
import { VerifyTokens } from './auth.js';

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
router.use(cookieParser())

// Get all polls for votelist
router.get('/:playlist_id', async (req, res) => {
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

// Insert/update row in votes table(whenever a vote is made)
router.post('/', VerifyTokens, async (req, res) => {
    // TODO 
    const { poll_id : pollId, vote } = req.body;
    const spotifyClient = new SpotifyClient(req.cookies.access_token);
    const userId = await spotifyClient.getUserData();
    try {
        const result = await pool.query(
            `INSERT INTO votes(poll_id, user_id, vote)
             VALUES ($1, $2, $3)
             ON CONFLICT (poll_id, user_id) DO UPDATE
             SET vote = EXCLUDED.vote`,
            [pollId, userId, vote]
        )
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error updating poll.');
    }
});

// Search songs on Spotify
router.post('/songs/:query', VerifyTokens, async (req, res) => {
    // TODO VerifyTokens
    const access_token = req.cookies.access_token
    const { query } = req.params
    const spotifyClient = new SpotifyClient(access_token);
    try {        
        res.json(await spotifyClient.searchSongs(query));
    } catch (error) {
        console.error(error);
        res.status.send('Error requesting from Spotify.');
    }

})

export default router;
