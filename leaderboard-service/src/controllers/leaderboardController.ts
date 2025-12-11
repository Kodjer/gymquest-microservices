// src/controllers/leaderboardController.ts
import { Request, Response } from 'express';
import { supabaseRequest } from '../config/supabase';

export const getTopPlayers = async (req: Request, res: Response) => {
  try {
    const { limit = 100 } = req.query;
    
    try {
      const players = await supabaseRequest('GET', 'players', null, `?select=user_id,level,xp,total_quests_completed&order=xp.desc&limit=`);
      res.json(players || []);
    } catch (dbError) {
      // Return empty leaderboard if DB has issues
      res.json([]);
    }
  } catch (error: any) {
    console.error('Error in getTopPlayers:', error);
    res.status(500).json({ error: error.message });
  }
};

export const getPlayerRank = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    
    const allPlayers = await supabaseRequest('GET', 'players', null, '?select=user_id,xp&order=xp.desc');
    
    if (!allPlayers) {
      return res.status(404).json({ error: 'Данные не найдены' });
    }
    
    const rank = allPlayers.findIndex((p: any) => p.user_id === userId) + 1;
    
    if (rank === 0) {
      return res.status(404).json({ error: 'Игрок не найден' });
    }
    
    res.json({ user_id: userId, rank, total_players: allPlayers.length });
  } catch (error: any) {
    console.error('Error in getPlayerRank:', error);
    res.status(500).json({ error: error.message });
  }
};