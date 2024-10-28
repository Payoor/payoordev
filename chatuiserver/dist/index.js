"use strict";

require("regenerator-runtime");
var _path = _interopRequireDefault(require("path"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var PORT = process.env.PORT;
var FLUTTER_WEB_APP = _path["default"].join(__dirname, '../public', 'web');
app.use(express["static"](FLUTTER_WEB_APP));
app.get('/', function (req, res) {
  var indexPath = _path["default"].join(FLUTTER_WEB_APP, 'index.html');
  res.sendFile(indexPath);
});
server.listen(PORT, function (error) {
  if (error) {
    return console.error('Error starting server:', error);
  }
  console.log("Server started on port ".concat(PORT));
});