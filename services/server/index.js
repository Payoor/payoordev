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

import corsOriginArray from './corsOriginArray';

import { initSocket } from './utils/socketio_util';

import paymentRoute from './routes/paymentRoute';
import googleApiRoute from './routes/googleApiRoute';


console.log(process.env.NODE_ENV);

const corsOptions = {
  origin: function (origin, callback) {
      const allowedOrigins = process.env.NODE_ENV === 'production' 
          ? corsOriginArray.production 
          : corsOriginArray.development;
      
      // Allow requests with no origin (like mobile apps, Postman, etc.)
      if (!origin) return callback(null, true);
      
      if (allowedOrigins.indexOf(origin) !== -1) {
          callback(null, true);
      } else {
          console.log('Blocked origin:', origin, 'Current environment:', process.env.NODE_ENV);
          callback(new Error('Not allowed by CORS'));
      }
  },
  methods: ['POST', 'OPTIONS', 'GET', 'PATCH', 'DELETE'],
  allowedHeaders: [
      'Origin',
      'X-Requested-With',
      'Content-Type',
      'Accept',
      'Authorization'
  ],
  credentials: true
};

app.use(cors(corsOptions));

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