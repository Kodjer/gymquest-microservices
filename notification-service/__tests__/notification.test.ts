import { supabaseRequest } from '../src/config/supabase';

global.fetch = jest.fn();

describe('Notification Service Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('should create notification', async () => {
    const mockNotification = { user_id: 'test', message: 'Test notification', is_read: false };
    
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify([mockNotification]),
    });

    const result = await supabaseRequest('POST', 'notifications', mockNotification);
    expect(result[0]).toHaveProperty('message', 'Test notification');
  });

  test('should mark notification as read', async () => {
    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify([{ is_read: true }]),
    });

    const result = await supabaseRequest('PATCH', 'notifications', { is_read: true }, '?id=eq.1');
    expect(result[0].is_read).toBe(true);
  });

  test('should filter unread notifications', () => {
    const notifications = [
      { id: '1', is_read: false },
      { id: '2', is_read: true },
      { id: '3', is_read: false }
    ];
    const unread = notifications.filter(n => !n.is_read);
    
    expect(unread).toHaveLength(2);
  });
});
