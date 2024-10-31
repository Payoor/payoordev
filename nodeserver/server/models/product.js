const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    filepath: { type: String, required: true, unique: true },
    data: { type: mongoose.Schema.Types.Mixed, default: {} },
    images: {
        type: [String],
        default: []
    }
}, { timestamps: true });



module.exports = mongoose.model('Product', productSchema);