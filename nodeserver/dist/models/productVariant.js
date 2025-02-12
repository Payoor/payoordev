"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var productVariant = new _db["default"].Schema({
  productId: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'newProduct',
    required: true
  },
  image: {
    type: String,
    "default": ""
  },
  unit: {
    type: String,
    required: true,
    "default": ""
  },
  price: {
    type: Number,
    required: true,
    "default": 0
  },
  availability: {
    type: String,
    required: true,
    "default": "YES"
  }
}, {
  timestamps: false
});
module.exports = _db["default"].model('ProductVariant', productVariant);