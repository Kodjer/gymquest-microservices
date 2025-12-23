// src/server.ts
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import playerRoutes from "./routes/player";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3002;

app.use(cors());
app.use(express.json());

app.use("/api/players", playerRoutes);

app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    service: "Player Service",
    port: PORT,
  });
});

app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Player Service - Port 3002</title>
      <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; background: #f5f5f5; }
        h1 { color: #2ecc71; }
        .endpoint { background: white; padding: 15px; margin: 10px 0; border-left: 4px solid #2ecc71; }
        .method { color: #3498db; font-weight: bold; }
        code { background: #ecf0f1; padding: 2px 6px; border-radius: 3px; }
        .test-link { background: #3498db; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; display: inline-block; margin-top: 10px; }
      </style>
    </head>
    <body>
      <h1>🎮 Player Service</h1>
      <p>Status: <strong style="color: green;">✓ RUNNING</strong></p>
      <p>Port: <strong>3002</strong></p>
      
      <h2>Available Endpoints:</h2>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/health</code>
        <p>Health check endpoint</p>
        <a class="test-link" href="/health" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/players/:userId</code>
        <p>Get player by user ID</p>
        <a class="test-link" href="/api/players/e5dc2a5b-009c-4945-907b-d0aeb166c17c" target="_blank">Test with user: TestPlayer</a>
      </div>
      
      <div class="endpoint">
        <span class="method">POST</span> <code>/api/players</code>
        <p>Create new player</p>
      </div>
      
      <div class="endpoint">
        <span class="method">POST</span> <code>/api/players/:userId/xp</code>
        <p>Add XP to player</p>
      </div>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`Player Service запущен на порту ${PORT}`);
});
