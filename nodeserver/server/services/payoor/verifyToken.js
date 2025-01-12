const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
    try {
        const bearerHeader = req.headers['authorization'];

        console.log(bearerHeader);

        if (typeof bearerHeader !== 'undefined') {
            const bearer = bearerHeader.split(' ');
            const bearerToken = bearer[1];
            req.token = bearerToken;

            jwt.verify(req.token, process.env.SECRET_KEY, (err, authData) => {
                if (err) {
                    console.log(err)
                    res.sendStatus(403);
                } else {
                    req.authData = authData;
                    req.user = authData;
                    next();
                }
            });
        } else {
            res.sendStatus(403);
        }
    } catch (error) {
        console.log('error', error);
    }
};

export default verifyToken;