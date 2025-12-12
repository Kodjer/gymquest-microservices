// src/controllers/achievementController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

// In-memory storage
const achievements: any[] = [];

export const getUserAchievements = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    console.log(
      `[GET] Looking for achievements for userId: ${userId}, total in memory: ${achievements.length}`
    );
    console.log("In memory:", achievements);
    const userAchs = achievements.filter((a) => a.user_id === userId);
    res.json(userAchs);
  } catch (error: any) {
    console.error("Error in getUserAchievements:", error);
    res.status(500).json({ error: error.message });
  }
};

export const checkAchievements = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;

    const players = await supabaseRequest(
      "GET",
      "players",
      null,
      `?user_id=eq.${userId}&select=*`
    );
    if (!players || players.length === 0) {
      return res.status(404).json({ error: "Игрок не найден" });
    }

    const player = players[0];
    const unlocked = [];

    const achievements = await supabaseRequest(
      "GET",
      "achievements",
      null,
      "?select=*"
    );
    const userAchievements = await supabaseRequest(
      "GET",
      "user_achievements",
      null,
      `?user_id=eq.${userId}&select=achievement_id`
    );
    const unlockedIds = new Set(
      userAchievements?.map((a: any) => a.achievement_id) || []
    );

    for (const achievement of achievements || []) {
      if (unlockedIds.has(achievement.id)) continue;

      let shouldUnlock = false;
      if (achievement.criteria_type === "quests_completed") {
        shouldUnlock =
          player.total_quests_completed >= achievement.criteria_value;
      } else if (achievement.criteria_type === "level") {
        shouldUnlock = player.level >= achievement.criteria_value;
      }

      if (shouldUnlock) {
        await supabaseRequest("POST", "user_achievements", {
          user_id: userId,
          achievement_id: achievement.id,
        });
        unlocked.push(achievement);
      }
    }

    res.json({ unlocked });
  } catch (error: any) {
    console.error("Error in checkAchievements:", error);
    res.status(500).json({ error: error.message });
  }
};

export const unlockAchievement = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { achievement_id } = req.body;

    const result = {
      id: Date.now().toString(),
      user_id: userId,
      achievement_id: achievement_id || "ach-" + Date.now(),
      unlocked_at: new Date().toISOString(),
    };

    console.log(`[POST] Unlocking for userId: ${userId}`);
    console.log("Pushing to memory:", result);
    achievements.push(result);
    console.log("Memory now has:", achievements.length);

    res.status(201).json(result);
  } catch (error: any) {
    console.error("Error in unlockAchievement:", error);
    res.status(500).json({ error: error.message });
  }
};
