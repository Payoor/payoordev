"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _validatePhoneNumber = _interopRequireDefault(require("../services/payoor/validatePhoneNumber"));
var _createVerification = _interopRequireDefault(require("../services/payoor/test/createVerification"));
var _createVerificationCheck = _interopRequireDefault(require("../services/payoor/test/createVerificationCheck"));
var _generateJWT = _interopRequireDefault(require("../services/payoor/generateJWT"));
var _saveUserName = _interopRequireDefault(require("../services/payoor/saveUserName"));
var _getValidUser = _interopRequireDefault(require("../services/payoor/getValidUser"));
var _saveMessage = _interopRequireDefault(require("../services/payoor/saveMessage"));
var _processRequest = _interopRequireDefault(require("../services/payoor/processRequest"));
var _trackUnread = _interopRequireDefault(require("../services/payoor/trackUnread"));
var _authChatController = _interopRequireDefault(require("../controllers/authChatController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var messageRoute = (0, _express["default"])();
messageRoute.post('/message/user/send', _authChatController["default"].sendUserMessage);
var _default = exports["default"] = messageRoute;