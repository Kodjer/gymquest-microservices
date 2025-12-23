// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import questRoutes from './routes/quests';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.use('/api/quests', questRoutes);

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'Quest Service',
    port: PORT
  });
});

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Quest Service - Port 3001</title>
      <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; background: #f5f5f5; }
        h1 { color: #e74c3c; }
        .endpoint { background: white; padding: 15px; margin: 10px 0; border-left: 4px solid #e74c3c; }
        .method { color: #3498db; font-weight: bold; }
        code { background: #ecf0f1; padding: 2px 6px; border-radius: 3px; }
        .test-link { background: #3498db; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; display: inline-block; margin-top: 10px; }
      </style>
    </head>
    <body>
      <h1>🎯 Quest Service</h1>
      <p>Status: <strong style="color: green;">✓ RUNNING</strong></p>
      <p>Port: <strong>3001</strong></p>
      
      <h2>Available Endpoints:</h2>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/health</code>
        <p>Health check endpoint</p>
        <a class="test-link" href="/health" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/quests/:userId</code>
        <p>Get all quests for user</p>
        <a class="test-link" href="/api/quests/demo-user-123" target="_blank">Test with user: demo-user-123</a>
      </div>
      
      <div class="endpoint">
        <span class="method">POST</span> <code>/api/quests</code>
        <p>Create new quest</p>
      </div>
      
      <div class="endpoint">
        <span class="method">PUT</span> <code>/api/quests/:id</code>
        <p>Update quest</p>
      </div>
      
      <div class="endpoint">
        <span class="method">PATCH</span> <code>/api/quests/:id/complete</code>
        <p>Complete quest</p>
      </div>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`Quest Service запущен на порту ${PORT}`);
  console.log(`API доступен по адресу: http://localhost:${PORT}/api/quests`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});