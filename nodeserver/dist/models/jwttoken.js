"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var JWTTokenSchema = new _db["default"].Schema({
  userId: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  expiry: {
    type: Date,
    required: true
  },
  isRevoked: {
    type: Boolean,
    "default": false
  },
  createdAt: {
    type: Date,
    "default": Date.now
  }
});
module.exports = _db["default"].model('JwtToken', JWTTokenSchema);