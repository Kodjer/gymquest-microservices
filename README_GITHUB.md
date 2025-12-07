# GymQuest Microservices

Микросервисная архитектура для геймификации фитнеса.

## Архитектура

Проект состоит из 6 независимых микросервисов:

- **Quest Service** (3001) - Управление квестами
- **Player Service** (3002) - Профили игроков и опыт
- **Achievement Service** (3003) - Система достижений
- **Analytics Service** (3004) - Аналитика и статистика
- **Notification Service** (3005) - Уведомления пользователей
- **Leaderboard Service** (3006) - Таблица лидеров

## Технологии

- **Backend**: Node.js 22, Express 5, TypeScript 5
- **Database**: Supabase PostgreSQL
- **Testing**: Jest, ts-jest
- **DevOps**: Docker, docker-compose
- **Development**: nodemon, ts-node

## Установка

```bash
# Клонировать репозиторий
git clone https://github.com/YOUR_USERNAME/gymquest-microservices.git
cd gymquest-microservices

# Установить зависимости для всех сервисов
cd quest-service && npm install
cd ../player-service && npm install
cd ../achievement-service && npm install
cd ../analytics-service && npm install
cd ../notification-service && npm install
cd ../leaderboard-service && npm install
```

## Запуск

### С Docker Compose (рекомендуется)

```bash
docker-compose up -d
```

### Ручной запуск

```bash
# Запустить каждый сервис в отдельном терминале
cd quest-service && npm run dev
cd player-service && npm run dev
cd achievement-service && npm run dev
cd analytics-service && npm run dev
cd notification-service && npm run dev
cd leaderboard-service && npm run dev
```

## Тестирование

```bash
# Запустить тесты для всех сервисов
cd quest-service && npm test
cd ../player-service && npm test
cd ../achievement-service && npm test
cd ../analytics-service && npm test
cd ../notification-service && npm test
cd ../leaderboard-service && npm test
```

## API Endpoints

### Quest Service (3001)
- `GET /api/quests/:userId` - Получить квесты пользователя
- `POST /api/quests` - Создать квест
- `PATCH /api/quests/:id` - Обновить квест
- `DELETE /api/quests/:id` - Удалить квест

### Player Service (3002)
- `GET /api/players/:userId` - Получить профиль игрока
- `POST /api/players` - Создать профиль
- `POST /api/players/:userId/xp` - Добавить опыт

### Achievement Service (3003)
- `GET /api/achievements/:userId` - Получить достижения пользователя
- `POST /api/achievements/check` - Проверить достижения

### Analytics Service (3004)
- `GET /api/analytics/stats` - Глобальная статистика
- `GET /api/analytics/users/:userId/activity` - Активность пользователя

### Notification Service (3005)
- `GET /api/notifications/:userId` - Получить уведомления
- `POST /api/notifications` - Создать уведомление
- `PATCH /api/notifications/:id/read` - Отметить как прочитанное

### Leaderboard Service (3006)
- `GET /api/leaderboard/top` - Топ игроков
- `GET /api/leaderboard/rank/:userId` - Ранг игрока

## Health Check

```bash
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
curl http://localhost:3004/health
curl http://localhost:3005/health
curl http://localhost:3006/health
```

## Переменные окружения

Каждый сервис требует `.env` файл:

```env
PORT=300X
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

## Лицензия

MIT
