const mongoose = require('mongoose');

const visitorSchema = new mongoose.Schema({
    username: {
        type: String,
        default: 'Visitor'
    },
    identifier: {
        type: String,
        required: true
    },
    email: {
        type: String
    },
    otp: {
        type: String
    },
});

const Visitor = mongoose.model('Visitor', visitorSchema);

export default Visitor;