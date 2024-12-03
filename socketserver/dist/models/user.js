"use strict";

var mongoose = require('mongoose');
var userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    trim: true,
    unique: true,
    required: true
  },
  phoneNumber: {
    type: String,
    unique: true,
    trim: true,
    required: true
  },
  location: {
    type: String,
    required: true,
    trim: true
  },
  shoppingList: {
    type: String,
    trim: true
  },
  isVerified: {
    type: Boolean,
    "default": false
  },
  hasBeenWelcomed: {
    type: Boolean,
    "default": false
  }
}, {
  timestamps: true
});
module.exports = mongoose.model('User', userSchema);