"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var productSchema = new _db["default"].Schema({
  product_name: {
    type: String
  },
  data: {
    type: _db["default"].Schema.Types.Mixed,
    "default": {}
  },
  images: {
    type: [String],
    "default": []
  },
  generatedDescription: {
    type: String,
    "default": ""
  },
  generatedCategories: {
    type: [String],
    "default": []
  }
}, {
  timestamps: true
});
productSchema.index({
  'data.NAME': 'text'
});
productSchema.index({
  'data.AVAILABILITY': 1,
  'data.UNIT': 1
});
module.exports = _db["default"].model('Product', productSchema);