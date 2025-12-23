# Quick Demo - Show that all services are working

Write-Host "`nGymQuest Microservices - Quick Check`n" -ForegroundColor Cyan
Write-Host "====================================`n" -ForegroundColor Cyan

$services = @(
    @{Name="Quest Service"; Port=3001},
    @{Name="Player Service"; Port=3002},
    @{Name="Achievement Service"; Port=3003},
    @{Name="Analytics Service"; Port=3004},
    @{Name="Notification Service"; Port=3005},
    @{Name="Leaderboard Service"; Port=3006}
)

foreach ($service in $services) {
    Write-Host "$($service.Name) [Port $($service.Port)]" -NoNewline
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$($service.Port)/health" -Method Get -TimeoutSec 2
        Write-Host " - OK" -ForegroundColor Green
    }
    catch {
        Write-Host " - FAIL" -ForegroundColor Red
    }
}

Write-Host "`n====================================`n" -ForegroundColor Cyan
