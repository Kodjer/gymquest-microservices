export interface Notification {
  id: string;
  user_id: string;
  type: 'achievement' | 'quest' | 'level_up' | 'streak';
  title: string;
  message: string;
  read: boolean;
  created_at: string;
}