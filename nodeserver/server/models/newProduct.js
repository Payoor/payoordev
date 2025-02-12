import mongoose from '../db';

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
    synced_to_algolia: {
        type: Boolean,
        default: false
    },
    variantCount: {
        type: Number,
        default: 0
    }
}, {
    timestamps: true
});

newProductSchema.index({ name: 'text' });

module.exports = mongoose.model('newProduct', newProductSchema);
