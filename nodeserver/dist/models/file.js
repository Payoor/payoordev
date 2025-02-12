"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var fileSchema = new _db["default"].Schema({
  uploadedAt: {
    type: Date,
    "default": Date.now
  },
  uploadedBy: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  url: {
    type: String,
    required: true
  },
  filePath: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});
var File = _db["default"].model('File', fileSchema);
module.exports = File;