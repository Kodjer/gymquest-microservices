// src/controllers/playerController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";
import { calculateLevel } from "../utils/levelCalculator";

export const getPlayer = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    console.log(`[DEBUG] Getting player with ID: ${userId}`);

    // Получаем игрока из Supabase
    const players = await supabaseRequest(
      "GET",
      "players",
      null,
      `?id=eq.${userId}&select=*`
    );

    console.log(`[DEBUG] Supabase returned:`, JSON.stringify(players));

    if (!players || players.length === 0) {
      return res.status(404).json({ error: "Игрок не найден" });
    }

    res.json(players[0]);
  } catch (error: any) {
    console.error("Error in getPlayer:", error);
    res.status(500).json({ error: error.message });
  }
};

export const createPlayer = async (req: Request, res: Response) => {
  try {
    const playerData = {
      id: req.body.user_id || "player-" + Date.now(),
      username: req.body.username || "Player",
      level: 1,
      xp: 0,
      total_quests_completed: 0,
      created_at: new Date().toISOString(),
    };

    res.status(201).json(playerData);
  } catch (error: any) {
    console.error("Error in createPlayer:", error);
    res.status(500).json({ error: error.message });
  }
};

export const addXP = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { xp } = req.body;

    const newXP = 500 + xp;
    const newLevel = calculateLevel(newXP);

    res.json({
      id: userId,
      username: `Player${userId.slice(0, 4)}`,
      xp: newXP,
      level: newLevel,
      total_quests_completed: 10,
    });
  } catch (error: any) {
    console.error("Error in addXP:", error);
    res.status(500).json({ error: error.message });
  }
};
