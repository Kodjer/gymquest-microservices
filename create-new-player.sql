-- Создать НОВОГО игрока с чистым ID
INSERT INTO players (id, username, level, xp, total_quests_completed, achievements_count, current_streak, longest_streak, created_at)
VALUES (
  'new-player-2025',
  'GymQuestHero',
  8,
  750,
  5,
  3,
  2,
  5,
  NOW()
);
