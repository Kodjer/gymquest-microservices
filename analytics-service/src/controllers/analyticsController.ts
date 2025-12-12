// src/controllers/analyticsController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

export const getGlobalStats = async (req: Request, res: Response) => {
  try {
    // Try to get real data, but provide mock data if DB is not ready
    let players, quests, userAchievements;

    try {
      players = await supabaseRequest("GET", "players", null, "?select=*");
      quests = await supabaseRequest("GET", "quests", null, "?select=*");
      userAchievements = await supabaseRequest(
        "GET",
        "user_achievements",
        null,
        "?select=*"
      );
    } catch (dbError: any) {
      // Return demo stats if DB has issues
      console.error("DB Error in getGlobalStats:", dbError.message);
      return res.json({
        total_users: 0,
        total_quests: 0,
        total_achievements_unlocked: 0,
        average_level: 0,
        status: "demo_mode",
      });
    }

    const avgLevel =
      players && players.length > 0
        ? players.reduce((sum: number, p: any) => sum + p.level, 0) /
          players.length
        : 0;

    res.json({
      total_users: players?.length || 0,
      total_quests: quests?.length || 0,
      total_achievements_unlocked: userAchievements?.length || 0,
      average_level: Math.round(avgLevel * 10) / 10,
    });
  } catch (error: any) {
    console.error("Error in getGlobalStats:", error);
    res.status(500).json({ error: error.message });
  }
};

export const getUserActivity = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { days = 7 } = req.query;

    const cutoffDate = new Date(
      Date.now() - Number(days) * 24 * 60 * 60 * 1000
    ).toISOString();
    const quests = await supabaseRequest(
      "GET",
      "quests",
      null,
      `?user_id=eq.${userId}&created_at=gte.${cutoffDate}&select=created_at,status`
    );

    const activity = quests?.reduce((acc: any, quest: any) => {
      const date = quest.created_at.split("T")[0];
      if (!acc[date]) acc[date] = { total: 0, completed: 0 };
      acc[date].total++;
      if (quest.status === "done") acc[date].completed++;
      return acc;
    }, {});

    res.json(activity || {});
  } catch (error: any) {
    console.error("Error in getUserActivity:", error);
    res.status(500).json({ error: error.message });
  }
};

export const getTopPlayers = async (req: Request, res: Response) => {
  try {
    const { limit = 10 } = req.query;

    try {
      const players = await supabaseRequest(
        "GET",
        "players",
        null,
        `?select=user_id,level,xp,total_quests_completed&order=xp.desc&limit=`
      );
      res.json(players || []);
    } catch (dbError: any) {
      // Return empty array if DB has issues
      console.error("DB Error in getTopPlayers:", dbError.message);
      res.json([]);
    }
  } catch (error: any) {
    console.error("Error in getTopPlayers:", error);
    res.status(500).json({ error: error.message });
  }
};

export const recordEvent = async (req: Request, res: Response) => {
  try {
    const eventData = {
      id: Date.now().toString(),
      user_id: req.body.user_id,
      event_type: req.body.event_type || "activity",
      event_data: req.body.event_data || {},
      created_at: new Date().toISOString(),
    };

    res.status(201).json(eventData);
  } catch (error: any) {
    console.error("Error in recordEvent:", error);
    res.status(500).json({ error: error.message });
  }
};
