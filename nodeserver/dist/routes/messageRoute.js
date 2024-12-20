"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _authChatController = _interopRequireDefault(require("../controllers/authChatController"));
var _auth = require("../middleware/admin/auth");
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var messageRoute = (0, _express["default"])();
messageRoute.get('/messages', _auth.authenticate, _authChatController["default"].getRoomMessages);
messageRoute.post('/message/user/send', _authChatController["default"].sendUserMessage);
var _default = exports["default"] = messageRoute;