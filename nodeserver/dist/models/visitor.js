"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var mongoose = require('mongoose');
var visitorSchema = new mongoose.Schema({
  username: {
    type: String,
    "default": 'Visitor'
  },
  identifier: {
    type: String,
    required: true
  },
  email: {
    type: String
  },
  otp: {
    type: String
  }
});
var Visitor = mongoose.model('Visitor', visitorSchema);
var _default = exports["default"] = Visitor;