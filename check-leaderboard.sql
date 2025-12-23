-- Проверка данных в таблице leaderboard
SELECT * FROM leaderboard WHERE player_id = 'e5dc2a5b-009c-4945-907b-d0aeb166c17c';

-- Все записи в leaderboard
SELECT * FROM leaderboard ORDER BY rank;
