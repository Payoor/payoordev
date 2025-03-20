"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var CouponSchema = new _db["default"].Schema({
  code: {
    type: String,
    required: true,
    unique: true,
    uppercase: true,
    trim: true
  },
  affiliate: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'Affiliate',
    required: true
  },
  email: {
    type: String,
    required: true
  },
  type: {
    type: String,
    required: true
  },
  discountAmount: {
    type: Number,
    "default": 0
  },
  usedCount: {
    type: Number,
    "default": 0
  },
  usedBy: {
    type: Array
  },
  metadata: {
    type: Object,
    "default": {
      //if afffiliate type: name, social media
    }
  },
  startDate: {
    type: Date,
    "default": Date.now
  },
  endDate: {
    type: Date
  },
  createdAt: {
    type: Date,
    "default": Date.now
  },
  updatedAt: {
    type: Date,
    "default": Date.now
  }
});
module.exports = _db["default"].model("Coupon", CouponSchema);