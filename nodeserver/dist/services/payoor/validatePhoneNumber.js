"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _formatNigerianPhoneNumber = _interopRequireDefault(require("./formatNigerianPhoneNumber"));
var _libphonenumberJs = require("libphonenumber-js");
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
function validatePhoneNumber(message) {
  var messageVal = message.trim();
  if (!messageVal) {
    return {
      isValid: false,
      error: 'Empty or invalid message received.'
    };
  }
  if (/[a-zA-Z]/.test(messageVal)) {
    return {
      isValid: false,
      error: 'Phone number should not contain letters.'
    };
  }
  try {
    var formattedNumber = (0, _formatNigerianPhoneNumber["default"])(messageVal);
    if (!(0, _libphonenumberJs.isValidPhoneNumber)(formattedNumber)) {
      //console.log('invalid')
      return {
        isValid: false,
        error: "Invalid phone number format: ".concat(messageVal)
      };
    }
    var phoneNumber = (0, _libphonenumberJs.parsePhoneNumber)(formattedNumber);

    //console.log(phoneNumber);

    var result = {
      isValid: true,
      originalInput: messageVal,
      formattedNumber: formattedNumber,
      phoneNumber: phoneNumber,
      country: phoneNumber.country || 'Unknown',
      nationalNumber: phoneNumber.nationalNumber,
      internationalFormat: phoneNumber.format('INTERNATIONAL')
    };

    //console.log('Phone number validation result:', result);

    return result;
  } catch (error) {
    //console.log(error)
    console.error('Error during phone number validation:', error.message);
    return {
      isValid: false,
      error: 'Error during phone number validation: ' + error.message
    };
  }
}
var _default = exports["default"] = validatePhoneNumber;