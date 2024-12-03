"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _orderController = _interopRequireDefault(require("../controllers/orderController"));
var _verifyJWT = _interopRequireDefault(require("../middleware/user/verifyJWT"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var orderRoute = (0, _express["default"])();
orderRoute.get('/user/get/orders', _verifyJWT["default"], _orderController["default"].getOrders);
orderRoute.get('/user/get/user-orders', _verifyJWT["default"], _orderController["default"].getUserOrders);
orderRoute.get('/user/get/order', _verifyJWT["default"], _orderController["default"].getOrder);
var _default = exports["default"] = orderRoute;