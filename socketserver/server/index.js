if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

import "regenerator-runtime";
const express = require('express');
const app = express();
const server = require('http').createServer(app);
const mongoose = require('mongoose');
import cors from 'cors';

import PaymentController from './controllers/paymentController';

const PORT = process.env.PORT;

import corsOriginArray from './corsOriginArray';

const corsOptions = {
    origin: corsOriginArray,
    optionsSuccessStatus: 200,
};

import paymentRoute from './routes/paymentRoute';

app.use(cors(corsOptions));
app.use(express.json());

app.use(paymentRoute);

const io = require('socket.io')(server, {
    cors: {
        origin: corsOriginArray,
        methods: ["GET", "POST"],
        credentials: true
    }
});

io.on('connection', (socket) => {
    console.log('User connected:', socket.id);
});

server.listen(PORT, (error) => {
    if (error) {
        return console.error('Error starting server:', error);
    }

    console.log(`Socket started on port ${PORT}`);
});

app.post('/notify', (req, res) => {
    try {
        // Emit to all connected clients
        io.emit('notification', {
            message: 'New notification',
            data: req.body
        });

        res.status(200).json({ message: 'Notification sent' });
    } catch (error) {
        console.error('Error sending notification:', error);
        res.status(500).json({ error: 'Failed to send notification' });
    }
});

mongoose.connect(process.env.MONGO_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
    .then(() => {
        console.log(`database connection on ${process.env.MONGO_URL}`)
    })
    .catch((error) => {
        console.error('Error connecting to MongoDB:', error);
    });