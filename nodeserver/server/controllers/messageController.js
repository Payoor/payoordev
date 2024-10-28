import Message from "../models/message";
import Visitor from "../models/visitor";

class MessageController {

    async saveVisitorMessage(req, res) {
        try {
            const { message, isLoggedIn, isUser, username, timestamp, visitoridentifier } = req.body;

            const visitor = await Visitor.findOneAndUpdate(
                { identifier: visitoridentifier },
                {
                    $set: {
                        username,
                        identifier: visitoridentifier
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

            await newMessage.save();

            res.status(201).send({ visitorData: visitor })
        } catch (error) {
            console.log(error);
            res.status(500).send({ error });
        }
    }

    async getVisitorMessages(visitor) {
        const visitorMessages = await Message.find({ visitor }).sort({ client_timestamp: 1 });

        return visitorMessages;
    }

    async saveUserMessage(req, res) {

    }

    async saveAdminMessage(req, res) {

    }
}

export default new MessageController();
