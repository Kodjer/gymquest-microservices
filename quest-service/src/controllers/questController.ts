// src/controllers/questController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

export const getQuests = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { status } = req.query;

    let query = `?user_id=eq.${userId}&select=*`;
    if (status) {
      query += `&status=eq.${status}`;
    }

    const data = await supabaseRequest("GET", "quests", null, query);
    res.json(data || []);
  } catch (error: any) {
    console.error("Error in getQuests:", error);
    res.status(500).json({ error: error.message });
  }
};

export const createQuest = async (req: Request, res: Response) => {
  try {
    const questData = {
      ...req.body,
      status: "pending",
      created_at: new Date().toISOString(),
    };
    const data = await supabaseRequest("POST", "quests", questData);
    res.status(201).json(data[0]);
  } catch (error: any) {
    console.error("Error in createQuest:", error);
    res.status(500).json({ error: error.message });
  }
};

export const updateQuest = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const updates = req.body;
    const data = await supabaseRequest(
      "PATCH",
      "quests",
      updates,
      `?id=eq.${id}`
    );

    if (!data || data.length === 0) {
      return res.status(404).json({ error: "Квест не найден" });
    }

    res.json(data[0]);
  } catch (error: any) {
    console.error("Error in updateQuest:", error);
    res.status(500).json({ error: error.message });
  }
};

export const deleteQuest = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await supabaseRequest("DELETE", "quests", null, `?id=eq.${id}`);
    res.status(204).send();
  } catch (error: any) {
    console.error("Error in deleteQuest:", error);
    res.status(500).json({ error: error.message });
  }
};

export const completeQuest = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const updates = {
      status: "done",
      completed_at: new Date().toISOString(),
    };
    const data = await supabaseRequest(
      "PATCH",
      "quests",
      updates,
      `?id=eq.${id}`
    );

    if (!data || data.length === 0) {
      return res.status(404).json({ error: "Квест не найден" });
    }

    res.json(data[0]);
  } catch (error: any) {
    console.error("Error in completeQuest:", error);
    res.status(500).json({ error: error.message });
  }
};

export const updateQuestStatus = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const data = await supabaseRequest(
      "PATCH",
      "quests",
      { status },
      `?id=eq.${id}`
    );
    res.json(data[0]);
  } catch (error: any) {
    console.error("Error in updateQuestStatus:", error);
    res.status(500).json({ error: error.message });
  }
};
