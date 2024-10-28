let ENVIRO;
let API_URL;

ENVIRO = 'production';

if (ENVIRO === 'development') {
    API_URL = `http://localhost:3030`;
} else {
    API_URL = `https://server.payoor.shop`;
}

export default API_URL;