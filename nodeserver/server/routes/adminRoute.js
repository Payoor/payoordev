import express from 'express';

import processRequest from '../services/payoor/processRequest';
import adminAuth from '../services/payoor/adminAuth';
import saveMessage from '../services/payoor/saveMessage';

import User from '../models/user';
import Admin from '../models/admin';
import Message from '../models/message';

const adminRoute = express();

adminRoute.post('/admin/create', async (req, res) => {
    const { username, password } = req.body;

    const newAdmin = new Admin({
        username,
        password
    });

    await newAdmin.save();

    res.status(200).json({ newAdmin });
});

adminRoute.post('/admin/authenticate', async (req, res) => {
    const { username, password } = req.body;

    try {
        const admin = await Admin.findByCredentials(username, password);

        if (admin) {
            // Assuming you're using JWT for authentication
            const token = await admin.generateAuthToken();

            console.log('Admin logged in:', admin);

            res.status(200).json({
                message: 'Authentication successful',
                admin: {
                    id: admin._id,
                    username: admin.username,
                    // Add any other non-sensitive admin details you want to send
                },
                token
            });
        } else {
            console.log('Invalid login credentials')
            // This else block might not be necessary if findByCredentials throws an error for invalid credentials
            res.status(401).json({ message: 'Invalid login credentials' });
        }
    } catch (error) {
        console.error('Login failed:', error);
        res.status(400).json({ message: 'An error occurred during authentication', error: error.message });
    }
});

adminRoute.get('/admin/getusers', adminAuth, async (req, res) => {
    const users = await User.find();

    // console.log(users);
    res.status(200).json(users);
});

adminRoute.get('/admin/getuser', adminAuth, async (req, res) => {
    const { user_id } = req.query;

    const user = await User.find({ _id: user_id });

    // console.log(user);
})

adminRoute.get('/admin/getconversation', adminAuth, async (req, res) => {
    const { id } = req.query;

    console.log(id);

    let page = 1;
    let limit = 20;

    const conversation = await Message.find({ user: id })
        .sort('-timestamp')
        .skip((page - 1) * limit)
        .limit(limit)
        .populate('user', 'username');

    res.status(200).send({ conversation: conversation.reverse() });
});

adminRoute.post('/admin/message', adminAuth, async (req, res) => {
    try {
        const { content, isUser, isAdmin, isLoggedIn, timestamp, userid, user } = req.body;

        const messageId = await saveMessage({
            message: content,
            isUser,
            timestamp,
            isLoggedIn,
            isAdmin,
            userid
        });

        processRequest(messageId);

        res.status(200).json({
            message: `Message sent to ${user.username}`,
            type: "adminmessage",
        });
    } catch (error) {
        console.log(error);
    }
});

adminRoute.get('/admin/getuserunreadstate', adminAuth, async (req, res) => {
    try {
        const { userid } = req.query;

        const useritem = await User.findById({ _id: userid });

        const { unreadMessages } = useritem;

        res.status(200).json({ unreadMessages, userid });
    } catch (error) {
        console.log(error);
    }
});

adminRoute.post('/admin/setmessagesread', adminAuth, async (req, res) => {
    try {
        const { userid } = req.query;

        const updatedUser = await User.findByIdAndUpdate(
            userid,
            { $set: { unreadMessages: [] } },
            { new: true, useFindAndModify: false }
        );

        if (!updatedUser) {
            console.log('User not found');
            return null;
        }

        res.status(200).json({ updatedUser });

    } catch (error) {
        console.log(error);
    }
});

adminRoute.delete('/admin/deleteallusers', adminAuth, async (req, res) => {
    try {
        const result = await User.deleteMany({});

        res.status(200).json({
            message: "All users deleted successfully",
            deletedCount: result.deletedCount
        });
    } catch (error) {
        console.error('Error deleting users:', error);
        res.status(500).json({ error: "An error occurred while deleting users" });
    }
});


export default adminRoute;