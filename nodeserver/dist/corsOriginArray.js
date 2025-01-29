"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var corsOriginArray = {
  development: ['http://localhost:3000', 'http://localhost:63882'],
  production: ['https://admin.development.payoor.store', 'https://admin.payoor.store', 'https://chat.payoor.store', 'https://chat.development.payoor.store']
};
var _default = exports["default"] = corsOriginArray;