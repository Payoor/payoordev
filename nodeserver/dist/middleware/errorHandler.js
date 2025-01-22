"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _winstonLogger = _interopRequireDefault(require("../configs/winstonLogger"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var errorHandler = function errorHandler(err, req, res, next) {
  _winstonLogger["default"].error('Unhandled error:', {
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    body: req.body
  });
  var statusCode = err.statusCode || 500;
  return res.status(statusCode).json({
    error: err.payoorDevErrorMessage ? err.payoorDevErrorMessage : 'Internal Server Error',
    message: err.message
  });
};
var _default = exports["default"] = errorHandler;