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

app.listen(PORT, () => {
  console.log(`Quest Service запущен на порту ${PORT}`);
  console.log(`API доступен по адресу: http://localhost:${PORT}/api/quests`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});