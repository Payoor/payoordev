import express from 'express';
import AuthChatController from "../controllers/authChatController";
import { authenticate } from '../middleware/admin/auth';

const messageRoute = express();

messageRoute.get('/messages', authenticate, AuthChatController.getRoomMessages);

messageRoute.post('/message/user/send', AuthChatController.sendUserMessage);


export default messageRoute;
