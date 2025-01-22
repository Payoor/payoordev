"use strict";

var mongoose = require('mongoose');
var errorLogSchema = new mongoose.Schema({
  timestamp: {
    type: Date,
    "default": Date.now
  },
  error: {
    type: String,
    required: true
  },
  stack: String,
  url: String,
  method: String,
  body: mongoose.Schema.Types.Mixed,
  user: mongoose.Schema.Types.Mixed
}, {
  timestamps: true // Adds createdAt and updatedAt
});
var ErrorLog = mongoose.model('ErrorLog', errorLogSchema);
module.exports = ErrorLog;