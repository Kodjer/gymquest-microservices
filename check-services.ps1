# Скрипт проверки всех микросервисов

$services = @(
    @{Name="Quest Service"; Port=3001},
    @{Name="Player Service"; Port=3002},
    @{Name="Achievement Service"; Port=3003},
    @{Name="Analytics Service"; Port=3004},
    @{Name="Notification Service"; Port=3005},
    @{Name="Leaderboard Service"; Port=3006}
)

Write-Host "Проверка микросервисов GymQuest..." -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

foreach ($service in $services) {
    $url = "http://localhost:$($service.Port)/health"
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 2
        Write-Host "✓ $($service.Name) (порт $($service.Port)): " -NoNewline -ForegroundColor Green
        Write-Host "РАБОТАЕТ" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ $($service.Name) (порт $($service.Port)): " -NoNewline -ForegroundColor Red
        Write-Host "НЕ ДОСТУПЕН" -ForegroundColor Red
    }
}

Write-Host "`n================================" -ForegroundColor Cyan
