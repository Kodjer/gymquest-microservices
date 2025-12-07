import { supabaseRequest } from '../src/config/supabase';

global.fetch = jest.fn();

describe('Achievement Service Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('should check achievement criteria', () => {
    const checkAchievement = (completed: number, required: number) => completed >= required;
    
    expect(checkAchievement(10, 5)).toBe(true);
    expect(checkAchievement(3, 5)).toBe(false);
  });

  test('should get user achievements', async () => {
    const mockAchievements = [{ id: '1', title: 'First Quest' }];
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify(mockAchievements),
    });

    const result = await supabaseRequest('GET', 'user_achievements', null, '?user_id=eq.test');
    expect(result).toHaveLength(1);
  });

  test('should unlock achievement', async () => {
    const mockUnlock = { user_id: 'test', achievement_id: '1' };
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify([mockUnlock]),
    });

    const result = await supabaseRequest('POST', 'user_achievements', mockUnlock);
    expect(result[0]).toHaveProperty('achievement_id', '1');
  });
});
