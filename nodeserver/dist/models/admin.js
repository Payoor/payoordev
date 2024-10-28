"use strict";

var _bcryptjs = _interopRequireDefault(require("bcryptjs"));
var _jsonwebtoken = _interopRequireDefault(require("jsonwebtoken"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var mongoose = require('mongoose');
var AdminSchema = new mongoose.Schema({
  username: {
    type: String,
    trim: true,
    required: true,
    unique: true
  },
  password: {
    type: String,
    trim: true,
    required: true,
    minlength: 10
  },
  tokens: [{
    access: {
      type: String,
      required: true
    },
    token: {
      type: String,
      required: true
    }
  }]
});
AdminSchema.statics.findByCredentials = function (username, password) {
  var Admin = this;
  return Admin.findOne({
    username: username
  }).then(function (admin) {
    if (!admin) {
      return Promise.reject();
    }
    return new Promise(function (resolve, reject) {
      _bcryptjs["default"].compare(password, admin.password, function (err, res) {
        if (res) {
          resolve(admin);
        } else {
          reject();
        }
      });
    });
  });
};
AdminSchema.statics.findByToken = function (token) {
  var Admin = this;
  var decoded;
  try {
    decoded = _jsonwebtoken["default"].verify(token, process.env.SECRET_KEY);
  } catch (e) {
    /*return new Promise((resolve, reject) => {
     reject();
    });*/
    return Promise.reject();
  }
  return Admin.findOne({
    '_id': decoded._id,
    'tokens.token': token,
    'tokens.access': 'auth'
  });
};
AdminSchema.methods.generateAuthToken = function () {
  var admin = this;
  var access = 'auth';
  var token = _jsonwebtoken["default"].sign({
    _id: admin._id.toHexString(),
    access: access
  }, process.env.SECRET_KEY).toString();
  admin.tokens.push({
    access: access,
    token: token
  });
  return admin.save().then(function () {
    return token;
  });
};
AdminSchema.pre('save', function (next) {
  var admin = this;
  if (admin.isModified('password')) {
    _bcryptjs["default"].genSalt(10, function (err, salt) {
      _bcryptjs["default"].hash(admin.password, salt, function (err, hash) {
        admin.password = hash;
        next();
      });
    });
  } else {
    next();
  }
});
module.exports = mongoose.model('Admin', AdminSchema);