const mongoose = require("mongoose");

const FoodModelSchema = new mongoose.Schema({
    nameOfFood: { type: String, required: true, default: "N/A" },
    ingredients: { type: String, required: true, default: "N/A" },
    estimatedCookingTime: { type: String, required: true, default: "N/A" }
});

const FoodModel = mongoose.model("FoodModel", FoodModelSchema);

module.exports = FoodModel;
