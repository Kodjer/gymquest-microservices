// src/controllers/leaderboardController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

export const getTopPlayers = async (req: Request, res: Response) => {
  try {
    // Получаем топ игроков из таблицы leaderboard
    const topPlayers = await supabaseRequest(
      "GET",
      "leaderboard",
      null,
      "?select=player_id,username,score,rank&order=rank.asc&limit=10"
    );

    if (!topPlayers || topPlayers.length === 0) {
      return res.json([]);
    }

    res.json(topPlayers);
  } catch (error: any) {
    console.error("Error in getTopPlayers:", error);
    res.status(500).json({ error: error.message });
  }
};

export const getPlayerRank = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    console.log(`[DEBUG] Getting player rank for ID: ${userId}`);

    // Получаем игрока из leaderboard
    const playerData = await supabaseRequest(
      "GET",
      "leaderboard",
      null,
      `?player_id=eq.${userId}&select=player_id,username,score,rank`
    );

    console.log(`[DEBUG] Supabase returned:`, playerData);

    if (!playerData || playerData.length === 0) {
      console.log(`[DEBUG] Player not found in leaderboard`);
      return res.status(404).json({ error: "Игрок не найден" });
    }

    console.log(`[DEBUG] Returning player:`, playerData[0]);
    res.json(playerData[0]);
  } catch (error: any) {
    console.error("Error in getPlayerRank:", error);
    res.status(500).json({ error: error.message });
  }
};

export const updatePlayerScore = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { xp, level } = req.body;

    // Обновляем игрока в базе данных
    const result = await supabaseRequest(
      "PATCH",
      "players",
      { xp, level },
      `?id=eq.${userId}`
    );

    res.status(200).json(result || { userId, xp, level });
  } catch (error: any) {
    console.error("Error in updatePlayerScore:", error);
    res.status(500).json({ error: error.message });
  }
};
