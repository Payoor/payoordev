const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
    userid: {
        type: String,
        trim: true,
        default: ""
    },
    userphonenumber: {
        type: String,
        trim: true,
        default: ""
    },
    socketid: {
        type: String,
        required: true,
        trim: true
    },
    created_at: { type: Date, default: Date.now },
    updated_at: { type: Date, default: Date.now }
});

const Room = mongoose.model('Room', roomSchema);

module.exports = Room;