import { Router } from "express";
import {
  getUserNotifications,
  createNotification,
  markAsRead,
} from "../controllers/notificationController";

const router = Router();

router.get("/:userId", getUserNotifications);
router.post("/", createNotification);
router.patch("/:id/read", markAsRead);

export default router;
