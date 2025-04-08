import { Router } from 'express';
import cookieParser from 'cookie-parser';
import pg from 'pg';
import { SpotifyClient } from '../clients/spotify_client.js';
import { AuthenticateApp, VerifyTokens } from './auth.js';

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
router.get('/polls/:playlist_id', VerifyTokens, async (req, res) => {
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
});

// Search songs on Spotify
router.get('/search/:song', AuthenticateApp, async (req, res) => {
    // TODO VerifyTokens
    const app_token = (req.cookies.app_token) ? req.cookies.app_token : res.locals.app_token;
    const { song } = req.params
    const spotifyClient = new SpotifyClient(app_token);
    console.log(app_token)
    try {        
        res.json(await spotifyClient.searchSongs(song));
    } catch (error) {
        console.error(error);
        res.status(401).send('Error requesting from Spotify.');
    }

})

router.post("/polls/create", VerifyTokens, async (req, res) => {
  const { playlist_id: playlistId, song_id: songId } = req.body;

  try {
    // Determine if a poll can be created
    const canMakePoll = await pool.query(
      ` SELECT 
            MAX(end_time) FILTER (WHERE end_time > NOW()) AS active_poll,
            (NOW() - MAX(end_time)) >= (
                    SELECT min_poll_timeout FROM Votelists 
                    WHERE playlist_id = $1
            ) AS timeout_window_elapsed
        FROM polls
        WHERE playlist_id = $1 AND song_id = $2`,
      [playlistId, songId]
    );
    const [activePoll, timeoutWindowElapsed] = [
      canMakePoll.rows[0]?.active_poll,
      canMakePoll.rows[0]?.timeout_window_elapsed,
    ];

    if (activePoll) {
      return res.status(400).send("There is already an active poll.");
    }

    if (!timeoutWindowElapsed) {
      return res.status(401).send("You must wait to start another poll.");
    }

    // Determine if the poll is to remove or add a song
    const song = await pool.query(
      `SELECT COUNT(*) > 0 AS exists_in_votelist
             FROM votelist_songs
             WHERE playlist_id = $1 AND song_id = $2`,
      [playlistId, songId]
    );
    const pollType = song.rows[0].exists_in_votelist ? "remove" : "add";

    const deletePoll = await pool.query(
      `DELETE FROM polls
         WHERE playlist_id = $1, song_id = $2`,
      [playlistId, songId]
    );

    const result = await pool.query(
      `INSERT INTO polls (poll_type, playlist_id, song_id)
             VALUES ($1, $2, $3)
             ON CONFLICT DO NOTHING`,
      [pollType, playlistId, songId]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error creating poll.");
  }
});

export default router;
