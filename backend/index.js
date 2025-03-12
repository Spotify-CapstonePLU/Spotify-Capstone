const express = require("express");
const axios = require("axios");

const cookieParser = require("cookie-parser");
const querystring = require("querystring");

const app = express();
app.use(cookieParser());
const PORT = 3000;

require("dotenv").config();

const CLIENT_ID = process.env.SPOTIFY_CLIENT_ID;
const CLIENT_SECRET = process.env.SPOTIFY_CLIENT_SECRET;
const REDIRECT_URI = process.env.SPOTIFY_REDIRECT_URI;
const SPOTIFY_SCOPES = process.env.SPOTIFY_SCOPES;

app.get("/", (req, res) => {
  res.send("Backend server for Spotify App is running!");
});

app.get("/auth", VerifyTokens, (req, res) => {
  console.log("User is authenticated!");
  res.send(req.cookies)
});

app.get("/callback", async (req, res) => {
  var code = req.query.code || null;
  var state = req.query.state || null;

  if (state === null) {
    return res.redirect(
      "/#" +
        querystring.stringify({
          error: "state_mismatch",
        })
    );
  } else {
    const response = await axios.post(
      "https://accounts.spotify.com/api/token",
      querystring.stringify({
        code: code,
        redirect_uri: REDIRECT_URI,
        grant_type: "authorization_code",
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
      }),
      {
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
      }
    );

    const access_token = response.data.access_token;
    const expires_in = response.data.expires_in * 1000;

    const refresh_token = response.data.refresh_token;
    res.cookie("refresh_token", refresh_token, {
      httpOnly: true,
      secure: false, // Set to true when deploying to production
      maxAge: 1000 * 60 * 60 * 24 * 30, // Set to expire in 30 days
    });
    res.cookie("access_token", access_token, {
      httpOnly: true,
      secure: false, // Set to true when deploying to production
      maxAge: expires_in, // 1 hour before expriring
    });
  }

  res.send("User has been authenticated!");
});

app.listen(PORT, () => {
  console.log(`Server is running on http://127.0.0.1:${PORT}`);
});

function generateRandomString(length) {
  const chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let result = "";

  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }

  return result;
}

async function VerifyTokens(req, res, next) {
  const access_token = req.cookies.access_token;
  if (access_token) {
    console.log("Access token found!");
    next();
    return;
  }

  console.log("No access token found!");

  const refresh_token = req.cookies.refresh_token;
  if (refresh_token) {
    console.log("Refresh token found! Attempting to refresh token...");
    const response = await axios.post(
      "https://accounts.spotify.com/api/token",
      querystring.stringify({
        grant_type: "refresh_token",
        refresh_token: refresh_token,
      }),
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          Authorization:
            "Basic " +
            new Buffer.from(CLIENT_ID + ":" + CLIENT_SECRET).toString("base64"),
        },
      }
    );

    const new_access_token = response.data.access_token;
    const expires_in = response.data.expires_in * 1000;
    res.cookie("access_token", new_access_token, {
      httpOnly: true,
      secure: false, // Set to true when deploying to production
      maxAge: expires_in, // 1 hour before expiring
    });
    
    next();
    return;
  } else {
    console.log("User has not logged in yet. Redirecting to login...");
    var state = generateRandomString(16);

    res.redirect(
      "https://accounts.spotify.com/authorize?" +
        querystring.stringify({
          response_type: "code",
          client_id: CLIENT_ID,
          scope: SPOTIFY_SCOPES,
          redirect_uri: REDIRECT_URI,
          state: state,
        })
    );
  }
}
