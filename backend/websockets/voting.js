export default function registerVotingWebSockets(app) {
    app.ws('/voting', (ws, req) => {
      console.log('WebSocket /voting connected');
  
      ws.on('message', (msg) => {
        console.log('Received:', msg);
        ws.send(`Echo: ${msg}`);
      });
  
      ws.on('close', () => {
        console.log('WebSocket /voting disconnected');
      });
    });
  }
  