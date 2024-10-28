if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

import twilio from "twilio";

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = twilio(accountSid, authToken);

async function createVerificationCheck(code, number) {
    console.log(code, number, 'check here');

    const verificationCheck = await client.verify.v2
        .services(process.env.TWILIO_SID)
        .verificationChecks.create({
            code: code,
            to: number
        });

   // console.log(verificationCheck);

    return {
        status: verificationCheck.status,
        number: verificationCheck.to
    };
}

export default createVerificationCheck;