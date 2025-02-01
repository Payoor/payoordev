"use strict";

var mongoose = require("mongoose");
var FoodModelSchema = new mongoose.Schema({
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
var FoodModel = mongoose.model("FoodModel", FoodModelSchema);
module.exports = FoodModel;