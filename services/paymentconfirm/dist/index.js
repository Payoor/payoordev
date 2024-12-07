"use strict";

var _cors = _interopRequireDefault(require("cors"));
var _corsOriginArray = _interopRequireDefault(require("./corsOriginArray"));
var _socketio_util = require("./utils/socketio_util");
var _paymentController = _interopRequireDefault(require("./controllers/paymentController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}
var express = require('express');
var app = express();
var http = require('http').createServer(app);
var io = require('socket.io')(http);
var path = require('path');
var corsOptions = {
  origin: _corsOriginArray["default"],
  optionsSuccessStatus: 200
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

app.post('/paystack/payment-response', _paymentController["default"].handlePayStackPaymentResponse);

// Start server
var PORT = process.env.PORT || 3031;
http.listen(PORT, function () {
  console.log("Server running on port ".concat(PORT));
});