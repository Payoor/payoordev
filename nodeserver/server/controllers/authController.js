const jwt = require('jsonwebtoken');

import Visitor from "../models/visitor";
import User from "../models/user";
import Message from "../models/message";
import EmailOtp from "../models/emailOtp";

import MessageController from "./authChatController";

import generateOTP from "../services/payoor/generateOTP";
import verifyOtp from "../services/payoor/verifyOtp";
import generateJWT from "../services/payoor/generateJWT";
import getValidUser from '../services/payoor/getValidUser';

import sendOtp from "../services/resend/sendOtp";

class AuthController {

    async generateOtp(req, res) {
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
            console.log(error)
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to send OTP',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }

    async verifyOtp(req, res) {
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
                        id: user._id
                    }
                };

                //console.log(response);

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
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to verify OTP',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }

    async handleSignUp(req, res) {
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
                            isVerified: user.isVerified
                        }
                    }
                };

                res.status(200).json(response);
            }
        } catch (error) {
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to create user',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }

    async generateJWT(req, res) {
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
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to create user',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }

    async getValidUser(req, res) {
        try {
            const { userId, tokenId } = req.authData;

            const validUser = await User.findOne({ _id: userId });

            if (validUser) {
                const userResponse = {
                    _id: validUser._id,
                    email: validUser.email,
                    name: validUser.name,
                    phoneNumber: validUser.phoneNumber
                };

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
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to create user',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }
}

export default new AuthController();