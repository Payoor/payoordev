"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _verifyToken = _interopRequireDefault(require("../services/payoor/verifyToken"));
var _authController = _interopRequireDefault(require("../controllers/authController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var authRoute = (0, _express["default"])();
authRoute.post('/auth/email/otp', _authController["default"].generateOtp);
authRoute.post('/auth/email/verify', _authController["default"].verifyOtp);
authRoute.post('/auth/affiliate/email/verify', _authController["default"].verifyAffiliateOtp);
authRoute.post('/auth/signup', _authController["default"].handleSignUp);
authRoute.post('/auth/genjwt', _authController["default"].generateJWT);
authRoute.get('/auth/getvaliduser', _verifyToken["default"], _authController["default"].getValidUser);
authRoute.post('/auth/jwt/delete', _verifyToken["default"], _authController["default"].handleSignOut);
var _default = exports["default"] = authRoute;