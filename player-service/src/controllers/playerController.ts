// src/controllers/playerController.ts
import { Request, Response } from 'express';
import { supabaseRequest } from '../config/supabase';
import { calculateLevel } from '../utils/levelCalculator';

export const getPlayer = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const data = await supabaseRequest('GET', 'players', null, `?user_id=eq.&select=*`);
    if (!data || data.length === 0) {
      return res.status(404).json({ error: 'Игрок не найден' });
    }
    res.json(data[0]);
  } catch (error: any) {
    console.error('Error in getPlayer:', error);
    res.status(500).json({ error: error.message });
  }
};

export const createPlayer = async (req: Request, res: Response) => {
  try {
    const playerData = {
      user_id: req.body.user_id,
      level: 1,
      xp: 0,
      total_quests_completed: 0
    };
    const data = await supabaseRequest('POST', 'players', playerData);
    res.status(201).json(data[0]);
  } catch (error: any) {
    console.error('Error in createPlayer:', error);
    res.status(500).json({ error: error.message });
  }
};

export const addXP = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { xp } = req.body;
    
    const existing = await supabaseRequest('GET', 'players', null, `?user_id=eq.&select=*`);
    if (!existing || existing.length === 0) {
      return res.status(404).json({ error: 'Игрок не найден' });
    }
    
    const player = existing[0];
    const newXP = player.xp + xp;
    const newLevel = calculateLevel(newXP);
    
    const updated = await supabaseRequest('PATCH', 'players', { 
      xp: newXP, 
      level: newLevel 
    }, `?user_id=eq.`);
    
    res.json(updated[0]);
  } catch (error: any) {
    console.error('Error in addXP:', error);
    res.status(500).json({ error: error.message });
  }
};