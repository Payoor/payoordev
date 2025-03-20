import mongoose from '../db';

const AffiliateSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true
    },
    socialmedia: {
        type: String,
    },
    phonenumber: {
        type: String,
        required: true
    },
    coupon: {
        type: String,
        default: 'none'
    },
    isActive: {
        type: Boolean,
        default: false
    }
});

module.exports = mongoose.model("Affiliate", AffiliateSchema);