import mongoose from '../db';

const productSchema = new mongoose.Schema({
    product_name: {
        type: String
    },
    data: {
        type: mongoose.Schema.Types.Mixed,
        default: {}
    },
    images: {
        type: [String],
        default: []
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

productSchema.index({ 'data.NAME': 'text' });

productSchema.index({ 'data.AVAILABILITY': 1, 'data.UNIT': 1 });

module.exports = mongoose.model('Product', productSchema);