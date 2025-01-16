"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _paymentController = _interopRequireDefault(require("../controllers/paymentController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var express = require('express');
var paymentRoute = express();
paymentRoute.post('/paystack/payment-response', _paymentController["default"].handlePayStackPaymentResponse);
var _default = exports["default"] = paymentRoute;