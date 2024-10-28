"use strict";

var mongoose = require("mongoose");
var fileSchema = new mongoose.Schema({
  uploadedAt: {
    type: Date,
    "default": Date.now
  },
  uploadedBy: {
    type: mongoose.Schema.Types.ObjectId,
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
var File = mongoose.model('File', fileSchema);
module.exports = File;