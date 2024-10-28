import User from '../../models/user';

import getPayloadFromToken from './getPayloadFromToken';

async function getValidUser(jwt) {
    if (!jwt) {
        console.error('No JWT provided');
        return { _id: null, phoneNumber: null };
    }

    try {
        const payload = getPayloadFromToken(jwt);

        if (!payload || !payload._id) {
            console.error('Invalid token payload');
            return { _id: null, phoneNumber: null };
        }

        const validUser = await User.findOne({ _id: payload._id });

        if (!validUser) {
            console.error('User not found');
            return { _id: null, phoneNumber: null };
        }

        return validUser;
    } catch (error) {
        console.error('Error in getValidUser:', error);
        return { _id: null, phoneNumber: null };
    }
}

export default getValidUser; 