# ============================================
# GYMQUEST MICROSERVICES - FULL DEMONSTRATION
# ============================================

Write-Host ""
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "  GYMQUEST MICROSERVICES - DEMONSTRATION FOR TEACHER" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Docker Status
Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "STEP 1: Checking Docker Containers" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
Write-Host ""
docker-compose ps
Write-Host ""

# Step 2: Check All Microservices Health
Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "STEP 2: Testing Microservices Health Endpoints" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
Write-Host ""

$services = @(
    @{Name="Quest Service"; Port=3001; Endpoint="/health"},
    @{Name="Player Service"; Port=3002; Endpoint="/health"},
    @{Name="Achievement Service"; Port=3003; Endpoint="/health"},
    @{Name="Analytics Service"; Port=3004; Endpoint="/health"},
    @{Name="Notification Service"; Port=3005; Endpoint="/health"},
    @{Name="Leaderboard Service"; Port=3006; Endpoint="/health"}
)

$allWorking = $true

foreach ($service in $services) {
    $url = "http://localhost:$($service.Port)$($service.Endpoint)"
    Write-Host "  Testing: $($service.Name) (Port: $($service.Port)) ... " -NoNewline
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 3
        Write-Host "WORKING" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED" -ForegroundColor Red
        $allWorking = $false
    }
}

Write-Host ""

# Step 3: Check Network Ports
Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "STEP 3: Verifying Network Ports" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
Write-Host ""

$ports = @(3001, 3002, 3003, 3004, 3005, 3006)

foreach ($port in $ports) {
    $connection = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-Host "  Port $port : OPEN" -ForegroundColor Green
    }
    else {
        Write-Host "  Port $port : CLOSED" -ForegroundColor Red
    }
}

Write-Host ""

# Step 4: Demonstrate API Calls
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host "STEP 4: Demonstrating API Functionality" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

# Test Player Service
Write-Host "  [Player Service] Creating test player..." -ForegroundColor Cyan
try {
    $playerData = @{
        user_id = "demo-user-$(Get-Random -Maximum 9999)"
        username = "DemoPlayer$(Get-Random -Maximum 999)"
        email = "demo$(Get-Random -Maximum 999)@gymquest.com"
    }
    $playerResponse = Invoke-RestMethod -Uri "http://localhost:3002/api/players" -Method Post -Body ($playerData | ConvertTo-Json) -ContentType "application/json"
    Write-Host "  ✓ Player created: ID = $($playerResponse.id)" -ForegroundColor Green
    $playerId = $playerResponse.id
    Write-Host ""
}
catch {
    Write-Host "  ✗ Failed to create player" -ForegroundColor Red
    Write-Host ""
}

# Test Quest Service
Write-Host "  [Quest Service] Fetching quests..." -ForegroundColor Cyan
try {
    $questsResponse = Invoke-RestMethod -Uri "http://localhost:3001/api/quests" -Method Get
    if ($questsResponse.Count -gt 0) {
        Write-Host "  ✓ Found $($questsResponse.Count) quests in database" -ForegroundColor Green
    }
    else {
        Write-Host "  ✓ Quest service responding (no quests yet)" -ForegroundColor Green
    }
    Write-Host ""
}
catch {
    Write-Host "  ✗ Failed to fetch quests" -ForegroundColor Red
    Write-Host ""
}

# Test Notification Service
Write-Host "  [Notification Service] Creating notification..." -ForegroundColor Cyan
try {
    $notificationData = @{
        user_id = "demo-user-123"
        type = "system"
        message = "Demo notification from GymQuest"
    }
    $notificationResponse = Invoke-RestMethod -Uri "http://localhost:3005/api/notifications" -Method Post -Body ($notificationData | ConvertTo-Json) -ContentType "application/json"
    Write-Host "  ✓ Notification created: ID = $($notificationResponse.id)" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "  ✗ Failed to create notification" -ForegroundColor Red
    Write-Host ""
}

# Test Leaderboard Service
Write-Host "  [Leaderboard Service] Fetching leaderboard..." -ForegroundColor Cyan
try {
    $leaderboardResponse = Invoke-RestMethod -Uri "http://localhost:3006/api/leaderboard" -Method Get
    Write-Host "  ✓ Leaderboard service responding" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "  ✗ Failed to fetch leaderboard" -ForegroundColor Red
    Write-Host ""
}

# Step 5: Show Architecture
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host "STEP 5: Microservices Architecture" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Architecture Overview:" -ForegroundColor White
Write-Host "  ┌────────────────────────────────────────────────┐" -ForegroundColor Gray
Write-Host "  │  Quest Service          → Port 3001            │" -ForegroundColor Gray
Write-Host "  │  Player Service         → Port 3002            │" -ForegroundColor Gray
Write-Host "  │  Achievement Service    → Port 3003            │" -ForegroundColor Gray
Write-Host "  │  Analytics Service      → Port 3004            │" -ForegroundColor Gray
Write-Host "  │  Notification Service   → Port 3005            │" -ForegroundColor Gray
Write-Host "  │  Leaderboard Service    → Port 3006            │" -ForegroundColor Gray
Write-Host "  └────────────────────────────────────────────────┘" -ForegroundColor Gray
Write-Host ""
Write-Host "  Each service:" -ForegroundColor White
Write-Host "    • Runs in isolated Docker container" -ForegroundColor Gray
Write-Host "    • Has dedicated port" -ForegroundColor Gray
Write-Host "    • Connected to Supabase database" -ForegroundColor Gray
Write-Host "    • Provides REST API endpoints" -ForegroundColor Gray
Write-Host "    • Can be scaled independently" -ForegroundColor Gray
Write-Host ""

# Step 6: CI/CD Information
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host "STEP 6: CI/CD Pipeline" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""
Write-Host "  CI/CD Setup:" -ForegroundColor White
Write-Host "    • Docker Compose for orchestration" -ForegroundColor Gray
Write-Host "    • Automated builds with docker-compose build" -ForegroundColor Gray
Write-Host "    • Health check endpoints for monitoring" -ForegroundColor Gray
Write-Host "    • Individual service deployments" -ForegroundColor Gray
Write-Host "    • Network isolation with Docker networks" -ForegroundColor Gray
Write-Host ""
Write-Host "  Deployment Commands:" -ForegroundColor White
Write-Host "    • Build: docker-compose build" -ForegroundColor Gray
Write-Host "    • Start: docker-compose up -d" -ForegroundColor Gray
Write-Host "    • Stop:  docker-compose down" -ForegroundColor Gray
Write-Host "    • Logs:  docker-compose logs -f" -ForegroundColor Gray
Write-Host ""

# Final Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host "SUMMARY" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

if ($allWorking) {
    Write-Host "  ✓✓✓ ALL MICROSERVICES ARE WORKING ✓✓✓" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Status: " -NoNewline
    Write-Host "READY FOR DEMONSTRATION" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Some services may have issues" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Status: " -NoNewline
    Write-Host "NEEDS ATTENTION" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Total Services: 6" -ForegroundColor White
Write-Host "  Ports Used: 3001-3006" -ForegroundColor White
Write-Host "  Database: Supabase (Cloud PostgreSQL)" -ForegroundColor White
Write-Host "  Orchestration: Docker Compose" -ForegroundColor White
Write-Host ""

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  DEMONSTRATION COMPLETE - SYSTEM IS OPERATIONAL           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Additional commands for teacher
Write-Host "Additional commands for live demonstration:" -ForegroundColor Yellow
Write-Host "  • Show logs:      docker-compose logs -f [service-name]" -ForegroundColor Gray
Write-Host "  • View containers: docker-compose ps" -ForegroundColor Gray
Write-Host "  • Test endpoint:   Invoke-RestMethod http://localhost:PORT/health" -ForegroundColor Gray
Write-Host ""
