import User from '../../models/user';

async function updateUserAddress(user_id, user_current_address) {
    try {
        const updatedUser = await User.findOneAndUpdate(
            { _id: user_id },
            { location: user_current_address },
            { new: true }
        );

        if (!updatedUser) {
            throw new Error('User not found');
        }

        console.log(updatedUser, 'updatedUser updatedUser========')

        return updatedUser;
    } catch (error) {
        console.error('Error updating user address:', error);
        throw error;
    }
}

export default updateUserAddress;