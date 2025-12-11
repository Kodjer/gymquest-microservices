# Run all tests for all microservices

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  RUNNING TESTS FOR ALL SERVICES" -ForegroundColor Cyan
Write-Host "=============================================`n" -ForegroundColor Cyan

$services = @(
    "quest-service",
    "player-service", 
    "achievement-service",
    "analytics-service",
    "notification-service",
    "leaderboard-service"
)

$results = @()

foreach ($service in $services) {
    Write-Host "Testing: $service ... " -NoNewline -ForegroundColor Yellow
    
    if (Test-Path $service) {
        Push-Location $service
        
        # Install dependencies if needed
        if (!(Test-Path "node_modules")) {
            Write-Host ""
            Write-Host "  Installing dependencies..." -ForegroundColor Cyan
            npm install --silent 2>&1 | Out-Null
        }
        
        # Run tests
        $output = npm test 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "PASSED" -ForegroundColor Green
            $results += @{Service=$service; Status="PASSED"}
        } else {
            Write-Host "FAILED" -ForegroundColor Red
            $results += @{Service=$service; Status="FAILED"}
        }
        
        Pop-Location
    } else {
        Write-Host "NOT FOUND" -ForegroundColor Red
        $results += @{Service=$service; Status="NOT_FOUND"}
    }
}

# Summary
Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  TEST RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "=============================================`n" -ForegroundColor Cyan

foreach ($result in $results) {
    $color = if ($result.Status -eq "PASSED") { "Green" } else { "Red" }
    Write-Host "  [$($result.Service)]: $($result.Status)" -ForegroundColor $color
}

$passed = ($results | Where-Object { $_.Status -eq "PASSED" }).Count
$total = $results.Count

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  Passed: $passed / $total" -ForegroundColor $(if ($passed -eq $total) { "Green" } else { "Yellow" })
Write-Host "=============================================`n" -ForegroundColor Cyan
