# Check all microservices are running

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  GYMQUEST MICROSERVICES CHECK" -ForegroundColor Cyan
Write-Host "=============================================`n" -ForegroundColor Cyan

$services = @(
    @{Name="Quest Service"; Port=3001},
    @{Name="Player Service"; Port=3002},
    @{Name="Achievement Service"; Port=3003},
    @{Name="Analytics Service"; Port=3004},
    @{Name="Notification Service"; Port=3005},
    @{Name="Leaderboard Service"; Port=3006}
)

$results = @()

foreach ($service in $services) {
    Write-Host "[$($service.Name)] port $($service.Port) ... " -NoNewline
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$($service.Port)/health" -Method Get -TimeoutSec 2
        Write-Host "OK" -ForegroundColor Green
        $results += $true
    }
    catch {
        Write-Host "FAILED" -ForegroundColor Red
        $results += $false
    }
}

$working = ($results | Where-Object { $_ -eq $true }).Count
$total = $results.Count

Write-Host "`n=============================================" -ForegroundColor Cyan
if ($working -eq $total) {
    Write-Host "  SUCCESS: All $total services are running!" -ForegroundColor Green
} else {
    Write-Host "  Result: $working / $total services running" -ForegroundColor Yellow
}
Write-Host "=============================================`n" -ForegroundColor Cyan
