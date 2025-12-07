// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import playerRoutes from './routes/player';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3002;

app.use(cors());
app.use(express.json());

app.use('/api/players', playerRoutes);

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'Player Service',
    port: PORT
  });
});

app.listen(PORT, () => {
  console.log(`Player Service запущен на порту ${PORT}`);
});