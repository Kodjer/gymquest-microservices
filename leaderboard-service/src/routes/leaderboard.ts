import { Router } from "express";
import {
  getTopPlayers,
  getPlayerRank,
  updatePlayerScore,
} from "../controllers/leaderboardController";

const router = Router();

router.get("/", getTopPlayers);
router.get("/rank/:userId", getPlayerRank);
router.post("/update/:userId", updatePlayerScore);

export default router;
