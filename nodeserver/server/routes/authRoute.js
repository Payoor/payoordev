import express from 'express';

import AuthController from "../controllers/authController";

const authRoute = express();

authRoute.get('/auth/getvaliduser', AuthController.getValidUser);

authRoute.get('/auth/getunauthmsg', AuthController.getUnAuthenticatedMsg);

authRoute.get('/auth/getvisitor', AuthController.getCurrentVisitorData);

authRoute.post('/auth/email', AuthController.generateOtp);

authRoute.post('/auth/otp', AuthController.verifyOtp);

authRoute.post('/auth/name', AuthController.saveUserName);

export default authRoute;  