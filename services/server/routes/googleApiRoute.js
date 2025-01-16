import GoogleApiController from '../controllers/googleApiController';

const express = require('express');
const googleApiRoute = express();

googleApiRoute.get('/googleapi/search-places', GoogleApiController.searchPlaces);

googleApiRoute.get('/googleapi/geocode', GoogleApiController.reverseGeocode);

export default googleApiRoute;