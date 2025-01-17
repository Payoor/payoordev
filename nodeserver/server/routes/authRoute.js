import express from 'express';

import verifyToken from "../services/payoor/verifyToken";

import AuthController from "../controllers/authController";

const authRoute = express();

authRoute.post('/auth/email/otp', AuthController.generateOtp);

authRoute.post('/auth/email/verify', AuthController.verifyOtp);

authRoute.post('/auth/signup', AuthController.handleSignUp);

authRoute.post('/auth/genjwt', AuthController.generateJWT);

authRoute.get('/auth/getvaliduser', verifyToken, AuthController.getValidUser);

authRoute.post('/auth/jwt/delete', verifyToken, AuthController.handleSignOut)

export default authRoute;