"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;
var _googleApiController = _interopRequireDefault(require("../controllers/googleApiController"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { "default": e }; }
var express = require('express');
var googleApiRoute = express();
googleApiRoute.get('/googleapi/search-places', _googleApiController["default"].searchPlaces);
googleApiRoute.get('/googleapi/geocode', _googleApiController["default"].reverseGeocode);
var _default = exports["default"] = googleApiRoute;