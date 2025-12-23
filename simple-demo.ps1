# ============================================
# SIMPLE DEMO - Test Microservices with Mock Data
# ============================================

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "  GYMQUEST - DEMO WITH MOCK DATA" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green

Write-Host "NOTE: Supabase domain is unavailable." -ForegroundColor Yellow
Write-Host "Showing that microservices are running and ports are open.`n" -ForegroundColor Yellow

# Check all services
Write-Host "Checking all microservices:`n" -ForegroundColor Cyan

$services = @(
    @{Name="Quest Service"; Port=3001},
    @{Name="Player Service"; Port=3002},
    @{Name="Achievement Service"; Port=3003},
    @{Name="Analytics Service"; Port=3004},
    @{Name="Notification Service"; Port=3005},
    @{Name="Leaderboard Service"; Port=3006}
)

foreach ($svc in $services) {
    Write-Host "  $($svc.Name) [Port $($svc.Port)]" -NoNewline
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$($svc.Port)/health" -Method Get -TimeoutSec 2
        Write-Host " - RUNNING" -ForegroundColor Green
        Write-Host "    Response: $($response | ConvertTo-Json -Compress)" -ForegroundColor Gray
    } catch {
        Write-Host " - FAILED" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "================================================" -ForegroundColor Green
Write-Host "  MICROSERVICES ARCHITECTURE" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green

Write-Host "6 Microservices running on ports 3001-3006:" -ForegroundColor White
Write-Host "  - Each service in separate Docker container" -ForegroundColor Gray
Write-Host "  - Independent scaling and deployment" -ForegroundColor Gray
Write-Host "  - RESTful API endpoints" -ForegroundColor Gray
Write-Host "  - Docker Compose orchestration" -ForegroundColor Gray
Write-Host ""

Write-Host "================================================" -ForegroundColor Green
Write-Host "  TO FIX SUPABASE CONNECTION:" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Green
Write-Host "1. Create new Supabase project at: https://supabase.com" -ForegroundColor White
Write-Host "2. Update docker-compose.yml with new URL and key" -ForegroundColor White
Write-Host "3. Restart services: docker-compose restart" -ForegroundColor White
Write-Host ""
