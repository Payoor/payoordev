"use strict";

var mongoose = require('mongoose');
var emailOtpSchema = new mongoose.Schema({
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
var EmailOtp = mongoose.model('EmailOtp', emailOtpSchema);
module.exports = EmailOtp;