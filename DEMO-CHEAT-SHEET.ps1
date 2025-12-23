# =============================================
# CHEAT SHEET FOR TEACHER DEMONSTRATION
# =============================================

Write-Host "`n" -NoNewline
Write-Host "================================================" -ForegroundColor Green
Write-Host "  GYMQUEST - DEMO CHEAT SHEET FOR TEACHER" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green

Write-Host "QUICK START COMMANDS:`n" -ForegroundColor Yellow
Write-Host "  1. Start all services:" -ForegroundColor White
Write-Host "     docker-compose up -d`n" -ForegroundColor Cyan

Write-Host "  2. Check services:" -ForegroundColor White
Write-Host "     .\quick-demo.ps1`n" -ForegroundColor Cyan

Write-Host "  3. View containers:" -ForegroundColor White
Write-Host "     docker-compose ps`n" -ForegroundColor Cyan

Write-Host "  4. View logs:" -ForegroundColor White
Write-Host "     docker-compose logs -f`n" -ForegroundColor Cyan

Write-Host "  5. Stop all services:" -ForegroundColor White
Write-Host "     docker-compose down`n" -ForegroundColor Cyan

Write-Host "================================================`n" -ForegroundColor Green

Write-Host "SERVICES AND PORTS:`n" -ForegroundColor Yellow
Write-Host "  Quest Service        -> http://localhost:3001" -ForegroundColor White
Write-Host "  Player Service       -> http://localhost:3002" -ForegroundColor White
Write-Host "  Achievement Service  -> http://localhost:3003" -ForegroundColor White
Write-Host "  Analytics Service    -> http://localhost:3004" -ForegroundColor White
Write-Host "  Notification Service -> http://localhost:3005" -ForegroundColor White
Write-Host "  Leaderboard Service  -> http://localhost:3006" -ForegroundColor White

Write-Host "`n================================================`n" -ForegroundColor Green

Write-Host "TEST ENDPOINTS:`n" -ForegroundColor Yellow
Write-Host "  Health Check (any service):" -ForegroundColor White
Write-Host "  Invoke-RestMethod http://localhost:3001/health`n" -ForegroundColor Cyan

Write-Host "  Get all quests:" -ForegroundColor White
Write-Host "  Invoke-RestMethod http://localhost:3001/api/quests`n" -ForegroundColor Cyan

Write-Host "  Get all players:" -ForegroundColor White
Write-Host "  Invoke-RestMethod http://localhost:3002/api/players`n" -ForegroundColor Cyan

Write-Host "  Get leaderboard:" -ForegroundColor White
Write-Host "  Invoke-RestMethod http://localhost:3006/api/leaderboard`n" -ForegroundColor Cyan

Write-Host "================================================`n" -ForegroundColor Green

Write-Host "KEY FEATURES TO SHOW:`n" -ForegroundColor Yellow
Write-Host "  [+] 6 independent microservices" -ForegroundColor Green
Write-Host "  [+] Each service on separate port (3001-3006)" -ForegroundColor Green
Write-Host "  [+] Docker containerization" -ForegroundColor Green
Write-Host "  [+] Docker Compose orchestration" -ForegroundColor Green
Write-Host "  [+] Supabase cloud database" -ForegroundColor Green
Write-Host "  [+] REST API endpoints" -ForegroundColor Green
Write-Host "  [+] Health check endpoints" -ForegroundColor Green
Write-Host "  [+] Independent scaling capability" -ForegroundColor Green

Write-Host "`n================================================`n" -ForegroundColor Green

Write-Host "CI/CD DEMONSTRATION:`n" -ForegroundColor Yellow
Write-Host "  1. Show docker-compose.yml file" -ForegroundColor White
Write-Host "  2. Build all services: docker-compose build" -ForegroundColor White
Write-Host "  3. Start services: docker-compose up -d" -ForegroundColor White
Write-Host "  4. Verify with: .\quick-demo.ps1" -ForegroundColor White
Write-Host "  5. Show logs: docker-compose logs [service-name]" -ForegroundColor White

Write-Host "`n================================================`n" -ForegroundColor Green

Write-Host "TROUBLESHOOTING:`n" -ForegroundColor Yellow
Write-Host "  If service fails:" -ForegroundColor White
Write-Host "  - Check logs: docker-compose logs [service-name]" -ForegroundColor Gray
Write-Host "  - Restart: docker-compose restart [service-name]" -ForegroundColor Gray
Write-Host "  - Rebuild: docker-compose up -d --build [service-name]" -ForegroundColor Gray

Write-Host "`n================================================`n" -ForegroundColor Green

# Run quick check
Write-Host "CURRENT STATUS:`n" -ForegroundColor Yellow
.\quick-demo.ps1

Write-Host "================================================`n" -ForegroundColor Green
Write-Host "  READY FOR DEMONSTRATION!" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green
