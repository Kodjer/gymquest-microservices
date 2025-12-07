import { Router } from 'express';
import { getUserNotifications, createNotification, markAsRead } from '../controllers/notificationController';

const router = Router();

router.get('/notifications/:userId', getUserNotifications);
router.post('/notifications', createNotification);
router.patch('/notifications/:id/read', markAsRead);

export default router;