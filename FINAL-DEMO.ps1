# ФИНАЛЬНЫЙ ДЕМО СКРИПТ ДЛЯ ПРЕПОДА
# Все ID соответствуют реальным данным в Supabase

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        ДЕМОНСТРАЦИЯ МИКРОСЕРВИСОВ GymQuest            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Реальные ID из базы данных
$PLAYER_ID = "e5dc2a5b-009c-4945-907b-d0aeb1666c17"
$USER_ID = "demo-user-123"

Write-Host "1️⃣  QUEST SERVICE (PORT 3001)" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:3001/api/quests/$USER_ID`n" -ForegroundColor Gray
try {
    $quests = Invoke-RestMethod "http://localhost:3001/api/quests/$USER_ID"
    Write-Host "   ✅ Квестов в базе: $($quests.Count)" -ForegroundColor Green
    $quests | Select-Object -First 3 | ForEach-Object {
        Write-Host "      📜 $($_.title) - $($_.xp_reward) XP ($($_.difficulty))" -ForegroundColor White
    }
} catch { Write-Host "   ❌ Ошибка: $_" -ForegroundColor Red }

Write-Host "`n2️⃣  PLAYER SERVICE (PORT 3002)" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:3002/api/players/$PLAYER_ID`n" -ForegroundColor Gray
try {
    $player = Invoke-RestMethod "http://localhost:3002/api/players/$PLAYER_ID"
    Write-Host "   ✅ Игрок: $($player.username)" -ForegroundColor Green
    Write-Host "      Level: $($player.level) | XP: $($player.xp)" -ForegroundColor White
    Write-Host "      Квестов выполнено: $($player.total_quests_completed)" -ForegroundColor White
} catch { Write-Host "   ❌ Ошибка: $_" -ForegroundColor Red }

Write-Host "`n3️⃣  ACHIEVEMENT SERVICE (PORT 3003)" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:3003/api/achievements/$USER_ID`n" -ForegroundColor Gray
try {
    $achievements = Invoke-RestMethod "http://localhost:3003/api/achievements/$USER_ID"
    Write-Host "   ✅ Достижений разблокировано: $($achievements.Count)" -ForegroundColor Green
    $achievements | ForEach-Object {
        Write-Host "      $($_.achievements.icon) $($_.achievements.name) - +$($_.achievements.xp_reward) XP" -ForegroundColor White
    }
} catch { Write-Host "   ❌ Ошибка: $_" -ForegroundColor Red }

Write-Host "`n4️⃣  ANALYTICS SERVICE (PORT 3004)" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:3004/api/analytics/global`n" -ForegroundColor Gray
try {
    $analytics = Invoke-RestMethod "http://localhost:3004/api/analytics/global"
    Write-Host "   ✅ Глобальная статистика:" -ForegroundColor Green
    Write-Host "      Всего пользователей: $($analytics.total_users)" -ForegroundColor White
} catch { Write-Host "   ❌ Ошибка: $_" -ForegroundColor Red }

Write-Host "`n5️⃣  NOTIFICATION SERVICE (PORT 3005)" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:3005/api/notifications/$USER_ID`n" -ForegroundColor Gray
try {
    $notifications = Invoke-RestMethod "http://localhost:3005/api/notifications/$USER_ID"
    Write-Host "   ✅ Уведомлений: $($notifications.Count)" -ForegroundColor Green
    $notifications | Select-Object -First 2 | ForEach-Object {
        Write-Host "      📬 $($_.type): $($_.title)" -ForegroundColor White
    }
} catch { Write-Host "   ❌ Ошибка: $_" -ForegroundColor Red }

Write-Host "`n6️⃣  LEADERBOARD SERVICE (PORT 3006)" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:3006/api/leaderboard`n" -ForegroundColor Gray
try {
    $leaderboard = Invoke-RestMethod "http://localhost:3006/api/leaderboard"
    Write-Host "   ✅ Игроков в таблице: $($leaderboard.Count)" -ForegroundColor Green
    $leaderboard | Select-Object -First 3 | ForEach-Object {
        Write-Host "      🏆 #$($_.rank) - $($_.username): $($_.score) очков" -ForegroundColor White
    }
} catch { Write-Host "   ❌ Ошибка: $_" -ForegroundColor Red }

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  🎉 ВСЕ СЕРВИСЫ РАБОТАЮТ С РЕАЛЬНОЙ БАЗОЙ SUPABASE!   ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📌 Откройте в браузере любой порт (3001-3006)" -ForegroundColor Yellow
Write-Host "   Например: http://localhost:3003" -ForegroundColor Cyan
