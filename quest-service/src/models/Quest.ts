// src/models/Quest.ts

// Интерфейс описывает структуру квеста в базе данных
export interface Quest {
  id: string;                           // Уникальный идентификатор квеста (UUID)
  user_id: string;                      // ID пользователя, которому принадлежит квест
  title: string;                        // Название квеста (например, "Сделать зарядку")
  xp_reward: number;                    // Награда в XP (10, 25 или 50)
  difficulty: 'easy' | 'medium' | 'hard'; // Сложность квеста
  status: 'pending' | 'done';           // Статус: ожидает выполнения или выполнен
  created_at?: string;                  // Дата создания (автоматически)
  updated_at?: string;                  // Дата последнего обновления
}

// Интерфейс для создания нового квеста (без id, created_at)
export interface CreateQuestDto {
  user_id: string;
  title: string;
  xp_reward: number;
  difficulty: 'easy' | 'medium' | 'hard';
}

// Интерфейс для обновления квеста (все поля опциональны)
export interface UpdateQuestDto {
  title?: string;
  xp_reward?: number;
  difficulty?: 'easy' | 'medium' | 'hard';
  status?: 'pending' | 'done';
}
