// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import achievementRoutes from './routes/achievements';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3003;

app.use(cors());
app.use(express.json());

app.use('/api/achievements', achievementRoutes);

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'Achievement Service',
    port: PORT
  });
});

app.listen(PORT, () => {
  console.log(`Achievement Service запущен на порту ${PORT}`);
});