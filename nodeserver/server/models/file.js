const mongoose = require("mongoose");

const fileSchema = new mongoose.Schema({
    uploadedAt: {
        type: Date,
        default: Date.now
    },
    uploadedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    url: {
        type: String,
        required: true
    },
    filePath: {
        type: String,
        required: true
    },
}, {
    timestamps: true
});

const File = mongoose.model('File', fileSchema);

module.exports = File;