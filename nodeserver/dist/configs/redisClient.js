"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _require = require('redis'),
  createClient = _require.createClient;
var redisClient = createClient({
  url: process.env.REDIS_URL,
  socket: {
    reconnectStrategy: function reconnectStrategy(retries) {
      if (retries > 10) {
        console.log('Too many retries on Redis. Moving on.');
        return new Error('Too many retries on Redis');
      }
      return Math.min(retries * 50, 1000);
    }
  }
});
redisClient.on('connect', function () {
  console.log('Redis client connected');
});
redisClient.on('error', function (err) {
  console.error('Redis Client Error:', err);
});
redisClient.on('reconnecting', function () {
  console.log('Redis client reconnecting');
});
redisClient.on('ready', function () {
  console.log('Redis client is ready');
});
redisClient.connect().then(function () {
  console.log('Connected to Redis');
})["catch"](function (err) {
  console.error('Redis Client Error:', err);
});
var _default = exports["default"] = redisClient;