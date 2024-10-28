if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

import twilio from "twilio";

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = twilio(accountSid, authToken);

async function createVerification(number) {
    const verification = await client.verify.v2
        .services(process.env.TWILIO_SID)
        .verifications.create({
            channel: "sms",
            to: number,
        });

       // console.log(verification, 'done');

    return verification.status;
}

export default createVerification;