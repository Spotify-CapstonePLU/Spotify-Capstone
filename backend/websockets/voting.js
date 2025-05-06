import { Router } from 'express';

const routerWs = Router();

routerWs.ws('/voting', (ws, req) => {
  console.log('WebSocket /voting connected');

  ws.on('message', async (msg) => {
    console.log('Received:', msg);
    // ws.send(`Echo: ${msg}`);

    // run code that does sql stuff for vote
    // create function(in another file?) that sends data to sql function and 
    // waits for response to send back (backend controller)

    try {
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
          ws.send(JSON.stringify({ type: 'error', message: `Server error registering vote. pollId: ${pollId}` }));
        }

        // Send response back to client
        ws.send(JSON.stringify({
          type: 'vote_ack',
          success: true,
          pollId: pollId,
          message: voteResult
        }));
      } else {
        ws.send(JSON.stringify({ type: 'error', message: 'Unknown message type' }));
      }
    } catch (err) {
      console.error('WebSocket error:', err);
      ws.send(JSON.stringify({ type: 'error', message: 'Invalid message format' }));
    }
  });

  ws.on('close', () => {
    console.log('WebSocket /voting disconnected');
  });
});

