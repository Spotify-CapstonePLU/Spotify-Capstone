import { Router } from 'express';
import { Pool } from 'pg';
import { Axios } from 'axios';

const axios = new Axios();
const router = Router();
const pool = new Pool({ connectionString: process.env.DB_HOST, ssl: { rejectUnauthorized: false } });


export default router;
