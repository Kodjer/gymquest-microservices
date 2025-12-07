// src/utils/levelCalculator.ts

// Константы для расчёта уровней
const XP_PER_LEVEL = 100;         // Сколько XP нужно для одного уровня

/**
 * Рассчитывает уровень игрока по его XP
 * Формула: level = floor(xp / 100) + 1
 * Примеры:
 *   0 XP  уровень 1
 *   99 XP  уровень 1
 *   100 XP  уровень 2
 *   250 XP  уровень 3
 */
export function calculateLevel(xp: number): number {
  // Math.floor округляет вниз
  // Например: floor(99 / 100) = floor(0.99) = 0
  // floor(150 / 100) = floor(1.5) = 1
  return Math.floor(xp / XP_PER_LEVEL) + 1;
}

/**
 * Рассчитывает сколько XP нужно до следующего уровня
 * Формула: XP_PER_LEVEL - (xp % XP_PER_LEVEL)
 * Примеры:
 *   25 XP  нужно ещё 75 XP до уровня 2
 *   100 XP  нужно ещё 100 XP до уровня 3
 *   150 XP  нужно ещё 50 XP до уровня 3
 */
export function calculateXpToNextLevel(xp: number): number {
  // xp % XP_PER_LEVEL - остаток от деления (сколько XP в текущем уровне)
  // Например: 25 % 100 = 25 (есть 25 XP в текущем уровне)
  // Нужно: 100 - 25 = 75 XP до следующего
  const currentLevelXp = xp % XP_PER_LEVEL;
  return XP_PER_LEVEL - currentLevelXp;
}

/**
 * Рассчитывает процент прогресса до следующего уровня
 * Формула: (xp % XP_PER_LEVEL) / XP_PER_LEVEL * 100
 * Примеры:
 *   25 XP  25% прогресса
 *   50 XP  50% прогресса
 *   99 XP  99% прогресса
 *   100 XP  0% прогресса (новый уровень начался)
 */
export function calculateProgressPercent(xp: number): number {
  const currentLevelXp = xp % XP_PER_LEVEL;
  // Math.round округляет до ближайшего целого
  // Например: 25.6  26
  return Math.round((currentLevelXp / XP_PER_LEVEL) * 100);
}

/**
 * Рассчитывает процент выполненных квестов
 * Формула: (completed / total) * 100
 * Если total = 0, возвращает 0 (избегаем деления на ноль)
 */
export function calculateCompletionRate(completedQuests: number, totalQuests: number): number {
  if (totalQuests === 0) return 0;
  return Math.round((completedQuests / totalQuests) * 100);
}
