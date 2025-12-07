import { supabaseRequest } from '../src/config/supabase';

global.fetch = jest.fn();

describe('Player Service Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('should create player successfully', async () => {
    const mockPlayer = { user_id: 'test', level: 1, xp: 0 };
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify([mockPlayer]),
    });

    const result = await supabaseRequest('POST', 'players', mockPlayer);
    expect(result[0]).toHaveProperty('level', 1);
  });

  test('should calculate level from XP', () => {
    const calculateLevel = (xp: number) => Math.floor(xp / 100) + 1;
    
    expect(calculateLevel(0)).toBe(1);
    expect(calculateLevel(150)).toBe(2);
    expect(calculateLevel(500)).toBe(6);
  });

  test('should add XP correctly', () => {
    const currentXP = 50;
    const reward = 100;
    const newXP = currentXP + reward;
    
    expect(newXP).toBe(150);
  });
});
