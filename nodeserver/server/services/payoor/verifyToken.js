import jwt from 'jsonwebtoken';

import JwtToken from "../../models/jwttoken";

const verifyToken = async (req, res, next) => {
    try {
        const bearerHeader = req.headers['authorization'];

        if (typeof bearerHeader !== 'undefined') {
            const bearer = bearerHeader.split(' ');
            const bearerToken = bearer[1];
            req.token = bearerToken;

            jwt.verify(req.token, process.env.SECRET_KEY, async (err, authData) => {
                if (err) {
                    console.log(err)
                    return res.sendStatus(403);
                }

                try {
                    const token = await JwtToken.findById(authData.tokenId);
                    if (!token || token.isRevoked) {
                        return res.sendStatus(403);
                    }

                    req.authData = authData;
                    req.user = authData;
                    next();
                } catch (dbError) {
                    console.log('Database error:', dbError);
                    return res.sendStatus(403);
                }
            });
        } else {
            res.sendStatus(403);
        }
    } catch (error) {
        console.log('error', error);
        res.sendStatus(403);
    }
};

export default verifyToken;