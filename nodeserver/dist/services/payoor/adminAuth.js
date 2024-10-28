"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _admin = _interopRequireDefault(require("../../models/admin"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var adminAuth = function adminAuth(req, res, next) {
  var token = req.header('x-auth');
  _admin["default"].findByToken(token).then(function (admin) {
    if (!admin) {
      return Promise.reject();
    }
    req.admin = admin;
    req.token = token;
    next();
  })["catch"](function (e) {
    res.status(401).send();
  });
};
var _default = exports["default"] = adminAuth;