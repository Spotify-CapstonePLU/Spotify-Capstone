import { Router } from 'express';
import expressWs from 'express-ws';
import pg from 'pg';
import cookieParser from 'cookie-parser';

const { Pool } = pg;
const pollPool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  port: process.env.DB_PORT,
  password: process.env.DB_PASSWORD,
  database: "postgres",
  ssl: { rejectUnauthorized: false }
});

const routerWs = Router();
routerWs.use(cookieParser());
expressWs(routerWs);

const pollClients = new Set();
const votingClients = new Set();

routerWs.ws('/polls', (ws) => {
  pollClients.add(ws)

  ws.on('close', () => {
    pollClients.delete(ws);
    console.log("Websockets /voting/polls disconnected");
  });
});


routerWs.ws('/', (ws, req) => {
  console.log('WebSocket /voting connected');
  votingClients.add(ws)
  ws.on('message', async (msg) => {
    console.log('Received:', msg);

    const data = JSON.parse(msg);

    if (data.type === 'vote') {
      const pollId = data.pollId;
      // const userId = data.userId;
      const vote = data.vote;

      // Example: pretend to send to DB/server and get a response
      let voteResult
      try {
        voteResult = await voteHandler(pollId, vote, req.cookies.access_token);
      } catch (error) {
        console.error("Server could not handle vote: " + error.message);
      }
    }
  });

  ws.on('close', () => {
    votingClients.delete(ws)
    console.log('WebSocket /voting disconnected');
  });
});

const NOTIFY_CHANNEL = 'polls_channel';

pollPool.query(`LISTEN ${NOTIFY_CHANNEL}`);

// Handle notifications from PostgreSQL
pollPool.on('notification', (msg) => {
  const payload = msg.payload;
  console.log('Received NOTIFY:', payload);

  // Broadcast payload to all connected WebSocket clients
  for (const client of pollClients) {
    if (client.readyState === 1) { // WebSocket.OPEN
      client.send(payload);
    }
  }
});


export default routerWs;