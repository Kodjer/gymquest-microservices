import { Router } from 'express';
import { getTopPlayers, getPlayerRank } from '../controllers/leaderboardController';

const router = Router();

router.get('/leaderboard', getTopPlayers);
router.get('/leaderboard/rank/:userId', getPlayerRank);

export default router;