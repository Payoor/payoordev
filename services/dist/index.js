"use strict";

var _cors = _interopRequireDefault(require("cors"));
var _corsOriginArray = _interopRequireDefault(require("./corsOriginArray"));
var _socketio_util = require("./utils/socketio_util");
var _paymentRoute = _interopRequireDefault(require("./routes/paymentRoute"));
var _googleApiRoute = _interopRequireDefault(require("./routes/googleApiRoute"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}
var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http, {
  transports: ['websocket', 'polling']
});
var path = require('path');
console.log(process.env.NODE_ENV);
var corsOptions = {
  origin: function origin(_origin, callback) {
    var allowedOrigins = process.env.NODE_ENV === 'production' ? _corsOriginArray["default"].production : _corsOriginArray["default"].development;

    // Allow requests with no origin (like mobile apps, Postman, etc.)
    if (!_origin) return callback(null, true);
    if (allowedOrigins.indexOf(_origin) !== -1) {
      callback(null, true);
    } else {
      console.log('Blocked origin:', _origin, 'Current environment:', process.env.NODE_ENV);
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['POST', 'OPTIONS', 'GET', 'PATCH', 'DELETE'],
  allowedHeaders: ['Origin', 'X-Requested-With', 'Content-Type', 'Accept', 'Authorization'],
  credentials: true
};
app.use((0, _cors["default"])(corsOptions));
app.use(express["static"](path.join(__dirname, 'public')));
app.use(express.json());
(0, _socketio_util.initSocket)(io);
io.on('connection', function (socket) {
  console.log('A user connected');

  /*socket.on('chat message', (msg) => {
      console.log('Message received:', msg); 
      // Broadcast the message to all connected clients
      io.emit('chat message', msg);
  });*/

  // Handle client disconnection
  socket.on('disconnect', function () {
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

app.use(_paymentRoute["default"]);
app.use(_googleApiRoute["default"]);

// Start server
var PORT = process.env.PORT || 3031;
http.listen(PORT, function () {
  console.log("Server running on port ".concat(PORT));
});