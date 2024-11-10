import User from "../models/user";
import Message from "../models/message";
import Visitor from "../models/visitor";

class AuthChatController {

    async sendUserMessage(req, res) {
        try {
            console.log(req.body);

            const response = {
                success: true,
                data: {
                    message: 'Success response',
                    chatresponse: {
                        text: "this is an AI response",
                        isClient: false,
                        isRead: false,
                    }
                }
            };

            res.status(200).json(response);
        } catch (error) {
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to send chat',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }
}

export default new AuthChatController();
