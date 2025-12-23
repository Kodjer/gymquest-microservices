// src/server.ts
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import routes from "./routes/analytics";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3004;

app.use(cors());
app.use(express.json());

app.use("/api/analytics", routes);

app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    service: "analytics Service",
    port: PORT,
  });
});

app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Analytics Service - Port 3004</title>
      <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; background: #f5f5f5; }
        h1 { color: #9b59b6; }
        .endpoint { background: white; padding: 15px; margin: 10px 0; border-left: 4px solid #9b59b6; }
        .method { color: #3498db; font-weight: bold; }
        code { background: #ecf0f1; padding: 2px 6px; border-radius: 3px; }
        .test-link { background: #3498db; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; display: inline-block; margin-top: 10px; }
      </style>
    </head>
    <body>
      <h1>📊 Analytics Service</h1>
      <p>Status: <strong style="color: green;">✓ RUNNING</strong></p>
      <p>Port: <strong>3004</strong></p>
      
      <h2>Available Endpoints:</h2>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/health</code>
        <p>Health check endpoint</p>
        <a class="test-link" href="/health" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/analytics/global</code>
        <p>Get global analytics</p>
        <a class="test-link" href="/api/analytics/global" target="_blank">Test Now</a>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span> <code>/api/analytics/:userId</code>
        <p>Get user analytics</p>
        <a class="test-link" href="/api/analytics/demo-user-123" target="_blank">Test with user: demo-user-123</a>
      </div>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`analytics Service запущен на порту ${PORT}`);
});
