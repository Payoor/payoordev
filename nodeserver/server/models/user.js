import mongoose from '../db';

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        trim: true,
        unique: true,
        required: true
    },
    phoneNumber: {
        type: String,
        unique: true,
        trim: true,
        required: true
    },
    location: {
        type: String,
        required: true,
        trim: true
    },
    shoppingList: {
        type: String,
        trim: true
    },
    isVerified: {
        type: Boolean,
        default: false
    },
    hasBeenWelcomed: {
        type: Boolean,
        default: false
    },
    completed_orders: {
        type: Number,
        default: 0
    },
    wallet_amount: {
        type: Number,
        default: 0.0
    },
    referral_code: {
        type: String,
        default: 'none'
    }
}, {
    timestamps: true
});


module.exports = mongoose.model('User', userSchema);