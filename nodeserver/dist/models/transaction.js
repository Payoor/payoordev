"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var transactionSchema = new _db["default"].Schema({
  initiatorId: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  orderId: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'Order',
    required: true
  },
  amount: {
    type: _db["default"].Schema.Types.Decimal128,
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
module.exports = _db["default"].model('Transactions', transactionSchema);