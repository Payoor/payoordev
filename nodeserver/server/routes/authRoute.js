import express from 'express';

import AuthController from "../controllers/authController";

const authRoute = express();

authRoute.post('/auth/email/otp', AuthController.generateOtp);

authRoute.post('/auth/email/verify', AuthController.verifyOtp);

authRoute.post('/auth/signup', AuthController.handleSignUp);

authRoute.post('/auth/genjwt', AuthController.generateJWT);

export default authRoute;   