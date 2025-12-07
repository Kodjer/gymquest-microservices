import { Router } from 'express';
import { getGlobalStats, getUserActivity, getTopPlayers } from '../controllers/analyticsController';

const router = Router();

router.get('/global', getGlobalStats);
router.get('/activity/:userId', getUserActivity);
router.get('/top', getTopPlayers);

export default router;