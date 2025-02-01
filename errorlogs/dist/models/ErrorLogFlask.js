"use strict";

var mongoose = require('mongoose');
var errorLogFlaskSchema = new mongoose.Schema({
  timestamp: {
    type: String,
    required: true
  },
  module: {
    type: String,
    required: true
  },
  level: {
    type: String,
    required: true
  },
  location: {
    type: String,
    required: true
  },
  message: {
    type: String,
    required: true
  },
  createdAt: {
    type: String,
    required: true
  },
  updatedAt: {
    type: String,
    required: true
  }
}, {
  timestamps: false
});
var ErrorLogFlask = mongoose.model('ErrorLogFlask', errorLogFlaskSchema);
module.exports = ErrorLogFlask;