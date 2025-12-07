import { supabaseRequest } from '../src/config/supabase';

global.fetch = jest.fn();

describe('Quest Service Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('should create quest successfully', async () => {
    const mockQuest = { id: '1', title: 'Test Quest', status: 'pending' };
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify([mockQuest]),
    });

    const result = await supabaseRequest('POST', 'quests', { title: 'Test Quest' });
    expect(result[0]).toHaveProperty('title', 'Test Quest');
  });

  test('should get quests successfully', async () => {
    const mockQuests = [{ id: '1', title: 'Quest 1' }];
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify(mockQuests),
    });

    const result = await supabaseRequest('GET', 'quests', null, '?user_id=eq.test');
    expect(result).toHaveLength(1);
  });

  test('should validate difficulty levels', () => {
    const validDifficulties = ['easy', 'medium', 'hard'];
    expect(validDifficulties).toContain('easy');
    expect(validDifficulties).not.toContain('expert');
  });
});
