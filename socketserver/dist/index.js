"use strict";

require("regenerator-runtime");
var _cors = _interopRequireDefault(require("cors"));
var _paymentController = _interopRequireDefault(require("./controllers/paymentController"));
var _corsOriginArray = _interopRequireDefault(require("./corsOriginArray"));
var _paymentRoute = _interopRequireDefault(require("./routes/paymentRoute"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var mongoose = require('mongoose');
var PORT = process.env.PORT;
var corsOptions = {
  origin: _corsOriginArray["default"],
  optionsSuccessStatus: 200
};
app.use((0, _cors["default"])(corsOptions));
app.use(express.json());
app.use(_paymentRoute["default"]);
var io = require('socket.io')(server, {
  cors: {
    origin: _corsOriginArray["default"],
    methods: ["GET", "POST"],
    credentials: true
  }
});
io.on('connection', function (socket) {
  console.log('User connected:', socket.id);
});
server.listen(PORT, function (error) {
  if (error) {
    return console.error('Error starting server:', error);
  }
  console.log("Socket started on port ".concat(PORT));
});
app.post('/notify', function (req, res) {
  try {
    // Emit to all connected clients
    io.emit('notification', {
      message: 'New notification',
      data: req.body
    });
    res.status(200).json({
      message: 'Notification sent'
    });
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({
      error: 'Failed to send notification'
    });
  }
});
mongoose.connect(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(function () {
  console.log("database connection on ".concat(process.env.MONGO_URL));
})["catch"](function (error) {
  console.error('Error connecting to MongoDB:', error);
});