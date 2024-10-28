import jwt from 'jsonwebtoken';

const User = require("../../models/user");

async function generateJWT({ userid }) {
    try {
        let user = await User.findOne({ _id: userid });

        if (user) {
            const user_payload = {
                _id: user._id
            };

            const token = jwt.sign(user_payload, process.env.SECRET_KEY, { expiresIn: '24h' });

            user.tokens.push({ token });
            await user.save();

            return token;
        } else {
            return false;
        }
    } catch (error) {
        console.error("Error generating JWT:", error);
        throw error;
    }
}

export default generateJWT;