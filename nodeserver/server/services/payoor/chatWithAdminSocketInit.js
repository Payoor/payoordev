import { Server } from 'socket.io';

import corsOriginArray from '../../corsOriginArray';
import getValidUser from './getValidUser';

import Admin from '../../models/admin';
import Message from '../../models/message';
import Room from '../../models/room';

let io;
let connectedUsers = [];

function initSocket(server) {
    io = new Server(server, {
        cors: {
            origin: corsOriginArray,
            methods: ["GET", "POST"]
        }
    });

    io.use(async (socket, next) => {
        try {
            const token = socket.handshake.auth.token;
            const adminAuth = socket.handshake.auth.admin;

            if (!token) {
                return next(new Error('Authentication error'));
            }

            if (adminAuth) {
                Admin.findByToken(token).then(admin => {
                    if (admin) {
                        socket.isAdmin = true;
                        next();
                    }
                });
            } else {
                const user = await getValidUser(token);
                socket.user = user;
                next();
            }
        } catch (error) {
            next(new Error('Authentication error'));
        }
    });

    io.on('connection', socket => {

        let roomId;
        
        socket.on('createRoom', async() => {
            console.log('New connection:', socket.id, 'User ID:', socket.user?._id);

            // Users create their own rooms
            roomId = socket.user?._id;
            const existingRoom = await Room.findOne({ userid: roomId });
            if (!existingRoom) {
                await Room.create({
                    userid: roomId,
                    userphonenumber: socket.user?.phoneNumber,
                    socketid: socket.id,
                });
            } else {
                existingRoom.socketid = socket.id;
                existingRoom.updated_at = new Date();
                await existingRoom.save();
            }

            socket.join(`${roomId}`);
            console.log(`User ${socket.user?._id} joined room: ${roomId}`);
            console.log(`Socket ${socket.id} is in rooms:`, socket.rooms);

            if (!connectedUsers.find((user) => user.user._id === socket.user?._id)) {
                connectedUsers.push({user: socket.user, isOnline: true});
                io.emit('updateUserList', connectedUsers);
            }
        });

        if (socket.isAdmin) {
            io.emit('updateUserList', connectedUsers);
        }

        // Admin joins user room
        socket.on("joinRoom", async(data) => {
            const { userId } = data;
            const roomName = `${userId}`;
            if (socket.isAdmin) {
                socket.join(roomName);
                console.log(`Admin joined room: ${roomName}`);
                console.log(`Socket ${socket.id} is in rooms:`, socket.rooms);
            }
        });
        
        // Admin leaver user room
        socket.on("leaveRoom", (currentRoom) => {
            socket.leave(currentRoom);
            console.log(socket.id + ' left room ' + currentRoom);
        });

        // Handle typing events
        socket.on("userTyping", (roomId) => {
            io.to(roomId).emit("userTyping");
        });
        socket.on("userStopTyping", (roomId) => {
            io.to(roomId).emit("userStopTyping");
        });
        socket.on("adminTyping", (roomId) => {
            io.to(roomId).emit("adminTyping");
        });
        socket.on("adminStopTyping", (roomId) => {
            io.to(roomId).emit("adminStopTyping");
        });


        socket.on("sendMessage", async (data) => {
            const {text, clienttimestamp, sender, userId } = data;
            try {
                const message = await Message.create({
                    roomId: userId,
                    text,
                    clienttimestamp,
                    sender,
                });

                io.to(userId).emit("receiveMessage", message);
                console.log(`Message sent to room ${userId}:`, message);
            } catch (error) {
                console.error("Error sending message:", error);
            }
        });

        socket.on('disconnect', () => {
            console.log('Disconnection:', socket.id, 'User ID:', socket.user?._id ?? 'admin');

            connectedUsers = connectedUsers.filter((user) => user.user._id !== socket.user?._id);
            if (!socket.isAdmin) {
                io.emit('updateUserList', connectedUsers);
            }
        });
    });
}

export { initSocket };
