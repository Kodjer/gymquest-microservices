# ===========================================
# GymQuest Microservices - Start and Demo
# ===========================================

Write-Host ""
Write-Host "===========================================`n" -ForegroundColor Cyan
Write-Host "  GymQuest Microservices Demo`n" -ForegroundColor Cyan
Write-Host "===========================================`n" -ForegroundColor Cyan

# Step 1: Start Docker Compose
Write-Host "[1/4] Starting all microservices...`n" -ForegroundColor Yellow
docker-compose up -d

Write-Host "`nWaiting 15 seconds for services to start...`n" -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Step 2: Show running containers
Write-Host "`n[2/4] Docker Containers Status:`n" -ForegroundColor Yellow
docker-compose ps

# Step 3: Check ports and health
Write-Host "`n[3/4] Testing Services and Ports:`n" -ForegroundColor Yellow

$services = @(
    @{Name="Quest Service"; Port=3001},
    @{Name="Player Service"; Port=3002},
    @{Name="Achievement Service"; Port=3003},
    @{Name="Analytics Service"; Port=3004},
    @{Name="Notification Service"; Port=3005},
    @{Name="Leaderboard Service"; Port=3006}
)

$workingCount = 0

foreach ($service in $services) {
    Write-Host "  - $($service.Name) [Port $($service.Port)]" -NoNewline
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$($service.Port)/health" -Method Get -TimeoutSec 3
        Write-Host " -> WORKING" -ForegroundColor Green
        $workingCount++
    }
    catch {
        Write-Host " -> FAILED" -ForegroundColor Red
    }
}

# Step 4: Summary
Write-Host "`n[4/4] Summary:`n" -ForegroundColor Yellow
Write-Host "  Total Services: 6" -ForegroundColor White
Write-Host "  Working Services: $workingCount" -ForegroundColor White
Write-Host "  Ports: 3001, 3002, 3003, 3004, 3005, 3006" -ForegroundColor White

if ($workingCount -eq 6) {
    Write-Host "`n  STATUS: ALL SERVICES RUNNING!" -ForegroundColor Green
} else {
    Write-Host "`n  STATUS: $workingCount/6 services running" -ForegroundColor Yellow
}

Write-Host "`n===========================================`n" -ForegroundColor Cyan
Write-Host "Access services at:" -ForegroundColor White
Write-Host "  Quest:        http://localhost:3001" -ForegroundColor Gray
Write-Host "  Player:       http://localhost:3002" -ForegroundColor Gray
Write-Host "  Achievement:  http://localhost:3003" -ForegroundColor Gray
Write-Host "  Analytics:    http://localhost:3004" -ForegroundColor Gray
Write-Host "  Notification: http://localhost:3005" -ForegroundColor Gray
Write-Host "  Leaderboard:  http://localhost:3006" -ForegroundColor Gray
Write-Host ""
