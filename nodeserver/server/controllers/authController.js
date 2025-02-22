const jwt = require('jsonwebtoken');

import User from "../models/user";
import EmailOtp from "../models/emailOtp";
import JwtToken from "../models/jwttoken";

import generateOTP from "../services/payoor/generateOTP";
import generateJWT from "../services/payoor/generateJWT";

import sendOtp from "../services/resend/sendOtp";

import redisClient from "../configs/redisClient";

class AuthController {

    async generateOtp(req, res, next) {
        try {
            const { email } = req.body;

            const otpcode = await generateOTP();

            await EmailOtp.deleteMany({ email });

            const mailResponse = await sendOtp({
                email,
                otp: otpcode
            });

            const newEmailOtp = new EmailOtp({
                email,
                otp: otpcode
            });
            await newEmailOtp.save();

            const response = {
                success: true,
                data: {
                    email,
                    message: 'OTP sent successfully',
                    timestamp: new Date().toISOString(),
                    mailResponse
                }
            };

            res.status(200).json(response);
        } catch (error) {
            console.log('error here', error, 'error here');
            error.payoorDevErrorMessage = 'Failed to send OTP';
            next(error);
        }
    }

    async verifyOtp(req, res, next) {
        try {
            const { email, otp } = req.body;

            const user = await User.findOne({ email });
            let userExists = false;

            if (user) {
                userExists = true;
            }

            const isValid = await EmailOtp.findOne({
                email,
                otp,
                used: false
            });

            if (isValid) {
                if (isValid.isExpired()) {
                    const expiredResponse = {
                        success: false,
                        data: {
                            message: 'OTP has expired',
                            timestamp: new Date().toISOString(),
                            verified: false
                        }
                    };
                    return res.status(400).json(expiredResponse);
                }

                await EmailOtp.updateOne(
                    { email, otp },
                    {
                        $set: {
                            used: true,
                            verifiedAt: new Date()
                        }
                    }
                );

                const response = {
                    success: true,
                    data: {
                        email,
                        message: 'OTP verified successfully',
                        verified: true,
                        timestamp: new Date().toISOString(),
                        userExists,
                        id: user ? user._id : ""
                    }
                };

                res.status(200).json(response);
            } else {
                const invalidResponse = {
                    success: false,
                    data: {
                        message: 'Invalid OTP',
                        timestamp: new Date().toISOString(),
                        verified: false
                    }
                };

                res.status(400).json(invalidResponse);
            }
        } catch (error) {
            console.log('error here', error, 'error here');
            error.payoorDevErrorMessage = 'Failed to verify OTP';
            next(error);
        }
    }

    async handleSignUp(req, res, next) {
        try {
            const { name, email, phone, location, shoppingList } = req.body;

            const existingUser = await User.findOne({ email });

            if (existingUser) {
                const duplicateResponse = {
                    success: false,
                    data: {
                        message: 'User with this email already exists',
                        timestamp: new Date().toISOString(),
                    }
                };

                return res.status(400).json(duplicateResponse);
            } else {
                const user = new User({
                    name,
                    email,
                    phoneNumber: phone,
                    location,
                    shoppingList,
                    isVerified: true
                });

                await user.save();

                const user_data_redis_store = `userdata:${user._id.toString()}`;

                let userData = {
                    _id: user._id.toString(),
                    email: user.email,
                    name: user.name,
                    phoneNumber: user.phoneNumber,
                    userAddress: user.location,
                };

                await redisClient.hSet(
                    user_data_redis_store,
                    JSON.parse(JSON.stringify(userData))
                );

                await redisClient.expire(user_data_redis_store, 86400);

                userData = await redisClient.hGetAll(user_data_redis_store);

                console.log(userData, 'userData here signup')

                const response = {
                    success: true,
                    data: {
                        message: 'User created successfully',
                        timestamp: new Date().toISOString(),
                        user: {
                            id: user._id,
                            name: user.name,
                            email: user.email,
                            phoneNumber: user.phoneNumber,
                            location: user.location,
                            userAddress: user.location,
                            isVerified: user.isVerified
                        }
                    }
                };

                res.status(200).json(response);
            }
        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to create user';
            next(error);
        }
    }

    async generateJWT(req, res, next) {
        try {
            const { id } = req.query;

            const token = await generateJWT({ userid: id });

            const response = {
                success: true,
                data: {
                    message: 'JWT generated successfully',
                    token
                }
            };

            res.status(200).json(response);
        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to generate jwt';
            next(error);
        }
    }

    async getValidUser(req, res, next) {
        try {
            const { userId, tokenId } = req.authData;

            const validUser = await User.findOne({ _id: userId });

            //console.log(req.session)
            //console.log(req.session.user)
            //console.log("=========session=========")

            //console.log('Session ID:', req.sessionID);

            if (validUser) {
                //console.log(validUser, 'validUser')
                const userResponse = {
                    _id: validUser._id,
                    email: validUser.email,
                    name: validUser.name,
                    phoneNumber: validUser.phoneNumber,
                    userAddress: validUser.location
                };

                console.log(userResponse, 'userResponse')

                //console.log(userResponse, 'userResponse')

                const user_data_redis_store = `userdata:${validUser._id.toString()}`;


                let userData = {
                    _id: validUser._id.toString(),
                    email: validUser.email,
                    name: validUser.name,
                    phoneNumber: validUser.phoneNumber,
                    userAddress: validUser.location,
                };

                await redisClient.hSet(
                    user_data_redis_store,
                    JSON.parse(JSON.stringify(userData))
                );

                if (validUser.completed_orders) {
                    await redisClient.set(
                        `${user_data_redis_store}:completed_orders`,
                        validUser.completed_orders
                    );
                } else {
                    await redisClient.set(
                        `${user_data_redis_store}:completed_orders`,
                        0
                    );
                }

                await redisClient.expire(user_data_redis_store, 86400);

                userData = await redisClient.hGetAll(user_data_redis_store);

                //console.log(userData, 'userData here')

                //console.log(userResponse)

                const response = {
                    success: true,
                    data: {
                        message: 'User found',
                        user: userResponse
                    }
                };

                //console.log(response);

                res.status(200).json(response);
            } else {
                const notFoundResponse = {
                    success: false,
                    data: {
                        message: 'User not found',
                        timestamp: new Date().toISOString()
                    }
                };

                res.status(404).json(notFoundResponse);
            }
        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to retrieve user';
            next(error);
        }
    }

    async handleSignOut(req, res, next) {
        try {
            const { userId, tokenId } = req.authData;

            const token = await JwtToken.findById(tokenId);

            if (!token) {
                const errorResponse = {
                    success: false,
                    data: {
                        message: 'Token not found',
                        timestamp: new Date().toISOString()
                    }
                };

                return res.status(404).json(errorResponse);
            }

            token.isRevoked = true;
            await token.save();

            const response = {
                success: true,
                data: {
                    message: 'Successfully signed out',
                    timestamp: new Date().toISOString()
                }
            };

            res.status(200).json(response);
        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to signout user';
            next(error);
        }
    }
}

export default new AuthController();