"use strict";

var mongoose = require('mongoose');
var messageSchema = new mongoose.Schema({
  text: {
    type: String,
    required: true
  },
  clienttimestamp: {
    type: String,
    required: true
  },
  servertimestamp: {
    type: Date,
    "default": Date.now
  },
  isRead: {
    type: Boolean,
    "default": false
  },
  sender: {
    type: String,
    "enum": ['user', 'admin', 'llm'],
    "default": 'user'
  }
}, {
  timestamps: false
});
var Message = mongoose.model('Message', messageSchema);
module.exports = Message;