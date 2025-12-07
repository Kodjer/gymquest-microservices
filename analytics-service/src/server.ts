// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import routes from './routes/analytics';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3004;

app.use(cors());
app.use(express.json());

app.use('/api/analytics', routes);

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'analytics Service',
    port: PORT
  });
});

app.listen(PORT, () => {
  console.log(`analytics Service запущен на порту ${PORT}`);
});