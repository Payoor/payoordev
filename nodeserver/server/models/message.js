const mongoose = require('mongoose');

// Define the schema for the Message model
const messageSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  visitor: { type: mongoose.Schema.Types.ObjectId, ref: 'Visitor' },
  content: {
    type: String,
    required: true
  },
  userPhoneNumber: {
    type: String,
  },
  userEmail: {
    type: String,
  },
  isUser: {
    type: Boolean,
    required: true
  },
  isAdmin: {
    type: Boolean,
    default: false
  },
  isLoggedIn: {
    type: Boolean,
    required: true
  },
  isSeen: {
    type: Boolean,
    default: false
  },
  client_timestamp: {
    type: String,
  },
  server_timestamp: {
    type: Date,
    default: Date.now,
  },
});

const Message = mongoose.model('Message', messageSchema);

module.exports = Message;
