# GymQuest Microservices - Docker

## Запуск всех 6 микросервисов

```bash
docker-compose up -d
```

## Проверка статуса

```bash
docker-compose ps
```

## Проверка работы сервисов

Все сервисы работают и доступны на портах 3001-3006:

```bash
# Health checks
curl http://localhost:3001/health  # Quest Service
curl http://localhost:3002/health  # Player Service
curl http://localhost:3003/health  # Achievement Service
curl http://localhost:3004/health  # Analytics Service
curl http://localhost:3005/health  # Notification Service
curl http://localhost:3006/health  # Leaderboard Service
```

## API Endpoints для демонстрации

### Quest Service (Port 3001)

```bash
# Создать квест
curl -X POST http://localhost:3001/api/quests \
  -H "Content-Type: application/json" \
  -d '{"user_id":"demo-123","title":"Test Quest","description":"Testing","xp_reward":100,"difficulty":"easy"}'

# Получить квесты пользователя
curl http://localhost:3001/api/quests/demo-123
```

### Player Service (Port 3002)

```bash
# Создать игрока
curl -X POST http://localhost:3002/api/players \
  -H "Content-Type: application/json" \
  -d '{"user_id":"player-123","username":"TestPlayer","email":"test@example.com"}'

# Получить профиль игрока
curl http://localhost:3002/api/players/player-123

# Добавить XP
curl -X POST http://localhost:3002/api/players/player-123/xp \
  -H "Content-Type: application/json" \
  -d '{"xp":50}'
```

### Achievement Service (Port 3003)

```bash
# Получить достижения пользователя
curl http://localhost:3003/api/achievements/demo-123
```

### Analytics Service (Port 3004)

```bash
# Получить глобальную аналитику
curl http://localhost:3004/api/analytics/global

# Получить аналитику пользователя
curl http://localhost:3004/api/analytics/demo-123
```

### Notification Service (Port 3005)

```bash
# Создать уведомление
curl -X POST http://localhost:3005/api/notifications \
  -H "Content-Type: application/json" \
  -d '{"user_id":"demo-123","type":"achievement","message":"Achievement unlocked!"}'

# Получить уведомления пользователя
curl http://localhost:3005/api/notifications/demo-123
```

### Leaderboard Service (Port 3006)

```bash
# Получить таблицу лидеров
curl http://localhost:3006/api/leaderboard

# Получить ранг игрока
curl http://localhost:3006/api/leaderboard/rank/player-123
```

## Демонстрационные скрипты PowerShell

```powershell
# Быстрая проверка всех сервисов
.\quick-demo.ps1

# Интерактивная демонстрация с примерами запросов
.\interactive-demo.ps1

# Полная шпаргалка для демонстрации
.\DEMO-CHEAT-SHEET.ps1
```

## Просмотр логов

```bash
# Все сервисы
docker-compose logs -f

# Конкретный сервис
docker-compose logs -f quest-service
docker-compose logs -f player-service
```

## Остановка

```bash
docker-compose down
```

## Архитектура

- **quest-service** (3001) - Управление квестами
- **player-service** (3002) - Профили игроков и уровни
- **achievement-service** (3003) - Достижения и награды
- **analytics-service** (3004) - Статистика и аналитика
- **notification-service** (3005) - Уведомления пользователей
- **leaderboard-service** (3006) - Таблица лидеров

## Технологии

- **Backend**: Node.js + TypeScript + Express
- **Database**: Supabase (PostgreSQL)
- **Containerization**: Docker + Docker Compose
- **Network**: Isolated Docker network with DNS configuration

Все сервисы подключены к Supabase PostgreSQL и работают независимо друг от друга.
