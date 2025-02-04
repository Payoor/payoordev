"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _orderController = _interopRequireDefault(require("../controllers/orderController"));
var _verifyToken = _interopRequireDefault(require("../services/payoor/verifyToken"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var orderRoute = (0, _express["default"])();
orderRoute.get('/user/get/orders', _verifyToken["default"], _orderController["default"].getUserOrders);
orderRoute.get('/user/get/order', _verifyToken["default"], _orderController["default"].getOrder);
orderRoute.post('/user/create/order', _verifyToken["default"], _orderController["default"].createOrder);
var _default = exports["default"] = orderRoute;