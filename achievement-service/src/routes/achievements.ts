// src/routes/achievements.ts
import { Router } from 'express';
import {
  getUserAchievements,
  checkAchievements,
} from '../controllers/achievementController';

const router = Router();

// GET /api/achievements/:userId - получить прогресс достижений пользователя
router.get('/:userId', getUserAchievements);

// POST /api/achievements/check - проверить и разблокировать достижения
router.post('/check', checkAchievements);

export default router;