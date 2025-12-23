// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import routes from './routes/leaderboard';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3006;

app.use(cors());
app.use(express.json());

app.use('/api/leaderboard', routes);

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'leaderboard Service',
    port: PORT
  });
});

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Leaderboard Service - Port 3006</title>
      <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; background: #f5f5f5; }
        h1 { color: #e67e22; }
        .endpoint { background: white; padding: 15px; margin: 10px 0; border-left: 4px solid #e67e22; }
        .method { color: #3498db; font-weight: bold; }
        code { background: #ecf0f1; padding: 2px 6px; border-radius: 3px; }
        .test-link { background: #3498db; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; display: inline-block; margin-top: 10px; }
      </style>
    </head>
    <body>
      <h1>🏅 Leaderboard Service</h1>
      <p>Status: <strong style="color: green;">✓ RUNNING</strong></p>
      <p>Port: <strong>3006</strong></p>
      
      <h2>Available Endpoints:</h2>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/health</code>
        <p>Health check endpoint</p>
        <a class="test-link" href="/health" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/leaderboard</code>
        <p>Get full leaderboard</p>
        <a class="test-link" href="/api/leaderboard" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/leaderboard/rank/:userId</code>
        <p>Get user rank</p>
        <a class="test-link" href="/api/leaderboard/rank/e5dc2a5b-009c-4945-907b-d0aeb166c17c" target="_blank">Test with user: TestPlayer</a>
      </div>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`leaderboard Service запущен на порту ${PORT}`);
});