"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var jwt = require('jsonwebtoken');
var verifyToken = function verifyToken(req, res, next) {
  try {
    var bearerHeader = req.headers['authorization'];
    if (typeof bearerHeader !== 'undefined') {
      var bearer = bearerHeader.split(' ');
      var bearerToken = bearer[1];
      req.token = bearerToken;
      jwt.verify(req.token, process.env.SECRET_KEY, function (err, authData) {
        if (err) {
          res.sendStatus(403);
        } else {
          req.authData = authData;
          //console.log('authData', authData);
          next();
        }
      });
    } else {
      res.sendStatus(403);
    }
  } catch (error) {
    console.log('error', error);
  }
};
var _default = exports["default"] = verifyToken;