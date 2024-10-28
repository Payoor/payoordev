const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        trim: true,
        default: "Visitor"
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
        trim: true
    },
    isVerified: {
        type: Boolean,
        default: false
    },
    otp: {
        code: String,
        expiresAt: Date
    },
    awaitingOtp: {  // Changed to camelCase for consistency
        type: Boolean,
        default: false  // It's good to set a default value
    },
    roles: {
        type: [String],
        default: ['user']
    },
    unreadMessages: {
        type: [mongoose.Schema.Types.ObjectId],
        ref: 'Message',
        default: []
    },
    isOnline: {
        type: Boolean,
        default: false
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }]
}, {
    timestamps: true
});

userSchema.methods.getToken = function (criteria) {
    const user = this;

    // If criteria is not specified, return the first token
    if (!criteria) {
        return user.tokens.length > 0 ? user.tokens[0].token : null;
    }

    // Find a token that matches the criteria
    const tokenObj = user.tokens.find(tokenObj => tokenObj.token === criteria);

    return tokenObj ? tokenObj.token : null;
};


module.exports = mongoose.model('User', userSchema);