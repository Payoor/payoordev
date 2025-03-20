"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _moment = _interopRequireDefault(require("moment"));
var _order2 = _interopRequireDefault(require("../models/order"));
var _redisClient = _interopRequireDefault(require("../configs/redisClient"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function ownKeys(e, r) { var t = Object.keys(e); if (Object.getOwnPropertySymbols) { var o = Object.getOwnPropertySymbols(e); r && (o = o.filter(function (r) { return Object.getOwnPropertyDescriptor(e, r).enumerable; })), t.push.apply(t, o); } return t; }
function _objectSpread(e) { for (var r = 1; r < arguments.length; r++) { var t = null != arguments[r] ? arguments[r] : {}; r % 2 ? ownKeys(Object(t), !0).forEach(function (r) { _defineProperty(e, r, t[r]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : ownKeys(Object(t)).forEach(function (r) { Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r)); }); } return e; }
function _defineProperty(e, r, t) { return (r = _toPropertyKey(r)) in e ? Object.defineProperty(e, r, { value: t, enumerable: !0, configurable: !0, writable: !0 }) : e[r] = t, e; }
function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return e; }; var t, e = {}, r = Object.prototype, n = r.hasOwnProperty, o = Object.defineProperty || function (t, e, r) { t[e] = r.value; }, i = "function" == typeof Symbol ? Symbol : {}, a = i.iterator || "@@iterator", c = i.asyncIterator || "@@asyncIterator", u = i.toStringTag || "@@toStringTag"; function define(t, e, r) { return Object.defineProperty(t, e, { value: r, enumerable: !0, configurable: !0, writable: !0 }), t[e]; } try { define({}, ""); } catch (t) { define = function define(t, e, r) { return t[e] = r; }; } function wrap(t, e, r, n) { var i = e && e.prototype instanceof Generator ? e : Generator, a = Object.create(i.prototype), c = new Context(n || []); return o(a, "_invoke", { value: makeInvokeMethod(t, r, c) }), a; } function tryCatch(t, e, r) { try { return { type: "normal", arg: t.call(e, r) }; } catch (t) { return { type: "throw", arg: t }; } } e.wrap = wrap; var h = "suspendedStart", l = "suspendedYield", f = "executing", s = "completed", y = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var p = {}; define(p, a, function () { return this; }); var d = Object.getPrototypeOf, v = d && d(d(values([]))); v && v !== r && n.call(v, a) && (p = v); var g = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(p); function defineIteratorMethods(t) { ["next", "throw", "return"].forEach(function (e) { define(t, e, function (t) { return this._invoke(e, t); }); }); } function AsyncIterator(t, e) { function invoke(r, o, i, a) { var c = tryCatch(t[r], t, o); if ("throw" !== c.type) { var u = c.arg, h = u.value; return h && "object" == _typeof(h) && n.call(h, "__await") ? e.resolve(h.__await).then(function (t) { invoke("next", t, i, a); }, function (t) { invoke("throw", t, i, a); }) : e.resolve(h).then(function (t) { u.value = t, i(u); }, function (t) { return invoke("throw", t, i, a); }); } a(c.arg); } var r; o(this, "_invoke", { value: function value(t, n) { function callInvokeWithMethodAndArg() { return new e(function (e, r) { invoke(t, n, e, r); }); } return r = r ? r.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(e, r, n) { var o = h; return function (i, a) { if (o === f) throw Error("Generator is already running"); if (o === s) { if ("throw" === i) throw a; return { value: t, done: !0 }; } for (n.method = i, n.arg = a;;) { var c = n.delegate; if (c) { var u = maybeInvokeDelegate(c, n); if (u) { if (u === y) continue; return u; } } if ("next" === n.method) n.sent = n._sent = n.arg;else if ("throw" === n.method) { if (o === h) throw o = s, n.arg; n.dispatchException(n.arg); } else "return" === n.method && n.abrupt("return", n.arg); o = f; var p = tryCatch(e, r, n); if ("normal" === p.type) { if (o = n.done ? s : l, p.arg === y) continue; return { value: p.arg, done: n.done }; } "throw" === p.type && (o = s, n.method = "throw", n.arg = p.arg); } }; } function maybeInvokeDelegate(e, r) { var n = r.method, o = e.iterator[n]; if (o === t) return r.delegate = null, "throw" === n && e.iterator["return"] && (r.method = "return", r.arg = t, maybeInvokeDelegate(e, r), "throw" === r.method) || "return" !== n && (r.method = "throw", r.arg = new TypeError("The iterator does not provide a '" + n + "' method")), y; var i = tryCatch(o, e.iterator, r.arg); if ("throw" === i.type) return r.method = "throw", r.arg = i.arg, r.delegate = null, y; var a = i.arg; return a ? a.done ? (r[e.resultName] = a.value, r.next = e.nextLoc, "return" !== r.method && (r.method = "next", r.arg = t), r.delegate = null, y) : a : (r.method = "throw", r.arg = new TypeError("iterator result is not an object"), r.delegate = null, y); } function pushTryEntry(t) { var e = { tryLoc: t[0] }; 1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e); } function resetTryEntry(t) { var e = t.completion || {}; e.type = "normal", delete e.arg, t.completion = e; } function Context(t) { this.tryEntries = [{ tryLoc: "root" }], t.forEach(pushTryEntry, this), this.reset(!0); } function values(e) { if (e || "" === e) { var r = e[a]; if (r) return r.call(e); if ("function" == typeof e.next) return e; if (!isNaN(e.length)) { var o = -1, i = function next() { for (; ++o < e.length;) if (n.call(e, o)) return next.value = e[o], next.done = !1, next; return next.value = t, next.done = !0, next; }; return i.next = i; } } throw new TypeError(_typeof(e) + " is not iterable"); } return GeneratorFunction.prototype = GeneratorFunctionPrototype, o(g, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), o(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, u, "GeneratorFunction"), e.isGeneratorFunction = function (t) { var e = "function" == typeof t && t.constructor; return !!e && (e === GeneratorFunction || "GeneratorFunction" === (e.displayName || e.name)); }, e.mark = function (t) { return Object.setPrototypeOf ? Object.setPrototypeOf(t, GeneratorFunctionPrototype) : (t.__proto__ = GeneratorFunctionPrototype, define(t, u, "GeneratorFunction")), t.prototype = Object.create(g), t; }, e.awrap = function (t) { return { __await: t }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, c, function () { return this; }), e.AsyncIterator = AsyncIterator, e.async = function (t, r, n, o, i) { void 0 === i && (i = Promise); var a = new AsyncIterator(wrap(t, r, n, o), i); return e.isGeneratorFunction(r) ? a : a.next().then(function (t) { return t.done ? t.value : a.next(); }); }, defineIteratorMethods(g), define(g, u, "Generator"), define(g, a, function () { return this; }), define(g, "toString", function () { return "[object Generator]"; }), e.keys = function (t) { var e = Object(t), r = []; for (var n in e) r.push(n); return r.reverse(), function next() { for (; r.length;) { var t = r.pop(); if (t in e) return next.value = t, next.done = !1, next; } return next.done = !0, next; }; }, e.values = values, Context.prototype = { constructor: Context, reset: function reset(e) { if (this.prev = 0, this.next = 0, this.sent = this._sent = t, this.done = !1, this.delegate = null, this.method = "next", this.arg = t, this.tryEntries.forEach(resetTryEntry), !e) for (var r in this) "t" === r.charAt(0) && n.call(this, r) && !isNaN(+r.slice(1)) && (this[r] = t); }, stop: function stop() { this.done = !0; var t = this.tryEntries[0].completion; if ("throw" === t.type) throw t.arg; return this.rval; }, dispatchException: function dispatchException(e) { if (this.done) throw e; var r = this; function handle(n, o) { return a.type = "throw", a.arg = e, r.next = n, o && (r.method = "next", r.arg = t), !!o; } for (var o = this.tryEntries.length - 1; o >= 0; --o) { var i = this.tryEntries[o], a = i.completion; if ("root" === i.tryLoc) return handle("end"); if (i.tryLoc <= this.prev) { var c = n.call(i, "catchLoc"), u = n.call(i, "finallyLoc"); if (c && u) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } else if (c) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); } else { if (!u) throw Error("try statement without catch or finally"); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } } } }, abrupt: function abrupt(t, e) { for (var r = this.tryEntries.length - 1; r >= 0; --r) { var o = this.tryEntries[r]; if (o.tryLoc <= this.prev && n.call(o, "finallyLoc") && this.prev < o.finallyLoc) { var i = o; break; } } i && ("break" === t || "continue" === t) && i.tryLoc <= e && e <= i.finallyLoc && (i = null); var a = i ? i.completion : {}; return a.type = t, a.arg = e, i ? (this.method = "next", this.next = i.finallyLoc, y) : this.complete(a); }, complete: function complete(t, e) { if ("throw" === t.type) throw t.arg; return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), y; }, finish: function finish(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.finallyLoc === t) return this.complete(r.completion, r.afterLoc), resetTryEntry(r), y; } }, "catch": function _catch(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.tryLoc === t) { var n = r.completion; if ("throw" === n.type) { var o = n.arg; resetTryEntry(r); } return o; } } throw Error("illegal catch attempt"); }, delegateYield: function delegateYield(e, r, n) { return this.delegate = { iterator: values(e), resultName: r, nextLoc: n }, "next" === this.method && (this.arg = t), y; } }, e; }
function _slicedToArray(r, e) { return _arrayWithHoles(r) || _iterableToArrayLimit(r, e) || _unsupportedIterableToArray(r, e) || _nonIterableRest(); }
function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _iterableToArrayLimit(r, l) { var t = null == r ? null : "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"]; if (null != t) { var e, n, i, u, a = [], f = !0, o = !1; try { if (i = (t = t.call(r)).next, 0 === l) { if (Object(t) !== t) return; f = !1; } else for (; !(f = (e = i.call(t)).done) && (a.push(e.value), a.length !== l); f = !0); } catch (r) { o = !0, n = r; } finally { try { if (!f && null != t["return"] && (u = t["return"](), Object(u) !== u)) return; } finally { if (o) throw n; } } return a; } }
function _arrayWithHoles(r) { if (Array.isArray(r)) return r; }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; }
function _classCallCheck(a, n) { if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function"); }
function _defineProperties(e, r) { for (var t = 0; t < r.length; t++) { var o = r[t]; o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(e, _toPropertyKey(o.key), o); } }
function _createClass(e, r, t) { return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: !1 }), e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
var _require = require('uuid'),
  uuidv4 = _require.v4;
var OrderController = /*#__PURE__*/function () {
  function OrderController() {
    _classCallCheck(this, OrderController);
  }
  return _createClass(OrderController, [{
    key: "createOrder",
    value: function () {
      var _createOrder = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee(req, res, next) {
        var _req$body, order, order_address, user, user_data_redis_store, completedOrders, ORDERS_KEY, items, cart_total, delivery_fee, service_charge, order_items, order_total, userData, userAddress, order_id, newOrder, serializedOrder, newLength, orderSummary, response;
        return _regeneratorRuntime().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              _context.prev = 0;
              _req$body = req.body, order = _req$body.order, order_address = _req$body.order_address;
              user = req.user;
              user_data_redis_store = "userdata:".concat(user.userId.toString());
              _context.next = 6;
              return _redisClient["default"].get("".concat(user_data_redis_store, ":completed_orders"));
            case 6:
              completedOrders = _context.sent;
              //console.log(completedOrders, 'completedOrders');
              ORDERS_KEY = "orders:".concat(user.userId);
              items = [];
              cart_total = order.totalAmount;
              delivery_fee = completedOrders && completedOrders == 0 ? 0 : 3500;
              service_charge = cart_total * 0.05;
              order_items = order.items;
              order_total = cart_total + delivery_fee + service_charge;
              Object.entries(order_items).forEach(function (_ref) {
                var _ref2 = _slicedToArray(_ref, 2),
                  id = _ref2[0],
                  item = _ref2[1];
                var product_data = {
                  product_id: id,
                  product_name: item.name,
                  product_units: sanitizeUnitKeys(item.units)
                };
                items.push(product_data);
              });
              _context.next = 17;
              return _redisClient["default"].hGetAll(user_data_redis_store);
            case 17:
              userData = _context.sent;
              if (!userData) {
                _context.next = 34;
                break;
              }
              _context.next = 21;
              return _redisClient["default"].hGet(user_data_redis_store, 'userAddress');
            case 21:
              userAddress = _context.sent;
              order_id = uuidv4();
              newOrder = {
                // Renamed from order to newOrder
                _id: order_id,
                userId: user.userId,
                items: items,
                order_address: order_address.length ? order_address : userAddress,
                cart_total: cart_total,
                delivery_fee: delivery_fee,
                service_charge: service_charge,
                total: order_total,
                status: 'pending',
                createdAt: Date.now(),
                delivery_date: 'order incomplete',
                reference: ''
              };
              serializedOrder = JSON.stringify(newOrder); //console.log('About to push to Redis...');
              _context.next = 27;
              return _redisClient["default"].rPush(ORDERS_KEY, serializedOrder);
            case 27:
              newLength = _context.sent;
              //console.log('Redis push complete, new length:', newLength);
              orderSummary = "Your order has been created. Below is your order summary:\n    \n    Order Details\n    -----------------\n    Cart Total: \u20A6".concat(cart_total.toLocaleString(), "\n    Delivery Fee: \u20A6").concat(delivery_fee.toLocaleString(), "\n    Service Charge: \u20A6").concat(service_charge.toLocaleString(), "\n    Total Amount: \u20A6").concat(order_total.toLocaleString(), "\n    Status: Pending Payment\n    Delivery Address: ").concat(userAddress, "\n    \n    Please Click the Pay Button to make payment\n    \n    Click the pay now button to complete payment.");
              console.log(newOrder, completedOrders, 'newOrder');
              response = {
                success: true,
                data: {
                  message: 'Success response',
                  chatresponse: {
                    text: orderSummary,
                    orderStatus: newOrder.status,
                    // Updated to use newOrder
                    orderId: newOrder._id,
                    // Updated to use newOrder
                    isClient: false,
                    isRead: false,
                    payload: newOrder // Updated to use newOrder
                  }
                }
              };
              res.status(200).json(response);
              _context.next = 35;
              break;
            case 34:
              res.status(404).json({
                success: false,
                message: 'Error creating order invalid user',
                error: 'User data not found' // Fixed error reference
              });
            case 35:
              _context.next = 43;
              break;
            case 37:
              _context.prev = 37;
              _context.t0 = _context["catch"](0);
              console.log('Error creating order:', _context.t0);
              _context.t0.statusCode = 400;
              _context.t0.payoorDevErrorMessage = 'Error creating order';
              next(_context.t0);
            case 43:
            case "end":
              return _context.stop();
          }
        }, _callee, null, [[0, 37]]);
      }));
      function createOrder(_x, _x2, _x3) {
        return _createOrder.apply(this, arguments);
      }
      return createOrder;
    }()
  }, {
    key: "getOrder",
    value: function () {
      var _getOrder = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee2(req, res, next) {
        var orderId, order;
        return _regeneratorRuntime().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              _context2.prev = 0;
              orderId = req.query.id;
              _context2.next = 4;
              return _order2["default"].findById(orderId).populate('userId', 'name email');
            case 4:
              order = _context2.sent;
              if (order) {
                _context2.next = 7;
                break;
              }
              return _context2.abrupt("return", res.status(404).json({
                success: false,
                message: 'Order not found'
              }));
            case 7:
              res.status(200).json({
                success: true,
                data: order
              });
              _context2.next = 16;
              break;
            case 10:
              _context2.prev = 10;
              _context2.t0 = _context2["catch"](0);
              console.log('error here', _context2.t0, 'error here');
              _context2.t0.statusCode = 400;
              _context2.t0.payoorDevErrorMessage = 'Error fetching order';
              next(_context2.t0);
            case 16:
            case "end":
              return _context2.stop();
          }
        }, _callee2, null, [[0, 10]]);
      }));
      function getOrder(_x4, _x5, _x6) {
        return _getOrder.apply(this, arguments);
      }
      return getOrder;
    }()
  }, {
    key: "getUserOrders",
    value: function () {
      var _getUserOrders = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee3(req, res, next) {
        var status, page, limit, skip, orders, ORDERS_KEY, pendingOrders, serializedOrders, formattedOrders, total, data;
        return _regeneratorRuntime().wrap(function _callee3$(_context3) {
          while (1) switch (_context3.prev = _context3.next) {
            case 0:
              _context3.prev = 0;
              status = req.query.status;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 10;
              skip = (page - 1) * limit;
              console.log(status, 'status');
              if (!(status === 'pending')) {
                _context3.next = 16;
                break;
              }
              ORDERS_KEY = "orders:".concat(req.user.userId);
              pendingOrders = [];
              _context3.next = 11;
              return _redisClient["default"].lRange(ORDERS_KEY, 0, -1);
            case 11:
              serializedOrders = _context3.sent;
              if (serializedOrders && serializedOrders.length > 0) {
                pendingOrders.push.apply(pendingOrders, _toConsumableArray(serializedOrders.map(function (order) {
                  return JSON.parse(order);
                })));
              }
              orders = pendingOrders;
              _context3.next = 19;
              break;
            case 16:
              _context3.next = 18;
              return _order2["default"].find({
                userId: req.user.userId,
                status: status
              }, {
                __v: 0
              }).sort({
                createdAt: -1
              }).skip(skip).limit(limit);
            case 18:
              orders = _context3.sent;
            case 19:
              //console.log(orders)
              formattedOrders = orders.map(function (order) {
                return _objectSpread(_objectSpread({}, order.toObject ? order.toObject() : order), {}, {
                  createdAt: (0, _moment["default"])(order.createdAt).format('MMM D, YYYY • h:mm A')
                });
              });
              total = orders.length;
              data = {
                message: 'Orders retrieved',
                page: page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: formattedOrders
              };
              res.status(200).json({
                success: true,
                data: data
              });
              _context3.next = 31;
              break;
            case 25:
              _context3.prev = 25;
              _context3.t0 = _context3["catch"](0);
              console.log('error here', _context3.t0, 'error here');
              _context3.t0.statusCode = 400;
              _context3.t0.payoorDevErrorMessage = 'Error fetching orders';
              next(_context3.t0);
            case 31:
            case "end":
              return _context3.stop();
          }
        }, _callee3, null, [[0, 25]]);
      }));
      function getUserOrders(_x7, _x8, _x9) {
        return _getUserOrders.apply(this, arguments);
      }
      return getUserOrders;
    }()
  }, {
    key: "getUserOrder",
    value: function () {
      var _getUserOrder = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee4(req, res, next) {
        var orderId, user, error, ORDERS_KEY, serializedOrders, orderIndex, orderStr, _order, order, _error;
        return _regeneratorRuntime().wrap(function _callee4$(_context4) {
          while (1) switch (_context4.prev = _context4.next) {
            case 0:
              _context4.prev = 0;
              orderId = req.query.orderId;
              user = req.user;
              if (orderId) {
                _context4.next = 7;
                break;
              }
              error = new Error('Order ID is required');
              error.statusCode = 400;
              throw error;
            case 7:
              ORDERS_KEY = "orders:".concat(user.userId);
              _context4.next = 10;
              return _redisClient["default"].lRange(ORDERS_KEY, 0, -1);
            case 10:
              serializedOrders = _context4.sent;
              if (!(serializedOrders && serializedOrders.length > 0)) {
                _context4.next = 17;
                break;
              }
              orderIndex = serializedOrders.findIndex(function (orderStr) {
                return orderStr.includes(orderId);
              });
              if (!(orderIndex !== -1)) {
                _context4.next = 17;
                break;
              }
              orderStr = serializedOrders[orderIndex];
              _order = JSON.parse(orderStr);
              return _context4.abrupt("return", res.status(200).json({
                success: true,
                message: 'Order retrieved successfully',
                data: _order
              }));
            case 17:
              _context4.next = 19;
              return _order2["default"].findOne({
                _id: orderId
              });
            case 19:
              order = _context4.sent;
              if (order) {
                _context4.next = 24;
                break;
              }
              _error = new Error('Order not found');
              _error.statusCode = 404;
              throw _error;
            case 24:
              return _context4.abrupt("return", res.status(200).json({
                success: true,
                message: 'Order retrieved successfully',
                data: order
              }));
            case 27:
              _context4.prev = 27;
              _context4.t0 = _context4["catch"](0);
              console.error('Error fetching order:', _context4.t0);
              _context4.t0.statusCode = _context4.t0.statusCode || 400;
              _context4.t0.payoorDevErrorMessage = 'Error fetching order';
              next(_context4.t0);
            case 33:
            case "end":
              return _context4.stop();
          }
        }, _callee4, null, [[0, 27]]);
      }));
      function getUserOrder(_x10, _x11, _x12) {
        return _getUserOrder.apply(this, arguments);
      }
      return getUserOrder;
    }()
  }, {
    key: "getPendingOrder",
    value: function () {
      var _getPendingOrder = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee5(req, res, next) {
        var orderId, error, PENDING_ORDER_ID, storedOrder, _error2, order;
        return _regeneratorRuntime().wrap(function _callee5$(_context5) {
          while (1) switch (_context5.prev = _context5.next) {
            case 0:
              _context5.prev = 0;
              orderId = req.query.id;
              if (orderId) {
                _context5.next = 6;
                break;
              }
              error = new Error('Order ID is required');
              error.statusCode = 400;
              throw error;
            case 6:
              PENDING_ORDER_ID = "pending:".concat(orderId);
              _context5.next = 9;
              return _redisClient["default"].get(PENDING_ORDER_ID);
            case 9:
              storedOrder = _context5.sent;
              if (storedOrder) {
                _context5.next = 14;
                break;
              }
              _error2 = new Error('Pending order not found');
              _error2.statusCode = 404;
              throw _error2;
            case 14:
              order = JSON.parse(storedOrder);
              console.log(order, 'this is the order that we want to pay for');
              res.status(200).json({
                status: 'success',
                data: order
              });
              _context5.next = 25;
              break;
            case 19:
              _context5.prev = 19;
              _context5.t0 = _context5["catch"](0);
              console.error('Error fetching order:', _context5.t0);
              _context5.t0.statusCode = _context5.t0.statusCode || 400;
              _context5.t0.payoorDevErrorMessage = 'Error fetching order';
              next(_context5.t0);
            case 25:
            case "end":
              return _context5.stop();
          }
        }, _callee5, null, [[0, 19]]);
      }));
      function getPendingOrder(_x13, _x14, _x15) {
        return _getPendingOrder.apply(this, arguments);
      }
      return getPendingOrder;
    }()
  }, {
    key: "updateDeliveryDateandAddress",
    value: function () {
      var _updateDeliveryDateandAddress = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee6(req, res, next) {
        var _req$body2, order_id, delivery_date, delivery_address, couponcode, user, error, ORDERS_KEY, serializedOrders, _error3, orderIndex, _error4, orderStr, parsedOrder, updatedOrder, PENDING_ORDER_ID, storedOrder, order;
        return _regeneratorRuntime().wrap(function _callee6$(_context6) {
          while (1) switch (_context6.prev = _context6.next) {
            case 0:
              _context6.prev = 0;
              _req$body2 = req.body, order_id = _req$body2.order_id, delivery_date = _req$body2.delivery_date, delivery_address = _req$body2.delivery_address, couponcode = _req$body2.couponcode;
              user = req.user;
              if (!(!order_id || !delivery_date)) {
                _context6.next = 7;
                break;
              }
              error = new Error('Order ID and delivery date are required');
              error.statusCode = 400;
              throw error;
            case 7:
              ORDERS_KEY = "orders:".concat(user.userId);
              _context6.next = 10;
              return _redisClient["default"].lRange(ORDERS_KEY, 0, -1);
            case 10:
              serializedOrders = _context6.sent;
              if (!(!serializedOrders || serializedOrders.length === 0)) {
                _context6.next = 15;
                break;
              }
              _error3 = new Error('No orders found');
              _error3.statusCode = 404;
              throw _error3;
            case 15:
              orderIndex = serializedOrders.findIndex(function (orderStr) {
                return orderStr.includes(order_id);
              });
              if (!(orderIndex === -1)) {
                _context6.next = 20;
                break;
              }
              _error4 = new Error('Order not found');
              _error4.statusCode = 404;
              throw _error4;
            case 20:
              orderStr = serializedOrders[orderIndex];
              parsedOrder = JSON.parse(orderStr);
              updatedOrder = _objectSpread(_objectSpread({}, parsedOrder), {}, {
                delivery_date: delivery_date,
                order_address: delivery_address,
                updatedAt: Date.now(),
                metadata: {
                  affiliatecode: couponcode ? couponcode : null
                }
              });
              _context6.next = 25;
              return _redisClient["default"].lSet(ORDERS_KEY, orderIndex, JSON.stringify(updatedOrder));
            case 25:
              PENDING_ORDER_ID = "pending:".concat(updatedOrder._id);
              console.log(PENDING_ORDER_ID, 'PENDING_ORDER_ID');
              _context6.next = 29;
              return _redisClient["default"].set(PENDING_ORDER_ID, JSON.stringify(updatedOrder), {
                EX: 60 * 60 // 1 hour
              });
            case 29:
              _context6.next = 31;
              return _redisClient["default"].get(PENDING_ORDER_ID);
            case 31:
              storedOrder = _context6.sent;
              order = JSON.parse(storedOrder); //console.log(order, 'stored pending order');
              return _context6.abrupt("return", res.status(200).json({
                success: true,
                message: 'Delivery date and address updated successfully',
                data: {
                  order: order
                }
              }));
            case 36:
              _context6.prev = 36;
              _context6.t0 = _context6["catch"](0);
              console.error('Error updating order:', _context6.t0);
              _context6.t0.statusCode = _context6.t0.statusCode || 400;
              _context6.t0.payoorDevErrorMessage = 'Error updating order delivery date and address';
              next(_context6.t0);
            case 42:
            case "end":
              return _context6.stop();
          }
        }, _callee6, null, [[0, 36]]);
      }));
      function updateDeliveryDateandAddress(_x16, _x17, _x18) {
        return _updateDeliveryDateandAddress.apply(this, arguments);
      }
      return updateDeliveryDateandAddress;
    }()
  }]);
}();
function getTotalAmount(text) {
  var totalPattern = /Total:\s([\d,]+)\sNaira/;
  var match = text.match(totalPattern);
  if (match) {
    return parseInt(match[1].replace(/,/g, ''), 10);
  } else {
    return null;
  }
}
function sanitizeUnitKeys(units) {
  var sanitizedUnits = {};
  Object.entries(units).forEach(function (_ref3) {
    var _ref4 = _slicedToArray(_ref3, 2),
      key = _ref4[0],
      value = _ref4[1];
    var sanitizedKey = key.replace(/\./g, '_');
    sanitizedUnits[sanitizedKey] = value;
  });
  return sanitizedUnits;
}
var _default = exports["default"] = new OrderController();