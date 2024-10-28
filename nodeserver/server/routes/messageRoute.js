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

import MessageController from "../controllers/messageController";

const messageRoute = express();

messageRoute.post('/message', async (req, res) => {
    try {
        const {
            message,
            userPhoneNumber,
            isUser,
            jwt,
            timestamp,
            inputType,
            isLoggedIn
        } = req.body;

        const messageValue = message;

        if (inputType === 'isPhonenumberInput') {
            const usernum = validatePhoneNumber(messageValue);

            if (usernum?.isValid && usernum.country === 'NG') {
                const pending = await createVerificationTest(usernum.formattedNumber);

                if (pending === 'pending') {
                    res.status(200).json({
                        message: "I sent you an OTP, please check your SMS and send it back to confirm you own this number",
                        type: "pendingotp",
                        token: ''
                    })
                } else {

                }
            }
        }

        if (inputType === 'isOtpInput') {
            const phoneNumber = (userPhoneNumber || '').trim();

            const usernum = validatePhoneNumber(phoneNumber);

            if (usernum?.isValid && usernum.country === 'NG') {
                const result = await createVerificationCheckTest(messageValue, usernum.formattedNumber);//{ status: "approved", number: usernum.formattedNumber }; // Consider awaiting actual verification

                if (result.status === "approved") {
                    const { token, user, isNewUser } = await generateJWT(phoneNumber);

                    if (user.username.length === 0 || user.username === 'Visitor' || isNewUser) {
                        res.status(200).json({
                            message: `Your number ${result.number} has been saved.\nPlease let us know your name`,
                            type: "receivedotp",
                            token: token,
                        });
                    } else {
                        const { username } = user;

                        res.status(200).json({
                            message: `Greetings ${username}, I'm here to accept your orders`,
                            type: "authenticated",
                            token: token,
                        });
                    }
                }
            }
        }

        if (inputType === 'isNameinput') {
            const username = message;

            const updatedUser = await saveUserName(username, jwt);

            if (updatedUser) {
                const { username, tokens } = updatedUser;
                const latestToken = tokens[tokens.length - 1]?.token;

                res.status(200).json({
                    message: `Greetings ${username}, I'm here to accept your orders`,
                    type: "authenticated",
                    token: latestToken,
                    username
                });
            }
        }

        if (inputType === 'isLoggedInInput') {
            const { _id, username, phoneNumber } = await getValidUser(jwt);

            if (_id === null) {
                res.status(200).json({
                    message: `Looks like you aren't signed in. Sign in with your phone number`,
                    type: "unauthenticated",
                    token: "",
                });
            } else {
                const messageId = await saveMessage({
                    message,
                    userPhoneNumber: phoneNumber,
                    isUser,
                    jwt,
                    timestamp,
                    inputType,
                    isLoggedIn
                });

                trackUnread(messageId);

                processRequest(messageId);

                res.status(200).json({
                    //message: `Hello ${username}, you're order is being processed`,
                    type: "orderconfirmation",
                    token: jwt,
                });
            }
        }

    } catch (error) {
        console.log(error);
    }
});

messageRoute.post('/message/visitor', MessageController.saveVisitorMessage);

export default messageRoute;