"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _visitor = _interopRequireDefault(require("../models/visitor"));
var _user = _interopRequireDefault(require("../models/user"));
var _message = _interopRequireDefault(require("../models/message"));
var _messageController = _interopRequireDefault(require("./messageController"));
var _generateOTP = _interopRequireDefault(require("../services/payoor/generateOTP"));
var _verifyOtp3 = _interopRequireDefault(require("../services/payoor/verifyOtp"));
var _generateJWT = _interopRequireDefault(require("../services/payoor/generateJWT"));
var _getValidUser3 = _interopRequireDefault(require("../services/payoor/getValidUser"));
var _sendOtp = _interopRequireDefault(require("../services/resend/sendOtp"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function _toConsumableArray(r) { return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _iterableToArray(r) { if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r); }
function _arrayWithoutHoles(r) { if (Array.isArray(r)) return _arrayLikeToArray(r); }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return e; }; var t, e = {}, r = Object.prototype, n = r.hasOwnProperty, o = Object.defineProperty || function (t, e, r) { t[e] = r.value; }, i = "function" == typeof Symbol ? Symbol : {}, a = i.iterator || "@@iterator", c = i.asyncIterator || "@@asyncIterator", u = i.toStringTag || "@@toStringTag"; function define(t, e, r) { return Object.defineProperty(t, e, { value: r, enumerable: !0, configurable: !0, writable: !0 }), t[e]; } try { define({}, ""); } catch (t) { define = function define(t, e, r) { return t[e] = r; }; } function wrap(t, e, r, n) { var i = e && e.prototype instanceof Generator ? e : Generator, a = Object.create(i.prototype), c = new Context(n || []); return o(a, "_invoke", { value: makeInvokeMethod(t, r, c) }), a; } function tryCatch(t, e, r) { try { return { type: "normal", arg: t.call(e, r) }; } catch (t) { return { type: "throw", arg: t }; } } e.wrap = wrap; var h = "suspendedStart", l = "suspendedYield", f = "executing", s = "completed", y = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var p = {}; define(p, a, function () { return this; }); var d = Object.getPrototypeOf, v = d && d(d(values([]))); v && v !== r && n.call(v, a) && (p = v); var g = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(p); function defineIteratorMethods(t) { ["next", "throw", "return"].forEach(function (e) { define(t, e, function (t) { return this._invoke(e, t); }); }); } function AsyncIterator(t, e) { function invoke(r, o, i, a) { var c = tryCatch(t[r], t, o); if ("throw" !== c.type) { var u = c.arg, h = u.value; return h && "object" == _typeof(h) && n.call(h, "__await") ? e.resolve(h.__await).then(function (t) { invoke("next", t, i, a); }, function (t) { invoke("throw", t, i, a); }) : e.resolve(h).then(function (t) { u.value = t, i(u); }, function (t) { return invoke("throw", t, i, a); }); } a(c.arg); } var r; o(this, "_invoke", { value: function value(t, n) { function callInvokeWithMethodAndArg() { return new e(function (e, r) { invoke(t, n, e, r); }); } return r = r ? r.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(e, r, n) { var o = h; return function (i, a) { if (o === f) throw Error("Generator is already running"); if (o === s) { if ("throw" === i) throw a; return { value: t, done: !0 }; } for (n.method = i, n.arg = a;;) { var c = n.delegate; if (c) { var u = maybeInvokeDelegate(c, n); if (u) { if (u === y) continue; return u; } } if ("next" === n.method) n.sent = n._sent = n.arg;else if ("throw" === n.method) { if (o === h) throw o = s, n.arg; n.dispatchException(n.arg); } else "return" === n.method && n.abrupt("return", n.arg); o = f; var p = tryCatch(e, r, n); if ("normal" === p.type) { if (o = n.done ? s : l, p.arg === y) continue; return { value: p.arg, done: n.done }; } "throw" === p.type && (o = s, n.method = "throw", n.arg = p.arg); } }; } function maybeInvokeDelegate(e, r) { var n = r.method, o = e.iterator[n]; if (o === t) return r.delegate = null, "throw" === n && e.iterator["return"] && (r.method = "return", r.arg = t, maybeInvokeDelegate(e, r), "throw" === r.method) || "return" !== n && (r.method = "throw", r.arg = new TypeError("The iterator does not provide a '" + n + "' method")), y; var i = tryCatch(o, e.iterator, r.arg); if ("throw" === i.type) return r.method = "throw", r.arg = i.arg, r.delegate = null, y; var a = i.arg; return a ? a.done ? (r[e.resultName] = a.value, r.next = e.nextLoc, "return" !== r.method && (r.method = "next", r.arg = t), r.delegate = null, y) : a : (r.method = "throw", r.arg = new TypeError("iterator result is not an object"), r.delegate = null, y); } function pushTryEntry(t) { var e = { tryLoc: t[0] }; 1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e); } function resetTryEntry(t) { var e = t.completion || {}; e.type = "normal", delete e.arg, t.completion = e; } function Context(t) { this.tryEntries = [{ tryLoc: "root" }], t.forEach(pushTryEntry, this), this.reset(!0); } function values(e) { if (e || "" === e) { var r = e[a]; if (r) return r.call(e); if ("function" == typeof e.next) return e; if (!isNaN(e.length)) { var o = -1, i = function next() { for (; ++o < e.length;) if (n.call(e, o)) return next.value = e[o], next.done = !1, next; return next.value = t, next.done = !0, next; }; return i.next = i; } } throw new TypeError(_typeof(e) + " is not iterable"); } return GeneratorFunction.prototype = GeneratorFunctionPrototype, o(g, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), o(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, u, "GeneratorFunction"), e.isGeneratorFunction = function (t) { var e = "function" == typeof t && t.constructor; return !!e && (e === GeneratorFunction || "GeneratorFunction" === (e.displayName || e.name)); }, e.mark = function (t) { return Object.setPrototypeOf ? Object.setPrototypeOf(t, GeneratorFunctionPrototype) : (t.__proto__ = GeneratorFunctionPrototype, define(t, u, "GeneratorFunction")), t.prototype = Object.create(g), t; }, e.awrap = function (t) { return { __await: t }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, c, function () { return this; }), e.AsyncIterator = AsyncIterator, e.async = function (t, r, n, o, i) { void 0 === i && (i = Promise); var a = new AsyncIterator(wrap(t, r, n, o), i); return e.isGeneratorFunction(r) ? a : a.next().then(function (t) { return t.done ? t.value : a.next(); }); }, defineIteratorMethods(g), define(g, u, "Generator"), define(g, a, function () { return this; }), define(g, "toString", function () { return "[object Generator]"; }), e.keys = function (t) { var e = Object(t), r = []; for (var n in e) r.push(n); return r.reverse(), function next() { for (; r.length;) { var t = r.pop(); if (t in e) return next.value = t, next.done = !1, next; } return next.done = !0, next; }; }, e.values = values, Context.prototype = { constructor: Context, reset: function reset(e) { if (this.prev = 0, this.next = 0, this.sent = this._sent = t, this.done = !1, this.delegate = null, this.method = "next", this.arg = t, this.tryEntries.forEach(resetTryEntry), !e) for (var r in this) "t" === r.charAt(0) && n.call(this, r) && !isNaN(+r.slice(1)) && (this[r] = t); }, stop: function stop() { this.done = !0; var t = this.tryEntries[0].completion; if ("throw" === t.type) throw t.arg; return this.rval; }, dispatchException: function dispatchException(e) { if (this.done) throw e; var r = this; function handle(n, o) { return a.type = "throw", a.arg = e, r.next = n, o && (r.method = "next", r.arg = t), !!o; } for (var o = this.tryEntries.length - 1; o >= 0; --o) { var i = this.tryEntries[o], a = i.completion; if ("root" === i.tryLoc) return handle("end"); if (i.tryLoc <= this.prev) { var c = n.call(i, "catchLoc"), u = n.call(i, "finallyLoc"); if (c && u) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } else if (c) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); } else { if (!u) throw Error("try statement without catch or finally"); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } } } }, abrupt: function abrupt(t, e) { for (var r = this.tryEntries.length - 1; r >= 0; --r) { var o = this.tryEntries[r]; if (o.tryLoc <= this.prev && n.call(o, "finallyLoc") && this.prev < o.finallyLoc) { var i = o; break; } } i && ("break" === t || "continue" === t) && i.tryLoc <= e && e <= i.finallyLoc && (i = null); var a = i ? i.completion : {}; return a.type = t, a.arg = e, i ? (this.method = "next", this.next = i.finallyLoc, y) : this.complete(a); }, complete: function complete(t, e) { if ("throw" === t.type) throw t.arg; return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), y; }, finish: function finish(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.finallyLoc === t) return this.complete(r.completion, r.afterLoc), resetTryEntry(r), y; } }, "catch": function _catch(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.tryLoc === t) { var n = r.completion; if ("throw" === n.type) { var o = n.arg; resetTryEntry(r); } return o; } } throw Error("illegal catch attempt"); }, delegateYield: function delegateYield(e, r, n) { return this.delegate = { iterator: values(e), resultName: r, nextLoc: n }, "next" === this.method && (this.arg = t), y; } }, e; }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; }
function _classCallCheck(a, n) { if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function"); }
function _defineProperties(e, r) { for (var t = 0; t < r.length; t++) { var o = r[t]; o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(e, _toPropertyKey(o.key), o); } }
function _createClass(e, r, t) { return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: !1 }), e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
var AuthController = /*#__PURE__*/function () {
  function AuthController() {
    _classCallCheck(this, AuthController);
  }
  return _createClass(AuthController, [{
    key: "getCurrentVisitorData",
    value: function () {
      var _getCurrentVisitorData = _asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee(req, res) {
        var visitorId, visitorData, visitorMessages, userdetails;
        return _regeneratorRuntime().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              _context.prev = 0;
              visitorId = req.query.visitorId;
              _context.next = 4;
              return _visitor["default"].findOne({
                identifier: visitorId
              });
            case 4:
              visitorData = _context.sent;
              if (!visitorData) {
                _context.next = 11;
                break;
              }
              _context.next = 8;
              return _messageController["default"].getVisitorMessages(visitorData._id);
            case 8:
              visitorMessages = _context.sent;
              userdetails = {
                username: visitorData.username,
                messages: visitorMessages
              };
              res.status(200).send({
                userdetails: userdetails
              });
            case 11:
              _context.next = 17;
              break;
            case 13:
              _context.prev = 13;
              _context.t0 = _context["catch"](0);
              console.log(_context.t0);
              res.status(500).send({
                error: _context.t0
              });
            case 17:
            case "end":
              return _context.stop();
          }
        }, _callee, null, [[0, 13]]);
      }));
      function getCurrentVisitorData(_x, _x2) {
        return _getCurrentVisitorData.apply(this, arguments);
      }
      return getCurrentVisitorData;
    }()
  }, {
    key: "getUnAuthenticatedMsg",
    value: function () {
      var _getUnAuthenticatedMsg = _asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee2(req, res) {
        var visitorId, visitor, newPayoorMessage;
        return _regeneratorRuntime().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              _context2.prev = 0;
              visitorId = req.query.visitorId; //const visitor = await Visitor.findOne({ identifier: visitorId })
              visitor = new _visitor["default"]({
                identifier: visitorId
              });
              newPayoorMessage = new _message["default"]({
                content: "It appears you aren't logged in please log in using your email address",
                visitor: visitor._id,
                isUser: false,
                isLoggedIn: false
              });
              _context2.next = 6;
              return newPayoorMessage.save();
            case 6:
              res.status(200).send({
                username: 'Visitor',
                payoormessage: {
                  _id: newPayoorMessage._id,
                  msg: newPayoorMessage.content,
                  isUser: newPayoorMessage.isUser,
                  isLoggedIn: newPayoorMessage.isLoggedIn
                }
              });
              _context2.next = 13;
              break;
            case 9:
              _context2.prev = 9;
              _context2.t0 = _context2["catch"](0);
              console.log(_context2.t0);
              res.status(500).send({
                error: _context2.t0
              });
            case 13:
            case "end":
              return _context2.stop();
          }
        }, _callee2, null, [[0, 9]]);
      }));
      function getUnAuthenticatedMsg(_x3, _x4) {
        return _getUnAuthenticatedMsg.apply(this, arguments);
      }
      return getUnAuthenticatedMsg;
    }()
  }, {
    key: "generateOtp",
    value: function () {
      var _generateOtp = _asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee3(req, res) {
        var _req$body, message, timestamp, isUser, isLoggedIn, visitoridentifier, email, otpcode, data, visitor, newMessage, newPayoorMessage;
        return _regeneratorRuntime().wrap(function _callee3$(_context3) {
          while (1) switch (_context3.prev = _context3.next) {
            case 0:
              _context3.prev = 0;
              _req$body = req.body, message = _req$body.message, timestamp = _req$body.timestamp, isUser = _req$body.isUser, isLoggedIn = _req$body.isLoggedIn;
              visitoridentifier = req.query.visitoridentifier;
              email = message;
              _context3.next = 6;
              return (0, _generateOTP["default"])();
            case 6:
              otpcode = _context3.sent;
              _context3.next = 9;
              return (0, _sendOtp["default"])({
                email: email,
                otp: otpcode
              });
            case 9:
              data = _context3.sent;
              _context3.next = 12;
              return _visitor["default"].findOneAndUpdate({
                identifier: visitoridentifier
              }, {
                $set: {
                  username: message,
                  email: message,
                  otp: otpcode
                }
              }, {
                "new": true,
                upsert: true
              });
            case 12:
              visitor = _context3.sent;
              newMessage = new _message["default"]({
                content: message,
                visitor: visitor._id,
                client_timestamp: timestamp,
                isUser: isUser,
                isLoggedIn: isLoggedIn
              });
              newPayoorMessage = new _message["default"]({
                content: "I just sent an OTP to ".concat(email, ". Please check the email and send this OTP to me"),
                visitor: visitor._id,
                isUser: false,
                isLoggedIn: isLoggedIn
              });
              _context3.next = 17;
              return newMessage.save();
            case 17:
              _context3.next = 19;
              return newPayoorMessage.save();
            case 19:
              res.status(200).send({
                username: email,
                payoormessage: {
                  _id: newPayoorMessage._id,
                  msg: newPayoorMessage.content,
                  isUser: newPayoorMessage.isUser,
                  isLoggedIn: isLoggedIn
                }
              });
              _context3.next = 26;
              break;
            case 22:
              _context3.prev = 22;
              _context3.t0 = _context3["catch"](0);
              console.log(_context3.t0);
              res.status(500).send({
                error: _context3.t0
              });
            case 26:
            case "end":
              return _context3.stop();
          }
        }, _callee3, null, [[0, 22]]);
      }));
      function generateOtp(_x5, _x6) {
        return _generateOtp.apply(this, arguments);
      }
      return generateOtp;
    }()
  }, {
    key: "verifyOtp",
    value: function () {
      var _verifyOtp2 = _asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee4(req, res) {
        var _req$body2, message, timestamp, isUser, isLoggedIn, visitoridentifier, currentVisitor, visitorFromOtp, newMessage, currentUser, hasUsername, jwt, newPayoorMessage, visitorMessages, originalOrder, content;
        return _regeneratorRuntime().wrap(function _callee4$(_context4) {
          while (1) switch (_context4.prev = _context4.next) {
            case 0:
              _context4.prev = 0;
              _req$body2 = req.body, message = _req$body2.message, timestamp = _req$body2.timestamp, isUser = _req$body2.isUser, isLoggedIn = _req$body2.isLoggedIn;
              visitoridentifier = req.query.visitoridentifier;
              _context4.next = 5;
              return _visitor["default"].findOne({
                identifier: visitoridentifier
              });
            case 5:
              currentVisitor = _context4.sent;
              _context4.next = 8;
              return (0, _verifyOtp3["default"])({
                otp: message,
                visitoridentifier: visitoridentifier
              });
            case 8:
              visitorFromOtp = _context4.sent;
              newMessage = new _message["default"]({
                content: message,
                visitor: currentVisitor._id,
                client_timestamp: timestamp,
                isUser: isUser,
                isLoggedIn: isLoggedIn
              });
              _context4.next = 12;
              return newMessage.save();
            case 12:
              if (!visitorFromOtp) {
                _context4.next = 35;
                break;
              }
              _context4.next = 15;
              return _user["default"].findOneAndUpdate({
                email: visitorFromOtp.email
              }, {
                $set: {
                  email: currentVisitor.email,
                  isVerified: true
                }
              }, {
                "new": true,
                upsert: true
              });
            case 15:
              currentUser = _context4.sent;
              hasUsername = currentUser && currentUser.username !== 'Visitor' ? true : false;
              _context4.next = 19;
              return (0, _generateJWT["default"])({
                userid: currentUser._id
              });
            case 19:
              jwt = _context4.sent;
              if (!hasUsername) {
                _context4.next = 29;
                break;
              }
              _context4.next = 23;
              return _message["default"].find({
                visitor: currentVisitor._id
              });
            case 23:
              visitorMessages = _context4.sent;
              originalOrder = visitorMessages[0].content;
              if (originalOrder) {
                content = "Hello, ".concat(currentUser.username, ", would you like to proceed with your original order of \n").concat(originalOrder);
              } else {
                content = "Hello, ".concat(currentUser.username, ". What orders do you want to make?");
              }
              newPayoorMessage = new _message["default"]({
                content: content,
                visitor: visitorFromOtp._id,
                isUser: false,
                isLoggedIn: isLoggedIn
              });
              _context4.next = 30;
              break;
            case 29:
              newPayoorMessage = new _message["default"]({
                content: "Your email has been confirmed. Please Tell me your name or how you wish to be addressed",
                visitor: visitorFromOtp._id,
                isUser: false,
                isLoggedIn: isLoggedIn
              });
            case 30:
              _context4.next = 32;
              return newPayoorMessage.save();
            case 32:
              res.status(200).send({
                username: currentVisitor.username,
                hasUsername: hasUsername,
                jwt: jwt && jwt.length ? jwt : "",
                payoormessage: {
                  _id: newPayoorMessage._id,
                  msg: newPayoorMessage.content,
                  isUser: newPayoorMessage.isUser,
                  isLoggedIn: isLoggedIn
                }
              });
              _context4.next = 37;
              break;
            case 35:
              console.log('visitorFromOtp', visitorFromOtp);
              res.status(500).send({
                error: error
              });
            case 37:
              _context4.next = 43;
              break;
            case 39:
              _context4.prev = 39;
              _context4.t0 = _context4["catch"](0);
              console.log(_context4.t0);
              res.status(500).send({
                error: _context4.t0
              });
            case 43:
            case "end":
              return _context4.stop();
          }
        }, _callee4, null, [[0, 39]]);
      }));
      function verifyOtp(_x7, _x8) {
        return _verifyOtp2.apply(this, arguments);
      }
      return verifyOtp;
    }()
  }, {
    key: "saveUserName",
    value: function () {
      var _saveUserName = _asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee5(req, res) {
        var _req$body3, message, timestamp, isUser, isLoggedIn, _req$query, jwt, visitoridentifier, _yield$_getValidUser, _id, email, currentUser, newMessage, currentVisitor, newPayoorMessage, content, visitorMessages, originalOrder;
        return _regeneratorRuntime().wrap(function _callee5$(_context5) {
          while (1) switch (_context5.prev = _context5.next) {
            case 0:
              _context5.prev = 0;
              _req$body3 = req.body, message = _req$body3.message, timestamp = _req$body3.timestamp, isUser = _req$body3.isUser, isLoggedIn = _req$body3.isLoggedIn;
              _req$query = req.query, jwt = _req$query.jwt, visitoridentifier = _req$query.visitoridentifier;
              _context5.next = 5;
              return (0, _getValidUser3["default"])(jwt);
            case 5:
              _yield$_getValidUser = _context5.sent;
              _id = _yield$_getValidUser._id;
              email = _yield$_getValidUser.email;
              if (!(_id && email)) {
                _context5.next = 34;
                break;
              }
              _context5.next = 11;
              return _user["default"].findOneAndUpdate({
                email: email
              }, {
                $set: {
                  username: message,
                  isVerified: true
                }
              }, {
                "new": true,
                upsert: true
              });
            case 11:
              currentUser = _context5.sent;
              newMessage = new _message["default"]({
                content: message,
                user: currentUser._id,
                client_timestamp: timestamp,
                isUser: isUser,
                isLoggedIn: true
              });
              _context5.next = 15;
              return newMessage.save();
            case 15:
              console.log(currentUser, newMessage);
              _context5.next = 18;
              return _visitor["default"].findOne({
                identifier: visitoridentifier
              });
            case 18:
              currentVisitor = _context5.sent;
              if (!currentVisitor) {
                _context5.next = 27;
                break;
              }
              _context5.next = 22;
              return _message["default"].find({
                visitor: currentVisitor._id
              });
            case 22:
              visitorMessages = _context5.sent;
              originalOrder = visitorMessages[0].content;
              content = "Hello, ".concat(currentUser.username, ", would you like to proceed with your original order of \n").concat(originalOrder);
              _context5.next = 28;
              break;
            case 27:
              content = "Hello, ".concat(currentUser.username, ". What orders do you want to make?");
            case 28:
              newPayoorMessage = new _message["default"]({
                content: content,
                user: currentUser._id,
                isUser: false,
                isLoggedIn: true
              });
              _context5.next = 31;
              return newPayoorMessage.save();
            case 31:
              res.status(200).send({
                username: currentUser.username,
                payoormessage: {
                  _id: newPayoorMessage._id,
                  msg: newPayoorMessage.content,
                  isUser: newPayoorMessage.isUser,
                  isLoggedIn: isLoggedIn
                }
              });
              _context5.next = 35;
              break;
            case 34:
              res.status(500).send({
                error: error
              });
            case 35:
              _context5.next = 41;
              break;
            case 37:
              _context5.prev = 37;
              _context5.t0 = _context5["catch"](0);
              console.log(_context5.t0);
              res.status(500).send({
                error: _context5.t0
              });
            case 41:
            case "end":
              return _context5.stop();
          }
        }, _callee5, null, [[0, 37]]);
      }));
      function saveUserName(_x9, _x10) {
        return _saveUserName.apply(this, arguments);
      }
      return saveUserName;
    }()
  }, {
    key: "getValidUser",
    value: function () {
      var _getValidUser2 = _asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee6(req, res) {
        var jwt, _yield$_getValidUser2, _id, username, email, visitorIdentity, latestVisitorIdentity, visitorMessages, userMessages, accountMessages, hasUsername;
        return _regeneratorRuntime().wrap(function _callee6$(_context6) {
          while (1) switch (_context6.prev = _context6.next) {
            case 0:
              _context6.prev = 0;
              jwt = req.query.jwt;
              _context6.next = 4;
              return (0, _getValidUser3["default"])(jwt);
            case 4:
              _yield$_getValidUser2 = _context6.sent;
              _id = _yield$_getValidUser2._id;
              username = _yield$_getValidUser2.username;
              email = _yield$_getValidUser2.email;
              _context6.next = 10;
              return _visitor["default"].find({
                email: email
              });
            case 10:
              visitorIdentity = _context6.sent;
              latestVisitorIdentity = visitorIdentity[visitorIdentity.length - 1];
              _context6.next = 14;
              return _message["default"].find({
                visitor: latestVisitorIdentity._id
              }).sort('-server_timestamp').select('_id visitor isUser isLoggedIn content client_timestamp server_timestamp');
            case 14:
              visitorMessages = _context6.sent;
              _context6.next = 17;
              return _message["default"].find({
                user: _id
              }).sort('server_timestamp').sort('server_timestamp').select('_id user isUser isLoggedIn content client_timestamp server_timestamp');
            case 17:
              userMessages = _context6.sent;
              accountMessages = [].concat(_toConsumableArray(visitorMessages), _toConsumableArray(userMessages));
              hasUsername = username !== 'Visitor' ? true : false;
              if (_id) {
                res.status(200).send({
                  username: hasUsername ? username : email,
                  hasUsername: hasUsername,
                  jwt: jwt && jwt.length ? jwt : "",
                  accountMessages: accountMessages
                });
              }
              _context6.next = 27;
              break;
            case 23:
              _context6.prev = 23;
              _context6.t0 = _context6["catch"](0);
              console.log(_context6.t0);
              res.status(404).send({
                error: _context6.t0
              });
            case 27:
            case "end":
              return _context6.stop();
          }
        }, _callee6, null, [[0, 23]]);
      }));
      function getValidUser(_x11, _x12) {
        return _getValidUser2.apply(this, arguments);
      }
      return getValidUser;
    }()
  }]);
}();
var _default = exports["default"] = new AuthController();