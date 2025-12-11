import { Router } from 'express';
import { getTopPlayers, getPlayerRank } from '../controllers/leaderboardController';

const router = Router();

router.get('/', getTopPlayers);
router.get('/rank/:userId', getPlayerRank);

export default router;