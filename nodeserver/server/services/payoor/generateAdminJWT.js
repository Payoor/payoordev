import jwt from 'jsonwebtoken';

async function generateAdminJWT({ adminid, username }) {
    const admin_payload = {
        _id: adminid,
        username
    }

    const token = jwt.sign(admin_payload, process.env.SECRET_KEY, { expiresIn: '24h' });
}

export default generateAdminJWT;