// src/controllers/notificationController.ts
import { Request, Response } from 'express';
import { supabaseRequest } from '../config/supabase';

export const getUserNotifications = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const data = await supabaseRequest('GET', 'notifications', null, `?user_id=eq.&select=*&order=created_at.desc`);
    res.json(data || []);
  } catch (error: any) {
    console.error('Error in getUserNotifications:', error);
    res.status(500).json({ error: error.message });
  }
};

export const createNotification = async (req: Request, res: Response) => {
  try {
    const notificationData = req.body;
    const data = await supabaseRequest('POST', 'notifications', notificationData);
    res.status(201).json(data[0]);
  } catch (error: any) {
    console.error('Error in createNotification:', error);
    res.status(500).json({ error: error.message });
  }
};

export const markAsRead = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const data = await supabaseRequest('PATCH', 'notifications', { is_read: true }, `?id=eq.`);
    res.json(data[0]);
  } catch (error: any) {
    console.error('Error in markAsRead:', error);
    res.status(500).json({ error: error.message });
  }
};