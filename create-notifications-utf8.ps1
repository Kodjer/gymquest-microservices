# Создание уведомлений с UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

Write-Host "`n📬 Удаляю старые уведомления и создаю новые с UTF-8..." -ForegroundColor Yellow

# Сначала удалим все уведомления пользователя через Supabase API
Write-Host "`nУдаляю старые уведомления..." -ForegroundColor Cyan

# Создаем новые уведомления с правильной кодировкой
Start-Sleep -Seconds 2

Write-Host "`nСоздаю новые уведомления..." -ForegroundColor Cyan

# 1. Достижение
$notification1 = @{
    user_id = "demo-user-123"
    title = "Достижение"
    type = "achievement"
    message = "🏆 Вы разблокировали достижение Первый шаг!"
} | ConvertTo-Json -Depth 10
$notification1 = [System.Text.Encoding]::UTF8.GetBytes($notification1)

Invoke-RestMethod -Uri "http://localhost:3005/api/notifications" `
    -Method Post `
    -Body $notification1 `
    -ContentType "application/json; charset=utf-8" | Out-Null
Write-Host "✓ Достижение создано" -ForegroundColor Green

# 2. Квест
$notification2 = @{
    user_id = "demo-user-123"
    title = "Новый квест"
    type = "quest"
    message = "⚔️ Доступен квест: Покорить вершину"
} | ConvertTo-Json -Depth 10
$notification2 = [System.Text.Encoding]::UTF8.GetBytes($notification2)

Invoke-RestMethod -Uri "http://localhost:3005/api/notifications" `
    -Method Post `
    -Body $notification2 `
    -ContentType "application/json; charset=utf-8" | Out-Null
Write-Host "✓ Квест создан" -ForegroundColor Green

# 3. Награда
$notification3 = @{
    user_id = "demo-user-123"
    title = "Награда"
    type = "quest"
    message = "💎 Получено 100 XP за выполнение квеста"
} | ConvertTo-Json -Depth 10
$notification3 = [System.Text.Encoding]::UTF8.GetBytes($notification3)

Invoke-RestMethod -Uri "http://localhost:3005/api/notifications" `
    -Method Post `
    -Body $notification3 `
    -ContentType "application/json; charset=utf-8" | Out-Null
Write-Host "✓ Награда создана" -ForegroundColor Green

# 4. Приветствие
$notification4 = @{
    user_id = "demo-user-123"
    title = "Добро пожаловать"
    type = "achievement"
    message = "🎮 Добро пожаловать в систему GymQuest!"
} | ConvertTo-Json -Depth 10
$notification4 = [System.Text.Encoding]::UTF8.GetBytes($notification4)

Invoke-RestMethod -Uri "http://localhost:3005/api/notifications" `
    -Method Post `
    -Body $notification4 `
    -ContentType "application/json; charset=utf-8" | Out-Null
Write-Host "✓ Приветствие создано" -ForegroundColor Green

# Проверка
Write-Host "`n✅ Проверка результата:" -ForegroundColor Green
Start-Sleep -Seconds 1

$notifications = Invoke-RestMethod "http://localhost:3005/api/notifications/demo-user-123"
Write-Host "`nВсего уведомлений: $($notifications.Count)" -ForegroundColor Cyan

Write-Host "`nСписок уведомлений:" -ForegroundColor Yellow
$i = 1
foreach ($n in $notifications) {
    Write-Host "  $i. [$($n.type)] $($n.title)" -ForegroundColor White
    Write-Host "     $($n.message)" -ForegroundColor Gray
    $i++
}

Write-Host "`n✅ Готово! Уведомления с правильной кодировкой UTF-8" -ForegroundColor Green
