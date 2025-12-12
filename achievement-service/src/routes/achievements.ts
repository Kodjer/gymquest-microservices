// src/routes/achievements.ts
import { Router } from "express";
import {
  getUserAchievements,
  checkAchievements,
  unlockAchievement,
} from "../controllers/achievementController";

const router = Router();

// GET /api/achievements/:userId - получить прогресс достижений пользователя
router.get("/:userId", getUserAchievements);

// POST /api/achievements/check - проверить и разблокировать достижения
router.post("/check", checkAchievements);

// POST /api/achievements/:userId/unlock - разблокировать достижение
router.post("/:userId/unlock", unlockAchievement);

export default router;
