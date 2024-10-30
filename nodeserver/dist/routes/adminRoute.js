"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _express = _interopRequireDefault(require("express"));
var _multer = _interopRequireDefault(require("multer"));
var _adminController = _interopRequireDefault(require("../controllers/adminController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var adminRoute = (0, _express["default"])();
function uploadFileWithMulter(storagepath) {
  var storage = _multer["default"].diskStorage({
    destination: function destination(req, file, cb) {
      cb(null, storagepath);
    },
    filename: function filename(req, file, cb) {
      cb(null, "".concat(Date.now(), "-").concat(file.originalname));
    }
  });
  return (0, _multer["default"])({
    storage: storage
  });
}
adminRoute.post('/admin/upload/products/excel', uploadFileWithMulter("files/excel").single('file'), _adminController["default"].uploadExcelSheet);
adminRoute.get('/admin/get/products', _adminController["default"].getProducts);
var _default = exports["default"] = adminRoute;