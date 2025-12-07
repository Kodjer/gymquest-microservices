export interface DailyStats {
  date: string;
  total_quests: number;
  completed_quests: number;
  active_users: number;
  total_xp_earned: number;
}

export interface UserStats {
  user_id: string;
  total_quests: number;
  completed_quests: number;
  total_xp: number;
  level: number;
  achievements_count: number;
  current_streak: number;
}

export interface GlobalStats {
  total_users: number;
  total_quests: number;
  total_achievements_unlocked: number;
  average_level: number;
  most_active_users: UserStats[];
}