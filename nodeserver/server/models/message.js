const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  roomId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Room',
    required: true,
  },
  text: {
    type: String,
    required: true
  },
  clienttimestamp: {
    type: String,
    required: true
  },
  servertimestamp: {
    type: Date,
    default: Date.now
  },
  isRead: {
    type: Boolean,
    default: false
  },
  sender: {
    type: String,
    enum: ['user', 'admin', 'llm'],
    default: 'user'
  },
}, {
  timestamps: false
});

const Message = mongoose.model('Message', messageSchema);

module.exports = Message;