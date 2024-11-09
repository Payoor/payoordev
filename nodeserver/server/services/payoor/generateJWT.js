import jwt from 'jsonwebtoken';

const JwtToken = require("../../models/jwttoken");

const JWT_SECRET = process.env.SECRET_KEY;
const EXPIRATION_TIME = '30d';

async function generateJWT({ userid }) {
    try {
        const expiryDate = new Date();
        expiryDate.setMonth(expiryDate.getMonth() + 1);

        const newToken = new JwtToken({
            userId: userid,
            expiry: expiryDate,
        });

        await newToken.save();

        const payload = {
            userId: userid,
            tokenId: newToken._id,
        };

        const jwtToken = jwt.sign(payload, JWT_SECRET, { expiresIn: EXPIRATION_TIME });

        return jwtToken;
    } catch (error) {
        console.error('Error generating JWT:', error);
        throw new Error('Could not generate JWT');
    }
}

export default generateJWT;