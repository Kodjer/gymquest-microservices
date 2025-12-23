// src/controllers/notificationController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

export const getUserNotifications = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;

    // Получаем уведомления из БД
    const userNotifs = await supabaseRequest(
      "GET",
      "notifications",
      null,
      `?user_id=eq.${userId}&order=created_at.desc`
    );

    res.json(userNotifs || []);
  } catch (error: any) {
    console.error("Error in getUserNotifications:", error);
    res.status(500).json({ error: error.message });
  }
};

export const createNotification = async (req: Request, res: Response) => {
  try {
    const notificationData = {
      user_id: req.body.user_id,
      title: req.body.title || req.body.type || "Уведомление",
      message: req.body.message,
      type: req.body.type || "info",
      read: false,
      created_at: new Date().toISOString(),
    };

    // Сохраняем в БД
    const saved = await supabaseRequest(
      "POST",
      "notifications",
      notificationData
    );

    res.status(201).json(saved || notificationData);
  } catch (error: any) {
    console.error("Error in createNotification:", error);
    res.status(500).json({ error: error.message });
  }
};

export const markAsRead = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const data = await supabaseRequest(
      "PATCH",
      "notifications",
      { is_read: true },
      `?id=eq.${id}`
    );
    res.json(data[0]);
  } catch (error: any) {
    console.error("Error in markAsRead:", error);
    res.status(500).json({ error: error.message });
  }
};
