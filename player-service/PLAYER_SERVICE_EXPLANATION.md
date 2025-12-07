# Player Service - Подробное объяснение кода

## Обзор микросервиса

Player Service (Сервис игрока)  это микросервис для управления профилями игроков, опытом (XP) и уровнями в приложении GymQuest. Этот сервис отвечает за:
- Создание и получение профилей игроков
- Управление опытом (XP) и уровнями
- Расчёт прогресса и статистики
- Хранение настроек игрока

## Структура проекта

```
player-service/
 src/
    config/           # Конфигурация (подключение к БД)
       supabase.ts
    models/           # TypeScript интерфейсы
       Player.ts
    utils/            # Вспомогательные функции
       levelCalculator.ts
    controllers/      # Бизнес-логика
       playerController.ts
    routes/           # API маршруты
       player.ts
    server.ts         # Главный файл сервера
 .env                  # Переменные окружения
 package.json          # Зависимости проекта
 tsconfig.json         # Конфигурация TypeScript
```

---

## 1. Файл: tsconfig.json

### Назначение
Конфигурация компилятора TypeScript. Определяет, как TypeScript будет компилировать код в JavaScript.

### Построчное объяснение

```json
{
  "compilerOptions": {
```
**compilerOptions**  основной раздел с параметрами компиляции

```json
    "target": "ES2020",
```
**target: "ES2020"**  код будет скомпилирован в JavaScript версии ES2020
- ES2020 поддерживает современные возможности: optional chaining (?.), nullish coalescing (??), BigInt
- Эта версия хорошо поддерживается Node.js 14+

```json
    "module": "commonjs",
```
**module: "commonjs"**  использовать систему модулей CommonJS
- CommonJS использует `require()` и `module.exports`
- Это стандартная система модулей для Node.js
- Альтернативы: "ES2015" (import/export), "AMD"

```json
    "lib": ["ES2020"],
```
**lib: ["ES2020"]**  подключить библиотеки типов для ES2020
- Даёт доступ к типам для Promise, Array.flat(), Object.fromEntries() и других современных возможностей
- Без этого TypeScript не знал бы о современных JavaScript API

```json
    "outDir": "./dist",
```
**outDir: "./dist"**  папка для скомпилированных .js файлов
- При выполнении `npm run build` TypeScript создаст папку `dist/`
- Структура папок сохранится: `src/server.ts`  `dist/server.js`

```json
    "rootDir": "./src",
```
**rootDir: "./src"**  корневая папка с исходным кодом
- TypeScript будет искать .ts файлы только в `src/`
- Это предотвращает случайную компиляцию файлов вне src/

```json
    "strict": true,
```
**strict: true**  включить все строгие проверки типов
- Включает: strictNullChecks, strictFunctionTypes, strictBindCallApply и др.
- Заставляет явно указывать типы, проверяет null/undefined
- Пример: `let name: string | undefined` вместо просто `let name`

```json
    "esModuleInterop": true,
```
**esModuleInterop: true**  улучшенная совместимость с ES модулями
- Позволяет писать `import express from 'express'` вместо `import * as express from 'express'`
- Автоматически добавляет `default` экспорт для CommonJS модулей

```json
    "skipLibCheck": true,
```
**skipLibCheck: true**  не проверять типы в node_modules
- Ускоряет компиляцию (не проверяет типы в библиотеках)
- Полезно, когда библиотеки уже проверены их авторами

```json
    "forceConsistentCasingInFileNames": true,
```
**forceConsistentCasingInFileNames: true**  проверять регистр в именах файлов
- `import Player from './player'` и `import Player from './Player'`  будут разные файлы
- Важно для Linux/Mac, где регистр имеет значение

```json
    "resolveJsonModule": true
```
**resolveJsonModule: true**  разрешить импорт .json файлов
- Можно писать `import config from './config.json'`
- TypeScript будет проверять типы полей из JSON

```json
  },
  "include": ["src/**/*"],
```
**include: ["src/**/*"]**  компилировать все файлы в src/
- `**/*` означает "все файлы во всех вложенных папках"
- TypeScript обработает src/server.ts, src/models/Player.ts, src/config/supabase.ts и т.д.

```json
  "exclude": ["node_modules", "dist"]
```
**exclude**  НЕ компилировать эти папки
- **node_modules**  сторонние библиотеки (не наш код)
- **dist**  уже скомпилированные файлы (избежать повторной компиляции)

---

## 2. Файл: package.json

### Назначение
Манифест Node.js проекта. Описывает зависимости, скрипты и метаданные.

### Построчное объяснение

```json
{
  "name": "player-service",
```
**name**  имя npm пакета
- Используется при публикации в npm registry
- Должно быть уникальным, если планируется публикация

```json
  "version": "1.0.0",
```
**version**  версия проекта в формате [semver](https://semver.org/)
- 1.0.0 = Major.Minor.Patch
- Major: несовместимые изменения, Minor: новые возможности, Patch: исправления

```json
  "description": "",
  "main": "index.js",
```
**main**  точка входа для модуля (если его импортируют)
- Для сервиса не критично, т.к. мы не публикуем пакет

```json
  "scripts": {
```
**scripts**  команды npm, которые можно запустить

```json
    "dev": "nodemon --exec ts-node src/server.ts",
```
**npm run dev**  режим разработки
- **nodemon**  утилита, которая перезапускает сервер при изменении файлов
- **--exec ts-node**  выполнить команду ts-node (запускает .ts без компиляции)
- **src/server.ts**  файл для запуска

Процесс:
1. nodemon следит за изменениями в .ts файлах
2. При изменении автоматически перезапускает ts-node src/server.ts
3. Код выполняется без создания dist/ папки

```json
    "build": "tsc",
```
**npm run build**  компиляция TypeScript в JavaScript
- **tsc**  TypeScript Compiler
- Читает tsconfig.json и компилирует src/  dist/
- Создаёт готовые к production .js файлы

```json
    "start": "node dist/server.js"
```
**npm start**  запуск в production
- Запускает уже скомпилированный JavaScript
- Быстрее, чем ts-node (нет компиляции на лету)
- Используется на сервере после `npm run build`

```json
  },
  "dependencies": {
```
**dependencies**  библиотеки, необходимые в production

```json
    "@supabase/supabase-js": "^2.86.2",
```
**@supabase/supabase-js**  клиент для работы с Supabase
- Предоставляет API для работы с PostgreSQL БД
- Методы: supabase.from('players').select(), .insert(), .update()
- **^2.86.2**  версия >=2.86.2 но <3.0.0

```json
    "cors": "^2.8.5",
```
**cors**  middleware для Express (Cross-Origin Resource Sharing)
- Позволяет фронтенду (localhost:3000) обращаться к API (localhost:3002)
- Без CORS браузер блокирует запросы между разными портами

```json
    "dotenv": "^17.2.3",
```
**dotenv**  загружает переменные из .env файла
- `dotenv.config()` читает .env и добавляет в process.env
- Секреты (API ключи) хранятся в .env, не в коде

```json
    "express": "^5.2.1"
```
**express**  веб-фреймворк для Node.js
- Упрощает создание HTTP сервера
- Предоставляет роутинг, middleware, обработку запросов

```json
  },
  "devDependencies": {
```
**devDependencies**  библиотеки только для разработки

```json
    "@types/cors": "^2.8.19",
    "@types/express": "^5.0.6",
    "@types/node": "^24.10.1",
```
**@types/**  TypeScript определения типов для JavaScript библиотек
- Позволяют использовать автодополнение и проверку типов
- Не нужны в production (код уже скомпилирован)

```json
    "nodemon": "^3.1.11",
```
**nodemon**  автоматический перезапуск при изменениях
- Только для разработки, в production используется pm2 или systemd

```json
    "ts-node": "^10.9.2",
```
**ts-node**  выполнение TypeScript без компиляции
- JIT компилятор для Node.js
- Удобно для разработки, но медленнее обычного Node

```json
    "typescript": "^5.9.3"
```
**typescript**  компилятор TypeScript
- Преобразует .ts  .js
- Проверяет типы при компиляции

---

## 3. Файл: .env

### Назначение
Хранение конфигурации и секретов (не коммитится в Git).

### Построчное объяснение

```env
PORT=3002
```
**PORT**  порт, на котором запустится сервер
- Player Service работает на порту 3002
- Quest Service  3001, Achievement Service  3003
- Разные порты позволяют запускать сервисы одновременно

```env
SUPABASE_URL=https://your-project.supabase.co
```
**SUPABASE_URL**  адрес вашего Supabase проекта
- Формат: https://xxx.supabase.co
- Получить в Supabase Dashboard  Settings  API
- Уникален для каждого проекта

```env
SUPABASE_ANON_KEY=your-anon-key
```
**SUPABASE_ANON_KEY**  публичный API ключ
- Используется для аутентификации запросов к Supabase
- Безопасен для клиентской стороны (с правилами RLS)
- Получить там же: Settings  API  anon public

---

## 4. Файл: src/config/supabase.ts

### Назначение
Создание подключения к базе данных Supabase.

### Построчное объяснение

```typescript
// src/config/supabase.ts
```
Комментарий с путём файла (удобно для навигации в большом проекте)

```typescript
import { createClient } from '@supabase/supabase-js';
```
**import { createClient }**  функция для создания клиента Supabase
- Named import: импортируем конкретную функцию из пакета
- createClient() вернёт объект с методами для работы с БД

```typescript
import dotenv from 'dotenv';
```
**import dotenv**  библиотека для загрузки .env
- Default import: импортируем весь модуль
- Используется для загрузки переменных окружения

```typescript
dotenv.config();
```
**dotenv.config()**  загрузить переменные из .env в process.env
- Ищет файл .env в корне проекта
- После вызова доступны process.env.PORT, process.env.SUPABASE_URL и т.д.
- Если .env не найден, переменные не будут загружены (но ошибки не будет)

```typescript
const supabaseUrl = process.env.SUPABASE_URL || 'https://your-project.supabase.co';
```
**const supabaseUrl**  URL Supabase проекта
- **process.env.SUPABASE_URL**  читает из .env файла
- **|| 'https://...'**  если переменная не задана, используется значение по умолчанию
- Это fallback для случаев, когда .env отсутствует

```typescript
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || 'your-anon-key';
```
**const supabaseAnonKey**  публичный API ключ
- Аналогично URL, с fallback значением
- В production обязательно должен быть настоящий ключ

```typescript
if (!process.env.SUPABASE_URL || !process.env.SUPABASE_ANON_KEY) {
  console.warn('Внимание: Supabase credentials не настроены в .env файле');
}
```
**if (!process.env.SUPABASE_URL ...)**  проверка наличия переменных
- **!** означает "если НЕ существует"
- **||** означает "ИЛИ"
- **console.warn()**  вывод предупреждения в консоль (желтый цвет)
- Не останавливает работу, но предупреждает разработчика

```typescript
export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```
**export const supabase**  создать и экспортировать клиент
- **export**  делает переменную доступной для импорта в других файлах
- **createClient()**  инициализирует подключение к Supabase
- Принимает URL и API ключ
- Возвращает объект с методами: from(), auth(), storage() и т.д.

Теперь в других файлах можно писать:
```typescript
import { supabase } from './config/supabase';
const { data } = await supabase.from('players').select('*');
```

---

## 5. Файл: src/models/Player.ts

### Назначение
TypeScript интерфейсы для типизации данных игрока.

### Построчное объяснение

```typescript
// src/models/Player.ts
```
Комментарий с путём файла

```typescript
export interface Player {
```
**export interface Player**  основной интерфейс для игрока
- **interface**  описание структуры объекта (только типы, без реализации)
- **export**  можно импортировать в других файлах
- Соответствует таблице `players` в БД

```typescript
  id: string;
```
**id: string**  уникальный идентификатор игрока
- Тип UUID (например: "550e8400-e29b-41d4-a716-446655440000")
- Первичный ключ в БД
- Генерируется Supabase при создании

```typescript
  user_id: string;
```
**user_id: string**  идентификатор пользователя из NextAuth
- Связь с аутентификацией
- Один user_id  один игрок
- Может быть email, GitHub ID и т.д.

```typescript
  level: number;
```
**level: number**  текущий уровень игрока
- Целое число (1, 2, 3, ...)
- Рассчитывается из XP: level = Math.floor(xp / 100) + 1

```typescript
  xp: number;
```
**xp: number**  опыт игрока (Experience Points)
- Целое число (0, 50, 150, ...)
- Увеличивается за выполнение квестов
- Определяет уровень

```typescript
  total_quests_completed: number;
```
**total_quests_completed: number**  количество выполненных квестов
- Счётчик успешно завершённых заданий
- Используется для достижений и статистики

```typescript
  achievements_unlocked: string[];
```
**achievements_unlocked: string[]**  массив ID разблокированных достижений
- **[]** означает массив
- **string[]**  массив строк
- Пример: ["first_quest", "level_10", "workout_streak_7"]
- В БД хранится как JSONB

```typescript
  current_streak: number;
```
**current_streak: number**  текущая серия выполненных квестов
- Количество дней подряд с завершённым квестом
- Обнуляется при пропуске дня
- Мотивирует ежедневные тренировки

```typescript
  longest_streak: number;
```
**longest_streak: number**  рекорд серии
- Максимальное значение current_streak
- Никогда не уменьшается
- Показывает лучший результат игрока

```typescript
  theme: 'light' | 'dark' | 'system';
```
**theme**  тема интерфейса
- **|** означает "ИЛИ" (union type)
- Может быть только одно из трёх значений
- Типичный паттерн для настроек с фиксированными вариантами

```typescript
  language: string;
```
**language: string**  язык интерфейса
- Пример: "ru", "en", "es"
- Может быть любой строкой (более гибко, чем union)

```typescript
  notifications_enabled: boolean;
```
**notifications_enabled: boolean**  включены ли уведомления
- **boolean**  логический тип (true или false)
- Используется для опциональных возможностей

```typescript
  created_at?: string;
```
**created_at?: string**  дата создания профиля
- **?** означает опциональное поле (может отсутствовать)
- Формат ISO 8601: "2025-12-04T15:30:00Z"
- Автоматически устанавливается БД при создании

```typescript
  updated_at?: string;
```
**updated_at?: string**  дата последнего обновления
- Также опциональное
- Автоматически обновляется БД при изменении

```typescript
}
```

---

```typescript
export interface PlayerStats {
```
**interface PlayerStats**  расширенная статистика игрока
- Используется в методе getPlayerStats()
- Включает рассчитанные поля (не из БД)

```typescript
  player: Player;
```
**player: Player**  базовый профиль игрока
- Включает все поля из интерфейса Player
- Вложенный объект

```typescript
  progress_to_next_level: number;
```
**progress_to_next_level**  процент прогресса к следующему уровню
- Число от 0 до 100
- Рассчитывается: (current_level_xp / xp_needed) * 100

```typescript
  xp_to_next_level: number;
```
**xp_to_next_level**  сколько XP нужно для следующего уровня
- Например, если нужно 400 XP для level 5, а у игрока 350, то xp_to_next_level = 50
- Показывает оставшийся путь

```typescript
  total_xp_next_level: number;
```
**total_xp_next_level**  всего XP нужно для следующего уровня
- Например, для уровня 5 нужно 400 XP
- Используется для отображения прогресс-баров

```typescript
  completion_rate: number;
```
**completion_rate**  процент выполнения квестов
- Число от 0 до 100
- Рассчитывается: (completed / total) * 100

```typescript
}
```

---

```typescript
export interface CreatePlayerDto {
```
**interface CreatePlayerDto**  данные для создания нового игрока
- **Dto** = Data Transfer Object (объект передачи данных)
- Используется в createPlayerInternal()

```typescript
  user_id: string;
```
**user_id: string**  единственное обязательное поле
- Остальные поля (level, xp и т.д.) будут установлены по умолчанию

```typescript
  level?: number;
```
**level?: number**  опциональный начальный уровень
- Обычно не указывается (используется дефолтное значение 1)

```typescript
  xp?: number;
```
Аналогично для остальных опциональных полей
- **?** делает все поля кроме user_id необязательными

```typescript
}
```

---

```typescript
export interface UpdatePlayerDto {
```
**interface UpdatePlayerDto**  данные для обновления игрока
- Используется в updatePlayer()
- Все поля опциональные

```typescript
  theme?: 'light' | 'dark' | 'system';
  language?: string;
  notifications_enabled?: boolean;
```
Только настройки, которые пользователь может изменить
- XP и level НЕ включены (обновляются через addXp)
- Это паттерн безопасности: разделение обновлений

```typescript
}
```

---

```typescript
export interface AddXpDto {
```
**interface AddXpDto**  данные для добавления XP
- Используется в addXp()

```typescript
  amount: number;
```
**amount: number**  сколько XP добавить
- Положительное число
- Пример: 50 (за выполнение квеста)

```typescript
  reason?: string;
```
**reason?: string**  причина добавления XP
- Опциональное поле для логирования
- Пример: "Completed quest: Morning Run"
- Можно использовать для истории действий

```typescript
}
```

---

[Продолжение следует...]
## 6. Файл: src/utils/levelCalculator.ts

### Назначение
Математические функции для расчёта уровней, опыта и прогресса.

### Построчное объяснение

```typescript
// src/utils/levelCalculator.ts
```

```typescript
export const calculateLevel = (xp: number): number => {
```
**export const calculateLevel**  функция для расчёта уровня из XP
- **const**  неизменяемая переменная (функцию нельзя переопределить)
- **(xp: number)**  параметр: количество опыта
- **: number**  возвращаемый тип: целое число
- **=>**  стрелочная функция (arrow function)

```typescript
  return Math.floor(xp / 100) + 1;
```
**Формула расчёта уровня:**
- **xp / 100**  делим XP на 100 (каждые 100 XP = 1 уровень)
- **Math.floor()**  округление вниз (350 / 100 = 3.5  3)
- **+ 1**  добавляем 1 (уровни начинаются с 1, а не с 0)

Примеры:
- 0 XP: Math.floor(0/100) + 1 = 0 + 1 = **Уровень 1**
- 50 XP: Math.floor(50/100) + 1 = 0 + 1 = **Уровень 1**
- 150 XP: Math.floor(150/100) + 1 = 1 + 1 = **Уровень 2**
- 999 XP: Math.floor(999/100) + 1 = 9 + 1 = **Уровень 10**

```typescript
};
```

---

```typescript
export const calculateXpToNextLevel = (currentXp: number): number => {
```
**calculateXpToNextLevel**  сколько XP осталось до следующего уровня

```typescript
  const currentLevel = calculateLevel(currentXp);
```
**const currentLevel**  определяем текущий уровень
- Вызываем calculateLevel() для получения уровня
- Пример: если currentXp = 250, то currentLevel = 3

```typescript
  const xpForNextLevel = currentLevel * 100;
```
**xpForNextLevel**  сколько всего XP нужно для следующего уровня
- Формула: уровень * 100
- Пример: для достижения уровня 4 нужно 4 * 100 = 400 XP

```typescript
  return xpForNextLevel - currentXp;
```
**return xpForNextLevel - currentXp**  разница между нужным и текущим XP
- Пример: 400 (нужно для lvl 4) - 250 (есть) = **150 XP осталось**

Полный пример:
- Игрок имеет 250 XP
- currentLevel = 3 (из расчёта 250/100 = 2, 2+1 = 3)
- xpForNextLevel = 3 * 100 = 300
- Осталось: 300 - 250 = **50 XP**

```typescript
};
```

---

```typescript
export const calculateProgressPercent = (currentXp: number): number => {
```
**calculateProgressPercent**  процент прогресса к следующему уровню

```typescript
  const currentLevel = calculateLevel(currentXp);
```
Получаем текущий уровень

```typescript
  const xpForCurrentLevel = (currentLevel - 1) * 100;
```
**xpForCurrentLevel**  сколько XP было на начало текущего уровня
- **(currentLevel - 1)**  предыдущий уровень
- Пример: на уровне 3 начало было при 200 XP ((3-1) * 100)

```typescript
  const xpForNextLevel = currentLevel * 100;
```
Сколько XP нужно для следующего уровня (как в предыдущей функции)

```typescript
  const xpInCurrentLevel = currentXp - xpForCurrentLevel;
```
**xpInCurrentLevel**  сколько XP заработано **на текущем уровне**
- Вычитаем XP с начала уровня
- Пример: 250 (текущий) - 200 (начало lvl 3) = 50 XP на этом уровне

```typescript
  const xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
```
**xpNeededForLevel**  сколько всего XP нужно для прохождения уровня
- Пример: 300 (конец lvl 3) - 200 (начало lvl 3) = 100 XP нужно

```typescript
  return Math.round((xpInCurrentLevel / xpNeededForLevel) * 100);
```
**Расчёт процента:**
1. **(xpInCurrentLevel / xpNeededForLevel)**  доля пройденного (0.0 - 1.0)
   - Пример: 50 / 100 = 0.5
2. ** 100**  преобразуем в проценты
   - 0.5  100 = 50
3. **Math.round()**  округляем до целого числа
   - 50.7  51%

Полный пример:
- 250 XP  уровень 3
- Начало уровня: 200 XP, конец: 300 XP
- На уровне заработано: 50 XP из 100 нужных
- Прогресс: **50%**

```typescript
};
```

---

```typescript
export const calculateCompletionRate = (
  completed: number,
  total: number
): number => {
```
**calculateCompletionRate**  процент выполненных квестов
- **completed: number**  количество выполненных квестов
- **total: number**  общее количество квестов

```typescript
  if (total === 0) return 0;
```
**Защита от деления на ноль**
- Если квестов нет (total = 0), возвращаем 0%
- Без этой проверки: 5 / 0 = Infinity (ошибка)

```typescript
  return Math.round((completed / total) * 100);
};
```
**Расчёт процента выполнения:**
- **(completed / total)**  доля выполненных
  - Пример: 7 выполнено из 10 = 0.7
- ** 100**  в проценты: 0.7  70
- **Math.round()**  округление: 70.4  70%

---

## 7. Файл: src/controllers/playerController.ts

### Назначение
Бизнес-логика для работы с игроками. Обработка запросов к API.

### Построчное объяснение

```typescript
// src/controllers/playerController.ts
import { Request, Response } from 'express';
```
**import { Request, Response }**  типы Express для HTTP запросов
- **Request**  объект входящего запроса (параметры, body, headers)
- **Response**  объект ответа (для отправки данных клиенту)
- Используются для типизации в TypeScript

```typescript
import { supabase } from '../config/supabase';
```
Импортируем клиент базы данных

```typescript
import { Player, PlayerStats, AddXpDto, UpdatePlayerDto } from '../models/Player';
```
Импортируем TypeScript интерфейсы

```typescript
import {
  calculateLevel,
  calculateXpToNextLevel,
  calculateProgressPercent,
  calculateCompletionRate,
} from '../utils/levelCalculator';
```
Импортируем функции расчёта

---

### Функция 1: getPlayer

```typescript
export const getPlayer = async (req: Request, res: Response) => {
```
**export const getPlayer**  получить профиль игрока
- **async**  асинхронная функция (использует await)
- **req: Request**  объект запроса
- **res: Response**  объект ответа

```typescript
  try {
```
**try**  блок, в котором могут возникнуть ошибки
- Если ошибка, выполнится блок catch

```typescript
    const { userId } = req.params;
```
**const { userId }**  извлечение userId из URL
- Деструктуризация объекта req.params
- Например, для URL `/api/player/user123`, userId = "user123"
- req.params содержит параметры из пути роута

```typescript
    const { data, error } = await supabase
      .from('players')
      .select('*')
      .eq('user_id', userId)
      .single();
```
**Запрос к базе данных:**
1. **await**  ждём завершения асинхронной операции
2. **supabase.from('players')**  выбираем таблицу players
3. **.select('*')**  выбрать все столбцы (id, user_id, level, xp и т.д.)
4. **.eq('user_id', userId)**  фильтр: WHERE user_id = userId
5. **.single()**  ожидаем одну запись (не массив)
6. **const { data, error }**  деструктуризация результата
   - **data**  данные игрока (если найден)
   - **error**  объект ошибки (если что-то пошло не так)

```typescript
    if (error) {
```
**if (error)**  если произошла ошибка при запросе

```typescript
      if (error.code === 'PGRST116') {
```
**PGRST116**  код ошибки "запись не найдена"
- Специфичный для PostgREST (используется в Supabase)
- Означает, что игрока с таким user_id не существует

```typescript
        const newPlayer = await createPlayerInternal(userId);
```
**createPlayerInternal(userId)**  создать нового игрока
- Внутренняя функция (определена ниже)
- Автоматически создаёт профиль при первом входе

```typescript
        return res.json(newPlayer);
```
**return res.json(newPlayer)**  отправить ответ клиенту
- **res.json()**  отправить JSON с HTTP 200
- **return**  завершить выполнение функции
- Клиент получит объект нового игрока

```typescript
      }
      return res.status(500).json({ error: error.message });
```
**Обработка других ошибок:**
- **res.status(500)**  HTTP статус "Internal Server Error"
- **.json({ error: error.message })**  отправить сообщение об ошибке
- Пример ответа: `{ "error": "Connection timeout" }`

```typescript
    }

    res.json(data);
```
**res.json(data)**  если всё ОК, отправить данные игрока
- data содержит объект Player из БД

```typescript
  } catch (error) {
```
**catch (error)**  обработка неожиданных ошибок
- Ловит ошибки из блока try
- Например: сетевые ошибки, некорректный JSON

```typescript
    res.status(500).json({ error: 'Не удалось получить профиль игрока' });
  }
};
```
Отправить общее сообщение об ошибке

---

### Функция 2: getPlayerStats

```typescript
export const getPlayerStats = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
```
Аналогично getPlayer  получаем userId из URL

```typescript
    let { data: player, error } = await supabase
      .from('players')
      .select('*')
      .eq('user_id', userId)
      .single();
```
**let { data: player, error }**  переименование data в player
- Используем **let** вместо **const**, т.к. player может измениться

```typescript
    if (error && error.code === 'PGRST116') {
      player = await createPlayerInternal(userId);
    } else if (error) {
      return res.status(500).json({ error: error.message });
    }
```
Аналогично getPlayer  создаём игрока, если не найден

```typescript
    const level = player.level;
    const currentXp = player.xp;
```
Извлекаем данные игрока для расчётов

```typescript
    const progressToNextLevel = calculateProgressPercent(currentXp);
    const xpToNextLevel = calculateXpToNextLevel(currentXp);
    const totalXpNextLevel = level * 100;
```
**Вычисляем статистику:**
- **progressToNextLevel**  процент прогресса (50%)
- **xpToNextLevel**  осталось XP (50)
- **totalXpNextLevel**  всего нужно для следующего уровня (300)

```typescript
    const { count: totalQuests } = await supabase
      .from('quests')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId);
```
**Запрос количества всех квестов:**
- **select('*', { count: 'exact' })**  подсчитать количество
- **head: true**  не возвращать данные, только счётчик
- **const { count: totalQuests }**  переименовать count в totalQuests
- Эффективнее, чем загружать все данные

```typescript
    const { count: completedQuests } = await supabase
      .from('quests')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .eq('status', 'done');
```
**Количество выполненных квестов:**
- Добавлен фильтр **.eq('status', 'done')**
- Подсчитываем только завершённые

```typescript
    const completionRate = calculateCompletionRate(
      completedQuests || 0,
      totalQuests || 0
    );
```
**Процент выполнения:**
- **completedQuests || 0**  если null, использовать 0
- Защита от undefined

```typescript
    const stats: PlayerStats = {
      player,
      progress_to_next_level: progressToNextLevel,
      xp_to_next_level: xpToNextLevel,
      total_xp_next_level: totalXpNextLevel,
      completion_rate: completionRate,
    };
```
**Формируем объект PlayerStats:**
- **stats: PlayerStats**  явная типизация
- Соответствует интерфейсу PlayerStats
- Включает player + рассчитанные поля

```typescript
    res.json(stats);
```
Отправляем статистику клиенту

```typescript
  } catch (error) {
    res.status(500).json({ error: 'Не удалось получить статистику игрока' });
  }
};
```

---

### Функция 3: addXp

```typescript
export const addXp = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
```
userId из URL (например: `/api/player/user123/xp`)

```typescript
    const { amount, reason }: AddXpDto = req.body;
```
**const { amount, reason }: AddXpDto**  данные из тела запроса
- **req.body**  данные, отправленные клиентом (POST/PUT)
- Пример: `{ "amount": 50, "reason": "Completed quest" }`
- **: AddXpDto**  типизация для проверки

```typescript
    const { data: player, error: fetchError } = await supabase
      .from('players')
      .select('*')
      .eq('user_id', userId)
      .single();
```
Получаем текущего игрока

```typescript
    if (fetchError) {
      return res.status(404).json({ error: 'Игрок не найден' });
    }
```
**404**  "Not Found" (игрок не существует)
- В отличие от getPlayer, здесь НЕ создаём нового игрока
- XP можно добавлять только существующему

```typescript
    const newXp = player.xp + amount;
    const newLevel = calculateLevel(newXp);
```
**Расчёт новых значений:**
- **newXp**  текущий XP + добавляемый
- **newLevel**  пересчитываем уровень

```typescript
    const { data: updatedPlayer, error: updateError } = await supabase
      .from('players')
      .update({
        xp: newXp,
        level: newLevel,
      })
      .eq('user_id', userId)
      .select()
      .single();
```
**Обновление БД:**
1. **.update({ xp: newXp, level: newLevel })**  установить новые значения
2. **.eq('user_id', userId)**  WHERE user_id = userId
3. **.select()**  вернуть обновлённую запись
4. **.single()**  ожидаем одну запись

```typescript
    if (updateError) {
      return res.status(500).json({ error: updateError.message });
    }

    res.json({
      message: `Добавлено ${amount} XP. ${reason ? `Причина: ${reason}` : ''}`,
      player: updatedPlayer,
    });
```
**Ответ клиенту:**
- Сообщение с подробностями
- Обновлённый объект игрока
- Пример: `{ "message": "Добавлено 50 XP. Причина: Completed quest", "player": {...} }`

```typescript
  } catch (error) {
    res.status(500).json({ error: 'Не удалось добавить XP' });
  }
};
```

---

### Функция 4: updatePlayer

```typescript
export const updatePlayer = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const updates: UpdatePlayerDto = req.body;
```
**updates: UpdatePlayerDto**  изменения из тела запроса
- Могут быть: theme, language, notifications_enabled
- НЕ xp и НЕ level (безопасность)

```typescript
    const { data, error } = await supabase
      .from('players')
      .update(updates)
      .eq('user_id', userId)
      .select()
      .single();
```
**Обновление настроек:**
- **.update(updates)**  применить все изменения из объекта
- Supabase автоматически обновит только переданные поля

```typescript
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Не удалось обновить игрока' });
  }
};
```

---

### Вспомогательная функция: createPlayerInternal

```typescript
const createPlayerInternal = async (userId: string): Promise<Player> => {
```
**const createPlayerInternal**  создать нового игрока (не экспортируется)
- **Promise<Player>**  возвращает Promise с объектом Player
- Используется только внутри этого файла

```typescript
  const newPlayer = {
    user_id: userId,
    level: 1,
    xp: 0,
    total_quests_completed: 0,
    achievements_unlocked: [],
    current_streak: 0,
    longest_streak: 0,
    theme: 'system' as const,
    language: 'ru',
    notifications_enabled: true,
  };
```
**Дефолтные значения для нового игрока:**
- **level: 1**  начальный уровень
- **xp: 0**  без опыта
- **achievements_unlocked: []**  пустой массив достижений
- **as const**  TypeScript литерал ('system' не может измениться)

```typescript
  const { data, error } = await supabase
    .from('players')
    .insert(newPlayer)
    .select()
    .single();
```
**Вставка в БД:**
- **.insert(newPlayer)**  создать новую запись
- **.select().single()**  вернуть созданный объект

```typescript
  if (error) {
    throw new Error(`Не удалось создать игрока: ${error.message}`);
  }
```
**throw new Error()**  выбросить исключение
- Остановит выполнение
- Будет поймано в catch блоке вызывающей функции

```typescript
  return data;
};
```

---

## 8. Файл: src/routes/player.ts

### Назначение
Определение API маршрутов. Связывает URL с функциями-обработчиками.

### Построчное объяснение

```typescript
// src/routes/player.ts
import { Router } from 'express';
```
**import { Router }**  класс для создания роутера
- Роутер  набор маршрутов (endpoints)
- Модульная организация API

```typescript
import {
  getPlayer,
  getPlayerStats,
  addXp,
  updatePlayer,
} from '../controllers/playerController';
```
Импортируем функции-обработчики

```typescript
const router = Router();
```
**const router = Router()**  создать экземпляр роутера
- Пустой объект, к которому добавим маршруты

---

```typescript
// GET /api/player/:userId - получить профиль игрока
router.get('/:userId', getPlayer);
```
**router.get('/:userId', getPlayer)**
- **get**  HTTP метод GET (чтение данных)
- **'/:userId'**  путь с параметром
  - **:** означает динамический параметр
  - Пример: `/api/player/user123`  userId = "user123"
- **getPlayer**  функция-обработчик
- **// комментарий**  описание маршрута для разработчиков

**Полный путь:** `GET http://localhost:3002/api/player/user123`

---

```typescript
// GET /api/player/:userId/stats - получить статистику игрока
router.get('/:userId/stats', getPlayerStats);
```
**Вложенный путь:**
- `/:userId/stats`  параметр + статичная часть
- Пример: `/api/player/user123/stats`
- Более специфичный маршрут (идёт после общего)

---

```typescript
// POST /api/player/:userId/xp - добавить XP игроку
router.post('/:userId/xp', addXp);
```
**router.post**  HTTP метод POST (создание/изменение)
- Используется для операций, изменяющих данные
- Тело запроса: `{ "amount": 50, "reason": "Quest completed" }`

**Полный запрос:**
```http
POST http://localhost:3002/api/player/user123/xp
Content-Type: application/json

{
  "amount": 50,
  "reason": "Completed Morning Run"
}
```

---

```typescript
// PUT /api/player/:userId - обновить настройки игрока
router.put('/:userId', updatePlayer);
```
**router.put**  HTTP метод PUT (обновление)
- Используется для изменения существующих данных
- Тело запроса: `{ "theme": "dark", "language": "en" }`

**Разница POST vs PUT:**
- **POST**  обычно для создания или специальных операций (addXp)
- **PUT**  для полного обновления ресурса (updatePlayer)

---

```typescript
export default router;
```
**export default router**  экспортировать роутер
- **default**  дефолтный экспорт (можно импортировать без {})
- В server.ts: `import playerRoutes from './routes/player'`

---

## 9. Файл: src/server.ts

### Назначение
Главный файл сервера. Инициализация Express, подключение middleware и роутов.

### Построчное объяснение

```typescript
// src/server.ts
import express from 'express';
```
**import express**  веб-фреймворк
- Default import (нет {})
- Функция для создания приложения

```typescript
import cors from 'cors';
```
**import cors**  middleware для CORS
- Разрешает запросы с других доменов/портов

```typescript
import dotenv from 'dotenv';
```
Загрузка .env файла

```typescript
import playerRoutes from './routes/player';
```
**import playerRoutes**  наши роуты
- Default import (export default в player.ts)

```typescript
dotenv.config();
```
Загрузить переменные окружения

```typescript
const app = express();
```
**const app = express()**  создать Express приложение
- Основной объект сервера
- Имеет методы: use(), get(), post(), listen()

```typescript
const PORT = process.env.PORT || 3002;
```
**PORT**  порт сервера
- Читаем из .env
- Если не задан, используем 3002

---

```typescript
app.use(cors());
```
**app.use(cors())**  подключить CORS middleware
- **app.use()**  применить middleware ко всем запросам
- **cors()**  вызов функции, возвращающей middleware
- Теперь фронтенд (localhost:3000) может обращаться к API (localhost:3002)

**Что делает cors():**
- Добавляет заголовок `Access-Control-Allow-Origin: *`
- Разрешает методы GET, POST, PUT, DELETE
- Позволяет браузеру делать кросс-доменные запросы

---

```typescript
app.use(express.json());
```
**app.use(express.json())**  парсер JSON
- Автоматически парсит тело запроса (req.body)
- Без этого req.body будет undefined
- Работает для Content-Type: application/json

**Пример:**
```
POST /api/player/user123/xp
Content-Type: application/json

{"amount": 50}
```
После middleware: `req.body = { amount: 50 }`

---

```typescript
app.use('/api/player', playerRoutes);
```
**app.use('/api/player', playerRoutes)**  монтировать роуты
- Все маршруты из playerRoutes будут доступны по `/api/player`
- **Префикс**  `/api/player`
- **Роуты**  `/:userId`, `/:userId/stats`, `/:userId/xp`

**Результат:**
- `router.get('/:userId')`  `GET /api/player/:userId`
- `router.get('/:userId/stats')`  `GET /api/player/:userId/stats`
- `router.post('/:userId/xp')`  `POST /api/player/:userId/xp`
- `router.put('/:userId')`  `PUT /api/player/:userId`

---

```typescript
app.get('/health', (req, res) => {
```
**app.get('/health', ...)**  health check endpoint
- **req**  объект запроса
- **res**  объект ответа
- Используется для мониторинга (жив ли сервис?)

```typescript
  res.json({
    status: 'OK',
    service: 'Player Service',
    port: PORT
  });
```
**res.json({...})**  отправить JSON ответ
- HTTP 200 OK
- Простой способ проверить, работает ли сервис

**Ответ:**
```json
{
  "status": "OK",
  "service": "Player Service",
  "port": 3002
}
```

```typescript
});
```

---

```typescript
app.listen(PORT, () => {
```
**app.listen(PORT, callback)**  запустить сервер
- **PORT**  порт для прослушивания (3002)
- **callback**  функция, вызываемая после запуска

```typescript
  console.log(` Player Service запущен на порту ${PORT}`);
  console.log(` API доступен по адресу: http://localhost:${PORT}/api/player`);
  console.log(`  Health check: http://localhost:${PORT}/health`);
});
```
**console.log()**  вывод информации в консоль
- **${PORT}**  template literal (подстановка переменной)
- Полезно для разработчиков: видно, что сервер запустился

**Вывод в консоль:**
```
 Player Service запущен на порту 3002
 API доступен по адресу: http://localhost:3002/api/player
  Health check: http://localhost:3002/health
```

---

## Резюме: Поток запроса

### Пример: Добавление XP

1. **Клиент отправляет запрос:**
```http
POST http://localhost:3002/api/player/user123/xp
Content-Type: application/json

{
  "amount": 50,
  "reason": "Completed quest"
}
```

2. **Express получает запрос**
   - Проходит через `cors()` middleware
   - Проходит через `express.json()`  парсит body

3. **Роутинг**
   - Префикс `/api/player`  playerRoutes
   - Метод POST, путь `/:userId/xp`  addXp()

4. **Controller: addXp()**
   - Извлекает userId = "user123" из req.params
   - Извлекает amount = 50, reason = "Completed quest" из req.body
   - Запрашивает игрока из БД
   - Рассчитывает newXp = player.xp + 50
   - Рассчитывает newLevel = calculateLevel(newXp)
   - Обновляет БД
   - Возвращает обновлённого игрока

5. **Ответ клиенту**
```json
{
  "message": "Добавлено 50 XP. Причина: Completed quest",
  "player": {
    "id": "...",
    "user_id": "user123",
    "level": 3,
    "xp": 250,
    ...
  }
}
```

---

## Ключевые концепции для защиты

### 1. Микросервисная архитектура
- **Разделение ответственности:** Player Service отвечает ТОЛЬКО за игроков
- **Независимое развёртывание:** Можно обновить Player Service без затрагивания Quest Service
- **Масштабирование:** Можно запустить несколько инстансов Player Service

### 2. RESTful API
- **GET**  чтение (getPlayer, getPlayerStats)
- **POST**  создание/специальные операции (addXp)
- **PUT**  обновление (updatePlayer)
- **Статусы:** 200 OK, 404 Not Found, 500 Internal Server Error

### 3. TypeScript
- **Статическая типизация:** Ошибки ловятся на этапе компиляции
- **Интерфейсы:** Player, PlayerStats, AddXpDto  контракты данных
- **IntelliSense:** Автодополнение в IDE

### 4. Асинхронное программирование
- **async/await:** Удобная работа с промисами
- **try/catch:** Обработка ошибок
- **Supabase клиент:** Все запросы асинхронные

### 5. Безопасность
- **Разделение endpoints:** addXp() и updatePlayer()  разные операции
- **Валидация:** TypeScript интерфейсы проверяют типы
- **Supabase RLS:** Row Level Security на уровне БД

---

## Структура БД (таблица players)

```sql
CREATE TABLE players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT UNIQUE NOT NULL,
  level INTEGER DEFAULT 1,
  xp INTEGER DEFAULT 0,
  total_quests_completed INTEGER DEFAULT 0,
  achievements_unlocked JSONB DEFAULT '[]'::jsonb,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  theme TEXT DEFAULT 'system',
  language TEXT DEFAULT 'ru',
  notifications_enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index для быстрого поиска по user_id
CREATE INDEX idx_players_user_id ON players(user_id);

-- Trigger для обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_players_updated_at
BEFORE UPDATE ON players
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
```

---

**Конец документации Player Service**

Этот сервис готов к работе. Для полноценного функционирования необходимо:
1. Настроить реальные Supabase credentials в .env
2. Создать таблицу players в Supabase с помощью SQL выше
3. Запустить сервис: `npm run dev`
4. Тестировать API через Postman или curl
