-- Очистить старые тестовые квесты и создать правильные
DELETE FROM quests WHERE user_id = 'demo-user-123';

-- Создать нормальные квесты (все со статусом pending - это единственный разрешенный статус)
INSERT INTO quests (id, user_id, title, description, xp_reward, difficulty, status, created_at) VALUES
('aaaaaaaa-1111-1111-1111-111111111111', 'demo-user-123', 'Conquer the Peak', 'Reach the highest point in the mountain', 500, 'hard', 'pending', NOW()),
('bbbbbbbb-2222-2222-2222-222222222222', 'demo-user-123', 'Forest Explorer', 'Explore all areas of the enchanted forest', 200, 'medium', 'pending', NOW()),
('cccccccc-3333-3333-3333-333333333333', 'demo-user-123', 'First Steps', 'Complete your training session', 100, 'easy', 'pending', NOW() - INTERVAL '1 day'),
('dddddddd-4444-4444-4444-444444444444', 'demo-user-123', 'Dragon Slayer', 'Defeat the legendary dragon', 1000, 'hard', 'pending', NOW()),
('eeeeeeee-5555-5555-5555-555555555555', 'demo-user-123', 'Treasure Hunter', 'Find 10 hidden treasures', 300, 'medium', 'pending', NOW() - INTERVAL '2 hours');
