import jwt from 'jsonwebtoken';
import JwtToken from '../../models/jwttoken';

const JWT_SECRET = process.env.SECRET_KEY;

const verifyJWT = async (req, res, next) => {
    try {
        const token = req.headers.authorization && req.headers.authorization.split(' ')[1];
        if (!token) {
            return res.status(401).json({ message: 'Token is required' });
        }

        const decoded = jwt.verify(token, JWT_SECRET);

        const tokenInDb = await JwtToken.findById(decoded.tokenId);
        if (!tokenInDb) {
            return res.status(401).json({ message: 'Token not found in database' });
        }

        const currentDate = new Date();
        if (new Date(tokenInDb.expiry) < currentDate) {
            return res.status(401).json({ message: 'Token has expired' });
        }

        req.user = decoded;
        //console.log(decoded)

        next();
    } catch (error) {
        console.error('Error verifying JWT:', error);
        return res.status(401).json({ message: 'Invalid or expired token' });
    }
};

export default verifyJWT;
