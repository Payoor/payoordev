"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var AffiliateSchema = new _db["default"].Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    unique: false
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  socialmedia: {
    type: String
  },
  phonenumber: {
    type: String,
    required: true
  },
  coupon: {
    type: String,
    "default": 'none'
  },
  isActive: {
    type: Boolean,
    "default": false
  }
});
module.exports = _db["default"].model("Affiliate", AffiliateSchema);