import { Server } from 'socket.io';

import corsOriginArray from './corsOriginArray';
import getValidUser from './services/payoor/getValidUser';

import Admin from './models/admin';

let io;

function initSocket(server) {
    io = new Server(server, {
        cors: {
            origin: corsOriginArray, // Ensure this variable is defined
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
                        socket.userId = 'admin';
                        next();
                    }
                });
            } else {
                const { _id } = await getValidUser(token);
                socket.userId = _id;
                next();
            }
        } catch (error) {
            next(new Error('Authentication error'));
        }
    });

    io.on('connection', socket => {
        console.log('New connection:', socket.id, 'User ID:', socket.userId);

        // Join the user to their specific room
        console.log(typeof `${socket.userId}`)
        socket.join(`${socket.userId}`);
        console.log('User joined room:', socket.userId);

        // Emit a confirmation to the client
        //socket.emit('authenticated', { userId: socket.userId });

        // Log rooms this socket is in
        console.log(`Socket ${socket.id} is in rooms:`, socket.rooms);

        socket.on('disconnect', () => {
            console.log('Disconnection:', socket.id, 'User ID:', socket.userId);
        });
    });
}

function getIO() {
    if (!io) {
        throw new Error('Socket.IO has not been initialized. Call initSocket first.');
    }
    return io;
}

export { initSocket, getIO };