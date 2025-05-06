
import cookieParser from 'cookie-parser';
import pg from 'pg';
import { SpotifyClient } from '../clients/spotify_client.js';

const { Pool } = pg;
const pool = new Pool({ 
    host: process.env.DB_HOST,
    user: process.env.DB_USER, 
    port: process.env.DB_PORT,
    password: process.env.DB_PASSWORD,
    database: "postgres",
    ssl: { rejectUnauthorized: false } 
});

export default async function voteHandler(pollId, vote, access_token) {
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

    try {
        const result = await pool.query(
            `INSERT INTO Votes(poll_id, user_id, vote)
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
}