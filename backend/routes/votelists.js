import { Router } from 'express';
import { Pool } from 'pg';

const router = Router();
const pool = new Pool({ connectionString: process.env.DB_HOST, ssl: { rejectUnauthorized: false } });

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

export default router;
