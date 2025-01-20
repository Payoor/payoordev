const mongoose = require('mongoose');

const newProductSchema = new mongoose.Schema({
    name: {
        type: String
    },
    image: {
        type: String,
        default: ""
    },
    generatedDescription: {
        type: String,
        default: ""
    },
    generatedCategories: {
        type: [String],
        default: []
    },
}, {
    timestamps: true
});

newProductSchema.index({ name: 'text' });

module.exports = mongoose.model('newProduct', newProductSchema);
