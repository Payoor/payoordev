const mongoose = require('mongoose');

const OrderSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    status: {
        type: String,
        enum: ['pending', 'processing', 'completed', 'cancelled'],
        default: 'pending'
    },
    items: {
        type: Array
    },
    total: {
        type: Number,
        required: true,
        default: 0
    },
    reference: {
        type: String,
    }
});

module.exports = mongoose.model('Order', OrderSchema);