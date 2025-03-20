"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _axios = _interopRequireDefault(require("axios"));
var _product = _interopRequireDefault(require("../models/product"));
var _image = _interopRequireDefault(require("../models/image"));
var _admin = _interopRequireDefault(require("../models/admin"));
var _user = _interopRequireDefault(require("../models/user"));
var _transaction = _interopRequireDefault(require("../models/transaction"));
var _order = _interopRequireDefault(require("../models/order"));
var _newProduct = _interopRequireDefault(require("../models/newProduct"));
var _productVariant = _interopRequireDefault(require("../models/productVariant"));
var _affiliate = _interopRequireDefault(require("../models/affiliate"));
var _coupon = _interopRequireDefault(require("../models/coupon"));
var _generateOTP = _interopRequireDefault(require("../services/payoor/generateOTP"));
var _sendAffiliateActiveStatus = _interopRequireDefault(require("../services/resend/sendAffiliateActiveStatus"));
var _sendAffiliateDeactivation = _interopRequireDefault(require("../services/resend/sendAffiliateDeactivation"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
function _createForOfIteratorHelper(r, e) { var t = "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"]; if (!t) { if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) { t && (r = t); var _n = 0, F = function F() {}; return { s: F, n: function n() { return _n >= r.length ? { done: !0 } : { done: !1, value: r[_n++] }; }, e: function e(r) { throw r; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var o, a = !0, u = !1; return { s: function s() { t = t.call(r); }, n: function n() { var r = t.next(); return a = r.done, r; }, e: function e(r) { u = !0, o = r; }, f: function f() { try { a || null == t["return"] || t["return"](); } finally { if (u) throw o; } } }; }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function ownKeys(e, r) { var t = Object.keys(e); if (Object.getOwnPropertySymbols) { var o = Object.getOwnPropertySymbols(e); r && (o = o.filter(function (r) { return Object.getOwnPropertyDescriptor(e, r).enumerable; })), t.push.apply(t, o); } return t; }
function _objectSpread(e) { for (var r = 1; r < arguments.length; r++) { var t = null != arguments[r] ? arguments[r] : {}; r % 2 ? ownKeys(Object(t), !0).forEach(function (r) { _defineProperty(e, r, t[r]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(e, Object.getOwnPropertyDescriptors(t)) : ownKeys(Object(t)).forEach(function (r) { Object.defineProperty(e, r, Object.getOwnPropertyDescriptor(t, r)); }); } return e; }
function _defineProperty(e, r, t) { return (r = _toPropertyKey(r)) in e ? Object.defineProperty(e, r, { value: t, enumerable: !0, configurable: !0, writable: !0 }) : e[r] = t, e; }
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return e; }; var t, e = {}, r = Object.prototype, n = r.hasOwnProperty, o = Object.defineProperty || function (t, e, r) { t[e] = r.value; }, i = "function" == typeof Symbol ? Symbol : {}, a = i.iterator || "@@iterator", c = i.asyncIterator || "@@asyncIterator", u = i.toStringTag || "@@toStringTag"; function define(t, e, r) { return Object.defineProperty(t, e, { value: r, enumerable: !0, configurable: !0, writable: !0 }), t[e]; } try { define({}, ""); } catch (t) { define = function define(t, e, r) { return t[e] = r; }; } function wrap(t, e, r, n) { var i = e && e.prototype instanceof Generator ? e : Generator, a = Object.create(i.prototype), c = new Context(n || []); return o(a, "_invoke", { value: makeInvokeMethod(t, r, c) }), a; } function tryCatch(t, e, r) { try { return { type: "normal", arg: t.call(e, r) }; } catch (t) { return { type: "throw", arg: t }; } } e.wrap = wrap; var h = "suspendedStart", l = "suspendedYield", f = "executing", s = "completed", y = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var p = {}; define(p, a, function () { return this; }); var d = Object.getPrototypeOf, v = d && d(d(values([]))); v && v !== r && n.call(v, a) && (p = v); var g = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(p); function defineIteratorMethods(t) { ["next", "throw", "return"].forEach(function (e) { define(t, e, function (t) { return this._invoke(e, t); }); }); } function AsyncIterator(t, e) { function invoke(r, o, i, a) { var c = tryCatch(t[r], t, o); if ("throw" !== c.type) { var u = c.arg, h = u.value; return h && "object" == _typeof(h) && n.call(h, "__await") ? e.resolve(h.__await).then(function (t) { invoke("next", t, i, a); }, function (t) { invoke("throw", t, i, a); }) : e.resolve(h).then(function (t) { u.value = t, i(u); }, function (t) { return invoke("throw", t, i, a); }); } a(c.arg); } var r; o(this, "_invoke", { value: function value(t, n) { function callInvokeWithMethodAndArg() { return new e(function (e, r) { invoke(t, n, e, r); }); } return r = r ? r.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(e, r, n) { var o = h; return function (i, a) { if (o === f) throw Error("Generator is already running"); if (o === s) { if ("throw" === i) throw a; return { value: t, done: !0 }; } for (n.method = i, n.arg = a;;) { var c = n.delegate; if (c) { var u = maybeInvokeDelegate(c, n); if (u) { if (u === y) continue; return u; } } if ("next" === n.method) n.sent = n._sent = n.arg;else if ("throw" === n.method) { if (o === h) throw o = s, n.arg; n.dispatchException(n.arg); } else "return" === n.method && n.abrupt("return", n.arg); o = f; var p = tryCatch(e, r, n); if ("normal" === p.type) { if (o = n.done ? s : l, p.arg === y) continue; return { value: p.arg, done: n.done }; } "throw" === p.type && (o = s, n.method = "throw", n.arg = p.arg); } }; } function maybeInvokeDelegate(e, r) { var n = r.method, o = e.iterator[n]; if (o === t) return r.delegate = null, "throw" === n && e.iterator["return"] && (r.method = "return", r.arg = t, maybeInvokeDelegate(e, r), "throw" === r.method) || "return" !== n && (r.method = "throw", r.arg = new TypeError("The iterator does not provide a '" + n + "' method")), y; var i = tryCatch(o, e.iterator, r.arg); if ("throw" === i.type) return r.method = "throw", r.arg = i.arg, r.delegate = null, y; var a = i.arg; return a ? a.done ? (r[e.resultName] = a.value, r.next = e.nextLoc, "return" !== r.method && (r.method = "next", r.arg = t), r.delegate = null, y) : a : (r.method = "throw", r.arg = new TypeError("iterator result is not an object"), r.delegate = null, y); } function pushTryEntry(t) { var e = { tryLoc: t[0] }; 1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e); } function resetTryEntry(t) { var e = t.completion || {}; e.type = "normal", delete e.arg, t.completion = e; } function Context(t) { this.tryEntries = [{ tryLoc: "root" }], t.forEach(pushTryEntry, this), this.reset(!0); } function values(e) { if (e || "" === e) { var r = e[a]; if (r) return r.call(e); if ("function" == typeof e.next) return e; if (!isNaN(e.length)) { var o = -1, i = function next() { for (; ++o < e.length;) if (n.call(e, o)) return next.value = e[o], next.done = !1, next; return next.value = t, next.done = !0, next; }; return i.next = i; } } throw new TypeError(_typeof(e) + " is not iterable"); } return GeneratorFunction.prototype = GeneratorFunctionPrototype, o(g, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), o(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, u, "GeneratorFunction"), e.isGeneratorFunction = function (t) { var e = "function" == typeof t && t.constructor; return !!e && (e === GeneratorFunction || "GeneratorFunction" === (e.displayName || e.name)); }, e.mark = function (t) { return Object.setPrototypeOf ? Object.setPrototypeOf(t, GeneratorFunctionPrototype) : (t.__proto__ = GeneratorFunctionPrototype, define(t, u, "GeneratorFunction")), t.prototype = Object.create(g), t; }, e.awrap = function (t) { return { __await: t }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, c, function () { return this; }), e.AsyncIterator = AsyncIterator, e.async = function (t, r, n, o, i) { void 0 === i && (i = Promise); var a = new AsyncIterator(wrap(t, r, n, o), i); return e.isGeneratorFunction(r) ? a : a.next().then(function (t) { return t.done ? t.value : a.next(); }); }, defineIteratorMethods(g), define(g, u, "Generator"), define(g, a, function () { return this; }), define(g, "toString", function () { return "[object Generator]"; }), e.keys = function (t) { var e = Object(t), r = []; for (var n in e) r.push(n); return r.reverse(), function next() { for (; r.length;) { var t = r.pop(); if (t in e) return next.value = t, next.done = !1, next; } return next.done = !0, next; }; }, e.values = values, Context.prototype = { constructor: Context, reset: function reset(e) { if (this.prev = 0, this.next = 0, this.sent = this._sent = t, this.done = !1, this.delegate = null, this.method = "next", this.arg = t, this.tryEntries.forEach(resetTryEntry), !e) for (var r in this) "t" === r.charAt(0) && n.call(this, r) && !isNaN(+r.slice(1)) && (this[r] = t); }, stop: function stop() { this.done = !0; var t = this.tryEntries[0].completion; if ("throw" === t.type) throw t.arg; return this.rval; }, dispatchException: function dispatchException(e) { if (this.done) throw e; var r = this; function handle(n, o) { return a.type = "throw", a.arg = e, r.next = n, o && (r.method = "next", r.arg = t), !!o; } for (var o = this.tryEntries.length - 1; o >= 0; --o) { var i = this.tryEntries[o], a = i.completion; if ("root" === i.tryLoc) return handle("end"); if (i.tryLoc <= this.prev) { var c = n.call(i, "catchLoc"), u = n.call(i, "finallyLoc"); if (c && u) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } else if (c) { if (this.prev < i.catchLoc) return handle(i.catchLoc, !0); } else { if (!u) throw Error("try statement without catch or finally"); if (this.prev < i.finallyLoc) return handle(i.finallyLoc); } } } }, abrupt: function abrupt(t, e) { for (var r = this.tryEntries.length - 1; r >= 0; --r) { var o = this.tryEntries[r]; if (o.tryLoc <= this.prev && n.call(o, "finallyLoc") && this.prev < o.finallyLoc) { var i = o; break; } } i && ("break" === t || "continue" === t) && i.tryLoc <= e && e <= i.finallyLoc && (i = null); var a = i ? i.completion : {}; return a.type = t, a.arg = e, i ? (this.method = "next", this.next = i.finallyLoc, y) : this.complete(a); }, complete: function complete(t, e) { if ("throw" === t.type) throw t.arg; return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), y; }, finish: function finish(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.finallyLoc === t) return this.complete(r.completion, r.afterLoc), resetTryEntry(r), y; } }, "catch": function _catch(t) { for (var e = this.tryEntries.length - 1; e >= 0; --e) { var r = this.tryEntries[e]; if (r.tryLoc === t) { var n = r.completion; if ("throw" === n.type) { var o = n.arg; resetTryEntry(r); } return o; } } throw Error("illegal catch attempt"); }, delegateYield: function delegateYield(e, r, n) { return this.delegate = { iterator: values(e), resultName: r, nextLoc: n }, "next" === this.method && (this.arg = t), y; } }, e; }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; }
function _classCallCheck(a, n) { if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function"); }
function _defineProperties(e, r) { for (var t = 0; t < r.length; t++) { var o = r[t]; o.enumerable = o.enumerable || !1, o.configurable = !0, "value" in o && (o.writable = !0), Object.defineProperty(e, _toPropertyKey(o.key), o); } }
function _createClass(e, r, t) { return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: !1 }), e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
var mongoose = require('mongoose');
var ObjectId = mongoose.Types.ObjectId;
var path = require('path');
var XLSX = require('xlsx');
if (process.env.NODE_ENV !== 'production') {
  require("dotenv").config();
}
var _require = require('@aws-sdk/client-s3'),
  S3Client = _require.S3Client,
  PutObjectCommand = _require.PutObjectCommand,
  DeleteObjectCommand = _require.DeleteObjectCommand;
var s3Client = new S3Client({
  region: process.env.AWSS3REGION,
  credentials: {
    accessKeyId: process.env.AWSACCESSKEY,
    secretAccessKey: process.env.AWSSECRETACCESSKEY
  }
});

/**
 * @param {string} bucketName - The name of the S3 bucket
 * @param {string} filePath - Local path of the file to upload
 * @param {string} key - The key (path) where the file will be stored in S3
 */
var AdminController = /*#__PURE__*/function () {
  function AdminController() {
    _classCallCheck(this, AdminController);
  }
  return _createClass(AdminController, [{
    key: "deleteAllProducts",
    value: function () {
      var _deleteAllProducts = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee(req, res) {
        var result, resultVariant;
        return _regeneratorRuntime().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              _context.prev = 0;
              _context.next = 3;
              return _newProduct["default"].deleteMany({});
            case 3:
              result = _context.sent;
              _context.next = 6;
              return _productVariant["default"].deleteMany({});
            case 6:
              resultVariant = _context.sent;
              if (!(result.deletedCount === 0 && resultVariant === 0)) {
                _context.next = 9;
                break;
              }
              return _context.abrupt("return", res.status(404).json({
                success: false,
                message: "No products found to delete"
              }));
            case 9:
              return _context.abrupt("return", res.status(200).json({
                success: true,
                message: "Successfully deleted ".concat(result.deletedCount, " products and ").concat(resultVariant.deletedCount, " variants"),
                deletedCount: result.deletedCount
              }));
            case 12:
              _context.prev = 12;
              _context.t0 = _context["catch"](0);
              console.error('Error in deleteAllProducts:', _context.t0);
              return _context.abrupt("return", res.status(500).json({
                success: false,
                message: "Error deleting products",
                error: _context.t0.message
              }));
            case 16:
            case "end":
              return _context.stop();
          }
        }, _callee, null, [[0, 12]]);
      }));
      function deleteAllProducts(_x, _x2) {
        return _deleteAllProducts.apply(this, arguments);
      }
      return deleteAllProducts;
    }()
  }, {
    key: "uploadExcelSheet",
    value: function () {
      var _uploadExcelSheet = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee2(req, res) {
        var filepath, excelSheetData;
        return _regeneratorRuntime().wrap(function _callee2$(_context2) {
          while (1) switch (_context2.prev = _context2.next) {
            case 0:
              _context2.prev = 0;
              if (req.file) {
                _context2.next = 3;
                break;
              }
              return _context2.abrupt("return", res.status(400).json({
                message: 'No file uploaded'
              }));
            case 3:
              filepath = req.file.path;
              excelSheetData = readExcelSheetFromFromPath(req.file.path);
              _context2.next = 7;
              return processExcelSheetData(excelSheetData, filepath);
            case 7:
              res.status(200).send({
                message: "Excel sheet uploaded successfully"
              });
              _context2.next = 14;
              break;
            case 10:
              _context2.prev = 10;
              _context2.t0 = _context2["catch"](0);
              console.log(_context2.t0);
              res.status(500).send({
                message: _context2.t0
              });
            case 14:
            case "end":
              return _context2.stop();
          }
        }, _callee2, null, [[0, 10]]);
      }));
      function uploadExcelSheet(_x3, _x4) {
        return _uploadExcelSheet.apply(this, arguments);
      }
      return uploadExcelSheet;
    }()
  }, {
    key: "addProduct",
    value: function () {
      var _addProduct = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee3(req, res, next) {
        var productName, product;
        return _regeneratorRuntime().wrap(function _callee3$(_context3) {
          while (1) switch (_context3.prev = _context3.next) {
            case 0:
              _context3.prev = 0;
              productName = req.body.productName;
              if (productName) {
                _context3.next = 4;
                break;
              }
              return _context3.abrupt("return", res.status(400).json({
                success: false,
                message: "Product name is required."
              }));
            case 4:
              product = new _newProduct["default"]({
                name: productName
              });
              _context3.next = 7;
              return product.save();
            case 7:
              res.status(201).send({
                success: true,
                message: "Product created successfully!",
                product: product
              });
              _axios["default"].post("".concat(process.env.LLM_SERVER, "/product/algolia/add?product_id=").concat(product._id))["catch"](function (error) {
                return console.error('Algolia sync failed:', error);
              });
              _context3.next = 17;
              break;
            case 11:
              _context3.prev = 11;
              _context3.t0 = _context3["catch"](0);
              console.log('error here', _context3.t0, 'error here');
              _context3.t0.statusCode = 400;
              _context3.t0.payoorDevErrorMessage = 'Failed to add product';
              next(_context3.t0);
            case 17:
            case "end":
              return _context3.stop();
          }
        }, _callee3, null, [[0, 11]]);
      }));
      function addProduct(_x5, _x6, _x7) {
        return _addProduct.apply(this, arguments);
      }
      return addProduct;
    }()
  }, {
    key: "addProductVariants",
    value: function () {
      var _addProductVariants = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee4(req, res, next) {
        var productId, _req$body, unit, price, isAvailable, product, productVariant;
        return _regeneratorRuntime().wrap(function _callee4$(_context4) {
          while (1) switch (_context4.prev = _context4.next) {
            case 0:
              _context4.prev = 0;
              productId = req.query.id;
              _req$body = req.body, unit = _req$body.unit, price = _req$body.price, isAvailable = _req$body.isAvailable;
              _context4.next = 5;
              return _newProduct["default"].findById(productId);
            case 5:
              product = _context4.sent;
              if (product) {
                _context4.next = 8;
                break;
              }
              return _context4.abrupt("return", res.status(404).json({
                success: false,
                message: "Product not found"
              }));
            case 8:
              if (!(!unit || !price || !isAvailable)) {
                _context4.next = 10;
                break;
              }
              return _context4.abrupt("return", res.status(400).json({
                success: false,
                message: "Values for fields (unit, price and isAvailable) are required."
              }));
            case 10:
              productVariant = new _productVariant["default"]({
                productId: product._id,
                unit: unit,
                price: price,
                availablility: isAvailable
              });
              _context4.next = 13;
              return productVariant.save();
            case 13:
              return _context4.abrupt("return", res.status(201).json({
                success: true,
                message: "Product variant added successfully",
                productVariant: productVariant
              }));
            case 16:
              _context4.prev = 16;
              _context4.t0 = _context4["catch"](0);
              console.log('error here', _context4.t0, 'error here');
              _context4.t0.statusCode = 400;
              _context4.t0.payoorDevErrorMessage = 'Failed to add product variant';
              next(_context4.t0);
            case 22:
            case "end":
              return _context4.stop();
          }
        }, _callee4, null, [[0, 16]]);
      }));
      function addProductVariants(_x8, _x9, _x10) {
        return _addProductVariants.apply(this, arguments);
      }
      return addProductVariants;
    }()
  }, {
    key: "getProducts",
    value: function () {
      var _getProducts = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee5(req, res, next) {
        var page, limit, skip, search, query, products, productIds, variants, productsWithVariants, totalCount;
        return _regeneratorRuntime().wrap(function _callee5$(_context5) {
          while (1) switch (_context5.prev = _context5.next) {
            case 0:
              _context5.prev = 0;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 20;
              skip = (page - 1) * limit;
              search = req.query.search || "";
              query = {};
              if (search) {
                query.name = {
                  $regex: search,
                  $options: "i"
                };
              }
              _context5.next = 9;
              return _newProduct["default"].find(query, {
                __v: 0
              }).skip(skip).limit(limit).lean();
            case 9:
              products = _context5.sent;
              console.log(products);
              productIds = products.map(function (product) {
                return product._id;
              });
              _context5.next = 14;
              return _productVariant["default"].find({
                productId: {
                  $in: productIds
                }
              }, {
                __v: 0
              }).lean();
            case 14:
              variants = _context5.sent;
              productsWithVariants = products.map(function (product) {
                return _objectSpread(_objectSpread({}, product), {}, {
                  variants: variants.filter(function (variant) {
                    return variant.productId.toString() === product._id.toString();
                  })
                });
              });
              _context5.next = 18;
              return _newProduct["default"].countDocuments(query);
            case 18:
              totalCount = _context5.sent;
              //console.log(products);

              res.status(200).send({
                message: "Products retrieved",
                page: page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount: totalCount,
                products: productsWithVariants
              });
              _context5.next = 28;
              break;
            case 22:
              _context5.prev = 22;
              _context5.t0 = _context5["catch"](0);
              console.log('error here', _context5.t0, 'error here');
              _context5.t0.statusCode = 400;
              _context5.t0.payoorDevErrorMessage = 'Failed to retrieve products';
              next(_context5.t0);
            case 28:
            case "end":
              return _context5.stop();
          }
        }, _callee5, null, [[0, 22]]);
      }));
      function getProducts(_x11, _x12, _x13) {
        return _getProducts.apply(this, arguments);
      }
      return getProducts;
    }()
  }, {
    key: "getProduct",
    value: function () {
      var _getProduct = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee6(req, res, next) {
        var id, product, productVariants, _id, name, image;
        return _regeneratorRuntime().wrap(function _callee6$(_context6) {
          while (1) switch (_context6.prev = _context6.next) {
            case 0:
              _context6.prev = 0;
              id = req.query.id;
              if (id) {
                _context6.next = 4;
                break;
              }
              return _context6.abrupt("return", res.status(400).send({
                message: "Product ID is required"
              }));
            case 4:
              _context6.next = 6;
              return _newProduct["default"].findById(id).lean();
            case 6:
              product = _context6.sent;
              if (product) {
                _context6.next = 9;
                break;
              }
              return _context6.abrupt("return", res.status(404).send({
                message: "Product not found"
              }));
            case 9:
              _context6.next = 11;
              return _productVariant["default"].find({
                productId: product._id
              }, {
                _id: 0,
                __v: 0,
                productId: 0
              }).lean();
            case 11:
              productVariants = _context6.sent;
              _id = product._id, name = product.name, image = product.image;
              res.status(200).send({
                _id: _id,
                name: name,
                image: image,
                variants: productVariants
              });
              _context6.next = 22;
              break;
            case 16:
              _context6.prev = 16;
              _context6.t0 = _context6["catch"](0);
              console.log('error here', _context6.t0, 'error here');
              _context6.t0.statusCode = 400;
              _context6.t0.payoorDevErrorMessage = 'Failed to retrieve product';
              next(_context6.t0);
            case 22:
            case "end":
              return _context6.stop();
          }
        }, _callee6, null, [[0, 16]]);
      }));
      function getProduct(_x14, _x15, _x16) {
        return _getProduct.apply(this, arguments);
      }
      return getProduct;
    }()
  }, {
    key: "updateProduct",
    value: function () {
      var _updateProduct = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee7(req, res, next) {
        var id, _req$body2, name, generatedDescription, generatedCategories, variants, product, productNameChanged, _iterator, _step, variantData, _id, unit, price, availability, variant, updatedVariants, updatedProduct;
        return _regeneratorRuntime().wrap(function _callee7$(_context7) {
          while (1) switch (_context7.prev = _context7.next) {
            case 0:
              _context7.prev = 0;
              id = req.query.id;
              _req$body2 = req.body, name = _req$body2.name, generatedDescription = _req$body2.generatedDescription, generatedCategories = _req$body2.generatedCategories, variants = _req$body2.variants;
              _context7.next = 5;
              return _newProduct["default"].findById(id, {
                __v: 0
              });
            case 5:
              product = _context7.sent;
              if (product) {
                _context7.next = 8;
                break;
              }
              return _context7.abrupt("return", res.status(404).json({
                success: false,
                message: 'Product not found'
              }));
            case 8:
              productNameChanged = product.name !== name;
              product.name = name !== null && name !== void 0 ? name : product.name;
              product.generatedDescription = generatedDescription !== null && generatedDescription !== void 0 ? generatedDescription : product.generatedDescription;
              product.generatedCategories = generatedCategories !== null && generatedCategories !== void 0 ? generatedCategories : product.generatedCategories;
              _context7.next = 14;
              return product.save();
            case 14:
              _iterator = _createForOfIteratorHelper(variants);
              _context7.prev = 15;
              _iterator.s();
            case 17:
              if ((_step = _iterator.n()).done) {
                _context7.next = 32;
                break;
              }
              variantData = _step.value;
              _id = variantData._id, unit = variantData.unit, price = variantData.price, availability = variantData.availability;
              _context7.next = 22;
              return _productVariant["default"].findById(_id);
            case 22:
              variant = _context7.sent;
              if (variant) {
                _context7.next = 25;
                break;
              }
              return _context7.abrupt("return", res.status(404).json({
                success: false,
                message: 'Product variant not found'
              }));
            case 25:
              variant.unit = unit !== null && unit !== void 0 ? unit : unit;
              variant.price = price !== null && price !== void 0 ? price : price;
              variant.availability = availability !== null && availability !== void 0 ? availability : availability;
              _context7.next = 30;
              return variant.save();
            case 30:
              _context7.next = 17;
              break;
            case 32:
              _context7.next = 37;
              break;
            case 34:
              _context7.prev = 34;
              _context7.t0 = _context7["catch"](15);
              _iterator.e(_context7.t0);
            case 37:
              _context7.prev = 37;
              _iterator.f();
              return _context7.finish(37);
            case 40:
              _context7.next = 42;
              return _productVariant["default"].find({
                productId: product._id
              }, {
                __v: 0
              }).lean();
            case 42:
              updatedVariants = _context7.sent;
              updatedProduct = _objectSpread(_objectSpread({}, product.toObject()), {}, {
                variants: updatedVariants
              });
              res.status(200).json({
                message: 'Product updated',
                product: updatedProduct
              });
              if (productNameChanged) {
                _axios["default"].put("".concat(process.env.LLM_SERVER, "/product/algolia/update"), {
                  product_id: id,
                  product_name: name
                })["catch"](function (error) {
                  return console.error('Algolia sync failed:', error);
                });
              }
              _context7.next = 54;
              break;
            case 48:
              _context7.prev = 48;
              _context7.t1 = _context7["catch"](0);
              console.log('error here', _context7.t1, 'error here');
              _context7.t1.statusCode = 400;
              _context7.t1.payoorDevErrorMessage = 'Failed to update product';
              next(_context7.t1);
            case 54:
            case "end":
              return _context7.stop();
          }
        }, _callee7, null, [[0, 48], [15, 34, 37, 40]]);
      }));
      function updateProduct(_x17, _x18, _x19) {
        return _updateProduct.apply(this, arguments);
      }
      return updateProduct;
    }()
  }, {
    key: "deleteProduct",
    value: function () {
      var _deleteProduct = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee8(req, res, next) {
        var productId, product;
        return _regeneratorRuntime().wrap(function _callee8$(_context8) {
          while (1) switch (_context8.prev = _context8.next) {
            case 0:
              _context8.prev = 0;
              productId = req.query.id;
              _context8.next = 4;
              return _newProduct["default"].findById(productId);
            case 4:
              product = _context8.sent;
              if (product) {
                _context8.next = 7;
                break;
              }
              return _context8.abrupt("return", res.status(404).send({
                message: "Product not found"
              }));
            case 7:
              _context8.next = 9;
              return _newProduct["default"].findByIdAndDelete(productId).lean();
            case 9:
              _context8.next = 11;
              return _productVariant["default"].deleteMany({
                productId: productId
              });
            case 11:
              res.status(200).send({
                message: "Product deleted successfully",
                product: product
              });
              _axios["default"]["delete"]("".concat(process.env.LLM_SERVER, "/product/algolia/delete?product_id=").concat(productId))["catch"](function (error) {
                return console.error('Algolia sync failed:', error);
              });
              _context8.next = 21;
              break;
            case 15:
              _context8.prev = 15;
              _context8.t0 = _context8["catch"](0);
              console.log('error here', _context8.t0, 'error here');
              _context8.t0.statusCode = 400;
              _context8.t0.payoorDevErrorMessage = 'Failed to delete product';
              next(_context8.t0);
            case 21:
            case "end":
              return _context8.stop();
          }
        }, _callee8, null, [[0, 15]]);
      }));
      function deleteProduct(_x20, _x21, _x22) {
        return _deleteProduct.apply(this, arguments);
      }
      return deleteProduct;
    }()
  }, {
    key: "deleteProductVariant",
    value: function () {
      var _deleteProductVariant = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee9(req, res, next) {
        var variantId, variant;
        return _regeneratorRuntime().wrap(function _callee9$(_context9) {
          while (1) switch (_context9.prev = _context9.next) {
            case 0:
              _context9.prev = 0;
              variantId = req.query.id;
              _context9.next = 4;
              return _productVariant["default"].findById(variantId);
            case 4:
              variant = _context9.sent;
              if (variant) {
                _context9.next = 7;
                break;
              }
              return _context9.abrupt("return", res.status(404).json({
                message: 'Variant not found'
              }));
            case 7:
              _context9.next = 9;
              return _productVariant["default"].findByIdAndDelete(variantId);
            case 9:
              res.status(200).json({
                message: 'Variant deleted successfully',
                variant: variant
              });
              _context9.next = 18;
              break;
            case 12:
              _context9.prev = 12;
              _context9.t0 = _context9["catch"](0);
              console.log('error here', _context9.t0, 'error here');
              _context9.t0.statusCode = 400;
              _context9.t0.payoorDevErrorMessage = 'Failed to delete product variant';
              next(_context9.t0);
            case 18:
            case "end":
              return _context9.stop();
          }
        }, _callee9, null, [[0, 12]]);
      }));
      function deleteProductVariant(_x23, _x24, _x25) {
        return _deleteProductVariant.apply(this, arguments);
      }
      return deleteProductVariant;
    }()
  }, {
    key: "uploadProductImage",
    value: function () {
      var _uploadProductImage = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee10(req, res, next) {
        var id, modelName, product, file, fileName, uploadParams, command, imageUrl, image;
        return _regeneratorRuntime().wrap(function _callee10$(_context10) {
          while (1) switch (_context10.prev = _context10.next) {
            case 0:
              _context10.prev = 0;
              if (req.file) {
                _context10.next = 3;
                break;
              }
              return _context10.abrupt("return", res.status(400).json({
                error: 'No file uploaded'
              }));
            case 3:
              id = req.query.id;
              modelName = req.body.modelName;
              if (!(modelName === 'newProduct')) {
                _context10.next = 11;
                break;
              }
              _context10.next = 8;
              return _newProduct["default"].findById(id);
            case 8:
              product = _context10.sent;
              _context10.next = 18;
              break;
            case 11:
              if (!(modelName === 'ProductVariant')) {
                _context10.next = 17;
                break;
              }
              _context10.next = 14;
              return _productVariant["default"].findById(id);
            case 14:
              product = _context10.sent;
              _context10.next = 18;
              break;
            case 17:
              return _context10.abrupt("return", res.status(404).send({
                message: "Invalid model name"
              }));
            case 18:
              if (product) {
                _context10.next = 20;
                break;
              }
              return _context10.abrupt("return", res.status(404).send({
                message: "Product not found"
              }));
            case 20:
              file = req.file;
              fileName = generateUniqueFileName(file.originalname);
              uploadParams = {
                Bucket: 'payoorimages',
                Key: "products/".concat(fileName),
                Body: file.buffer,
                ContentType: file.mimetype
              };
              command = new PutObjectCommand(uploadParams);
              _context10.next = 26;
              return s3Client.send(command);
            case 26:
              imageUrl = "https://payoorimages.s3.ap-southeast-2.amazonaws.com/products/".concat(fileName);
              image = new _image["default"]({
                imageUrl: imageUrl,
                modelName: modelName,
                modelId: id
              });
              _context10.next = 30;
              return image.save();
            case 30:
              product.image = imageUrl;
              _context10.next = 33;
              return product.save();
            case 33:
              res.status(200).send({
                message: "product image uploaded successfully",
                image: image
              });
              _context10.next = 41;
              break;
            case 36:
              _context10.prev = 36;
              _context10.t0 = _context10["catch"](0);
              console.log('error here', _context10.t0, 'error here');
              _context10.t0.payoorDevErrorMessage = 'Failed to upload product image';
              next(_context10.t0);
            case 41:
            case "end":
              return _context10.stop();
          }
        }, _callee10, null, [[0, 36]]);
      }));
      function uploadProductImage(_x26, _x27, _x28) {
        return _uploadProductImage.apply(this, arguments);
      }
      return uploadProductImage;
    }()
  }, {
    key: "getProductImages",
    value: function () {
      var _getProductImages = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee11(req, res, next) {
        var id, images;
        return _regeneratorRuntime().wrap(function _callee11$(_context11) {
          while (1) switch (_context11.prev = _context11.next) {
            case 0:
              _context11.prev = 0;
              id = req.query.id;
              _context11.next = 4;
              return _image["default"].find({
                modelId: id
              });
            case 4:
              images = _context11.sent;
              res.status(200).send({
                message: "images found",
                images: images,
                total: images.length
              });
              _context11.next = 13;
              break;
            case 8:
              _context11.prev = 8;
              _context11.t0 = _context11["catch"](0);
              console.log('error here', _context11.t0, 'error here');
              _context11.t0.payoorDevErrorMessage = 'Failed to retrieve product image';
              next(_context11.t0);
            case 13:
            case "end":
              return _context11.stop();
          }
        }, _callee11, null, [[0, 8]]);
      }));
      function getProductImages(_x29, _x30, _x31) {
        return _getProductImages.apply(this, arguments);
      }
      return getProductImages;
    }()
  }, {
    key: "deleteProductImage",
    value: function () {
      var _deleteProductImage = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee12(req, res, next) {
        var _req$query, id, isVariant, image, product, key, deleteCommand;
        return _regeneratorRuntime().wrap(function _callee12$(_context12) {
          while (1) switch (_context12.prev = _context12.next) {
            case 0:
              _context12.prev = 0;
              _req$query = req.query, id = _req$query.id, isVariant = _req$query.isVariant;
              if (id) {
                _context12.next = 4;
                break;
              }
              return _context12.abrupt("return", res.status(400).json({
                message: 'Image ID is required'
              }));
            case 4:
              if (!isVariant) {
                _context12.next = 8;
                break;
              }
              _context12.next = 7;
              return _image["default"].findOne({
                modelId: id
              });
            case 7:
              image = _context12.sent;
            case 8:
              if (isVariant) {
                _context12.next = 12;
                break;
              }
              _context12.next = 11;
              return _image["default"].findById(id);
            case 11:
              image = _context12.sent;
            case 12:
              if (image) {
                _context12.next = 14;
                break;
              }
              return _context12.abrupt("return", res.status(404).json({
                message: 'Image not found'
              }));
            case 14:
              if (!(image.modelName === 'newProduct')) {
                _context12.next = 18;
                break;
              }
              _context12.next = 17;
              return _newProduct["default"].findById(image.modelId);
            case 17:
              product = _context12.sent;
            case 18:
              if (!(image.modelName === 'ProductVariant')) {
                _context12.next = 22;
                break;
              }
              _context12.next = 21;
              return _productVariant["default"].findById(image.modelId);
            case 21:
              product = _context12.sent;
            case 22:
              if (product) {
                _context12.next = 24;
                break;
              }
              return _context12.abrupt("return", res.status(404).send({
                message: "Product not found"
              }));
            case 24:
              key = image.imageUrl.split('.com/').pop();
              deleteCommand = new DeleteObjectCommand({
                Bucket: 'payoorimages',
                Key: key
              });
              _context12.next = 28;
              return s3Client.send(deleteCommand);
            case 28:
              _context12.next = 30;
              return _image["default"].findOneAndDelete({
                modelId: product._id
              });
            case 30:
              product.image = "";
              _context12.next = 33;
              return product.save();
            case 33:
              res.status(200).json({
                message: 'Image deleted successfully',
                deletedImage: image
              });
              _context12.next = 41;
              break;
            case 36:
              _context12.prev = 36;
              _context12.t0 = _context12["catch"](0);
              console.log('error here', _context12.t0, 'error here');
              _context12.t0.payoorDevErrorMessage = 'Error deleteing image';
              next(_context12.t0);
            case 41:
            case "end":
              return _context12.stop();
          }
        }, _callee12, null, [[0, 36]]);
      }));
      function deleteProductImage(_x32, _x33, _x34) {
        return _deleteProductImage.apply(this, arguments);
      }
      return deleteProductImage;
    }()
  }, {
    key: "createAdmin",
    value: function () {
      var _createAdmin = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee13(req, res, next) {
        var _req$body3, username, password, existingAdmin, admin, token;
        return _regeneratorRuntime().wrap(function _callee13$(_context13) {
          while (1) switch (_context13.prev = _context13.next) {
            case 0:
              _context13.prev = 0;
              _req$body3 = req.body, username = _req$body3.username, password = _req$body3.password; // Validate input
              if (!(!username || !password)) {
                _context13.next = 4;
                break;
              }
              return _context13.abrupt("return", res.status(400).json({
                error: 'Username and password are required'
              }));
            case 4:
              _context13.next = 6;
              return _admin["default"].findOne({
                username: username
              });
            case 6:
              existingAdmin = _context13.sent;
              if (!existingAdmin) {
                _context13.next = 9;
                break;
              }
              return _context13.abrupt("return", res.status(400).json({
                error: 'Username already exists'
              }));
            case 9:
              // Create new admin
              admin = new _admin["default"]({
                username: username,
                password: password
              }); // Save admin and generate token
              _context13.next = 12;
              return admin.save();
            case 12:
              _context13.next = 14;
              return admin.generateAuthToken();
            case 14:
              token = _context13.sent;
              res.status(201).json({
                admin: admin,
                token: token
              });
              _context13.next = 24;
              break;
            case 18:
              _context13.prev = 18;
              _context13.t0 = _context13["catch"](0);
              console.log('error here', _context13.t0, 'error here');
              _context13.t0.statusCode = 400;
              _context13.t0.payoorDevErrorMessage = 'Failed to create admin';
              next(_context13.t0);
            case 24:
            case "end":
              return _context13.stop();
          }
        }, _callee13, null, [[0, 18]]);
      }));
      function createAdmin(_x35, _x36, _x37) {
        return _createAdmin.apply(this, arguments);
      }
      return createAdmin;
    }()
  }, {
    key: "signInAdmin",
    value: function () {
      var _signInAdmin = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee14(req, res, next) {
        var _req$body4, username, password, admin, token;
        return _regeneratorRuntime().wrap(function _callee14$(_context14) {
          while (1) switch (_context14.prev = _context14.next) {
            case 0:
              _context14.prev = 0;
              console.log(req.body);
              _req$body4 = req.body, username = _req$body4.username, password = _req$body4.password; // Validate input
              if (!(!username || !password)) {
                _context14.next = 5;
                break;
              }
              return _context14.abrupt("return", res.status(400).json({
                error: 'Username and password are required'
              }));
            case 5:
              _context14.next = 7;
              return _admin["default"].findByCredentials(username, password);
            case 7:
              admin = _context14.sent;
              _context14.next = 10;
              return admin.generateAuthToken();
            case 10:
              token = _context14.sent;
              res.json({
                admin: admin,
                token: token
              });
              _context14.next = 20;
              break;
            case 14:
              _context14.prev = 14;
              _context14.t0 = _context14["catch"](0);
              console.log('error here', _context14.t0, 'error here');
              _context14.t0.statusCode = 401;
              _context14.t0.payoorDevErrorMessage = 'Invalid login credentials';
              next(_context14.t0);
            case 20:
            case "end":
              return _context14.stop();
          }
        }, _callee14, null, [[0, 14]]);
      }));
      function signInAdmin(_x38, _x39, _x40) {
        return _signInAdmin.apply(this, arguments);
      }
      return signInAdmin;
    }()
  }, {
    key: "deleteAdmin",
    value: function () {
      var _deleteAdmin = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee15(req, res, next) {
        var adminId, adminCount, adminToDelete;
        return _regeneratorRuntime().wrap(function _callee15$(_context15) {
          while (1) switch (_context15.prev = _context15.next) {
            case 0:
              _context15.prev = 0;
              adminId = req.params.adminId; // Check if trying to delete self
              if (!(adminId === req.admin._id.toString())) {
                _context15.next = 4;
                break;
              }
              return _context15.abrupt("return", res.status(400).json({
                error: 'Cannot delete your own admin account'
              }));
            case 4:
              _context15.next = 6;
              return _admin["default"].countDocuments({});
            case 6:
              adminCount = _context15.sent;
              if (!(adminCount <= 1)) {
                _context15.next = 9;
                break;
              }
              return _context15.abrupt("return", res.status(400).json({
                error: 'Cannot delete the last admin account'
              }));
            case 9:
              _context15.next = 11;
              return _admin["default"].findById(adminId);
            case 11:
              adminToDelete = _context15.sent;
              if (adminToDelete) {
                _context15.next = 14;
                break;
              }
              return _context15.abrupt("return", res.status(404).json({
                error: 'Admin not found'
              }));
            case 14:
              _context15.next = 16;
              return _admin["default"].findByIdAndDelete(adminId);
            case 16:
              res.json({
                message: 'Admin deleted successfully',
                deletedAdmin: adminToDelete.username
              });
              _context15.next = 25;
              break;
            case 19:
              _context15.prev = 19;
              _context15.t0 = _context15["catch"](0);
              console.log('error here', _context15.t0, 'error here');
              _context15.t0.statusCode = 400;
              _context15.t0.payoorDevErrorMessage = 'Failed to delete admin';
              next(_context15.t0);
            case 25:
            case "end":
              return _context15.stop();
          }
        }, _callee15, null, [[0, 19]]);
      }));
      function deleteAdmin(_x41, _x42, _x43) {
        return _deleteAdmin.apply(this, arguments);
      }
      return deleteAdmin;
    }() // Optional: Add a method to get all admins for reference
  }, {
    key: "getAllAdmins",
    value: function () {
      var _getAllAdmins = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee16(req, res, next) {
        var admins;
        return _regeneratorRuntime().wrap(function _callee16$(_context16) {
          while (1) switch (_context16.prev = _context16.next) {
            case 0:
              _context16.prev = 0;
              _context16.next = 3;
              return _admin["default"].find({}, 'username _id');
            case 3:
              admins = _context16.sent;
              res.json(admins);
              _context16.next = 13;
              break;
            case 7:
              _context16.prev = 7;
              _context16.t0 = _context16["catch"](0);
              console.log('error here', _context16.t0, 'error here');
              _context16.t0.statusCode = 400;
              _context16.t0.payoorDevErrorMessage = 'Failed to fetch admins';
              next(_context16.t0);
            case 13:
            case "end":
              return _context16.stop();
          }
        }, _callee16, null, [[0, 7]]);
      }));
      function getAllAdmins(_x44, _x45, _x46) {
        return _getAllAdmins.apply(this, arguments);
      }
      return getAllAdmins;
    }()
  }, {
    key: "getUsers",
    value: function () {
      var _getUsers = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee17(req, res, next) {
        var page, limit, skip, search, query, users, totalCount;
        return _regeneratorRuntime().wrap(function _callee17$(_context17) {
          while (1) switch (_context17.prev = _context17.next) {
            case 0:
              _context17.prev = 0;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 10;
              skip = (page - 1) * limit;
              search = req.query.search || "";
              query = {};
              if (search) {
                query.name = {
                  $regex: search,
                  $options: "i"
                };
              }
              _context17.next = 9;
              return _user["default"].find(query, '_id email name phoneNumber').skip(skip).limit(limit).lean();
            case 9:
              users = _context17.sent;
              _context17.next = 12;
              return _user["default"].countDocuments(query);
            case 12:
              totalCount = _context17.sent;
              res.status(200).send({
                message: "Users retrieved",
                page: page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount: totalCount,
                users: users
              });
              _context17.next = 21;
              break;
            case 16:
              _context17.prev = 16;
              _context17.t0 = _context17["catch"](0);
              console.log('error here', _context17.t0, 'error here');
              _context17.t0.payoorDevErrorMessage = 'Failed to retrieve users';
              next(_context17.t0);
            case 21:
            case "end":
              return _context17.stop();
          }
        }, _callee17, null, [[0, 16]]);
      }));
      function getUsers(_x47, _x48, _x49) {
        return _getUsers.apply(this, arguments);
      }
      return getUsers;
    }()
  }, {
    key: "getUser",
    value: function () {
      var _getUser = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee18(req, res, next) {
        var id, user, userResponse, response;
        return _regeneratorRuntime().wrap(function _callee18$(_context18) {
          while (1) switch (_context18.prev = _context18.next) {
            case 0:
              _context18.prev = 0;
              id = req.query.id;
              if (id) {
                _context18.next = 4;
                break;
              }
              return _context18.abrupt("return", res.status(400).send({
                message: "User ID is required"
              }));
            case 4:
              _context18.next = 6;
              return _user["default"].findById(id).lean();
            case 6:
              user = _context18.sent;
              if (user) {
                _context18.next = 9;
                break;
              }
              return _context18.abrupt("return", res.status(404).send({
                message: "User not found"
              }));
            case 9:
              userResponse = {
                name: user.name,
                email: user.email,
                phoneNumber: user.phoneNumber,
                isVerified: user.isVerified,
                hasBeenWelcomed: user.hasBeenWelcomed
              };
              response = {
                success: true,
                data: {
                  message: 'User found',
                  user: userResponse
                }
              };
              res.status(200).send(response);
              _context18.next = 19;
              break;
            case 14:
              _context18.prev = 14;
              _context18.t0 = _context18["catch"](0);
              console.log('error here', _context18.t0, 'error here');
              _context18.t0.payoorDevErrorMessage = 'Failed to retrieve user';
              next(_context18.t0);
            case 19:
            case "end":
              return _context18.stop();
          }
        }, _callee18, null, [[0, 14]]);
      }));
      function getUser(_x50, _x51, _x52) {
        return _getUser.apply(this, arguments);
      }
      return getUser;
    }()
  }, {
    key: "getTransactions",
    value: function () {
      var _getTransactions = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee19(req, res, next) {
        var page, limit, skip, search, status, query, initiators, initiatorIds, transactions, totalCount;
        return _regeneratorRuntime().wrap(function _callee19$(_context19) {
          while (1) switch (_context19.prev = _context19.next) {
            case 0:
              _context19.prev = 0;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 10;
              skip = (page - 1) * limit;
              search = req.query.search || "";
              status = req.query.status || "";
              query = {};
              if (status) {
                query.status = status;
              }
              if (!search) {
                _context19.next = 14;
                break;
              }
              _context19.next = 11;
              return _user["default"].find({
                name: {
                  $regex: search,
                  $options: "i"
                }
              }, {
                _id: 1
              });
            case 11:
              initiators = _context19.sent;
              initiatorIds = initiators.map(function (user) {
                return user._id;
              });
              if (initiatorIds.length) {
                query.initiatorId = {
                  $in: initiatorIds
                };
              }
            case 14:
              _context19.next = 16;
              return _transaction["default"].find(query, {
                __v: 0,
                updatedAt: 0
              }).populate('initiatorId', 'name -_id').sort({
                createdAt: -1
              }).skip(skip).limit(limit).lean();
            case 16:
              transactions = _context19.sent;
              _context19.next = 19;
              return _transaction["default"].countDocuments(query);
            case 19:
              totalCount = _context19.sent;
              res.status(200).send({
                message: "Transactions retrieved",
                page: page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount: totalCount,
                transactions: transactions
              });
              _context19.next = 28;
              break;
            case 23:
              _context19.prev = 23;
              _context19.t0 = _context19["catch"](0);
              console.log('error here', _context19.t0, 'error here');
              _context19.t0.payoorDevErrorMessage = 'Failed to retrieve transactions';
              next(_context19.t0);
            case 28:
            case "end":
              return _context19.stop();
          }
        }, _callee19, null, [[0, 23]]);
      }));
      function getTransactions(_x53, _x54, _x55) {
        return _getTransactions.apply(this, arguments);
      }
      return getTransactions;
    }()
  }, {
    key: "getTransaction",
    value: function () {
      var _getTransaction = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee20(req, res, next) {
        var transactionId, transaction;
        return _regeneratorRuntime().wrap(function _callee20$(_context20) {
          while (1) switch (_context20.prev = _context20.next) {
            case 0:
              _context20.prev = 0;
              transactionId = req.query.id;
              if (transactionId) {
                _context20.next = 4;
                break;
              }
              return _context20.abrupt("return", res.status(400).send({
                message: "Transaction ID is required"
              }));
            case 4:
              _context20.next = 6;
              return _transaction["default"].findById(transactionId, {
                __v: 0,
                updatedAt: 0
              }).lean();
            case 6:
              transaction = _context20.sent;
              if (transaction) {
                _context20.next = 9;
                break;
              }
              return _context20.abrupt("return", res.status(404).json({
                success: false,
                message: 'Transaction not found'
              }));
            case 9:
              res.status(200).send({
                success: true,
                data: {
                  message: 'Transaction found',
                  transaction: transaction
                }
              });
              _context20.next = 17;
              break;
            case 12:
              _context20.prev = 12;
              _context20.t0 = _context20["catch"](0);
              console.log('error here', _context20.t0, 'error here');
              _context20.t0.payoorDevErrorMessage = 'Failed to retrieve transaction';
              next(_context20.t0);
            case 17:
            case "end":
              return _context20.stop();
          }
        }, _callee20, null, [[0, 12]]);
      }));
      function getTransaction(_x56, _x57, _x58) {
        return _getTransaction.apply(this, arguments);
      }
      return getTransaction;
    }()
  }, {
    key: "getUserTransactions",
    value: function () {
      var _getUserTransactions = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee21(req, res, next) {
        var userId, page, limit, skip, transactions, totalCount;
        return _regeneratorRuntime().wrap(function _callee21$(_context21) {
          while (1) switch (_context21.prev = _context21.next) {
            case 0:
              _context21.prev = 0;
              userId = req.query.userId;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 10;
              skip = (page - 1) * limit;
              _context21.next = 7;
              return _transaction["default"].find({
                initiatorId: userId
              }, {
                __v: 0,
                updatedAt: 0
              }).sort({
                createdAt: -1
              }).skip(skip).limit(limit).lean();
            case 7:
              transactions = _context21.sent;
              totalCount = transactions.length;
              res.status(200).send({
                message: "Transactions retrieved",
                page: page,
                totalPages: Math.ceil(totalCount / limit),
                totalCount: totalCount,
                transactions: transactions
              });
              _context21.next = 17;
              break;
            case 12:
              _context21.prev = 12;
              _context21.t0 = _context21["catch"](0);
              console.log('error here', _context21.t0, 'error here');
              _context21.t0.payoorDevErrorMessage = 'Failed to retrieve transactions';
              next(_context21.t0);
            case 17:
            case "end":
              return _context21.stop();
          }
        }, _callee21, null, [[0, 12]]);
      }));
      function getUserTransactions(_x59, _x60, _x61) {
        return _getUserTransactions.apply(this, arguments);
      }
      return getUserTransactions;
    }()
  }, {
    key: "getOrders",
    value: function () {
      var _getOrders = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee22(req, res, next) {
        var page, limit, skip, search, status, query, users, userIds, orders, total;
        return _regeneratorRuntime().wrap(function _callee22$(_context22) {
          while (1) switch (_context22.prev = _context22.next) {
            case 0:
              _context22.prev = 0;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 10;
              skip = (page - 1) * limit;
              search = req.query.search || "";
              status = req.query.status || "";
              query = {};
              if (status) {
                query.status = status;
              }
              if (!search) {
                _context22.next = 14;
                break;
              }
              _context22.next = 11;
              return _user["default"].find({
                name: {
                  $regex: search,
                  $options: "i"
                }
              }, {
                _id: 1
              });
            case 11:
              users = _context22.sent;
              userIds = users.map(function (user) {
                return user._id;
              });
              if (userIds.length) {
                query.userId = {
                  $in: userIds
                };
              }
            case 14:
              _context22.next = 16;
              return _order["default"].find(query, {
                __v: 0
              }).populate('userId', 'name -_id').sort({
                createdAt: -1
              }).skip(skip).limit(limit);
            case 16:
              orders = _context22.sent;
              _context22.next = 19;
              return _order["default"].countDocuments(query);
            case 19:
              total = _context22.sent;
              res.status(200).json({
                message: 'Orders retrieved',
                page: page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: orders
              });
              _context22.next = 28;
              break;
            case 23:
              _context22.prev = 23;
              _context22.t0 = _context22["catch"](0);
              console.log('error here', _context22.t0, 'error here');
              _context22.t0.payoorDevErrorMessage = 'Failed to retrieve orders';
              next(_context22.t0);
            case 28:
            case "end":
              return _context22.stop();
          }
        }, _callee22, null, [[0, 23]]);
      }));
      function getOrders(_x62, _x63, _x64) {
        return _getOrders.apply(this, arguments);
      }
      return getOrders;
    }()
  }, {
    key: "getUserOrders",
    value: function () {
      var _getUserOrders = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee23(req, res, next) {
        var userId, page, limit, skip, orders, total;
        return _regeneratorRuntime().wrap(function _callee23$(_context23) {
          while (1) switch (_context23.prev = _context23.next) {
            case 0:
              _context23.prev = 0;
              userId = req.query.userId;
              page = parseInt(req.query.page) || 1;
              limit = parseInt(req.query.limit) || 10;
              skip = (page - 1) * limit;
              _context23.next = 7;
              return _order["default"].find({
                userId: userId
              }, {
                __v: 0
              }).sort({
                createdAt: -1
              }).skip(skip).limit(limit);
            case 7:
              orders = _context23.sent;
              total = orders.length;
              res.status(200).json({
                message: 'Orders retrieved',
                page: page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: orders
              });
              _context23.next = 17;
              break;
            case 12:
              _context23.prev = 12;
              _context23.t0 = _context23["catch"](0);
              console.log('error here', _context23.t0, 'error here');
              _context23.t0.payoorDevErrorMessage = 'Failed to retrieve users';
              next(_context23.t0);
            case 17:
            case "end":
              return _context23.stop();
          }
        }, _callee23, null, [[0, 12]]);
      }));
      function getUserOrders(_x65, _x66, _x67) {
        return _getUserOrders.apply(this, arguments);
      }
      return getUserOrders;
    }()
  }, {
    key: "getOrder",
    value: function () {
      var _getOrder = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee24(req, res, next) {
        var orderId, order;
        return _regeneratorRuntime().wrap(function _callee24$(_context24) {
          while (1) switch (_context24.prev = _context24.next) {
            case 0:
              _context24.prev = 0;
              orderId = req.query.id;
              _context24.next = 4;
              return _order["default"].findById(orderId).populate('userId', 'name email');
            case 4:
              order = _context24.sent;
              if (order) {
                _context24.next = 7;
                break;
              }
              return _context24.abrupt("return", res.status(404).json({
                success: false,
                message: 'Order not found'
              }));
            case 7:
              res.status(200).json({
                success: true,
                data: order
              });
              _context24.next = 15;
              break;
            case 10:
              _context24.prev = 10;
              _context24.t0 = _context24["catch"](0);
              console.log('error here', _context24.t0, 'error here');
              _context24.t0.payoorDevErrorMessage = 'Failed to retrieve users';
              next(_context24.t0);
            case 15:
            case "end":
              return _context24.stop();
          }
        }, _callee24, null, [[0, 10]]);
      }));
      function getOrder(_x68, _x69, _x70) {
        return _getOrder.apply(this, arguments);
      }
      return getOrder;
    }()
  }, {
    key: "deleteOneUser",
    value: function () {
      var _deleteOneUser = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee25(req, res, next) {
        var userId, deletedUser;
        return _regeneratorRuntime().wrap(function _callee25$(_context25) {
          while (1) switch (_context25.prev = _context25.next) {
            case 0:
              _context25.prev = 0;
              userId = req.query.userId;
              _context25.next = 4;
              return _user["default"].findByIdAndDelete(userId);
            case 4:
              deletedUser = _context25.sent;
              if (deletedUser) {
                _context25.next = 7;
                break;
              }
              return _context25.abrupt("return", res.status(404).json({
                message: 'User not found'
              }));
            case 7:
              res.status(200).json({
                message: 'User deleted successfully'
              });
              _context25.next = 15;
              break;
            case 10:
              _context25.prev = 10;
              _context25.t0 = _context25["catch"](0);
              console.log('error here', _context25.t0, 'error here');
              _context25.t0.payoorDevErrorMessage = 'Error deleting user';
              next(_context25.t0);
            case 15:
            case "end":
              return _context25.stop();
          }
        }, _callee25, null, [[0, 10]]);
      }));
      function deleteOneUser(_x71, _x72, _x73) {
        return _deleteOneUser.apply(this, arguments);
      }
      return deleteOneUser;
    }()
  }, {
    key: "getDashboardAggregateData",
    value: function () {
      var _getDashboardAggregateData = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee26(req, res, next) {
        var availableProductsCount, pendingOrdersCount, completedOrdersCount, pendingTransactionsCount, verifiedTransactionsCount, usersCount;
        return _regeneratorRuntime().wrap(function _callee26$(_context26) {
          while (1) switch (_context26.prev = _context26.next) {
            case 0:
              _context26.prev = 0;
              _context26.next = 3;
              return _productVariant["default"].countDocuments({
                availability: 'YES'
              });
            case 3:
              availableProductsCount = _context26.sent;
              _context26.next = 6;
              return _order["default"].countDocuments({
                status: 'pending'
              });
            case 6:
              pendingOrdersCount = _context26.sent;
              _context26.next = 9;
              return _order["default"].countDocuments({
                status: 'completed'
              });
            case 9:
              completedOrdersCount = _context26.sent;
              _context26.next = 12;
              return _transaction["default"].countDocuments({
                status: 'pending'
              });
            case 12:
              pendingTransactionsCount = _context26.sent;
              _context26.next = 15;
              return _transaction["default"].countDocuments({
                status: 'verified'
              });
            case 15:
              verifiedTransactionsCount = _context26.sent;
              _context26.next = 18;
              return _user["default"].countDocuments();
            case 18:
              usersCount = _context26.sent;
              res.status(200).send({
                message: "Dashboard data retrieved",
                numberOfAvailableProducts: availableProductsCount,
                numberOfPendingOrders: pendingOrdersCount,
                numberOfCompletedOrders: completedOrdersCount,
                numberOfPendingTransactions: pendingTransactionsCount,
                numberOfVerifiedTransactions: verifiedTransactionsCount,
                numberOfUsers: usersCount
              });
              _context26.next = 27;
              break;
            case 22:
              _context26.prev = 22;
              _context26.t0 = _context26["catch"](0);
              console.log('error here', _context26.t0, 'error here');
              _context26.t0.payoorDevErrorMessage = 'Failed to retrieve dashboard data';
              next(_context26.t0);
            case 27:
            case "end":
              return _context26.stop();
          }
        }, _callee26, null, [[0, 22]]);
      }));
      function getDashboardAggregateData(_x74, _x75, _x76) {
        return _getDashboardAggregateData.apply(this, arguments);
      }
      return getDashboardAggregateData;
    }()
  }, {
    key: "getAffiliates",
    value: function () {
      var _getAffiliates = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee27(req, res, next) {
        var affiltes;
        return _regeneratorRuntime().wrap(function _callee27$(_context27) {
          while (1) switch (_context27.prev = _context27.next) {
            case 0:
              _context27.prev = 0;
              _context27.next = 3;
              return _affiliate["default"].find({});
            case 3:
              affiltes = _context27.sent;
              //console.log(affiltes)
              res.status(200).json({
                affiliates: affiltes
              });
              _context27.next = 12;
              break;
            case 7:
              _context27.prev = 7;
              _context27.t0 = _context27["catch"](0);
              console.log('error here', _context27.t0, 'error here');
              _context27.t0.payoorDevErrorMessage = 'Error deleting user';
              next(_context27.t0);
            case 12:
            case "end":
              return _context27.stop();
          }
        }, _callee27, null, [[0, 7]]);
      }));
      function getAffiliates(_x77, _x78, _x79) {
        return _getAffiliates.apply(this, arguments);
      }
      return getAffiliates;
    }()
  }, {
    key: "toggleAffiliateActiveState",
    value: function () {
      var _toggleAffiliateActiveState = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee28(req, res, next) {
        var _req$body5, affiliate_id, email, isActive, activeStatus, updatedAffiliate, couponCode, affiliateCoupon, couponObjectId, coupons, deleteResult;
        return _regeneratorRuntime().wrap(function _callee28$(_context28) {
          while (1) switch (_context28.prev = _context28.next) {
            case 0:
              _context28.prev = 0;
              _req$body5 = req.body, affiliate_id = _req$body5.affiliate_id, email = _req$body5.email, isActive = _req$body5.isActive;
              activeStatus = typeof isActive === 'string' ? isActive === 'true' : Boolean(isActive);
              _context28.next = 5;
              return _affiliate["default"].findOneAndUpdate({
                _id: affiliate_id
              }, {
                isActive: activeStatus
              }, {
                "new": true
              });
            case 5:
              updatedAffiliate = _context28.sent;
              if (updatedAffiliate) {
                _context28.next = 8;
                break;
              }
              return _context28.abrupt("return", res.status(404).json({
                success: false,
                message: 'Affiliate not found'
              }));
            case 8:
              if (!activeStatus) {
                _context28.next = 21;
                break;
              }
              _context28.next = 11;
              return (0, _generateOTP["default"])();
            case 11:
              couponCode = _context28.sent;
              affiliateCoupon = new _coupon["default"]({
                code: couponCode,
                email: email,
                affiliate: affiliate_id,
                type: 'affiliate program',
                metadata: {
                  email: email,
                  type: 'affiliate program'
                }
              });
              _context28.next = 15;
              return affiliateCoupon.save();
            case 15:
              _context28.next = 17;
              return (0, _sendAffiliateActiveStatus["default"])({
                email: email,
                affiliateCode: affiliateCoupon.code
              });
            case 17:
              _context28.next = 19;
              return _affiliate["default"].findOneAndUpdate({
                _id: affiliate_id
              }, {
                coupon: affiliateCoupon.code
              }, {
                "new": true
              });
            case 19:
              _context28.next = 43;
              break;
            case 21:
              _context28.prev = 21;
              couponObjectId = typeof affiliate_id === 'string' ? new ObjectId(affiliate_id) : affiliate_id;
              _context28.next = 25;
              return _coupon["default"].find({
                affiliate: couponObjectId
              });
            case 25:
              coupons = _context28.sent;
              if (!(coupons.length === 0)) {
                _context28.next = 31;
                break;
              }
              _context28.next = 29;
              return (0, _sendAffiliateDeactivation["default"])({
                email: email,
                affiliateCode: "N/A",
                reason: "Account deactivated"
              });
            case 29:
              _context28.next = 37;
              break;
            case 31:
              _context28.next = 33;
              return _coupon["default"].deleteMany({
                affiliate: couponObjectId
              });
            case 33:
              deleteResult = _context28.sent;
              console.log("Deleted ".concat(deleteResult.deletedCount, " coupons for affiliate ").concat(affiliate_id));
              _context28.next = 37;
              return (0, _sendAffiliateDeactivation["default"])({
                email: email,
                affiliateCode: coupons[0].code,
                reason: "Account deactivated"
              });
            case 37:
              _context28.next = 43;
              break;
            case 39:
              _context28.prev = 39;
              _context28.t0 = _context28["catch"](21);
              console.error('Error during coupon deactivation:', _context28.t0);
              throw new Error("Failed to deactivate affiliate coupons: ".concat(_context28.t0.message));
            case 43:
              return _context28.abrupt("return", res.status(200).json({
                success: true,
                message: "Affiliate status updated to ".concat(activeStatus ? 'active' : 'inactive'),
                affiliate: updatedAffiliate
              }));
            case 46:
              _context28.prev = 46;
              _context28.t1 = _context28["catch"](0);
              console.log('error here', _context28.t1, 'error here');
              _context28.t1.payoorDevErrorMessage = 'Error updating affiliate active status';
              next(_context28.t1);
            case 51:
            case "end":
              return _context28.stop();
          }
        }, _callee28, null, [[0, 46], [21, 39]]);
      }));
      function toggleAffiliateActiveState(_x80, _x81, _x82) {
        return _toggleAffiliateActiveState.apply(this, arguments);
      }
      return toggleAffiliateActiveState;
    }()
  }]);
}();
var _default = exports["default"] = new AdminController();
function readExcelSheetFromFromPath(filepath) {
  var filePath = path.resolve(filepath);
  var workbook = XLSX.readFile(filePath);
  var sheetName = workbook.SheetNames[0];
  var worksheet = workbook.Sheets[sheetName];
  var excelSheetData = XLSX.utils.sheet_to_json(worksheet);
  return excelSheetData;
}
function processExcelSheetData(_x83, _x84) {
  return _processExcelSheetData.apply(this, arguments);
}
function _processExcelSheetData() {
  _processExcelSheetData = _asyncToGenerator(/*#__PURE__*/_regeneratorRuntime().mark(function _callee29(excelSheetData, filepath) {
    var index, productData;
    return _regeneratorRuntime().wrap(function _callee29$(_context29) {
      while (1) switch (_context29.prev = _context29.next) {
        case 0:
          _context29.t0 = _regeneratorRuntime().keys(excelSheetData);
        case 1:
          if ((_context29.t1 = _context29.t0()).done) {
            _context29.next = 8;
            break;
          }
          index = _context29.t1.value;
          productData = new _product["default"]({
            filepath: filepath,
            data: excelSheetData[index]
          });
          _context29.next = 6;
          return productData.save();
        case 6:
          _context29.next = 1;
          break;
        case 8:
        case "end":
          return _context29.stop();
      }
    }, _callee29);
  }));
  return _processExcelSheetData.apply(this, arguments);
}
var generateUniqueFileName = function generateUniqueFileName(originalname) {
  var timestamp = Date.now();
  var extension = originalname.split('.').pop();
  return "".concat(timestamp, "-").concat(Math.random().toString(36).substring(2, 15), ".").concat(extension);
};