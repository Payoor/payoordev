"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var visitorSchema = new _db["default"].Schema({
  username: {
    type: String,
    "default": 'Visitor'
  },
  identifier: {
    type: String,
    required: true
  },
  email: {
    type: String
  },
  otp: {
    type: String
  }
});
var Visitor = _db["default"].model('Visitor', visitorSchema);
var _default = exports["default"] = Visitor;