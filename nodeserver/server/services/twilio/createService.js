if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const twilio = require("twilio");

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = twilio(accountSid, authToken);

async function createService() {
    const service = await client.verify.v2.services.create({
        friendlyName: "Payoor Service", //Payoor
    });

   // console.log(service.sid);
}

//createService();

export default createService;