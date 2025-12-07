// src/models/Player.ts

// Интерфейс игрока в базе данных
export interface Player {
  id?: string;                    // UUID игрока (опционально, генерируется БД)
  user_id: string;                // Уникальный ID пользователя
  level: number;                  // Текущий уровень игрока
  xp: number;                     // Текущий опыт (XP)
  total_quests: number;           // Общее количество созданных квестов
  completed_quests: number;       // Количество выполненных квестов
  sound_enabled: boolean;         // Включены ли звуки
  created_at?: string;            // Дата создания профиля
  updated_at?: string;            // Дата последнего обновления
}

// Интерфейс для создания нового игрока
export interface CreatePlayerDto {
  user_id: string;
  sound_enabled?: boolean;        // По умолчанию true
}

// Интерфейс для обновления настроек игрока
export interface UpdatePlayerDto {
  sound_enabled?: boolean;
}

// Интерфейс для добавления XP
export interface AddXpDto {
  xp: number;                     // Сколько XP добавить (может быть отрицательным)
}

// Интерфейс статистики игрока (для ответа клиенту)
export interface PlayerStats {
  user_id: string;
  level: number;
  xp: number;
  xp_to_next_level: number;       // Сколько XP до следующего уровня
  progress_percent: number;       // Процент прогресса до следующего уровня
  total_quests: number;
  completed_quests: number;
  completion_rate: number;        // Процент выполненных квестов
}
