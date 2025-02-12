"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var messageSchema = new _db["default"].Schema({
  roomId: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'Room',
    required: true
  },
  text: {
    type: String,
    required: true
  },
  clienttimestamp: {
    type: String,
    required: true
  },
  servertimestamp: {
    type: Date,
    "default": Date.now
  },
  isRead: {
    type: Boolean,
    "default": false
  },
  sender: {
    type: String,
    "enum": ['user', 'admin', 'llm'],
    "default": 'user'
  }
}, {
  timestamps: false
});
var Message = _db["default"].model('Message', messageSchema);
module.exports = Message;