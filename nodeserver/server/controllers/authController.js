import Visitor from "../models/visitor";
import User from "../models/user";
import Message from "../models/message";

import MessageController from "./messageController";

import generateOTP from "../services/payoor/generateOTP";
import verifyOtp from "../services/payoor/verifyOtp";
import generateJWT from "../services/payoor/generateJWT";
import getValidUser from '../services/payoor/getValidUser';

import sendOtp from "../services/resend/sendOtp";

class AuthController {

    async getCurrentVisitorData(req, res) {
        try {
            const { visitorId } = req.query;

            const visitorData = await Visitor.findOne({ identifier: visitorId });

            if (visitorData) {
                const visitorMessages = await MessageController.getVisitorMessages(visitorData._id);

                const userdetails = {
                    username: visitorData.username,
                    messages: visitorMessages
                }

                res.status(200).send({ userdetails });
            }
        } catch (error) {
            console.log(error);
            res.status(500).send({ error });
        }
    }

    async getUnAuthenticatedMsg(req, res) {
        try {
            const { visitorId } = req.query;

            //const visitor = await Visitor.findOne({ identifier: visitorId })
            const visitor = new Visitor({ identifier: visitorId })

            const newPayoorMessage = new Message({
                content: `It appears you aren't logged in please log in using your email address`,
                visitor: visitor._id,
                isUser: false,
                isLoggedIn: false
            });

            await newPayoorMessage.save();

            res.status(200).send({
                username: 'Visitor',
                payoormessage: {
                    _id: newPayoorMessage._id,
                    msg: newPayoorMessage.content,
                    isUser: newPayoorMessage.isUser,
                    isLoggedIn: newPayoorMessage.isLoggedIn
                },
            });

        } catch (error) {
            console.log(error)
            res.status(500).send({ error });
        }
    }

    async generateOtp(req, res) {
        try {
            const { message, timestamp, isUser, isLoggedIn } = req.body;
            const { visitoridentifier } = req.query;

            const email = message;

            const otpcode = await generateOTP();

            const data = await sendOtp({
                email,
                otp: otpcode
            });

            const visitor = await Visitor.findOneAndUpdate(
                { identifier: visitoridentifier },
                {
                    $set: {
                        username: message,
                        email: message,
                        otp: otpcode
                    }
                },
                {
                    new: true,
                    upsert: true
                }
            );

            const newMessage = new Message({
                content: message,
                visitor: visitor._id,
                client_timestamp: timestamp,
                isUser,
                isLoggedIn
            });

            const newPayoorMessage = new Message({
                content: `I just sent an OTP to ${email}. Please check the email and send this OTP to me`,
                visitor: visitor._id,
                isUser: false,
                isLoggedIn
            });

            await newMessage.save();

            await newPayoorMessage.save();

            res.status(200).send({
                username: email,
                payoormessage: {
                    _id: newPayoorMessage._id,
                    msg: newPayoorMessage.content,
                    isUser: newPayoorMessage.isUser,
                    isLoggedIn
                },
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ error });
        }
    }

    async verifyOtp(req, res) {
        try {
            const { message, timestamp, isUser, isLoggedIn } = req.body;
            const { visitoridentifier } = req.query;

            const currentVisitor = await Visitor.findOne({ identifier: visitoridentifier });
            const visitorFromOtp = await verifyOtp({ otp: message, visitoridentifier });

            const newMessage = new Message({
                content: message,
                visitor: currentVisitor._id,
                client_timestamp: timestamp,
                isUser,
                isLoggedIn
            });

            await newMessage.save();

            if (visitorFromOtp) {
                const currentUser = await User.findOneAndUpdate(
                    { email: visitorFromOtp.email },
                    {
                        $set: {
                            email: currentVisitor.email,
                            isVerified: true,
                        }
                    },
                    {
                        new: true,
                        upsert: true
                    }
                );

                const hasUsername = currentUser && currentUser.username !== 'Visitor' ? true : false;

                const jwt = await generateJWT({ userid: currentUser._id });

                let newPayoorMessage;

                if (hasUsername) {
                    const visitorMessages = await Message.find({ visitor: currentVisitor._id });
                    const originalOrder = visitorMessages[0].content;
                    let content;

                    if (originalOrder) {
                        content = `Hello, ${currentUser.username}, would you like to proceed with your original order of \n${originalOrder}`;
                    } else {
                        content = `Hello, ${currentUser.username}. What orders do you want to make?`;
                    }

                    newPayoorMessage = new Message({
                        content: content,
                        visitor: visitorFromOtp._id,
                        isUser: false,
                        isLoggedIn
                    });
                } else {
                    newPayoorMessage = new Message({
                        content: `Your email has been confirmed. Please Tell me your name or how you wish to be addressed`,
                        visitor: visitorFromOtp._id,
                        isUser: false,
                        isLoggedIn
                    });
                }

                await newPayoorMessage.save();

                res.status(200).send({
                    username: currentVisitor.username,
                    hasUsername,
                    jwt: jwt && jwt.length ? jwt : "",
                    payoormessage: {
                        _id: newPayoorMessage._id,
                        msg: newPayoorMessage.content,
                        isUser: newPayoorMessage.isUser,
                        isLoggedIn
                    },
                });
            } else {
                console.log('visitorFromOtp', visitorFromOtp)
                res.status(500).send({ error });
            }

        } catch (error) {
            console.log(error);
            res.status(500).send({ error });
        }
    }

    async saveUserName(req, res) {
        try {
            const { message, timestamp, isUser, isLoggedIn } = req.body;
            const { jwt, visitoridentifier } = req.query;

            const { _id, email } = await getValidUser(jwt);

            if (_id && email) {
                const currentUser = await User.findOneAndUpdate(
                    { email },
                    {
                        $set: {
                            username: message,
                            isVerified: true,
                        }
                    },
                    {
                        new: true,
                        upsert: true
                    }
                );

                const newMessage = new Message({
                    content: message,
                    user: currentUser._id,
                    client_timestamp: timestamp,
                    isUser,
                    isLoggedIn: true
                });

                await newMessage.save();

                console.log(currentUser, newMessage);

                const currentVisitor = await Visitor.findOne({ identifier: visitoridentifier });
                let newPayoorMessage;
                let content;

                if (currentVisitor) {
                    const visitorMessages = await Message.find({ visitor: currentVisitor._id });
                    const originalOrder = visitorMessages[0].content;
                    content = `Hello, ${currentUser.username}, would you like to proceed with your original order of \n${originalOrder}`;

                } else {
                    content = `Hello, ${currentUser.username}. What orders do you want to make?`;
                }

                newPayoorMessage = new Message({
                    content,
                    user: currentUser._id,
                    isUser: false,
                    isLoggedIn: true
                });

                await newPayoorMessage.save();

                res.status(200).send({
                    username: currentUser.username,
                    payoormessage: {
                        _id: newPayoorMessage._id,
                        msg: newPayoorMessage.content,
                        isUser: newPayoorMessage.isUser,
                        isLoggedIn
                    },
                });
            } else {
                res.status(500).send({ error });
            }
        } catch (error) {
            console.log(error)
            res.status(500).send({ error });
        }
    }

    async getValidUser(req, res) {
        try {
            const { jwt } = req.query;

            const { _id, username, email } = await getValidUser(jwt);

            const visitorIdentity = await Visitor.find({ email });
            const latestVisitorIdentity = visitorIdentity[visitorIdentity.length - 1];
            const visitorMessages = await Message.find({ visitor: latestVisitorIdentity._id })
                .sort('-server_timestamp')
                .select('_id visitor isUser isLoggedIn content client_timestamp server_timestamp');
            const userMessages = await Message.find({ user: _id }).sort('server_timestamp')
                .sort('server_timestamp')
                .select('_id user isUser isLoggedIn content client_timestamp server_timestamp');

            const accountMessages = [...visitorMessages, ...userMessages];

            const hasUsername = username !== 'Visitor' ? true : false;

            if (_id) {
                res.status(200).send({
                    username: hasUsername ? username : email,
                    hasUsername,
                    jwt: jwt && jwt.length ? jwt : "",
                    accountMessages
                });
            }
        } catch (error) {
            console.log(error)
            res.status(404).send({ error });
        }
    }
}

export default new AuthController();