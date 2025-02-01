"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _transactionController = _interopRequireDefault(require("../controllers/transactionController"));
var _verifyToken = _interopRequireDefault(require("../services/payoor/verifyToken"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var transactionRoute = (0, _express["default"])();
transactionRoute.get('/user/get/transactions', _verifyToken["default"], _transactionController["default"].getUserTransactions);
transactionRoute.get('/user/get/transaction', _verifyToken["default"], _transactionController["default"].getTransaction);
transactionRoute.get('/user/get/transaction-and-order-details', _verifyToken["default"], _transactionController["default"].getTransactionStatusAndOrderDetails);
var _default = exports["default"] = transactionRoute;