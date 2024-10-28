"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var jwt = require('jsonwebtoken');
function getPayloadFromToken(token) {
  try {
    var payload = jwt.verify(token, process.env.SECRET_KEY);
    return payload;
  } catch (error) {
    console.error("Error decoding JWT:", error);
    throw error;
  }
}
var _default = exports["default"] = getPayloadFromToken;