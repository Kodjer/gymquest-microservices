-- Удалить старого игрока и создать нового с правильными данными
DELETE FROM players WHERE id = 'e5dc2a5b-009c-4945-907b-d0aeb1666c17';

-- Создать нового игрока
INSERT INTO players (id, username, level, xp, total_quests_completed, achievements_count, current_streak, longest_streak, created_at)
VALUES (
  'e5dc2a5b-009c-4945-907b-d0aeb1666c17',
  'TestPlayer',
  5,
  500,
  3,
  3,
  0,
  0,
  NOW()
);
