# ФИНАЛЬНАЯ ДЕМОНСТРАЦИЯ - ВСЕ ПРАВИЛЬНЫЕ ID
# Запустите после обновления игрока в Supabase

$PLAYER_ID = "e5dc2a5b-009c-4945-907b-d0aeb166c17c"
$USER_ID = "demo-user-123"

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     ДЕМОНСТРАЦИЯ 6 МИКРОСЕРВИСОВ - ВСЕ ДАННЫЕ ИЗ БД   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "1. QUEST SERVICE (3001)" -ForegroundColor Yellow
$quests = Invoke-RestMethod "http://localhost:3001/api/quests/$USER_ID"
Write-Host "   Квестов: $($quests.Count)" -ForegroundColor White
$quests | Select-Object -First 3 | ForEach-Object {
    Write-Host "   - $($_.title) ($($_.xp_reward) XP, $($_.difficulty))" -ForegroundColor Gray
}

Write-Host "`n2. PLAYER SERVICE (3002)" -ForegroundColor Yellow
$player = Invoke-RestMethod "http://localhost:3002/api/players/$PLAYER_ID"
Write-Host "   Игрок: $($player.username)" -ForegroundColor White
Write-Host "   Level: $($player.level) | XP: $($player.xp)" -ForegroundColor Gray
Write-Host "   Квестов: $($player.total_quests_completed) | Достижений: $($player.achievements_count)" -ForegroundColor Gray

Write-Host "`n3. ACHIEVEMENT SERVICE (3003)" -ForegroundColor Yellow
$achievements = Invoke-RestMethod "http://localhost:3003/api/achievements/$USER_ID"
Write-Host "   Достижений: $($achievements.Count)" -ForegroundColor White
$achievements | ForEach-Object {
    Write-Host "   - $($_.achievements.icon) $($_.achievements.name) (+$($_.achievements.xp_reward) XP)" -ForegroundColor Gray
}

Write-Host "`n4. ANALYTICS SERVICE (3004)" -ForegroundColor Yellow
$analytics = Invoke-RestMethod "http://localhost:3004/api/analytics/global"
Write-Host "   Пользователей: $($analytics.total_users)" -ForegroundColor White

Write-Host "`n5. NOTIFICATION SERVICE (3005)" -ForegroundColor Yellow
$notifications = Invoke-RestMethod "http://localhost:3005/api/notifications/$USER_ID"
Write-Host "   Уведомлений: $($notifications.Count)" -ForegroundColor White

Write-Host "`n6. LEADERBOARD SERVICE (3006)" -ForegroundColor Yellow
$leaderboard = Invoke-RestMethod "http://localhost:3006/api/leaderboard"
Write-Host "   Игроков в таблице: $($leaderboard.Count)" -ForegroundColor White

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║    ВСЕ 6 СЕРВИСОВ РАБОТАЮТ С ДАННЫМИ ИЗ SUPABASE!     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`nОткройте браузер: http://localhost:3001 - http://localhost:3006" -ForegroundColor Yellow
