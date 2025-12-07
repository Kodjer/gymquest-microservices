// src/models/Achievement.ts

export interface Achievement {
  id: string;
  name: string;
  description: string;
  icon: string;
  category: 'quest' | 'level' | 'streak' | 'special';
  requirement_type: 'quest_count' | 'level_reached' | 'streak_count' | 'xp_total' | 'custom';
  requirement_value: number;
  reward_xp: number;
  is_hidden: boolean;
  created_at?: string;
}

export interface UserAchievement {
  id: string;
  user_id: string;
  achievement_id: string;
  unlocked_at: string;
  progress?: number;
}

export interface AchievementProgress {
  achievement: Achievement;
  unlocked: boolean;
  progress: number;
  progress_percent: number;
  unlocked_at?: string;
}

export interface CheckAchievementsRequest {
  user_id: string;
  trigger: 'quest_completed' | 'level_up' | 'streak_updated' | 'manual';
}

export interface UnlockAchievementRequest {
  user_id: string;
  achievement_id: string;
}