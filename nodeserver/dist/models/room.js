"use strict";

var mongoose = require('mongoose');
var roomSchema = new mongoose.Schema({
  userid: {
    type: String,
    trim: true,
    "default": ""
  },
  userphonenumber: {
    type: String,
    trim: true,
    "default": ""
  },
  socketid: {
    type: String,
    required: true,
    trim: true
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
});
var Room = mongoose.model('Room', roomSchema);
module.exports = Room;