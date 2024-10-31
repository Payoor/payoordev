"use strict";

var mongoose = require('mongoose');
var imageSchema = new mongoose.Schema({
  imageUrl: {
    type: String,
    required: true
  },
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  }
}, {
  timestamps: true
});
module.exports = mongoose.model('Image', imageSchema);