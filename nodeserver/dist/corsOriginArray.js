"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var corsOriginArray = {
  development: ['http://localhost:3000', 'http://localhost:63882', 'http://localhost:8088', 'http://localhost:57896'],
  production: ['https://admin.payoor.store', 'https://chat.payoor.store', 'https://shop.payoor.store', 'https://payoor.store']
};
var _default = exports["default"] = corsOriginArray;