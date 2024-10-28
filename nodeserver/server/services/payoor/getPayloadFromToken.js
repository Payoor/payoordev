const jwt = require('jsonwebtoken');

function getPayloadFromToken(token) {
    try {
        const payload = jwt.verify(token, process.env.SECRET_KEY);
        return payload;
    } catch (error) {
        console.error("Error decoding JWT:", error);
        throw error;
    }
}

export default getPayloadFromToken;