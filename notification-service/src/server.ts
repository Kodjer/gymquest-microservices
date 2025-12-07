// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import routes from './routes/notifications';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3005;

app.use(cors());
app.use(express.json());

app.use('/api/notifications', routes);

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'notification Service',
    port: PORT
  });
});

app.listen(PORT, () => {
  console.log(`notification Service запущен на порту ${PORT}`);
});