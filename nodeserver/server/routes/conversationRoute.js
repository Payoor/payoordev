import express from 'express';

import Message from '../models/message';

import getConversation from '../services/payoor/getConversation';
import getPayloadFromToken from '../services/payoor/getPayloadFromToken';

const conversationRoute = express();

conversationRoute.get('/getconversation', async (req, res) => {
    const { jwt } = req.query;

    const conversation = await getConversation(jwt);

    res.status(200).send({ conversation });
});

conversationRoute.post('/saveconversation', async (req, res) => {
    try {
        const { jwt } = req.query;
        const body = req.body;

        if (!Array.isArray(body)) {
            return res.status(400).send({ message: 'Invalid input: body must be an array' });
        }

        console.log(body);

        const payload = getPayloadFromToken(jwt);

        const savePromises = body.map(msg => {
            const newMessage = new Message({
                user: payload._id,
                content: msg.message,
                userPhoneNumber: payload.phoneNumber,
                isUser: msg.isUser,
                isAdmin: !msg.isUser,
                isLoggedIn: msg.isLoggedIn,
                timestamp: msg.timestamp
            });

            return newMessage.save();
        });

        await Promise.all(savePromises);

        res.status(200).send({ message: 'All messages saved successfully' });
    } catch (error) {
        console.error('Error saving conversation:', error);
        res.status(500).send({ message: 'An error occurred while saving the conversation' });
    }
});

export default conversationRoute;