import Room from '../../models/room';

async function joinRoom(userid) {
    const rooms = await Room.find({ userid })
        /*.sort({ updated_at: -1 })
        .limit(1)
        .populate('userid')
        .exec();

        return rooms[0];*/

    console.log(rooms);
}

export default joinRoom;