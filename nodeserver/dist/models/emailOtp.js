"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var emailOtpSchema = new _db["default"].Schema({
  email: {
    type: String,
    required: true
  },
  otp: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    "default": Date.now,
    expires: 300 // OTP expires after 5 minutes
  },
  used: {
    type: Boolean,
    "default": false
  },
  verifiedAt: {
    type: Date
  }
});
emailOtpSchema.index({
  email: 1,
  otp: 1
});
emailOtpSchema.methods.isExpired = function () {
  var now = new Date();
  var createdAt = this.createdAt;
  var diffInMinutes = (now - createdAt) / (1000 * 60);
  return diffInMinutes > 5;
};
var EmailOtp = _db["default"].model('EmailOtp', emailOtpSchema);
module.exports = EmailOtp;