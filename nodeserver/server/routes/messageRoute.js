import express from 'express';

import validatePhoneNumber from '../services/payoor/validatePhoneNumber';
import createVerificationTest from '../services/payoor/test/createVerification';
import createVerificationCheckTest from '../services/payoor/test/createVerificationCheck';
import generateJWT from '../services/payoor/generateJWT';
import saveUserName from '../services/payoor/saveUserName';
import getValidUser from '../services/payoor/getValidUser';
import saveMessage from '../services/payoor/saveMessage';
import processRequest from '../services/payoor/processRequest';
import trackUnread from '../services/payoor/trackUnread';

import AuthChatController from "../controllers/authChatController";

const messageRoute = express();

messageRoute.post('/message/user/send', AuthChatController.sendUserMessage);


export default messageRoute;