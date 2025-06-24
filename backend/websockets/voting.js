import { Router } from 'express';
import expressWs from 'express-ws';
import pg from 'pg';
import cookieParser from 'cookie-parser';
import voteHandler from '../services/voting_websocket_service.js';

const { Pool } = pg;
const pollPool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  port: process.env.DB_PORT,
  password: process.env.DB_PASSWORD,
  database: "postgres",
  ssl: { rejectUnauthorized: false }
});

const router = Router();
router.use(cookieParser());
expressWs(router);

const pollClients = new Set();
const votingClients = new Set();

router.ws('/polls', (ws) => {
  console.log('WebSocket /voting/polls connected');
  pollClients.add(ws)

  ws.on('close', () => {
    pollClients.delete(ws);
    console.log("Websockets /voting/polls disconnected");
  });
});

router.ws('/', (ws, req) => {
  console.log('WebSocket /voting connected');
  votingClients.add(ws)
  ws.on('open', () => {
    console.log('WebSocket open event triggered');
  });

  ws.on('message', async (msg) => {
    console.log('Received message on /voting:', msg);
    const data = JSON.parse(msg);


    const {vote, pollId, id} = data;
    let voteResult
    try {
      voteResult = await voteHandler(pollId, vote, req.cookies.access_token);
    } catch (error) {
      console.error("Server could not handle vote: " + error.message);
    }

    console.log("message id: " + id + ", " + voteResult);
    ws.send(voteResult);
  });

  ws.on('error', (err) => {
    console.error('WebSocket error:', err);
  });

  ws.on('close', () => {
    votingClients.delete(ws)
    console.log('WebSocket /voting disconnected');
  });
});

// const NOTIFY_CHANNEL = 'polls_channel';

// pollPool.query(`LISTEN ${NOTIFY_CHANNEL}`);

// // Handle notifications from PostgreSQL
// pollPool.on('notification', (msg) => {
//   const payload = msg.payload;
//   console.log('Received NOTIFY:', payload);

//   // Broadcast payload to all connected WebSocket clients
//   for (const client of pollClients) {
//     if (client.readyState === 1) { // WebSocket.OPEN
//       client.send(payload);
//     }
//   }
// });

export default router;