const Message = require("../../models/message");

import getPayloadFromToken from './getPayloadFromToken';

async function getConversation(jwt) {
    try {
        const payload = getPayloadFromToken(jwt);
        let page = 1;
        let limit = 20;

        const conversation = await Message.find({ user: payload._id })
            .sort('-timestamp')
            .skip((page - 1) * limit)
            .limit(limit)
            .populate('user', 'username');

        return conversation.reverse();
    } catch (error) {
        console.log(error);
        throw error;
    }
}

export default getConversation;