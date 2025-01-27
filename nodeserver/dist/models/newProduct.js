"use strict";

var mongoose = require('mongoose');
var newProductSchema = new mongoose.Schema({
  name: {
    type: String
  },
  image: {
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
  },
  synced_to_algolia: {
    type: Boolean,
    "default": false
  }
}, {
  timestamps: true
});
newProductSchema.index({
  name: 'text'
});
module.exports = mongoose.model('newProduct', newProductSchema);