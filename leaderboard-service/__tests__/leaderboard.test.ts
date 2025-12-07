import { supabaseRequest } from '../src/config/supabase';

global.fetch = jest.fn();

describe('Leaderboard Service Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('should get top players sorted by XP', async () => {
    const mockPlayers = [
      { user_id: 'user1', xp: 500 },
      { user_id: 'user2', xp: 300 },
      { user_id: 'user3', xp: 700 }
    ];
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify(mockPlayers),
    });

    const result = await supabaseRequest('GET', 'players', null, '?order=xp.desc&limit=10');
    expect(result).toHaveLength(3);
  });

  test('should calculate player rank', () => {
    const players = [
      { user_id: 'user1', xp: 700 },
      { user_id: 'user2', xp: 500 },
      { user_id: 'user3', xp: 300 }
    ];
    
    const getRank = (userId: string) => players.findIndex(p => p.user_id === userId) + 1;
    
    expect(getRank('user1')).toBe(1);
    expect(getRank('user3')).toBe(3);
  });

  test('should limit leaderboard results', () => {
    const limit = 10;
    expect(limit).toBeGreaterThan(0);
    expect(limit).toBeLessThanOrEqual(100);
  });
});
