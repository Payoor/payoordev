const User = require("../../models/user");

import getPayloadFromToken from './getPayloadFromToken';

async function saveUserName(username, jwt) {
    try {
        const payload = getPayloadFromToken(jwt);

        const updatedUser = await User.findOneAndUpdate(
            { _id: payload._id },
            { username: username },
            { new: true }
        );

        return updatedUser;
    } catch (error) {
        console.log(error);
        throw error; 
    }
}

export default saveUserName;
