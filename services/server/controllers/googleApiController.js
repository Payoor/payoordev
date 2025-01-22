import axios from "axios";
import { Client } from "@googlemaps/google-maps-services-js";

const client = new Client({});

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

class GoogleApiController {
    async searchPlaces(req, res, next) {
        try {
            const placesResponse = await axios.get(
                `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${req.query.query}&region=ng&components=country:ng&key=${process.env.GOOGLE_MAPS_API_KEY}`
            );

            const filteredResults = placesResponse.data.results.map(place => ({
                formatted_address: place.formatted_address,
                icon: place.icon
            }));

            const response = {
                success: true,
                data: {
                    placesResponse: filteredResults
                }
            }
            return res.status(200).json(response);
        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Error searching location';
            next(error);
        }
    }

    async reverseGeocode(req, res, next) {
        try {
            const { lat, lng } = req.query;

            const geocodeResponse = await client.reverseGeocode({
                params: {
                    latlng: { lat: parseFloat(lat), lng: parseFloat(lng) },
                    key: process.env.GOOGLE_MAPS_API_KEY
                }
            });


            if (geocodeResponse.data.results && geocodeResponse.data.results.length > 0) {
                console.log(geocodeResponse.data.results[0].formatted_address);
                const filteredResults = geocodeResponse.data.results.map(place => ({
                    formatted_address: place.formatted_address,
                    icon: place.icon
                }));
                const response = {
                    success: true,
                    data: {
                        address: geocodeResponse.data.results[0].formatted_address,
                        filteredResults
                    }
                }

                return res.status(200).json(response);
            } else {
                const response = {
                    success: true,
                    data: {
                        address: `${lat}, ${lng}`
                    }
                }

                return res.status(200).json(response);
            }

        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Error reading coordinates';
            next(error);
        }
    }
}

export default new GoogleApiController();
