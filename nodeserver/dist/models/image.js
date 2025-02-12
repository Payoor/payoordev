"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var imageSchema = new _db["default"].Schema({
  imageUrl: {
    type: String,
    required: true
  },
  modelName: {
    type: String,
    "enum": ['newProduct', 'ProductVariant'],
    "default": 'newProduct'
  },
  modelId: {
    type: _db["default"].Schema.Types.ObjectId,
    refPath: 'modelName',
    required: true
  }
}, {
  timestamps: true
});
module.exports = _db["default"].model('Image', imageSchema);