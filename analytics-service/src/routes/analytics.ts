import { Router } from "express";
import {
  getGlobalStats,
  getUserActivity,
  getTopPlayers,
  recordEvent,
} from "../controllers/analyticsController";

const router = Router();

router.get("/global", getGlobalStats);
router.get("/activity/:userId", getUserActivity);
router.get("/top", getTopPlayers);
router.post("/event", recordEvent);

export default router;
