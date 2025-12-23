// src/server.ts
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import routes from "./routes/notifications";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3005;

app.use(cors());
app.use(express.json());

app.use("/api/notifications", routes);

app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    service: "notification Service",
    port: PORT,
  });
});

app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Notification Service - Port 3005</title>
      <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; background: #f5f5f5; }
        h1 { color: #1abc9c; }
        .endpoint { background: white; padding: 15px; margin: 10px 0; border-left: 4px solid #1abc9c; }
        .method { color: #3498db; font-weight: bold; }
        code { background: #ecf0f1; padding: 2px 6px; border-radius: 3px; }
        .test-link { background: #3498db; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; display: inline-block; margin-top: 10px; }
      </style>
    </head>
    <body>
      <h1>🔔 Notification Service</h1>
      <p>Status: <strong style="color: green;">✓ RUNNING</strong></p>
      <p>Port: <strong>3005</strong></p>
      
      <h2>Available Endpoints:</h2>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/health</code>
        <p>Health check endpoint</p>
        <a class="test-link" href="/health" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/notifications/:userId</code>
        <p>Get user notifications</p>
        <a class="test-link" href="/api/notifications/demo-user-123" target="_blank">Test with user: demo-user-123</a>
      </div>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`notification Service запущен на порту ${PORT}`);
});
