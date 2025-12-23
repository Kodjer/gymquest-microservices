-- Обновить игрока на демо-данные
UPDATE players 
SET 
  level = 5,
  xp = 500,
  total_quests_completed = 3,
  achievements_count = 3
WHERE id = 'e5dc2a5b-009c-4945-907b-d0aeb166c17c';
