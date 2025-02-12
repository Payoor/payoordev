"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var newProductSchema = new _db["default"].Schema({
  name: {
    type: String
  },
  image: {
    type: String,
    "default": ""
  },
  generatedDescription: {
    type: String,
    "default": ""
  },
  generatedCategories: {
    type: [String],
    "default": []
  },
  synced_to_algolia: {
    type: Boolean,
    "default": false
  },
  variantCount: {
    type: Number,
    "default": 0
  }
}, {
  timestamps: true
});
newProductSchema.index({
  name: 'text'
});
module.exports = _db["default"].model('newProduct', newProductSchema);