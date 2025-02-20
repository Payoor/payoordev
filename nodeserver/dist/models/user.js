"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var userSchema = new _db["default"].Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    trim: true,
    unique: true,
    required: true
  },
  phoneNumber: {
    type: String,
    unique: true,
    trim: true,
    required: true
  },
  location: {
    type: String,
    required: true,
    trim: true
  },
  shoppingList: {
    type: String,
    trim: true
  },
  isVerified: {
    type: Boolean,
    "default": false
  },
  hasBeenWelcomed: {
    type: Boolean,
    "default": false
  },
  completed_orders: {
    type: Number,
    "default": 0
  }
}, {
  timestamps: true
});
module.exports = _db["default"].model('User', userSchema);