"use strict";

var mongoose = require('mongoose');
var JWTTokenSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  expiry: {
    type: Date,
    required: true
  },
  isRevoked: {
    type: Boolean,
    "default": false
  },
  createdAt: {
    type: Date,
    "default": Date.now
  }
});
module.exports = mongoose.model('JwtToken', JWTTokenSchema);