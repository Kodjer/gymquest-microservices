// src/routes/player.ts
import { Router } from 'express';
import {
  getPlayer,
  createPlayer,
  addXP,
} from '../controllers/playerController';

const router = Router();

// GET /api/player/:userId - получить профиль игрока
router.get('/:userId', getPlayer);

// POST /api/player - создать профиль игрока
router.post('/', createPlayer);

// POST /api/player/:userId/xp - добавить XP игроку
router.post('/:userId/xp', addXP);

export default router;