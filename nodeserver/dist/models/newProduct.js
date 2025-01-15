"use strict";

var mongoose = require('mongoose');
var newProductSchema = new mongoose.Schema({
  name: {
    type: String
  },
  images: {
    type: String,
    "default": ""
  },
  generatedDescription: {
    type: String,
    "default": ""
  },
  generatedCategories: {
    type: [String],
    "default": []
  }
}, {
  timestamps: true
});
module.exports = mongoose.model('newProduct', newProductSchema);