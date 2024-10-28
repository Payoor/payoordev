import Message from '../../models/message';
import User from '../../models/user';

import { getIO } from '../../socketInit';

async function processRequest(messageId) {
    try {
        const io = getIO();
        const messageItem = await Message.findOne({ _id: messageId });

        if (!messageItem) {
            console.log('Message not found');
            return;
        }

        const { user, isUser, content, timestamp } = messageItem;

        const validUser = await User.findOne({ _id: user });

        const { _id, username } = validUser

        console.log(typeof `${_id}`)

        const room = `${_id}`;
        console.log('Emitting to room:', room);

        if (!isUser) {
            io.to(room).emit('newmessage', { msg: { content, isUser, timestamp } });
        } else if (isUser) {
            io.to(`admin`).emit('newmessage', { msg: { content, isUser, timestamp, username, userid: _id } });
        }
        console.log('Emission completed');
    } catch (error) {
        console.error('Error in processRequest:', error);
    }
}

export default processRequest;