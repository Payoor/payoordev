import mongoose from '../db';

const CouponSchema = new mongoose.Schema({
    code: {
        type: String,
        required: true,
        unique: true,
        uppercase: true,
        trim: true
    },
    affiliate: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Affiliate',
        required: true
    },
    email: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: true,
    },
    discountAmount: {
        type: Number,
        default: 0
    },
    usedCount: {
        type: Number,
        default: 0
    },
    usedBy: {
        type: Array
    },
    metadata: {
        type: Object,
        default: {
            //if afffiliate type: name, social media
        }
    },
    startDate: {
        type: Date,
        default: Date.now
    },
    endDate: {
        type: Date,
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    updatedAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model("Coupon", CouponSchema);