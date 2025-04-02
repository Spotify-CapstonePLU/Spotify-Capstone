const express = require("express");
const authRoutes = require("./routes/auth");
const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Backend server for Spotify App is running!");
});

app.use('/auth', authRoutes)

app.listen(PORT, () => {
  console.log(`Server is running on http://127.0.0.1:${PORT}`);
});
