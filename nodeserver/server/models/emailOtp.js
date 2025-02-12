import mongoose from '../db';

const emailOtpSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
    },
    otp: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 300 // OTP expires after 5 minutes
    },
    used: {
        type: Boolean,
        default: false
    },
    verifiedAt: {
        type: Date
    }
});

emailOtpSchema.index({ email: 1, otp: 1 });

emailOtpSchema.methods.isExpired = function () {
    const now = new Date();
    const createdAt = this.createdAt;
    const diffInMinutes = (now - createdAt) / (1000 * 60);
    return diffInMinutes > 5;
};

const EmailOtp = mongoose.model('EmailOtp', emailOtpSchema);

module.exports = EmailOtp;