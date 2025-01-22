const mongoose = require('mongoose');

const errorLogSchema = new mongoose.Schema({
    timestamp: {
        type: Date,
        default: Date.now
    },
    error: {
        type: String,
        required: true
    },
    stack: String,
    url: String,
    method: String,
    body: mongoose.Schema.Types.Mixed,
    user: mongoose.Schema.Types.Mixed
}, {
    timestamps: true  // Adds createdAt and updatedAt
});

const ErrorLog = mongoose.model('ErrorLog', errorLogSchema);

module.exports = ErrorLog;