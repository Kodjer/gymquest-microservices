-- Обновить существующего игрока на нормальные данные
UPDATE players 
SET 
  username = 'TestPlayer',
  level = 5,
  xp = 500,
  total_quests_completed = 3,
  achievements_count = 3
WHERE id = 'e5dc2a5b-009c-4945-907b-d0aeb1666c17';
