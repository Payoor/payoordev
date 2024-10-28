"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
function sanitizeId(id) {
  return id.replace(/[^\w\s]/gi, ''); // Example: removes special characters
}
var _default = exports["default"] = sanitizeId;