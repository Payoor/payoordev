"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.initSocket = exports.getIO = void 0;
var io;
var initSocket = exports.initSocket = function initSocket(socketIo) {
  io = socketIo;
};
var getIO = exports.getIO = function getIO() {
  if (!io) {
    throw new Error('Socket.io not initialized');
  }
  return io;
};