import mongoose from 'mongoose';

import User from '../../models/user';
import Message from '../../models/message';

import { getIO } from '../../socketInit';

async function trackUnread(messageId) {
    try {
        const io = getIO();
        const messageItem = await Message.findById({ _id: messageId });

        if (messageItem) {
            const { user } = messageItem;

            const messageObjectId = new mongoose.Types.ObjectId(messageId);

            const updatedUser = await User.findByIdAndUpdate(
                user,
                { $push: { unreadMessages: messageObjectId } },
                { new: true, useFindAndModify: false }
            );

            if (!updatedUser) {
                console.log('User not found');
                return null;
            }

            console.log('Unread message added successfully');
            console.log(updatedUser);
            io.to(`admin`).emit('updateunread', { userid: user });
            return updatedUser;
        }
    } catch (error) {
        console.log(error)
    }
}

export default trackUnread;