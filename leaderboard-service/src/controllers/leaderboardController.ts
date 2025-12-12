// src/controllers/leaderboardController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

// In-memory storage
const players: any[] = [];

export const getTopPlayers = async (req: Request, res: Response) => {
  try {
    const sorted = [...players].sort((a, b) => b.xp - a.xp);
    res.json(sorted);
  } catch (error: any) {
    console.error("Error in getTopPlayers:", error);
    res.status(500).json({ error: error.message });
  }
};

export const getPlayerRank = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;

    const allPlayers = await supabaseRequest(
      "GET",
      "players",
      null,
      "?select=user_id,xp&order=xp.desc"
    );

    if (!allPlayers) {
      return res.status(404).json({ error: "Данные не найдены" });
    }

    const rank = allPlayers.findIndex((p: any) => p.user_id === userId) + 1;

    if (rank === 0) {
      return res.status(404).json({ error: "Игрок не найден" });
    }

    res.json({ user_id: userId, rank, total_players: allPlayers.length });
  } catch (error: any) {
    console.error("Error in getPlayerRank:", error);
    res.status(500).json({ error: error.message });
  }
};

export const updatePlayerScore = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { xp, level } = req.body;

    const existing = players.findIndex((p) => p.user_id === userId);

    const result = {
      user_id: userId,
      xp: xp || 0,
      level: level || 1,
      updated_at: new Date().toISOString(),
    };

    if (existing >= 0) {
      players[existing] = result;
    } else {
      players.push(result);
    }

    res.status(200).json(result);
  } catch (error: any) {
    console.error("Error in updatePlayerScore:", error);
    res.status(500).json({ error: error.message });
  }
};
