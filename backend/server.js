import express from "express";
import authRoutes from "./routes/auth.js";
import votelistRoutes from "./routes/votelists.js"
const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Backend server for Spotify App is running!");
});

app.use('/auth', authRoutes)
app.use('/votelists', votelistRoutes)

app.listen(PORT, () => {
  console.log(`Server is running on http://127.0.0.1:${PORT}`);
});
