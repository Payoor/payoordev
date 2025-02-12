"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var roomSchema = new _db["default"].Schema({
  userid: {
    type: String,
    trim: true,
    "default": ""
  },
  userphonenumber: {
    type: String,
    trim: true,
    "default": ""
  },
  socketid: {
    type: String,
    required: true,
    trim: true
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
});
var Room = _db["default"].model('Room', roomSchema);
module.exports = Room;