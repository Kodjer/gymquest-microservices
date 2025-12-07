# Achievement Service - Подробное объяснение кода

## Обзор микросервиса

Achievement Service (Сервис достижений)  это микросервис для управления системой достижений в приложении GymQuest. Этот сервис отвечает за:
- Хранение и получение всех доступных достижений
- Проверку условий разблокировки достижений
- Отслеживание прогресса пользователей
- Автоматическую разблокировку при выполнении условий
- Расчёт процента выполнения для каждого достижения

## Структура проекта

```
achievement-service/
 src/
    config/                    # Конфигурация
       supabase.ts           # Подключение к БД
    models/                    # TypeScript интерфейсы
       Achievement.ts        # Модели достижений
    utils/                     # Вспомогательные функции
       achievementChecker.ts # Логика проверки
    controllers/               # Бизнес-логика
       achievementController.ts
    routes/                    # API маршруты
       achievements.ts
    server.ts                  # Главный файл сервера
 .env                           # Переменные окружения
 package.json                   # Зависимости проекта
 tsconfig.json                  # Конфигурация TypeScript
```

---

## 1. Файл: src/models/Achievement.ts

### Назначение
TypeScript интерфейсы для типизации данных достижений.

### Построчное объяснение

```typescript
// src/models/Achievement.ts
```

```typescript
export interface Achievement {
```
**export interface Achievement**  основной интерфейс достижения
- Описывает структуру объекта достижения
- Соответствует таблице `achievements` в БД

```typescript
  id: string;
```
**id: string**  уникальный идентификатор достижения
- UUID формат
- Первичный ключ в БД
- Пример: "ach_first_quest", "ach_level_10"

```typescript
  name: string;
```
**name: string**  название достижения
- Отображается пользователю
- Пример: "Первый шаг", "Мастер тренировок"

```typescript
  description: string;
```
**description: string**  описание достижения
- Подробности о том, как получить
- Пример: "Выполните свой первый квест"

```typescript
  icon: string;
```
**icon: string**  иконка достижения
- Может быть emoji или URL изображения
- Пример: "", "", ""

```typescript
  category: 'quest' | 'level' | 'streak' | 'special';
```
**category**  категория достижения
- **quest**  связано с квестами
- **level**  связано с уровнями
- **streak**  связано с сериями
- **special**  особые достижения

```typescript
  requirement_type: 'quest_count' | 'level_reached' | 'streak_count' | 'xp_total' | 'custom';
```
**requirement_type**  тип требования для разблокировки
- **quest_count**  количество выполненных квестов
- **level_reached**  достигнутый уровень
- **streak_count**  длина серии
- **xp_total**  общий накопленный XP
- **custom**  пользовательское условие

```typescript
  requirement_value: number;
```
**requirement_value: number**  пороговое значение
- Для quest_count: количество квестов (например, 10)
- Для level_reached: уровень (например, 5)
- Для streak_count: дни серии (например, 7)
- Для xp_total: общий XP (например, 1000)

```typescript
  reward_xp: number;
```
**reward_xp: number**  награда в XP за разблокировку
- Бонусный опыт при получении достижения
- Мотивирует игроков открывать достижения

```typescript
  is_hidden: boolean;
```
**is_hidden: boolean**  скрытое ли достижение
- **true**  не показывается пока не разблокировано
- **false**  видно всем игрокам
- Создаёт эффект сюрприза

```typescript
  created_at?: string;
```
**created_at?: string**  дата создания достижения
- Опциональное поле
- ISO 8601 формат

```typescript
}
```

---

```typescript
export interface UserAchievement {
```
**interface UserAchievement**  связь игрока с достижением
- Хранит информацию о разблокированных достижениях
- Таблица `user_achievements` в БД

```typescript
  id: string;
```
ID записи (первичный ключ)

```typescript
  user_id: string;
```
**user_id: string**  идентификатор пользователя
- Связь с таблицей players

```typescript
  achievement_id: string;
```
**achievement_id: string**  ID разблокированного достижения
- Связь с таблицей achievements
- Foreign key

```typescript
  unlocked_at: string;
```
**unlocked_at: string**  дата и время разблокировки
- Когда игрок получил достижение
- Используется для отображения в хронологическом порядке

```typescript
  progress?: number;
```
**progress?: number**  текущий прогресс (опционально)
- Для достижений с частичным выполнением
- Пример: выполнено 7 из 10 квестов

```typescript
}
```

---

```typescript
export interface AchievementProgress {
```
**interface AchievementProgress**  прогресс достижения для пользователя
- Комбинирует данные достижения и прогресс игрока
- Используется в API ответах

```typescript
  achievement: Achievement;
```
**achievement: Achievement**  полная информация о достижении
- Вложенный объект Achievement

```typescript
  unlocked: boolean;
```
**unlocked: boolean**  разблокировано ли достижение
- true  игрок получил это достижение
- false  ещё не получено

```typescript
  progress: number;
```
**progress: number**  текущее значение прогресса
- Абсолютное число (5 квестов, 3 уровень и т.д.)

```typescript
  progress_percent: number;
```
**progress_percent: number**  процент выполнения
- От 0 до 100
- Для отображения прогресс-баров

```typescript
  unlocked_at?: string;
```
**unlocked_at?: string**  когда разблокировано (если unlocked = true)
- Опциональное, т.к. заполняется только для разблокированных

```typescript
}
```

---

```typescript
export interface CheckAchievementsRequest {
```
**interface CheckAchievementsRequest**  запрос на проверку достижений
- Тело POST запроса к /api/achievements/check

```typescript
  user_id: string;
```
**user_id: string**  ID пользователя для проверки

```typescript
  trigger: 'quest_completed' | 'level_up' | 'streak_updated' | 'manual';
```
**trigger**  событие, вызвавшее проверку
- **quest_completed**  после завершения квеста
- **level_up**  после повышения уровня
- **streak_updated**  после обновления серии
- **manual**  ручная проверка всех достижений

```typescript
}
```

---

```typescript
export interface UnlockAchievementRequest {
```
**interface UnlockAchievementRequest**  запрос на разблокировку (не используется в текущей реализации)

```typescript
  user_id: string;
  achievement_id: string;
}
```

---

## 2. Файл: src/utils/achievementChecker.ts

### Назначение
Функции для проверки условий достижений и автоматической разблокировки.

### Построчное объяснение

```typescript
// src/utils/achievementChecker.ts
import { supabase } from '../config/supabase';
import { Achievement } from '../models/Achievement';
```

---

### Функция 1: checkQuestAchievements

```typescript
export const checkQuestAchievements = async (
  userId: string,
  totalQuests: number
): Promise<string[]> => {
```
**checkQuestAchievements**  проверка достижений за количество квестов
- **userId**  ID игрока
- **totalQuests**  сколько квестов выполнено
- **Promise<string[]>**  возвращает массив ID разблокированных достижений

```typescript
  const unlockedIds: string[] = [];
```
**unlockedIds**  массив для сохранения ID новых достижений
- Начинаем с пустого массива

```typescript
  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'quest_count');
```
**Запрос к БД:**
- Получаем все достижения типа 'quest_count'
- Только те, что связаны с количеством квестов
- Пример: "Выполните 10 квестов", "Выполните 50 квестов"

```typescript
  if (!achievements) return unlockedIds;
```
**Защита от пустого результата**
- Если достижений нет, возвращаем пустой массив

```typescript
  for (const achievement of achievements) {
```
**Цикл по всем достижениям**
- Проверяем каждое достижение отдельно

```typescript
    if (totalQuests >= achievement.requirement_value) {
```
**Проверка условия:**
- Если игрок выполнил достаточно квестов
- Пример: totalQuests = 15, requirement_value = 10  true

```typescript
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
```
**Проверка, не получено ли уже:**
- Избегаем повторной разблокировки
- Вызываем вспомогательную функцию

```typescript
      if (!alreadyUnlocked) {
```
Если ещё НЕ разблокировано:

```typescript
        await unlockAchievement(userId, achievement.id);
```
**Разблокировать достижение:**
- Создаём запись в user_achievements
- Добавляем временную метку

```typescript
        unlockedIds.push(achievement.id);
```
Добавляем ID в список разблокированных

```typescript
      }
    }
  }

  return unlockedIds;
};
```
Возвращаем массив ID новых достижений

---

### Функция 2: checkLevelAchievements

```typescript
export const checkLevelAchievements = async (
  userId: string,
  level: number
): Promise<string[]> => {
```
**checkLevelAchievements**  проверка достижений за уровень
- Аналогична checkQuestAchievements, но для уровней

```typescript
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'level_reached');
```
**Получаем достижения типа 'level_reached'**
- Пример: "Достигните 5 уровня", "Достигните 20 уровня"

```typescript
  if (!achievements) return unlockedIds;

  for (const achievement of achievements) {
    if (level >= achievement.requirement_value) {
```
**Проверка уровня:**
- Пример: level = 7, requirement_value = 5  true

```typescript
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        unlockedIds.push(achievement.id);
      }
    }
  }

  return unlockedIds;
};
```

---

### Функция 3: checkStreakAchievements

```typescript
export const checkStreakAchievements = async (
  userId: string,
  streak: number
): Promise<string[]> => {
```
**checkStreakAchievements**  проверка достижений за серии

```typescript
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'streak_count');
```
**Получаем достижения типа 'streak_count'**
- Пример: "Серия 7 дней", "Серия 30 дней"

```typescript
  if (!achievements) return unlockedIds;

  for (const achievement of achievements) {
    if (streak >= achievement.requirement_value) {
```
**Проверка серии:**
- Пример: streak = 10, requirement_value = 7  true

```typescript
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        unlockedIds.push(achievement.id);
      }
    }
  }

  return unlockedIds;
};
```

---

### Функция 4: checkXpAchievements

```typescript
export const checkXpAchievements = async (
  userId: string,
  totalXp: number
): Promise<string[]> => {
```
**checkXpAchievements**  проверка достижений за общий XP

```typescript
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'xp_total');
```
**Получаем достижения типа 'xp_total'**
- Пример: "Заработайте 1000 XP", "Заработайте 10000 XP"

```typescript
  if (!achievements) return unlockedIds;

  for (const achievement of achievements) {
    if (totalXp >= achievement.requirement_value) {
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        unlockedIds.push(achievement.id);
      }
    }
  }

  return unlockedIds;
};
```

---

### Вспомогательная функция: isAchievementUnlocked

```typescript
const isAchievementUnlocked = async (
  userId: string,
  achievementId: string
): Promise<boolean> => {
```
**isAchievementUnlocked**  проверить, разблокировано ли уже достижение
- Не экспортируется (приватная функция)
- Возвращает boolean

```typescript
  const { data } = await supabase
    .from('user_achievements')
    .select('id')
    .eq('user_id', userId)
    .eq('achievement_id', achievementId)
    .single();
```
**Запрос к таблице user_achievements:**
- Ищем запись с user_id И achievement_id
- .single()  ожидаем максимум одну запись
- Если нет записи, data будет null

```typescript
  return !!data;
```
**return !!data**  двойное отрицание для boolean
- **!data**  если data = null, то true
- **!!data**  если data = null, то false; если data = объект, то true
- Элегантный способ конвертации в boolean

```typescript
};
```

---

### Вспомогательная функция: unlockAchievement

```typescript
const unlockAchievement = async (
  userId: string,
  achievementId: string
): Promise<void> => {
```
**unlockAchievement**  разблокировать достижение для пользователя
- Приватная функция
- Promise<void>  ничего не возвращает

```typescript
  await supabase.from('user_achievements').insert({
    user_id: userId,
    achievement_id: achievementId,
    unlocked_at: new Date().toISOString(),
  });
```
**Вставка записи в БД:**
- **user_id**  кому разблокировано
- **achievement_id**  какое достижение
- **unlocked_at**  текущая дата и время в ISO формате
- **new Date().toISOString()**  "2025-12-04T19:06:30.123Z"

```typescript
};
```

---

### Функция: calculateProgress

```typescript
export const calculateProgress = (
  currentValue: number,
  requiredValue: number
): { progress: number; percent: number } => {
```
**calculateProgress**  рассчитать прогресс в абсолютных и процентных значениях
- **currentValue**  текущее значение (5 квестов)
- **requiredValue**  требуемое значение (10 квестов)
- Возвращает объект с двумя полями

```typescript
  const progress = Math.min(currentValue, requiredValue);
```
**progress**  текущий прогресс, не больше требуемого
- **Math.min()**  берём меньшее из двух
- Если выполнено 15 квестов, а нужно 10, progress = 10 (не 15)
- Защита от перевыполнения в процентах

```typescript
  const percent = Math.round((progress / requiredValue) * 100);
```
**percent**  процент выполнения
- **(progress / requiredValue)**  доля (0.0 - 1.0)
- ** 100**  в проценты (0 - 100)
- **Math.round()**  округление до целого

```typescript
  return { progress, percent };
};
```
Возвращаем объект с обоими значениями

**Пример:**
```typescript
calculateProgress(7, 10)  // { progress: 7, percent: 70 }
calculateProgress(15, 10) // { progress: 10, percent: 100 }
calculateProgress(3, 10)  // { progress: 3, percent: 30 }
```

---

## 3. Файл: src/controllers/achievementController.ts

### Назначение
Контроллеры (обработчики) для API endpoints достижений.

### Построчное объяснение

```typescript
// src/controllers/achievementController.ts
import { Request, Response } from 'express';
import { supabase } from '../config/supabase';
import {
  Achievement,
  AchievementProgress,
  CheckAchievementsRequest,
} from '../models/Achievement';
import {
  checkQuestAchievements,
  checkLevelAchievements,
  checkStreakAchievements,
  checkXpAchievements,
  calculateProgress,
} from '../utils/achievementChecker';
```

---

### Контроллер 1: getAllAchievements

```typescript
export const getAllAchievements = async (req: Request, res: Response) => {
```
**getAllAchievements**  получить все доступные достижения
- Публичный endpoint (не требует аутентификации)
- Показывает все достижения (кроме скрытых, если нужно)

```typescript
  try {
    const { data, error } = await supabase
      .from('achievements')
      .select('*')
      .order('category', { ascending: true });
```
**Запрос к БД:**
- Выбрать все достижения
- Сортировать по категории (quest, level, streak, special)
- **ascending: true**  по возрастанию (A-Z)

```typescript
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    res.json(data);
```
Отправить массив достижений клиенту

```typescript
  } catch (error) {
    res.status(500).json({ error: 'Не удалось получить достижения' });
  }
};
```

---

### Контроллер 2: getUserAchievements

```typescript
export const getUserAchievements = async (req: Request, res: Response) => {
```
**getUserAchievements**  получить прогресс достижений конкретного пользователя
- Показывает все достижения с прогрессом
- Отмечает разблокированные

```typescript
  try {
    const { userId } = req.params;
```
Извлекаем userId из URL (например, /api/achievements/user123)

```typescript
    // Получить все достижения
    const { data: allAchievements, error: achievementsError } = await supabase
      .from('achievements')
      .select('*');
```
**Шаг 1: получить список всех достижений**

```typescript
    if (achievementsError) {
      return res.status(500).json({ error: achievementsError.message });
    }
```

```typescript
    // Получить разблокированные достижения пользователя
    const { data: userAchievements, error: userError } = await supabase
      .from('user_achievements')
      .select('*')
      .eq('user_id', userId);
```
**Шаг 2: получить разблокированные достижения игрока**
- Таблица user_achievements
- Фильтр по user_id

```typescript
    if (userError) {
      return res.status(500).json({ error: userError.message });
    }
```

```typescript
    // Получить статистику игрока
    const { data: player } = await supabase
      .from('players')
      .select('*')
      .eq('user_id', userId)
      .single();
```
**Шаг 3: получить статистику игрока**
- Нужна для расчёта прогресса
- total_quests_completed, level, current_streak, xp

```typescript
    if (!player) {
      return res.status(404).json({ error: 'Игрок не найден' });
    }
```

```typescript
    // Формируем прогресс для каждого достижения
    const progress: AchievementProgress[] = allAchievements.map((achievement) => {
```
**Шаг 4: объединить данные**
- Для каждого достижения создаём объект AchievementProgress
- .map()  трансформация массива

```typescript
      const userAch = userAchievements?.find(
        (ua) => ua.achievement_id === achievement.id
      );
```
**Найти, разблокировано ли это достижение:**
- .find()  ищет первый элемент, удовлетворяющий условию
- Если не найдено, userAch = undefined

```typescript
      let currentValue = 0;
      switch (achievement.requirement_type) {
```
**Определить текущее значение прогресса в зависимости от типа:**

```typescript
        case 'quest_count':
          currentValue = player.total_quests_completed;
          break;
```
Для достижений за квесты берём total_quests_completed

```typescript
        case 'level_reached':
          currentValue = player.level;
          break;
```
Для достижений за уровень берём level

```typescript
        case 'streak_count':
          currentValue = player.current_streak;
          break;
```
Для достижений за серию берём current_streak

```typescript
        case 'xp_total':
          currentValue = player.xp;
          break;
```
Для достижений за XP берём xp

```typescript
      }
```

```typescript
      const { progress: prog, percent } = calculateProgress(
        currentValue,
        achievement.requirement_value
      );
```
**Рассчитать прогресс:**
- currentValue  текущее значение игрока
- requirement_value  требуемое значение
- Получаем progress и percent

```typescript
      return {
        achievement,
        unlocked: !!userAch,
        progress: prog,
        progress_percent: percent,
        unlocked_at: userAch?.unlocked_at,
      };
```
**Формируем объект AchievementProgress:**
- **achievement**  полная информация о достижении
- **unlocked**  true если userAch существует
- **progress**  абсолютное значение
- **progress_percent**  процент
- **unlocked_at**  дата разблокировки (если есть)
- **?.**  optional chaining (безопасный доступ)

```typescript
    });

    res.json(progress);
```
Отправляем массив прогресса клиенту

```typescript
  } catch (error) {
    res.status(500).json({ error: 'Не удалось получить прогресс достижений' });
  }
};
```

---

### Контроллер 3: checkAchievements

```typescript
export const checkAchievements = async (req: Request, res: Response) => {
```
**checkAchievements**  проверить и автоматически разблокировать достижения
- Главная функция сервиса
- Вызывается после важных событий

```typescript
  try {
    const { user_id, trigger }: CheckAchievementsRequest = req.body;
```
**Извлечь данные из body:**
- user_id  кого проверяем
- trigger  какое событие произошло

```typescript
    // Получить данные игрока
    const { data: player } = await supabase
      .from('players')
      .select('*')
      .eq('user_id', user_id)
      .single();

    if (!player) {
      return res.status(404).json({ error: 'Игрок не найден' });
    }
```
Получаем статистику игрока для проверки

```typescript
    let unlockedIds: string[] = [];
```
Массив для ID новых достижений

```typescript
    // Проверяем достижения в зависимости от триггера
    switch (trigger) {
```
**switch**  выбор действия на основе trigger

```typescript
      case 'quest_completed':
        const questIds = await checkQuestAchievements(
          user_id,
          player.total_quests_completed
        );
        unlockedIds.push(...questIds);
        break;
```
**Триггер: quest_completed**
- Проверяем только достижения за квесты
- **...questIds**  spread operator (разворачивает массив)
- Пример: unlockedIds = [], questIds = ['id1', 'id2']  unlockedIds = ['id1', 'id2']

```typescript
      case 'level_up':
        const levelIds = await checkLevelAchievements(user_id, player.level);
        unlockedIds.push(...levelIds);
        break;
```
**Триггер: level_up**
- Проверяем только достижения за уровни

```typescript
      case 'streak_updated':
        const streakIds = await checkStreakAchievements(
          user_id,
          player.current_streak
        );
        unlockedIds.push(...streakIds);
        break;
```
**Триггер: streak_updated**
- Проверяем только достижения за серии

```typescript
      case 'manual':
        // Проверяем все типы достижений
        const [questUnlocked, levelUnlocked, streakUnlocked, xpUnlocked] =
          await Promise.all([
            checkQuestAchievements(user_id, player.total_quests_completed),
            checkLevelAchievements(user_id, player.level),
            checkStreakAchievements(user_id, player.current_streak),
            checkXpAchievements(user_id, player.xp),
          ]);
```
**Триггер: manual**
- Проверяем ВСЕ типы достижений
- **Promise.all()**  выполнить все промисы параллельно
- Массив деструктуризация  каждый результат в свою переменную

```typescript
        unlockedIds.push(
          ...questUnlocked,
          ...levelUnlocked,
          ...streakUnlocked,
          ...xpUnlocked
        );
        break;
```
Добавляем все разблокированные ID

```typescript
    }
```

```typescript
    // Получить информацию о разблокированных достижениях
    let unlockedAchievements: Achievement[] = [];
    if (unlockedIds.length > 0) {
      const { data } = await supabase
        .from('achievements')
        .select('*')
        .in('id', unlockedIds);

      unlockedAchievements = data || [];
    }
```
**Получить полную информацию о новых достижениях:**
- **.in('id', unlockedIds)**  WHERE id IN ('id1', 'id2', ...)
- SQL: SELECT * FROM achievements WHERE id IN (...)

```typescript
    res.json({
      message: `Проверено достижений: ${unlockedIds.length} разблокировано`,
      unlocked_count: unlockedIds.length,
      unlocked_achievements: unlockedAchievements,
    });
```
**Ответ клиенту:**
- Сообщение
- Количество разблокированных
- Массив достижений с полной информацией

```typescript
  } catch (error) {
    res.status(500).json({ error: 'Не удалось проверить достижения' });
  }
};
```

---

### Контроллер 4: createAchievement

```typescript
export const createAchievement = async (req: Request, res: Response) => {
```
**createAchievement**  создать новое достижение (admin функция)

```typescript
  try {
    const achievementData = req.body;
```
Получаем данные нового достижения из body

```typescript
    const { data, error } = await supabase
      .from('achievements')
      .insert(achievementData)
      .select()
      .single();
```
**Вставить в БД:**
- .insert()  добавить запись
- .select()  вернуть созданную запись
- .single()  ожидаем одну запись

```typescript
    if (error) {
      return res.status(500).json({ error: error.message });
    }

    res.status(201).json(data);
```
**201 Created**  стандартный код для успешного создания
- Возвращаем созданное достижение

```typescript
  } catch (error) {
    res.status(500).json({ error: 'Не удалось создать достижение' });
  }
};
```

---

## 4. Файл: src/routes/achievements.ts

### Назначение
Определение API маршрутов для достижений.

### Построчное объяснение

```typescript
// src/routes/achievements.ts
import { Router } from 'express';
import {
  getAllAchievements,
  getUserAchievements,
  checkAchievements,
  createAchievement,
} from '../controllers/achievementController';

const router = Router();
```

```typescript
// GET /api/achievements - получить все достижения
router.get('/', getAllAchievements);
```
**GET /**
- Базовый путь: /api/achievements
- Полный путь: GET /api/achievements
- Возвращает все достижения

```typescript
// GET /api/achievements/:userId - получить прогресс достижений пользователя
router.get('/:userId', getUserAchievements);
```
**GET /:userId**
- Полный путь: GET /api/achievements/user123
- userId из URL попадает в req.params
- Возвращает прогресс для конкретного игрока

```typescript
// POST /api/achievements/check - проверить и разблокировать достижения
router.post('/check', checkAchievements);
```
**POST /check**
- Полный путь: POST /api/achievements/check
- Body: { user_id, trigger }
- Проверяет и разблокирует достижения

```typescript
// POST /api/achievements - создать новое достижение (admin)
router.post('/', createAchievement);
```
**POST /**
- Полный путь: POST /api/achievements
- Body: данные нового достижения
- Создаёт достижение в БД

```typescript
export default router;
```

---

## 5. Файл: src/server.ts

### Назначение
Главный файл сервера Express.

### Построчное объяснение

```typescript
// src/server.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import achievementRoutes from './routes/achievements';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3003;
```
**PORT = 3003**  уникальный порт для Achievement Service

```typescript
app.use(cors());
app.use(express.json());
```
Middleware для CORS и парсинга JSON

```typescript
app.use('/api/achievements', achievementRoutes);
```
**Монтирование роутов:**
- Префикс /api/achievements
- router.get('/')  GET /api/achievements
- router.get('/:userId')  GET /api/achievements/:userId
- router.post('/check')  POST /api/achievements/check

```typescript
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'Achievement Service',
    port: PORT
  });
});
```
Health check endpoint

```typescript
app.listen(PORT, () => {
  console.log(` Achievement Service запущен на порту ${PORT}`);
  console.log(` API доступен по адресу: http://localhost:${PORT}/api/achievements`);
  console.log(` Health check: http://localhost:${PORT}/health`);
});
```
Запуск сервера с информационными сообщениями

---

## Поток работы сервиса

### Сценарий: Игрок выполнил квест

1. **Quest Service** завершает квест
2. **Quest Service** вызывает Player Service: `POST /api/player/:userId/xp`
3. **Player Service** увеличивает total_quests_completed
4. **Player Service** вызывает Achievement Service: `POST /api/achievements/check`
   ```json
   {
     "user_id": "user123",
     "trigger": "quest_completed"
   }
   ```

5. **Achievement Service** получает запрос в checkAchievements()
6. Загружает данные игрока из БД (total_quests_completed)
7. Вызывает checkQuestAchievements()
8. Проходит по всем достижениям типа 'quest_count'
9. Проверяет каждое: `totalQuests >= requirement_value`
10. Для подходящих проверяет isAchievementUnlocked()
11. Если не разблокировано, вызывает unlockAchievement()
12. Добавляет запись в user_achievements
13. Собирает ID всех новых достижений
14. Загружает полную информацию о них
15. Возвращает ответ:
    ```json
    {
      "message": "Проверено достижений: 2 разблокировано",
      "unlocked_count": 2,
      "unlocked_achievements": [
        {
          "id": "ach_first_quest",
          "name": "Первый шаг",
          "description": "Выполните первый квест",
          "reward_xp": 50
        },
        {
          "id": "ach_10_quests",
          "name": "Новичок",
          "description": "Выполните 10 квестов",
          "reward_xp": 100
        }
      ]
    }
    ```

---

## Структура БД

### Таблица: achievements

```sql
CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT DEFAULT '',
  category TEXT NOT NULL CHECK (category IN ('quest', 'level', 'streak', 'special')),
  requirement_type TEXT NOT NULL CHECK (requirement_type IN ('quest_count', 'level_reached', 'streak_count', 'xp_total', 'custom')),
  requirement_value INTEGER NOT NULL,
  reward_xp INTEGER DEFAULT 0,
  is_hidden BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_achievements_category ON achievements(category);
CREATE INDEX idx_achievements_type ON achievements(requirement_type);
```

### Таблица: user_achievements

```sql
CREATE TABLE user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL REFERENCES players(user_id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMPTZ DEFAULT NOW(),
  progress INTEGER DEFAULT 0,
  UNIQUE(user_id, achievement_id)
);

CREATE INDEX idx_user_achievements_user ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_achievement ON user_achievements(achievement_id);
```

### Примеры достижений

```sql
INSERT INTO achievements (name, description, icon, category, requirement_type, requirement_value, reward_xp) VALUES
('Первый шаг', 'Выполните свой первый квест', '', 'quest', 'quest_count', 1, 50),
('Новичок', 'Выполните 10 квестов', '', 'quest', 'quest_count', 10, 100),
('Ветеран', 'Выполните 50 квестов', '', 'quest', 'quest_count', 50, 500),
('Уровень 5', 'Достигните 5 уровня', '', 'level', 'level_reached', 5, 200),
('Уровень 10', 'Достигните 10 уровня', '', 'level', 'level_reached', 10, 500),
('Серия 3', 'Тренируйтесь 3 дня подряд', '', 'streak', 'streak_count', 3, 150),
('Серия 7', 'Тренируйтесь неделю подряд', '', 'streak', 'streak_count', 7, 300),
('1000 XP', 'Заработайте 1000 опыта', '', 'special', 'xp_total', 1000, 200);
```

---

## Ключевые концепции

### 1. Триггеры (Triggers)
- **quest_completed**  оптимизация: проверяем только quest_count
- **level_up**  проверяем только level_reached
- **streak_updated**  проверяем только streak_count
- **manual**  проверяем все (используется редко)

### 2. Защита от дубликатов
- UNIQUE constraint в БД: (user_id, achievement_id)
- Проверка isAchievementUnlocked() перед разблокировкой
- Игрок не может получить достижение дважды

### 3. Прогресс-трекинг
- Для каждого достижения рассчитывается текущий прогресс
- Показывается процент выполнения
- Мотивирует игрока продолжать

### 4. Reward XP
- При разблокировке достижения игрок получает бонусный XP
- Это создаёт положительную обратную связь
- Можно реализовать автоматическое начисление через webhook

---

## Интеграция с другими сервисами

```

  Quest Service  
    (port 3001)  

          Квест завершён
         

 Player Service  
    (port 3002)  

          Проверить достижения
         

 Achievement Service  
     (port 3003)      

```

**Конец документации Achievement Service**