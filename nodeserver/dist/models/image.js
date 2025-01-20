"use strict";

var mongoose = require('mongoose');
var imageSchema = new mongoose.Schema({
  imageUrl: {
    type: String,
    required: true
  },
  modelName: {
    type: String,
    "enum": ['newProduct', 'ProductVariant'],
    "default": 'newProduct'
  },
  modelId: {
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'modelName',
    required: true
  }
}, {
  timestamps: true
});
module.exports = mongoose.model('Image', imageSchema);