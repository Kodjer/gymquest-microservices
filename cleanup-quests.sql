-- Удалить все лишние квесты, оставить только 5 нормальных для demo-user-123
DELETE FROM quests 
WHERE id NOT IN (
  'aaaaaaaa-1111-1111-1111-111111111111',  -- Conquer the Peak
  'bbbbbbbb-2222-2222-2222-222222222222',  -- Forest Explorer
  'cccccccc-3333-3333-3333-333333333333',  -- First Steps
  'dddddddd-4444-4444-4444-444444444444',  -- Dragon Slayer
  'eeeeeeee-5555-5555-5555-555555555555'   -- Treasure Hunter
);
