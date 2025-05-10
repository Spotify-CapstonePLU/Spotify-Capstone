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
  const spotifyClient = new SpotifyClient(req.cookies.access_token);
  try {
    const result = await pool.query(`SELECT 
                                       Polls.*, 
                                       to_jsonb(Songs) AS song
                                     FROM Polls
                                     LEFT JOIN Songs ON Songs.song_id = Polls.song_id
                                     WHERE Polls.playlist_id = $1;`,
      [playlist_id]
    );
    const songIds = result.rows.map((track) => track.song_id);
    if (songIds.length == 0) {
      return res.json([])
    }
    const images = (await spotifyClient.getSongsById(songIds)).map((track) => track.imageUrl);
    const realResult = result.rows.map((row, index) => ({
      ...row,
      song: {
        ...row.song,
        imageUrl: images[index]
      }
    }));
    console.log("help4")
    res.json(realResult);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error retrieving polls.');
  }
});

// Insert/update row in votes table(whenever a vote is made)
// should be websocket
router.post('/', VerifyTokens, async (req, res) => {
  // TODO 
  const { poll_id: pollId, vote } = req.body;
  const spotifyClient = new SpotifyClient(req.cookies.access_token);
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
});

// Search songs on Spotify
router.get('/search', AuthenticateApp, async (req, res) => {
  // TODO VerifyTokens
  const app_token = (req.cookies.app_token) ? req.cookies.app_token : res.locals.app_token;
  const song = req.query.song;
  const spotifyClient = new SpotifyClient(app_token);
  console.log(app_token)
  try {
    const songs = await spotifyClient.searchSongs(song);
    const result = songs.tracks.items.map((track) => ({
        song_id: track.id,
        title: track.name,
        album: track.album.name,
        artists: track.artists.map(artist => artist.name),
        imageUrl: track.album.images?.[0]?.url
      
    }))
    res.json(result);
  } catch (error) {
    console.error(error);
    // console.error('Error searching songs:', error.response?.data || error.message);
    const status = 500
    if (error.response?.status) {
      status = error.response?.status
    }
    res.status(status).send('Error searching songs from spotify.');
  }

})

router.post("/polls/create", VerifyTokens, async (req, res) => {
  const { playlist_id: playlistId, song_id: songId } = req.body;
  const spotifyClient = new SpotifyClient(req.cookies.access_token);

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

    if (timeoutWindowElapsed) {
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
         WHERE playlist_id = $1 AND song_id = $2`,
      [playlistId, songId]
    );

    const songInfo = (await spotifyClient.getSongsById([songId]))[0];

    const makeSong = await pool.query(
      `INSERT INTO Songs (song_id, title, album, artists)
            VALUES ($1, $2, $3, $4)
            ON CONFLICT DO NOTHING`,
      [songInfo.song_id, songInfo.name, songInfo.album, JSON.stringify(songInfo.artists)]
    )

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
