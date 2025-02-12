"use strict";

var _db = _interopRequireDefault(require("../db"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var FoodModelSchema = new _db["default"].Schema({
  nameOfFood: {
    type: String,
    required: true,
    "default": "N/A"
  },
  ingredients: {
    type: String,
    required: true,
    "default": "N/A"
  },
  estimatedCookingTime: {
    type: String,
    required: true,
    "default": "N/A"
  }
});
var FoodModel = _db["default"].model("FoodModel", FoodModelSchema);
module.exports = FoodModel;