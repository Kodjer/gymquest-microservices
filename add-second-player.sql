-- 1. Создать таблицу leaderboard
CREATE TABLE IF NOT EXISTS leaderboard (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  player_id text UNIQUE NOT NULL,
  username text NOT NULL,
  score integer DEFAULT 0,
  rank integer,
  updated_at timestamptz DEFAULT NOW()
);

-- 2. Создать второго игрока
INSERT INTO players (id, username, level, xp, total_quests_completed, achievements_count, current_streak, longest_streak, created_at)
VALUES (
  'second-player-2025',
  'GymHero',
  3,
  250,
  2,
  1,
  1,
  3,
  NOW()
);

-- 3. Добавить обоих игроков в leaderboard
INSERT INTO leaderboard (player_id, username, score, rank, updated_at)
VALUES 
  ('e5dc2a5b-009c-4945-907b-d0aeb166c17c', 'TestPlayer', 500, 1, NOW()),
  ('second-player-2025', 'GymHero', 250, 2, NOW())
ON CONFLICT (player_id) DO UPDATE 
SET username = EXCLUDED.username, 
    score = EXCLUDED.score, 
    rank = EXCLUDED.rank, 
    updated_at = EXCLUDED.updated_at;
