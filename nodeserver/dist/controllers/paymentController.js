"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _transaction = _interopRequireDefault(require("../models/transaction"));
var _order = _interopRequireDefault(require("../models/order"));
var _redisClient = _interopRequireDefault(require("../configs/redisClient"));
var _getOrderDetails = _interopRequireDefault(require("../services/payoor/getOrderDetails"));
var _updateUserAddress = _interopRequireDefault(require("../services/payoor/updateUserAddress"));
var _sendAffiliateCouponUsageAlert = _interopRequireDefault(require("../services/resend/sendAffiliateCouponUsageAlert"));
var _affiliate = _interopRequireDefault(require("../models/affiliate"));
var _coupon = _interopRequireDefault(require("../models/coupon"));
var _excluded = ["_id", "metadata"];
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function ownKeys(e, r) { var t = Object.keys(e); if (Object.getOwnPropertySymbols) { var o = Object.getOwnPropertySymbols(e); r && (o = o.filter(function (r) { return Object.getOwnPropertyDescriptor(e, r).enumerable; })), t.push.apply(t, o); } return t; }
function _objectSpread(e) { for (var r = 1; r < arguments.length; r++) { var t = null != arguments[r] ? arguments[r] : {}; r % 2 ? ownKeys(Object(t), !0).forEach(function (r) { _defineProperty(e, r, t[r]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : ownKeys(Object(t)).forEach(function (r) { Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r)); }); } return e; }
function _defineProperty(e, r, t) { return (r = _toPropertyKey(r)) in e ? Object.defineProperty(e, r, { value: t, enumerable: !0, configurable: !0, writable: !0 }) : e[r] = t, e; }
function _objectWithoutProperties(e, t) { if (null == e) return {}; var o, r, i = _objectWithoutPropertiesLoose(e, t); if (Object.getOwnPropertySymbols) { var s = Object.getOwnPropertySymbols(e); for (r = 0; r < s.length; r++) o = s[r], t.includes(o) || {}.propertyIsEnumerable.call(e, o) && (i[o] = e[o]); } return i; }
function _objectWithoutPropertiesLoose(r, e) { if (null == r) return {}; var t = {}; for (var n in r) if ({}.hasOwnProperty.call(r, n)) { if (e.includes(n)) continue; t[n] = r[n]; } return t; }
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return e; }; var t, e = {}, r = Object.prototype, n = r.hasOwnProperty, o = Object.defineProperty || function (t, e, r) { t[e] = r.value; }, i = "function" == typeof Symbol ? Symbol : {}, a = i.iterator || "@@iterator", c = i.asyncIterator || "@@asyncIterator", u = i.toStringTag || "@@toStringTag"; function define(t, e, r) { return Object.defineProperty(t, e, { value: r, enumerable: !0, configurable: !0, writable: !0 }), t[e]; } try { define({}, ""); } catch (t) { define = function define(t, e, r) { return t[e] = r; }; } function wrap(t, e, r, n) { var i = e && e.prototype instanceof Generator ? e : Generator, a = Object.create(i.prototype), c = new Context(n || []); return o(a, "_invoke", { value: makeInvokeMethod(t, r, c) }), a; } function tryCatch(t, e, r) { try { return { type: "normal", arg: t.call(e, r) }; } catch (t) { return { type: "throw", arg: t }; } } e.wrap = wrap; var h = "suspendedStart", l = "suspendedYield", f = "executing", s = "completed", y = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var p = {}; define(p, a, function () { return this; }); var d = Object.getPrototypeOf, v = d && d(d(values([]))); v && v !== r && n.call(v, a) && (p = v); var g = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(p); function defineIteratorMethods(t) { ["next", "throw", "return"].forEach(function (e) { define(t, e, function (t) { return this._invoke(e, t); }); }); } function AsyncIterator(t, e) { function invoke(r, o, i, a) { var c = tryCatch(t[r], t, o); if ("throw" !== c.type) { var u = c.arg, h = u.value; return h && "object" == _typeof(h) && n.call(h, "__await") ? e.resolve(h.__await).then(function (t) { invoke("next", t, i, a); }, function (t) { invoke("throw", t, i, a); }) : e.resolve(h).then(function (t) { u.value = t, i(u); }, function (t) { return invoke("throw", t, i, a); }); } a(c.arg); } var r; o(this, "_invoke", { value: function value(t, n) { function callInvokeWithMethodAndArg() { return new e(function (e, r) { invoke(t, n, e, r); }); } return r = r ? r.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(e, r, n) { var o = h; return function (i, a) { if (o === f) throw Error("Generator is already running"); if (o === s) { if ("throw" === i) throw a; return { value: t, done: !0 }; } for (n.method = i, n.arg = a;;) { var c = n.delegate; if (c) { var u = maybeInvokeDelegate(c, n); if (u) { if (u === y) continue; return u; } } if ("next" === n.method) n.sent = n._sent = n.arg;else if ("throw" === n.method) { if (o === h) throw o = s, n.arg; n.dispatchException(n.arg); } else "return" === n.method && n.abrupt("return", n.arg); o = f; var p = tryCatch(e, r, n); if ("normal" === p.type) { if (o = n.done ? s : l, p.arg === y) continue; return { value: p.arg, done: n.done }; } "throw" === p.type && (o = s, n.method = "throw", n.arg = p.arg); } }; } function maybeInvokeDelegate(e, r) { var n = r.method, o = e.iterator[n]; if (o === t) return r.delegate = null, "throw" === n && e.iterator["return"] && (r.method = "return", r.arg = t, maybeInvokeDelegate(e, r), "throw" === r.method) || "return" !== n && (r.method = "throw", r.arg = new TypeError("The iterator does not provide a '" + n + "' method")), y; var i = tryCatch(o, e.iterator, r.arg); if ("throw" === i.type) return r.method = "throw", r.arg = i.arg, r.delegate = null, y; var a = i.arg; return a ? a.done ? (r[e.resultName] = a.value, r.next = e.nextLoc, "return" !== r.method && (r.method = "next", r.arg = t), r.delegate = null, y) : a : (r.method = "throw", r.arg = new TypeError("iterator result is not an object"), r.delegate = null, y); } function pushTryEntry(t) { var e = { tryLoc: t[0] }; 1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e); } function resetTryEntry(t) { var e = t.completion || {}; e.type = "normal", delete e.arg, t.completion = e; } function Context(t) { this.tryEntries = [{ tryLoc: "root" }], t.forEach(pushTryEntry, this), this.reset(!0); } function values(e) { if (e || "" === e) { var r = e[a]; if (r) return r.call(e); if ("function" == typeof e.next) return e; if (!isNaN(e.length)) { var o = -1, i = function next() { for (; ++o < e.length;) if (n.call(e, o)) return next.value = e[o], next.done = !1, next; return next.value = t, next.done = !0, next; }; return i.next = i; } } throw new TypeError(_typeof(e) + " is not iterable"); } return GeneratorFunction.prototype = GeneratorFunctionPrototype, o(g, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), o(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, u, "GeneratorFunction"), e.isGeneratorFunction = function (t) { var e = "function" == typeof t && t.constructor; return !!e && (e === GeneratorFunction || "GeneratorFunction" === (e.displayName || e.name)); }, e.mark = function (t) { return Object.setPrototypeOf ? Object.setPrototypeOf(t, GeneratorFunctionPrototype) : (t.__proto__ = GeneratorFunctionPrototype, define(t, u, "GeneratorFunction")), t.prototype = Object.create(g), t; }, e.awrap = function (t) { return { __await: t }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, c, function () { return this; }), e.AsyncIterator = AsyncIterator, e.async = function (t, r, n, o, i) { void 0 === i && (i = Promise); var a = new AsyncIterator(wrap(t, r, n, o), i); return e.isGeneratorFunction(r) ? a : a.next().then(function (t) { return t.done ? t.value : a.next(); }); }, defineIteratorMethods(g), define(g, u, "Generator"), define(g, a, function () { return this; }), define(g, "toString", function () { return "[object Generator]"; }), e.keys = function (t) { var e = Object(t), r = []; for (var n in e) r.push(n); return r.reverse(), function next() { for (; r.length;) { var t = r.pop(); if (t in e) return next.value = t, next.done = !1, next; } return next.done = !0, next; }; }, e.values = values, Context.prototype = { constructor: Context, reset: function reset(e) { if (this.prev = 0, this.next = 0, this.sent = this._sent = t, this.done = !1, this.delegate = null, this.method = "next", this.arg = t, this.tryEntries.forEach(resetTryEntry), !e) for (var r in this) "t" === r.charAt(0) && n.call(this, r) && !isNaN(+r.slice(1)) && (this[r] = t); }, stop: function stop() { this.done = !0; var t = this.tryEntries[0].completion; if ("throw" === t.type) throw t.arg; return this.rval; }, dispatchException: function dispatchException(e) { if (this.done) throw e; var r = this; function handle(n, o) { return a.type = "throw", a.arg = e, r.next = n, o && (r.method = "next", r.arg = t), !!o; } for (var o = this.tryEntries.length - 1; o >= 0; --o) { var i = this.tryEntries[o], a = i.completion; if ("root" === i.tryLoc) return handle("end"); if (i.tryLoc <= this.prev) { var c = n.call(i, "catchLoc"), u = n.call(i, "finallyLoc"); if (c && u) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } else if (c) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); } else { if (!u) throw Error("try statement without catch or finally"); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } } } }, abrupt: function abrupt(t, e) { for (var r = this.tryEntries.length - 1; r >= 0; --r) { var o = this.tryEntries[r]; if (o.tryLoc <= this.prev && n.call(o, "finallyLoc") && this.prev < o.finallyLoc) { var i = o; break; } } i && ("break" === t || "continue" === t) && i.tryLoc <= e && e <= i.finallyLoc && (i = null); var a = i ? i.completion : {}; return a.type = t, a.arg = e, i ? (this.method = "next", this.next = i.finallyLoc, y) : this.complete(a); }, complete: function complete(t, e) { if ("throw" === t.type) throw t.arg; return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), y; }, finish: function finish(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.finallyLoc === t) return this.complete(r.completion, r.afterLoc), resetTryEntry(r), y; } }, "catch": function _catch(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.tryLoc === t) { var n = r.completion; if ("throw" === n.type) { var o = n.arg; resetTryEntry(r); } return o; } } throw Error("illegal catch attempt"); }, delegateYield: function delegateYield(e, r, n) { return this.delegate = { iterator: values(e), resultName: r, nextLoc: n }, "next" === this.method && (this.arg = t), y; } }, e; }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; }
function _classCallCheck(a, n) { if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function"); }
function _defineProperties(e, r) { for (var t = 0; t < r.length; t++) { var o = r[t]; o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(e, _toPropertyKey(o.key), o); } }
function _createClass(e, r, t) { return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: !1 }), e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
var https = require('https');
var crypto = require('crypto');
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}
var PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;
var FLUTTERWAVE_SECRET_KEY = process.env.FLUTTERWAVE_SECRET_KEY;
var PaymentController = /*#__PURE__*/function () {
  function PaymentController() {
    _classCallCheck(this, PaymentController);
  }
  return _createClass(PaymentController, [{
    key: "generateTransferDetails",
    value: function () {
      var _generateTransferDetails = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee2(req, res, next) {
        var email, total, orderId, userId, name, _req$body, delivery_fee, service_charge, amount, amountTotal, tx_ref, params, options, flutterwaveReq;
        return _regeneratorRuntime().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              _context2.prev = 0;
              email = req.email, total = req.total, orderId = req.orderId, userId = req.userId, name = req.name;
              _req$body = req.body, delivery_fee = _req$body.delivery_fee, service_charge = _req$body.service_charge;
              amount = total;
              if (!(!email || !amount)) {
                _context2.next = 7;
                break;
              }
              console.log('email and amount are required');
              return _context2.abrupt("return", res.status(400).json({
                message: 'email and amount are required'
              }));
            case 7:
              if (!(typeof delivery_fee !== 'number' || typeof service_charge !== 'number' || typeof amount !== 'number')) {
                _context2.next = 9;
                break;
              }
              throw new Error('All amounts must be numbers');
            case 9:
              amountTotal = (delivery_fee + service_charge + amount).toFixed(2);
              tx_ref = generateTransactionReference();
              params = JSON.stringify({
                amount: amountTotal,
                email: email,
                currency: "NGN",
                tx_ref: tx_ref,
                fullname: name
              });
              console.log(params);
              options = {
                hostname: 'api.flutterwave.com',
                port: 443,
                path: '/v3/charges?type=bank_transfer',
                method: 'POST',
                headers: {
                  'Authorization': "Bearer ".concat(FLUTTERWAVE_SECRET_KEY),
                  'Content-Type': 'application/json',
                  'accept': 'application/json'
                }
              };
              flutterwaveReq = https.request(options, function (flutterwaveRes) {
                var data = '';
                flutterwaveRes.on('data', function (chunk) {
                  data += chunk;
                });
                var response = {
                  success: true,
                  data: {
                    message: 'Success response',
                    chatresponse: {
                      text: "this is an AI response",
                      isClient: false,
                      isRead: false
                    }
                  }
                };
                flutterwaveRes.on('end', /*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee() {
                  var transfer_reference, transaction;
                  return _regeneratorRuntime().wrap(function _callee$(_context) {
                    while (1) switch (_context.prev = _context.next) {
                      case 0:
                        console.log('Response:', data);
                        transfer_reference = JSON.parse(data).meta.authorization.transfer_reference;
                        response.data.account_number = JSON.parse(data).meta.authorization.transfer_account;
                        response.data.bank = JSON.parse(data).meta.authorization.transfer_bank;
                        response.data.amount = JSON.parse(data).meta.authorization.transfer_amount;
                        response.data.transfer_reference = transfer_reference;
                        response.data.transaction_reference = tx_ref;
                        res.status(200).json(response);
                        transaction = new _transaction["default"]({
                          initiatorId: userId,
                          orderId: orderId,
                          amount: amount,
                          reference: tx_ref
                        });
                        _context.next = 11;
                        return transaction.save();
                      case 11:
                        _context.next = 13;
                        return _order["default"].findOneAndUpdate({
                          _id: orderId
                        }, {
                          $set: {
                            reference: tx_ref
                          }
                        }, {
                          "new": true,
                          runValidators: true
                        });
                      case 13:
                      case "end":
                        return _context.stop();
                    }
                  }, _callee);
                })));
              });
              flutterwaveReq.on('error', function (error) {
                console.log(error);
                return res.status(400).json({
                  message: 'Error generating bank transfer details'
                });
              });
              flutterwaveReq.write(params);
              flutterwaveReq.end();
              _context2.next = 25;
              break;
            case 20:
              _context2.prev = 20;
              _context2.t0 = _context2["catch"](0);
              console.log('error here', _context2.t0, 'error here');
              _context2.t0.payoorDevErrorMessage = 'Failed to generate bank transfer details';
              next(_context2.t0);
            case 25:
            case "end":
              return _context2.stop();
          }
        }, _callee2, null, [[0, 20]]);
      }));
      function generateTransferDetails(_x, _x2, _x3) {
        return _generateTransferDetails.apply(this, arguments);
      }
      return generateTransferDetails;
    }()
  }, {
    key: "handleFlutterwavePaymentResponse",
    value: function () {
      var _handleFlutterwavePaymentResponse = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee3(req, res, next) {
        var secretHash, signature, event, paymentData, txRef;
        return _regeneratorRuntime().wrap(function _callee3$(_context3) {
          while (1) switch (_context3.prev = _context3.next) {
            case 0:
              _context3.prev = 0;
              secretHash = process.env.FLUTTERWAVE_SECRET_HASH;
              signature = req.headers["verif-hash"];
              if (!(!signature || signature !== secretHash)) {
                _context3.next = 5;
                break;
              }
              return _context3.abrupt("return", res.status(401).json({
                success: false,
                message: "Unauthorized request"
              }));
            case 5:
              event = req.body;
              paymentData = req.body.data;
              if (!(event.event === "charge.completed" && event.data.status === "successful")) {
                _context3.next = 13;
                break;
              }
              txRef = paymentData.tx_ref;
              console.log("Payment received for:", txRef);
              _context3.next = 12;
              return _transaction["default"].findOneAndUpdate({
                reference: txRef
              }, {
                $set: {
                  status: "verified"
                }
              }, {
                "new": true,
                runValidators: true
              });
            case 12:
              return _context3.abrupt("return", res.status(200).json({
                success: true,
                message: "Payment verified successfully",
                mailResponse: mailResponse
              }));
            case 13:
              console.log('Unhandled event type:', event.event);
              _context3.next = 21;
              break;
            case 16:
              _context3.prev = 16;
              _context3.t0 = _context3["catch"](0);
              console.log('error here', _context3.t0, 'error here');
              _context3.t0.payoorDevErrorMessage = 'Failed verify payment';
              next(_context3.t0);
            case 21:
            case "end":
              return _context3.stop();
          }
        }, _callee3, null, [[0, 16]]);
      }));
      function handleFlutterwavePaymentResponse(_x4, _x5, _x6) {
        return _handleFlutterwavePaymentResponse.apply(this, arguments);
      }
      return handleFlutterwavePaymentResponse;
    }()
  }, {
    key: "generatePaymentLink",
    value: function () {
      var _generatePaymentLink = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee5(req, res, next) {
        var email, total, orderId, userId, _req$body2, delivery_fee, service_charge, amount, amountTotal, params, options, paystackRequest;
        return _regeneratorRuntime().wrap(function _callee5$(_context5) {
          while (1) switch (_context5.prev = _context5.next) {
            case 0:
              _context5.prev = 0;
              email = req.email, total = req.total, orderId = req.orderId, userId = req.userId;
              _req$body2 = req.body, delivery_fee = _req$body2.delivery_fee, service_charge = _req$body2.service_charge; //const { order, user } = res.locals;
              amount = total; //console.log('amount', amount);
              if (!(!email || !amount)) {
                _context5.next = 7;
                break;
              }
              console.log('email and amount are required');
              return _context5.abrupt("return", res.status(400).json({
                message: 'email and amount are required'
              }));
            case 7:
              if (!(typeof delivery_fee !== 'number' || typeof service_charge !== 'number' || typeof amount !== 'number')) {
                _context5.next = 9;
                break;
              }
              throw new Error('All amounts must be numbers');
            case 9:
              amountTotal = 1000; //(delivery_fee + service_charge + amount).toFixed(2);
              params = JSON.stringify({
                "email": email,
                "amount": Math.round(amountTotal * 100) // this conversion can be done either on the client side or server side.
                // channels: ["bank_transfer"]
              });
              options = {
                hostname: 'api.paystack.co',
                port: 443,
                path: '/transaction/initialize',
                method: 'POST',
                headers: {
                  Authorization: "Bearer ".concat(PAYSTACK_SECRET_KEY),
                  'Content-Type': 'application/json'
                }
              };
              paystackRequest = https.request(options, function (paystackResponse) {
                var data = '';
                paystackResponse.on('data', function (chunk) {
                  data += chunk;
                });
                var response = {
                  success: true,
                  data: {
                    message: 'Success response',
                    chatresponse: {
                      text: "this is an AI response",
                      isClient: false,
                      isRead: false
                    }
                  }
                };
                paystackResponse.on('end', /*#__PURE__*/_asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee4() {
                  var transaction_reference, transaction, order_update;
                  return _regeneratorRuntime().wrap(function _callee4$(_context4) {
                    while (1) switch (_context4.prev = _context4.next) {
                      case 0:
                        console.log('data here', data);
                        transaction_reference = JSON.parse(data).data.reference;
                        response.data.authorization_url = JSON.parse(data).data.authorization_url;
                        response.data.transaction_reference = transaction_reference;
                        response.data.access_code = JSON.parse(data).data.access_code;

                        //console.log(response);

                        res.status(200).json(response);
                        transaction = new _transaction["default"]({
                          initiatorId: userId,
                          orderId: orderId,
                          amount: amount,
                          reference: transaction_reference
                        });
                        transaction.save();
                        _context4.next = 10;
                        return _order["default"].findOneAndUpdate({
                          _id: orderId
                        }, {
                          $set: {
                            reference: transaction_reference
                          }
                        }, {
                          "new": true,
                          runValidators: true
                        });
                      case 10:
                        order_update = _context4.sent;
                      case 11:
                      case "end":
                        return _context4.stop();
                    }
                  }, _callee4);
                })));
              }).on('error', function (error) {
                console.log(error);
                return res.status(400).json({
                  message: 'Error generating payment link'
                });
              });
              paystackRequest.write(params);
              paystackRequest.end();
              _context5.next = 22;
              break;
            case 17:
              _context5.prev = 17;
              _context5.t0 = _context5["catch"](0);
              console.log('error here', _context5.t0, 'error here');
              _context5.t0.payoorDevErrorMessage = 'Failed to generate payment link';
              next(_context5.t0);
            case 22:
            case "end":
              return _context5.stop();
          }
        }, _callee5, null, [[0, 17]]);
      }));
      function generatePaymentLink(_x7, _x8, _x9) {
        return _generatePaymentLink.apply(this, arguments);
      }
      return generatePaymentLink;
    }()
  }, {
    key: "handlePayStackPaymentResponse",
    value: function () {
      var _handlePayStackPaymentResponse = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee6(req, res) {
        var paystackSignature, hash, event, paymentData, _mailResponse;
        return _regeneratorRuntime().wrap(function _callee6$(_context6) {
          while (1) switch (_context6.prev = _context6.next) {
            case 0:
              _context6.prev = 0;
              paystackSignature = req.headers['x-paystack-signature'];
              hash = crypto.createHmac('sha512', PAYSTACK_SECRET_KEY).update(JSON.stringify(req.body)).digest('hex');
              if (!(hash !== paystackSignature)) {
                _context6.next = 5;
                break;
              }
              return _context6.abrupt("return", res.status(401).json({
                message: 'Unauthorized request'
              }));
            case 5:
              event = req.body;
              paymentData = event.data;
              _context6.t0 = event.event;
              _context6.next = _context6.t0 === 'charge.success' ? 10 : _context6.t0 === 'transfer.success' ? 12 : _context6.t0 === 'charge.failed' ? 14 : 15;
              break;
            case 10:
              console.log('charge successful:', paymentData);
              return _context6.abrupt("break", 16);
            case 12:
              console.log('transfer successful:', paymentData);
              return _context6.abrupt("break", 16);
            case 14:
              return _context6.abrupt("break", 16);
            case 15:
              console.log('Unhandled event type:', event.event);
            case 16:
              _context6.next = 18;
              return _transaction["default"].findOneAndUpdate({
                reference: paymentData.reference
              }, {
                $set: {
                  status: "verified"
                }
              }, {
                "new": true,
                runValidators: true
              });
            case 18:
              _context6.next = 20;
              return sendTransactionVerification({
                email: paymentData.customer.email,
                amount: formatAmount(paymentData.amount / 100)
              });
            case 20:
              _mailResponse = _context6.sent;
              return _context6.abrupt("return", res.status(200).json({
                message: 'Webhook processed successfully',
                mailResponse: _mailResponse
              }));
            case 24:
              _context6.prev = 24;
              _context6.t1 = _context6["catch"](0);
              console.log('error here', _context6.t1, 'error here');
              _context6.t1.payoorDevErrorMessage = 'Failed verify payment';
              next(_context6.t1);
            case 29:
            case "end":
              return _context6.stop();
          }
        }, _callee6, null, [[0, 24]]);
      }));
      function handlePayStackPaymentResponse(_x10, _x11) {
        return _handlePayStackPaymentResponse.apply(this, arguments);
      }
      return handlePayStackPaymentResponse;
    }()
  }, {
    key: "verifyPayment",
    value: function () {
      var _verifyPayment = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee7(req, res) {
        var _https, transactionReference, options, transaction, verificationRequest, errorResponse;
        return _regeneratorRuntime().wrap(function _callee7$(_context7) {
          while (1) switch (_context7.prev = _context7.next) {
            case 0:
              _context7.prev = 0;
              _https = require('https');
              transactionReference = req.body.transactionReference;
              options = {
                hostname: 'api.paystack.co',
                port: 443,
                path: "/transaction/verify/".concat(transactionReference),
                method: 'GET',
                headers: {
                  Authorization: "Bearer ".concat(PAYSTACK_SECRET_KEY)
                }
              };
              _context7.next = 6;
              return _transaction["default"].findOne({
                reference: transactionReference
              });
            case 6:
              transaction = _context7.sent;
              if (transaction) {
                _context7.next = 9;
                break;
              }
              return _context7.abrupt("return", res.status(404).json({
                message: 'Transaction not found.'
              }));
            case 9:
              verificationRequest = _https.request(options, function (verificationResponse) {
                var data = '';
                verificationResponse.on('data', function (chunk) {
                  data += chunk;
                });
                var response = {
                  success: true,
                  data: {
                    message: 'Payment verified!',
                    chatresponse: {
                      text: "this is an AI response",
                      isClient: false,
                      isRead: false
                    }
                  }
                };
                verificationResponse.on('end', function () {
                  console.log(JSON.parse(data));
                  transaction.status = 'verified';
                  transaction.paymentDate = new Date(JSON.parse(data).data.paid_at);
                  transaction.save();
                  res.status(200).json(response);
                });
              }).on('error', function (error) {
                console.log(error);
                return res.status(400).json({
                  message: 'Error verifying payment'
                });
              });
              verificationRequest.end();
              _context7.next = 18;
              break;
            case 13:
              _context7.prev = 13;
              _context7.t0 = _context7["catch"](0);
              console.log(_context7.t0);
              errorResponse = {
                success: false,
                data: {
                  message: _context7.t0.message || 'Failed to verify payment',
                  error: process.env.NODE_ENV === 'development' ? _context7.t0.toString() : undefined,
                  timestamp: new Date().toISOString()
                }
              };
              res.status(500).json(errorResponse);
            case 18:
            case "end":
              return _context7.stop();
          }
        }, _callee7, null, [[0, 13]]);
      }));
      function verifyPayment(_x12, _x13) {
        return _verifyPayment.apply(this, arguments);
      }
      return verifyPayment;
    }()
  }, {
    key: "handleBaniPayment",
    value: function () {
      var _handleBaniPayment = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee8(req, res) {
        var merchant_private_key, headers, body, sig, hmac, digest, webhookData, order_ref, paymentStatus, PENDING_ORDER_ID, storedOrder, order, _id, metadata, orderWithoutId, affiliatecode, newMongoOrder, total, payout, user_id, user_current_address;
        return _regeneratorRuntime().wrap(function _callee8$(_context8) {
          while (1) switch (_context8.prev = _context8.next) {
            case 0:
              _context8.prev = 0;
              merchant_private_key = process.env.MERCHANT_PRIVATE_KEY_BANI;
              headers = req.headers;
              body = req.rawBody; // Validate request body
              if (body) {
                _context8.next = 7;
                break;
              }
              console.log('no body');
              return _context8.abrupt("return", res.status(400).json({
                status: false,
                message: "No body provided"
              }));
            case 7:
              if (headers["bani-hook-signature"]) {
                _context8.next = 9;
                break;
              }
              return _context8.abrupt("return", res.status(400).json({
                status: false,
                message: "No signature provided"
              }));
            case 9:
              // Verify signature
              sig = Buffer.from(headers["bani-hook-signature"], "utf8");
              hmac = crypto.createHmac("sha256", merchant_private_key);
              digest = Buffer.from(hmac.update(body).digest("hex"), "utf8");
              if (!(sig.length !== digest.length || !crypto.timingSafeEqual(digest, sig))) {
                _context8.next = 14;
                break;
              }
              return _context8.abrupt("return", res.status(401).json({
                status: false,
                message: "Invalid signature"
              }));
            case 14:
              webhookData = JSON.parse(body);
              order_ref = webhookData.data.custom_data.order_ref;
              paymentStatus = webhookData.data.pay_status; //console.log(order_ref, 'order_ref');
              if (!(paymentStatus === 'paid')) {
                _context8.next = 41;
                break;
              }
              // Use direct key lookup instead of list search
              PENDING_ORDER_ID = "pending:".concat(order_ref);
              _context8.next = 21;
              return _redisClient["default"].get(PENDING_ORDER_ID);
            case 21:
              storedOrder = _context8.sent;
              if (storedOrder) {
                _context8.next = 25;
                break;
              }
              console.error('Order not found:', order_ref);
              return _context8.abrupt("return", res.status(404).json({
                status: false,
                message: "Order not found"
              }));
            case 25:
              order = JSON.parse(storedOrder);
              _id = order._id, metadata = order.metadata, orderWithoutId = _objectWithoutProperties(order, _excluded);
              console.log(metadata, 'metadata');
              affiliatecode = metadata.affiliatecode;
              newMongoOrder = new _order["default"](_objectSpread(_objectSpread({}, orderWithoutId), {}, {
                reference: webhookData.data.transaction_ref,
                status: 'processing',
                metadata: metadata
              }));
              _context8.next = 32;
              return Promise.all([newMongoOrder.save(), _redisClient["default"].del(PENDING_ORDER_ID)]);
            case 32:
              (0, _getOrderDetails["default"])(newMongoOrder._id);
              total = newMongoOrder.total;
              payout = total * 0.1;
              if (affiliatecode) {
                updateAffiliate(affiliatecode, total, payout);
              }
              user_id = newMongoOrder.userId;
              user_current_address = newMongoOrder.order_address;
              console.log(newMongoOrder, 'newMongoOrder======newMongoOrder======newMongoOrder');
              (0, _updateUserAddress["default"])(user_id, user_current_address);
              return _context8.abrupt("return", res.status(200).json({
                status: true,
                message: "Payment processed successfully",
                data: {
                  order: newMongoOrder
                }
              }));
            case 41:
              return _context8.abrupt("return", res.status(200).json({
                status: true,
                message: "Webhook received"
              }));
            case 44:
              _context8.prev = 44;
              _context8.t0 = _context8["catch"](0);
              console.error('Webhook processing error:', _context8.t0);
              return _context8.abrupt("return", res.status(500).json({
                status: false,
                message: "Error processing webhook",
                error: _context8.t0.message
              }));
            case 48:
            case "end":
              return _context8.stop();
          }
        }, _callee8, null, [[0, 44]]);
      }));
      function handleBaniPayment(_x14, _x15) {
        return _handleBaniPayment.apply(this, arguments);
      }
      return handleBaniPayment;
    }()
  }]);
}();
var _default = exports["default"] = new PaymentController();
var generateTransactionReference = function generateTransactionReference() {
  var text = "";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for (var i = 0; i < 10; i++) text += possible.charAt(Math.floor(Math.random() * possible.length));
  return text;
};
var formatAmount = function formatAmount(amount) {
  var formatter = new Intl.NumberFormat("en-NG", {
    style: "currency",
    currency: "NGN",
    minimumFractionDigits: 0
  });
  return formatter.format(amount);
};
function updateAffiliate(_x16, _x17, _x18) {
  return _updateAffiliate.apply(this, arguments);
}
function _updateAffiliate() {
  _updateAffiliate = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee9(coupon, amountSpent, payout) {
    var couponCode, affiliate, email;
    return _regeneratorRuntime().wrap(function _callee9$(_context9) {
      while (1) switch (_context9.prev = _context9.next) {
        case 0:
          _context9.prev = 0;
          _context9.next = 3;
          return _coupon["default"].findOne({
            code: coupon
          });
        case 3:
          couponCode = _context9.sent;
          _context9.next = 6;
          return _affiliate["default"].findOne({
            coupon: coupon
          });
        case 6:
          affiliate = _context9.sent;
          couponCode.usedCount = couponCode.usedCount + 1;
          _context9.next = 10;
          return couponCode.save();
        case 10:
          if (!(couponCode && affiliate)) {
            _context9.next = 15;
            break;
          }
          console.log(couponCode, affiliate);
          email = affiliate.email;
          _context9.next = 15;
          return (0, _sendAffiliateCouponUsageAlert["default"])({
            email: email,
            affiliateCode: coupon,
            amountSpent: amountSpent,
            payout: payout
          });
        case 15:
          _context9.next = 20;
          break;
        case 17:
          _context9.prev = 17;
          _context9.t0 = _context9["catch"](0);
          console.log(_context9.t0);
        case 20:
        case "end":
          return _context9.stop();
      }
    }, _callee9, null, [[0, 17]]);
  }));
  return _updateAffiliate.apply(this, arguments);
}