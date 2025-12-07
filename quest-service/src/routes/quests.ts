// src/routes/quests.ts
import { Router } from 'express';
import {
  getQuests,
  createQuest,
  updateQuest,
  deleteQuest,
  completeQuest,
} from '../controllers/questController';

// Создаём роутер - он связывает URL с функциями контроллера
const router = Router();

// GET /api/quests/:userId - получить все квесты пользователя
// Пример: GET /api/quests/user123?status=pending
router.get('/:userId', getQuests);

// POST /api/quests - создать новый квест
// Пример тела запроса: { "user_id": "user123", "title": "Зарядка", "xp_reward": 10, "difficulty": "easy" }
router.post('/', createQuest);

// PUT /api/quests/:id - обновить квест
// Пример: PUT /api/quests/quest-uuid-123
router.put('/:id', updateQuest);

// DELETE /api/quests/:id - удалить квест
// Пример: DELETE /api/quests/quest-uuid-123
router.delete('/:id', deleteQuest);

// PATCH /api/quests/:id/complete - пометить квест как выполненный
// Пример: PATCH /api/quests/quest-uuid-123/complete
router.patch('/:id/complete', completeQuest);

export default router;
