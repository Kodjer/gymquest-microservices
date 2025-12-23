# =============================================
# Interactive Microservices Demo
# =============================================

function Show-Request {
    param($Method, $Url, $Body)
    Write-Host "`n>>> REQUEST >>>" -ForegroundColor Cyan
    Write-Host "  Method: $Method" -ForegroundColor Yellow
    Write-Host "  URL: $Url" -ForegroundColor Yellow
    if ($Body) {
        Write-Host "  Body:" -ForegroundColor Yellow
        Write-Host "  $Body" -ForegroundColor Gray
    }
}

function Show-Response {
    param($Response, $StatusCode = 200)
    Write-Host "`n<<< RESPONSE <<<" -ForegroundColor Green
    Write-Host "  Status: $StatusCode OK" -ForegroundColor Green
    Write-Host "  Data:" -ForegroundColor Green
    $Response | ConvertTo-Json -Depth 3 | Write-Host -ForegroundColor White
}

function Test-QuestService {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  QUEST SERVICE - Port 3001" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    $testUserId = "demo-user-123"
    
    # Create new quest
    $newQuest = @{
        user_id = $testUserId
        title = "Demo Quest - $(Get-Date -Format 'HH:mm:ss')"
        description = "This is a demo quest for demonstration"
        xp_reward = 100
        difficulty = "medium"
    } | ConvertTo-Json
    
    Show-Request -Method "POST" -Url "http://localhost:3001/api/quests" -Body $newQuest
    try {
        $created = Invoke-RestMethod -Uri "http://localhost:3001/api/quests" -Method Post -Body $newQuest -ContentType "application/json"
        Show-Response -Response $created -StatusCode 201
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
    
    # GET user quests
    Write-Host "`n------------------------------------------------" -ForegroundColor Gray
    Show-Request -Method "GET" -Url "http://localhost:3001/api/quests/$testUserId"
    try {
        $quests = Invoke-RestMethod -Uri "http://localhost:3001/api/quests/$testUserId" -Method Get
        Show-Response -Response $quests
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
}

function Test-PlayerService {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  PLAYER SERVICE - Port 3002" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    # Create new player
    $random = Get-Random -Maximum 9999
    $userId = "demo-user-$random"
    $newPlayer = @{
        user_id = $userId
        username = "DemoPlayer$random"
        email = "demo$random@gymquest.com"
    } | ConvertTo-Json
    
    Show-Request -Method "POST" -Url "http://localhost:3002/api/players" -Body $newPlayer
    try {
        $created = Invoke-RestMethod -Uri "http://localhost:3002/api/players" -Method Post -Body $newPlayer -ContentType "application/json"
        Show-Response -Response $created -StatusCode 201
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
    
    # GET player profile
    Write-Host "`n------------------------------------------------" -ForegroundColor Gray
    Show-Request -Method "GET" -Url "http://localhost:3002/api/players/$userId"
    try {
        $player = Invoke-RestMethod -Uri "http://localhost:3002/api/players/$userId" -Method Get
        Show-Response -Response $player
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
    
    # Add XP to player
    Write-Host "`n------------------------------------------------" -ForegroundColor Gray
    $xpData = @{
        xp = 50
    } | ConvertTo-Json
    
    Show-Request -Method "POST" -Url "http://localhost:3002/api/players/$userId/xp" -Body $xpData
    try {
        $updated = Invoke-RestMethod -Uri "http://localhost:3002/api/players/$userId/xp" -Method Post -Body $xpData -ContentType "application/json"
        Show-Response -Response $updated
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
}

function Test-AchievementService {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  ACHIEVEMENT SERVICE - Port 3003" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    $userId = "demo-user-123"
    
    Show-Request -Method "GET" -Url "http://localhost:3003/api/achievements/$userId"
    try {
        $achievements = Invoke-RestMethod -Uri "http://localhost:3003/api/achievements/$userId" -Method Get
        Show-Response -Response $achievements
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
}

function Test-AnalyticsService {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  ANALYTICS SERVICE - Port 3004" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    # Get global stats
    Show-Request -Method "GET" -Url "http://localhost:3004/api/analytics/global"
    try {
        $analytics = Invoke-RestMethod -Uri "http://localhost:3004/api/analytics/global" -Method Get
        Show-Response -Response $analytics
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
    
    # Get top players
    Write-Host "`n------------------------------------------------" -ForegroundColor Gray
    Show-Request -Method "GET" -Url "http://localhost:3004/api/analytics/top"
    try {
        $top = Invoke-RestMethod -Uri "http://localhost:3004/api/analytics/top" -Method Get
        Show-Response -Response $top
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
}

function Test-NotificationService {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  NOTIFICATION SERVICE - Port 3005" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    # Create notification
    $userId = "demo-user-123"
    $newNotification = @{
        user_id = $userId
        type = "achievement"
        message = "Demo notification - Achievement unlocked!"
    } | ConvertTo-Json
    
    Show-Request -Method "POST" -Url "http://localhost:3005/api/notifications" -Body $newNotification
    try {
        $created = Invoke-RestMethod -Uri "http://localhost:3005/api/notifications" -Method Post -Body $newNotification -ContentType "application/json"
        Show-Response -Response $created -StatusCode 201
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
    
    # GET user notifications
    Write-Host "`n------------------------------------------------" -ForegroundColor Gray
    Show-Request -Method "GET" -Url "http://localhost:3005/api/notifications/$userId"
    try {
        $notifications = Invoke-RestMethod -Uri "http://localhost:3005/api/notifications/$userId" -Method Get
        Show-Response -Response $notifications
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
}

function Test-LeaderboardService {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  LEADERBOARD SERVICE - Port 3006" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    Show-Request -Method "GET" -Url "http://localhost:3006/api/leaderboard"
    try {
        $leaderboard = Invoke-RestMethod -Uri "http://localhost:3006/api/leaderboard" -Method Get
        Show-Response -Response $leaderboard
    } catch {
        Write-Host "`n  Error: $_" -ForegroundColor Red
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "`n================================================" -ForegroundColor Green
    Write-Host "  GYMQUEST MICROSERVICES - INTERACTIVE DEMO" -ForegroundColor Green
    Write-Host "================================================`n" -ForegroundColor Green
    
    Write-Host "Choose a service to test:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Quest Service (Port 3001)" -ForegroundColor White
    Write-Host "  2. Player Service (Port 3002)" -ForegroundColor White
    Write-Host "  3. Achievement Service (Port 3003)" -ForegroundColor White
    Write-Host "  4. Analytics Service (Port 3004)" -ForegroundColor White
    Write-Host "  5. Notification Service (Port 3005)" -ForegroundColor White
    Write-Host "  6. Leaderboard Service (Port 3006)" -ForegroundColor White
    Write-Host ""
    Write-Host "  7. Test ALL Services" -ForegroundColor Cyan
    Write-Host "  8. Quick Health Check" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  0. Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host "================================================`n" -ForegroundColor Green
}

# Main Loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (0-8)"
    
    switch ($choice) {
        "1" { Test-QuestService; Read-Host "`nPress Enter to continue" }
        "2" { Test-PlayerService; Read-Host "`nPress Enter to continue" }
        "3" { Test-AchievementService; Read-Host "`nPress Enter to continue" }
        "4" { Test-AnalyticsService; Read-Host "`nPress Enter to continue" }
        "5" { Test-NotificationService; Read-Host "`nPress Enter to continue" }
        "6" { Test-LeaderboardService; Read-Host "`nPress Enter to continue" }
        "7" {
            Test-QuestService
            Test-PlayerService
            Test-AchievementService
            Test-AnalyticsService
            Test-NotificationService
            Test-LeaderboardService
            Read-Host "`nPress Enter to continue"
        }
        "8" {
            Write-Host "`nQuick Health Check:" -ForegroundColor Yellow
            $services = @(
                @{Name="Quest"; Port=3001},
                @{Name="Player"; Port=3002},
                @{Name="Achievement"; Port=3003},
                @{Name="Analytics"; Port=3004},
                @{Name="Notification"; Port=3005},
                @{Name="Leaderboard"; Port=3006}
            )
            foreach ($svc in $services) {
                try {
                    $null = Invoke-RestMethod -Uri "http://localhost:$($svc.Port)/health" -Method Get -TimeoutSec 2
                    Write-Host "  $($svc.Name) [Port $($svc.Port)] - OK" -ForegroundColor Green
                } catch {
                    Write-Host "  $($svc.Name) [Port $($svc.Port)] - FAIL" -ForegroundColor Red
                }
            }
            Read-Host "`nPress Enter to continue"
        }
        "0" { Write-Host "`nExiting...`n" -ForegroundColor Yellow }
        default { Write-Host "`nInvalid choice. Try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} while ($choice -ne "0")
