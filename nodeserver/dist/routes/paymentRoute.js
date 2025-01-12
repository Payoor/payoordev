"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _paymentController = _interopRequireDefault(require("../controllers/paymentController"));
var _orderController = _interopRequireDefault(require("../controllers/orderController"));
var _verifyToken = _interopRequireDefault(require("../services/payoor/verifyToken"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var express = require('express');
var paymentRoute = express();
paymentRoute.post('/paystack/generate-payment-link', _verifyToken["default"], _orderController["default"].createOrder, _paymentController["default"].generatePaymentLink);
paymentRoute.post('/paystack/payment-response', _paymentController["default"].handlePayStackPaymentResponse);
paymentRoute.post('/paystack/verify-payment', _paymentController["default"].verifyPayment);
var _default = exports["default"] = paymentRoute;