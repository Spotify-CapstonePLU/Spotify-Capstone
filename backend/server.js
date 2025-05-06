import express from "express";
import expressWs from "express-ws";
import cors from "cors";
import bodyParser from "body-parser";
import authRoutes from "./routes/auth.js";
import votelistRoutes from "./routes/votelists.js";
import votingRoutes from "./routes/voting.js";
import votingWsRoutes from "./websockets/voting.js";

const app = express();
expressWs(app)
const PORT = 3000;

app.use(
  cors({
    origin: "http://127.0.0.1:8000",
    credentials: true
  })
);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.send("Backend server for Spotify App is running!");
});

app.use("/auth", authRoutes);
app.use("/votelists", votelistRoutes);
app.use("/voting", votingRoutes);

app.ws("/voting", votingWsRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on http://127.0.0.1:${PORT}`);
});
