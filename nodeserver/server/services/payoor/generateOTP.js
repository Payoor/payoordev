import speakeasy from "speakeasy";

async function generateOTP() {
    const secret = speakeasy.generateSecret();
    const token = speakeasy.totp({ secret: secret.base32 });

    return token;
}

export default generateOTP;