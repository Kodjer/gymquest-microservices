# 🎯 Демонстрация работы GymQuest Microservices

## Быстрый запуск для проверки

### 1. Запуск всех микросервисов

```powershell
docker-compose up -d
```

### 2. Проверка здоровья сервисов

```powershell
.\check-services.ps1
```

### 3. Тестирование функционала

```powershell
.\demo-requests.ps1
```

---

## Архитектура

**6 микросервисов:**

- ✅ Quest Service (3001) — управление квестами
- ✅ Player Service (3002) — управление игроками
- ✅ Achievement Service (3003) — достижения
- ✅ Analytics Service (3004) — аналитика
- ✅ Notification Service (3005) — уведомления
- ✅ Leaderboard Service (3006) — таблица лидеров

**База данных:** Supabase (общая БД, разные таблицы для каждого сервиса)

---

## Проверка каждого сервиса

### Quest Service (порт 3001)

```powershell
# Health check
curl http://localhost:3001/health

# Получить все квесты
curl http://localhost:3001/api/quests

# Создать квест
curl -X POST http://localhost:3001/api/quests `
  -H "Content-Type: application/json" `
  -d '{"title":"Demo Quest","description":"Test","reward_xp":100}'
```

### Player Service (порт 3002)

```powershell
# Health check
curl http://localhost:3002/health

# Получить игроков
curl http://localhost:3002/api/players

# Создать игрока
curl -X POST http://localhost:3002/api/players `
  -H "Content-Type: application/json" `
  -d '{"username":"TestPlayer","email":"test@example.com"}'
```

### Achievement Service (порт 3003)

```powershell
# Health check
curl http://localhost:3003/health

# Получить достижения
curl http://localhost:3003/api/achievements
```

### Analytics Service (порт 3004)

```powershell
# Health check
curl http://localhost:3004/health

# Получить аналитику
curl http://localhost:3004/api/analytics
```

### Notification Service (порт 3005)

```powershell
# Health check
curl http://localhost:3005/health

# Получить уведомления
curl http://localhost:3005/api/notifications
```

### Leaderboard Service (порт 3006)

```powershell
# Health check
curl http://localhost:3006/health

# Получить таблицу лидеров
curl http://localhost:3006/api/leaderboard
```

---

## Юнит-тесты

Каждый сервис имеет юнит-тесты:

```powershell
# Тестирование quest-service
cd quest-service; npm test; cd ..

# Тестирование player-service
cd player-service; npm test; cd ..

# Тестирование achievement-service
cd achievement-service; npm test; cd ..

# И так далее для всех сервисов
```

---

## Что реализовано

### ✅ Микросервисная архитектура

- Каждый сервис — отдельный Docker контейнер
- Независимая разработка и деплой
- REST API для каждого сервиса

### ✅ База данных

- Supabase (PostgreSQL)
- Shared Database паттерн
- Разные таблицы для каждого сервиса

### ✅ Контейнеризация

- Dockerfile для каждого сервиса
- Docker Compose для оркестрации
- Изолированная сеть

### ✅ Тестирование

- Jest для юнит-тестов
- Моки для изоляции тестов
- Покрытие основного функционала

### ✅ TypeScript

- Типизация во всех сервисах
- Модели данных
- Контроллеры и роуты

---

## Структура проекта

```
gymquest-microservices/
├── docker-compose.yml          # Оркестрация сервисов
├── quest-service/              # Микросервис квестов
├── player-service/             # Микросервис игроков
├── achievement-service/        # Микросервис достижений
├── analytics-service/          # Микросервис аналитики
├── notification-service/       # Микросервис уведомлений
└── leaderboard-service/        # Микросервис лидерборда
```

Каждый сервис содержит:

- `src/` — исходный код
- `__tests__/` — юнит-тесты
- `Dockerfile` — контейнеризация
- `package.json` — зависимости

---

## Остановка сервисов

```powershell
docker-compose down
```
