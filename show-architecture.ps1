# Show Microservices Architecture

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  GymQuest Microservices Architecture" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Service Architecture:`n" -ForegroundColor Yellow

Write-Host "  1. Quest Service         [Port 3001]" -ForegroundColor White
Write-Host "     - Manages workout quests" -ForegroundColor Gray
Write-Host "     - CRUD operations for quests" -ForegroundColor Gray
Write-Host ""

Write-Host "  2. Player Service        [Port 3002]" -ForegroundColor White
Write-Host "     - User profile management" -ForegroundColor Gray
Write-Host "     - Level and XP tracking" -ForegroundColor Gray
Write-Host ""

Write-Host "  3. Achievement Service   [Port 3003]" -ForegroundColor White
Write-Host "     - Achievement tracking" -ForegroundColor Gray
Write-Host "     - Badge system" -ForegroundColor Gray
Write-Host ""

Write-Host "  4. Analytics Service     [Port 3004]" -ForegroundColor White
Write-Host "     - Statistics tracking" -ForegroundColor Gray
Write-Host "     - Performance metrics" -ForegroundColor Gray
Write-Host ""

Write-Host "  5. Notification Service  [Port 3005]" -ForegroundColor White
Write-Host "     - User notifications" -ForegroundColor Gray
Write-Host "     - Event messaging" -ForegroundColor Gray
Write-Host ""

Write-Host "  6. Leaderboard Service   [Port 3006]" -ForegroundColor White
Write-Host "     - Global rankings" -ForegroundColor Gray
Write-Host "     - Competitive tracking" -ForegroundColor Gray
Write-Host ""

Write-Host "Technology Stack:`n" -ForegroundColor Yellow
Write-Host "  - Runtime: Node.js + TypeScript" -ForegroundColor White
Write-Host "  - Database: Supabase (PostgreSQL)" -ForegroundColor White
Write-Host "  - Containerization: Docker" -ForegroundColor White
Write-Host "  - Orchestration: Docker Compose" -ForegroundColor White
Write-Host "  - API: REST" -ForegroundColor White
Write-Host ""

Write-Host "Network:`n" -ForegroundColor Yellow
Write-Host "  - All services in 'gymquest-network'" -ForegroundColor White
Write-Host "  - Isolated Docker network" -ForegroundColor White
Write-Host "  - Port mapping: 3001-3006" -ForegroundColor White
Write-Host ""

Write-Host "========================================`n" -ForegroundColor Cyan
