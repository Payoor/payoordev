import Visitor from "../../models/visitor";

async function verifyOtp({ otp, visitoridentifier }) {
    console.log(otp, visitoridentifier)
    try {
        const visitor = await Visitor.findOne({ otp, identifier: visitoridentifier });

        if (visitor) {
            return visitor;
        } else {
            return false;
        }
    } catch (error) {
        console.log(error);
    }
}

export default verifyOtp; 