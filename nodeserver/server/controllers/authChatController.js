import Message from "../models/message";

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

    async getRoomMessages(req, res, next) {
        try {
            const { roomId } = req.query;

            const messages = await Message.find({roomId: roomId});

            const data = {
                message: 'Messages retrieved',
                messages: messages,
            }

            res.status(200).json({
                success: true,
                data
            });

        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to retrieve messages';
            next(error);
        }
    }
}

export default new AuthChatController();
