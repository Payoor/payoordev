"use strict";

var mongoose = require('mongoose');
var transactionSchema = new mongoose.Schema({
  initiatorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  orderId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Order',
    required: true
  },
  amount: {
    type: mongoose.Schema.Types.Decimal128,
    required: true
  },
  status: {
    type: String,
    "enum": ['pending', 'verified'],
    "default": 'pending'
  },
  reference: {
    type: String,
    unique: true,
    trim: true,
    required: true
  },
  paymentDate: {
    type: Date
  }
}, {
  timestamps: true
});
module.exports = mongoose.model('Transactions', transactionSchema);