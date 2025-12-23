-- SQL для создания достижений в Supabase
-- Скопируйте и вставьте в SQL Editor в Supabase Dashboard

-- Создаем достижения
INSERT INTO achievements (id, name, description, icon, requirement_type, requirement_value, xp_reward) VALUES
('11111111-1111-1111-1111-111111111111', 'First Step', 'Complete your first quest', '🎯', 'quests_completed', 1, 50),
('22222222-2222-2222-2222-222222222222', 'Level 5 Master', 'Reach level 5', '⭐', 'level', 5, 100),
('33333333-3333-3333-3333-333333333333', 'Quest Hunter', 'Complete 10 quests', '🏆', 'quests_completed', 10, 200)
ON CONFLICT (id) DO NOTHING;

-- Привязываем к пользователю
INSERT INTO user_achievements (user_id, achievement_id) VALUES
('demo-user-123', '11111111-1111-1111-1111-111111111111'),
('demo-user-123', '22222222-2222-2222-2222-222222222222'),
('demo-user-123', '33333333-3333-3333-3333-333333333333')
ON CONFLICT DO NOTHING;
