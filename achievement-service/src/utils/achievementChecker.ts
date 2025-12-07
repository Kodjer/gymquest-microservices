// src/utils/achievementChecker.ts
import { supabase } from '../config/supabase';
import { Achievement } from '../models/Achievement';

export const checkQuestAchievements = async (
  userId: string,
  totalQuests: number
): Promise<string[]> => {
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'quest_count');

  if (!achievements) return unlockedIds;

  for (const achievement of achievements) {
    if (totalQuests >= achievement.requirement_value) {
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        unlockedIds.push(achievement.id);
      }
    }
  }

  return unlockedIds;
};

export const checkLevelAchievements = async (
  userId: string,
  level: number
): Promise<string[]> => {
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'level_reached');

  if (!achievements) return unlockedIds;

  for (const achievement of achievements) {
    if (level >= achievement.requirement_value) {
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        unlockedIds.push(achievement.id);
      }
    }
  }

  return unlockedIds;
};

export const checkStreakAchievements = async (
  userId: string,
  streak: number
): Promise<string[]> => {
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'streak_count');

  if (!achievements) return unlockedIds;

  for (const achievement of achievements) {
    if (streak >= achievement.requirement_value) {
      const alreadyUnlocked = await isAchievementUnlocked(userId, achievement.id);
      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        unlockedIds.push(achievement.id);
      }
    }
  }

  return unlockedIds;
};

export const checkXpAchievements = async (
  userId: string,
  totalXp: number
): Promise<string[]> => {
  const unlockedIds: string[] = [];

  const { data: achievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('requirement_type', 'xp_total');

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

const isAchievementUnlocked = async (
  userId: string,
  achievementId: string
): Promise<boolean> => {
  const { data } = await supabase
    .from('user_achievements')
    .select('id')
    .eq('user_id', userId)
    .eq('achievement_id', achievementId)
    .single();

  return !!data;
};

const unlockAchievement = async (
  userId: string,
  achievementId: string
): Promise<void> => {
  await supabase.from('user_achievements').insert({
    user_id: userId,
    achievement_id: achievementId,
    unlocked_at: new Date().toISOString(),
  });
};

export const calculateProgress = (
  currentValue: number,
  requiredValue: number
): { progress: number; percent: number } => {
  const progress = Math.min(currentValue, requiredValue);
  const percent = Math.round((progress / requiredValue) * 100);
  return { progress, percent };
};