"use strict";

var mongoose = require('mongoose');
var productVariant = new mongoose.Schema({
  productId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'newProduct',
    required: true
  },
  image: {
    type: String,
    "default": ""
  },
  unit: {
    type: String,
    required: true,
    "default": ""
  },
  price: {
    type: Number,
    required: true,
    "default": 0
  },
  availability: {
    type: String,
    required: true,
    "default": "YES"
  }
}, {
  timestamps: false
});
module.exports = mongoose.model('ProductVariant', productVariant);