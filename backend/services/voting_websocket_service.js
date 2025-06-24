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
            return "User ID not found.";
        }
    } catch (error) {
        console.error(error);
        if (error.response?.status === 401) {
            return "Invalid or expired Spotify access token.";
        }
        return "Failed to retrieve user's id.";
    }

    try {
        const voteResult = await pool.query(
            `INSERT INTO Votes(poll_id, user_id, vote)
             VALUES ($1, $2, $3::vote)
             ON CONFLICT (poll_id, user_id) DO UPDATE
             SET vote = EXCLUDED.vote`,
            [pollId, userId, vote]
        )

        const result = await pool.query(
            `SELECT 
                Polls.*, 
                to_jsonb(Songs) AS song
             FROM Polls
             LEFT JOIN Songs ON Songs.song_id = Polls.song_id
             WHERE poll_id = $1
            `,
            [pollId]
        )
        const songIds = result.rows.map((track) => track.song_id);
        if (songIds.length == 0) {
            return JSON.stringify([]);
        }
        const images = (await spotifyClient.getSongsById(songIds)).map((track) => track.imageUrl);
        const realResult = result.rows.map((row, index) => ({
            ...row,
            song: {
                ...row.song,
                imageUrl: images[index]
            }
        }));
        return JSON.stringify(realResult);
    } catch (error) {
        console.error(error);
        return "Error updating poll.";
    }
}