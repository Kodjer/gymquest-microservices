# Full functional test - create and retrieve data

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  FULL FUNCTIONAL TEST" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

$testUserId = "test-user-$(Get-Random -Maximum 9999)"

# Test 1: Create Player
Write-Host "`n[1] Creating player..." -ForegroundColor Yellow
try {
    $playerBody = @{
        user_id = $testUserId
        username = "TestPlayer"
        email = "test@example.com"
    } | ConvertTo-Json

    $player = Invoke-RestMethod -Uri "http://localhost:3002/api/players" `
        -Method POST `
        -Body $playerBody `
        -ContentType "application/json" `
        -TimeoutSec 5
    
    Write-Host "    SUCCESS: Player created with ID: $($player.id)" -ForegroundColor Green
} catch {
    Write-Host "    FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Create Quest
Write-Host "`n[2] Creating quest..." -ForegroundColor Yellow
try {
    $questBody = @{
        user_id = $testUserId
        title = "Test Quest"
        description = "Complete 10 pushups"
        xp_reward = 50
        difficulty = "easy"
    } | ConvertTo-Json

    $quest = Invoke-RestMethod -Uri "http://localhost:3001/api/quests" `
        -Method POST `
        -Body $questBody `
        -ContentType "application/json" `
        -TimeoutSec 5
    
    Write-Host "    SUCCESS: Quest created - '$($quest.title)'" -ForegroundColor Green
} catch {
    Write-Host "    FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Get Quests
Write-Host "`n[3] Getting quests for user..." -ForegroundColor Yellow
try {
    $quests = Invoke-RestMethod -Uri "http://localhost:3001/api/quests/$testUserId" `
        -Method GET `
        -TimeoutSec 5
    
    Write-Host "    SUCCESS: Found $($quests.Count) quest(s)" -ForegroundColor Green
} catch {
    Write-Host "    FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Get Achievements
Write-Host "`n[4] Getting achievements..." -ForegroundColor Yellow
try {
    $achievements = Invoke-RestMethod -Uri "http://localhost:3003/api/achievements/$testUserId" `
        -Method GET `
        -TimeoutSec 5
    
    Write-Host "    SUCCESS: Retrieved $($achievements.Count) achievement(s)" -ForegroundColor Green
} catch {
    Write-Host "    FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Check all services respond
Write-Host "`n[5] Checking all services..." -ForegroundColor Yellow
$services = @(3001, 3002, 3003, 3004, 3005, 3006)
$allOk = $true

foreach ($port in $services) {
    try {
        $health = Invoke-RestMethod -Uri "http://localhost:$port/health" -Method GET -TimeoutSec 2
        Write-Host "    Port $port : OK" -ForegroundColor Green
    } catch {
        Write-Host "    Port $port : FAILED" -ForegroundColor Red
        $allOk = $false
    }
}

# Summary
Write-Host "`n=============================================" -ForegroundColor Cyan
if ($allOk) {
    Write-Host "  RESULT: All tests PASSED!" -ForegroundColor Green
    Write-Host "  System is fully functional!" -ForegroundColor Green
} else {
    Write-Host "  RESULT: Some tests failed" -ForegroundColor Yellow
}
Write-Host "=============================================`n" -ForegroundColor Cyan
