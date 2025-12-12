// src/controllers/notificationController.ts
import { Request, Response } from "express";
import { supabaseRequest } from "../config/supabase";

// In-memory storage
const notifications: any[] = [];

export const getUserNotifications = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const userNotifs = notifications.filter((n) => n.user_id === userId);
    res.json(userNotifs);
  } catch (error: any) {
    console.error("Error in getUserNotifications:", error);
    res.status(500).json({ error: error.message });
  }
};

export const createNotification = async (req: Request, res: Response) => {
  try {
    const notificationData = {
      id: "notif-" + Date.now(),
      user_id: req.body.user_id,
      message: req.body.message,
      type: req.body.type || "info",
      is_read: false,
      created_at: new Date().toISOString(),
    };

    notifications.push(notificationData);

    res.status(201).json(notificationData);
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
