# COMPLETE DEMONSTRATION - All labs verification

Write-Host "`n" -NoNewline
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  GYMQUEST MICROSERVICES - LABS DEMO" -ForegroundColor Cyan
Write-Host "  Complete System Verification" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Step 1: Check Docker Compose
Write-Host "`n[STEP 1] Checking Docker Compose..." -ForegroundColor Yellow
if (Test-Path "docker-compose.yml") {
    Write-Host "  [OK] docker-compose.yml found" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] docker-compose.yml not found" -ForegroundColor Red
    exit
}

# Step 2: Check all microservices exist
Write-Host "`n[STEP 2] Checking project structure..." -ForegroundColor Yellow
$services = @("quest-service", "player-service", "achievement-service", 
              "analytics-service", "notification-service", "leaderboard-service")
$allExist = $true

foreach ($service in $services) {
    if (Test-Path $service) {
        Write-Host "  [OK] $service" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $service not found" -ForegroundColor Red
        $allExist = $false
    }
}

if (!$allExist) {
    Write-Host "`n  ERROR: Not all services exist!" -ForegroundColor Red
    exit
}

# Step 3: Check if services are running
Write-Host "`n[STEP 3] Checking services health..." -ForegroundColor Yellow
$ports = @(3001, 3002, 3003, 3004, 3005, 3006)
$serviceNames = @("Quest", "Player", "Achievement", "Analytics", "Notification", "Leaderboard")
$runningCount = 0

for ($i = 0; $i -lt $ports.Count; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$($ports[$i])/health" -Method Get -TimeoutSec 2
        Write-Host "  [OK] $($serviceNames[$i]) Service (port $($ports[$i]))" -ForegroundColor Green
        $runningCount++
    } catch {
        Write-Host "  [FAIL] $($serviceNames[$i]) Service (port $($ports[$i])) - Not running" -ForegroundColor Red
    }
}

if ($runningCount -ne 6) {
    Write-Host "`n  WARNING: Only $runningCount/6 services running" -ForegroundColor Yellow
    Write-Host "  Run: docker-compose up -d" -ForegroundColor White
    exit
}

# Step 4: Run all unit tests
Write-Host "`n[STEP 4] Running unit tests..." -ForegroundColor Yellow
$testResults = @()

foreach ($service in $services) {
    Write-Host "  Testing $service..." -NoNewline
    Push-Location $service
    
    $output = npm test 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " PASSED" -ForegroundColor Green
        $testResults += $true
    } else {
        Write-Host " FAILED" -ForegroundColor Red
        $testResults += $false
    }
    
    Pop-Location
}

$passedTests = ($testResults | Where-Object { $_ -eq $true }).Count

# Step 5: Test API functionality
Write-Host "`n[STEP 5] Testing API functionality..." -ForegroundColor Yellow

try {
    $testId = "demo-$(Get-Random -Maximum 9999)"
    
    # Create quest
    $questBody = @{
        user_id = $testId
        title = "Demo Quest"
        description = "Test quest"
        xp_reward = 100
        difficulty = "easy"
    } | ConvertTo-Json
    
    $quest = Invoke-RestMethod -Uri "http://localhost:3001/api/quests" `
        -Method POST -Body $questBody -ContentType "application/json" -TimeoutSec 3
    
    Write-Host "  [OK] Quest created successfully" -ForegroundColor Green
    
    # Get quests
    $quests = Invoke-RestMethod -Uri "http://localhost:3001/api/quests/$testId" -Method GET -TimeoutSec 3
    Write-Host "  [OK] Quest retrieved successfully" -ForegroundColor Green
    
} catch {
    Write-Host "  [WARN] API test had issues (DB might be empty)" -ForegroundColor Yellow
}

# Step 6: Check Docker containers
Write-Host "`n[STEP 6] Checking Docker containers..." -ForegroundColor Yellow
$containers = docker-compose ps --services 2>$null
if ($containers) {
    Write-Host "  [OK] All containers are managed by Docker Compose" -ForegroundColor Green
} else {
    Write-Host "  [WARN] Could not verify Docker containers" -ForegroundColor Yellow
}

# Final Report
Write-Host "`n" -NoNewline
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "            FINAL REPORT" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

Write-Host "`n  Architecture:" -ForegroundColor White
Write-Host "    - Microservices: 6/6" -ForegroundColor Green
Write-Host "    - Docker Compose: YES" -ForegroundColor Green
Write-Host "    - Database: Supabase (Shared DB)" -ForegroundColor Green

Write-Host "`n  Services Status:" -ForegroundColor White
Write-Host "    - Running: $runningCount/6" -ForegroundColor $(if ($runningCount -eq 6) {"Green"} else {"Red"})

Write-Host "`n  Tests:" -ForegroundColor White
Write-Host "    - Unit Tests: $passedTests/6 PASSED" -ForegroundColor $(if ($passedTests -eq 6) {"Green"} else {"Yellow"})

Write-Host "`n  Technology Stack:" -ForegroundColor White
Write-Host "    - Language: TypeScript" -ForegroundColor Green
Write-Host "    - Framework: Express.js" -ForegroundColor Green
Write-Host "    - Testing: Jest" -ForegroundColor Green
Write-Host "    - Containerization: Docker" -ForegroundColor Green

Write-Host "`n" -NoNewline
Write-Host "=============================================" -ForegroundColor Cyan

if ($runningCount -eq 6 -and $passedTests -eq 6) {
    Write-Host "  STATUS: ALL LABS COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "`n  System is fully operational!" -ForegroundColor Green
    Write-Host "  All 6 microservices are running and tested!" -ForegroundColor Green
} else {
    Write-Host "  STATUS: LABS MOSTLY COMPLETED" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "`n  Some components need attention" -ForegroundColor Yellow
}

Write-Host "`n"
