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

export default router;
