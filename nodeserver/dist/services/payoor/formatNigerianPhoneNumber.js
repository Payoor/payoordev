"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
function formatNigerianPhoneNumber(input) {
  var numberString = String(input).trim();
  if (numberString.startsWith('+234')) {
    return numberString;
  }
  numberString = numberString.replace(/\D/g, '');
  if (!/^\d+$/.test(numberString)) {
    throw new Error('Input must contain only numbers after trimming');
  }
  if (numberString.startsWith('0')) {
    numberString = numberString.slice(1);
  }
  if (numberString.startsWith('234')) {
    return '+' + numberString;
  }
  return '+234' + numberString;
}
var _default = exports["default"] = formatNigerianPhoneNumber;