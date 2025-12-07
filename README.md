# GymQuest Microservices - Docker

## Запуск всех 6 микросервисов

```bash
docker-compose up -d
```

## Проверка статуса

```bash
docker-compose ps
```

## Просмотр логов

```bash
# Все сервисы
docker-compose logs -f

# Конкретный сервис
docker-compose logs -f quest-service
```

## Остановка

```bash
docker-compose down
```

## Проверка работы сервисов

```bash
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
curl http://localhost:3004/health
curl http://localhost:3005/health
curl http://localhost:3006/health
```

## Создание квеста (пример)

```bash
curl -X POST http://localhost:3001/api/quests \
  -H "Content-Type: application/json; charset=utf-8" \
  -d '{"user_id":"docker-test","title":"Docker Quest","description":"Test from Docker","xp_reward":100,"difficulty":"easy"}'
```

## Архитектура

- **quest-service** (3001) - Управление квестами
- **player-service** (3002) - Профили игроков
- **achievement-service** (3003) - Достижения
- **analytics-service** (3004) - Аналитика
- **notification-service** (3005) - Уведомления
- **leaderboard-service** (3006) - Таблица лидеров

Все сервисы подключены к Supabase PostgreSQL.
