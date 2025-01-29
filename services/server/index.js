if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const express = require('express');
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http, {
    transports: ['websocket', 'polling']
});
const path = require('path');
import cors from 'cors';

import corsOrginArray from './corsOriginArray';

import { initSocket } from './utils/socketio_util';

import paymentRoute from './routes/paymentRoute';
import googleApiRoute from './routes/googleApiRoute';

if (process.env.NODE_ENV !== 'production') {
    const corsOptions = {
        origin: process.env.NODE_ENV === 'production' ? corsOrginArray.production : corsOrginArray.development,
        optionsSuccessStatus: 200,
    };

    app.use(cors(corsOptions));
}

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

initSocket(io);


io.on('connection', (socket) => {
    console.log('A user connected');

    /*socket.on('chat message', (msg) => {
        console.log('Message received:', msg); 
        // Broadcast the message to all connected clients
        io.emit('chat message', msg);
    });*/

    // Handle client disconnection
    socket.on('disconnect', () => {
        console.log('User disconnected');
    });
});

/*setTimeout(() => {
    console.log('hey emit')
    io.emit('transaction.success', {
        reference: 'paymentData.reference',
        amount: 'paymentData.amount',
        status: 'success'
    });
}, 3000); */

app.use(paymentRoute);
app.use(googleApiRoute);

// Start server
const PORT = process.env.PORT || 3031;
http.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});