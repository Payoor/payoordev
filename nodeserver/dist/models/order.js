"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var OrderSchema = new _db["default"].Schema({
  userId: {
    type: _db["default"].Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  createdAt: {
    type: Date,
    "default": Date.now
  },
  status: {
    type: String,
    "enum": ['pending', 'processing', 'completed', 'cancelled'],
    "default": 'pending'
  },
  items: {
    type: Array
  },
  cart_total: {
    type: Number,
    required: true,
    "default": 0
  },
  total: {
    type: Number,
    required: true,
    "default": 0
  },
  order_address: {
    type: String,
    required: true
  },
  delivery_fee: {
    type: Number,
    required: true
  },
  service_charge: {
    type: Number,
    required: true
  },
  reference: {
    type: String
  },
  delivery_date: {
    type: String
  },
  metadata: {
    type: Object,
    "default": {}
  }
});
module.exports = _db["default"].model('Order', OrderSchema);