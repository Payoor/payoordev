"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _authController = _interopRequireDefault(require("../controllers/authController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var authRoute = (0, _express["default"])();
authRoute.get('/auth/getvaliduser', _authController["default"].getValidUser);
authRoute.get('/auth/getunauthmsg', _authController["default"].getUnAuthenticatedMsg);
authRoute.get('/auth/getvisitor', _authController["default"].getCurrentVisitorData);
authRoute.post('/auth/email', _authController["default"].generateOtp);
authRoute.post('/auth/otp', _authController["default"].verifyOtp);
authRoute.post('/auth/name', _authController["default"].saveUserName);
var _default = exports["default"] = authRoute;