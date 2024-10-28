import Room from '../../models/room';

async function createRoom(userid, socketid, userphonenumber) {
    const room = new Room({
        userid,
        socketid,
        userphonenumber
    });

    await room.save();

    return room;
}

export default createRoom;