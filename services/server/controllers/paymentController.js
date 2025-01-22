import Transaction from "../models/transaction";
import JwtToken from "../models/jwttoken";

import { getIO } from '../utils/socketio_util';

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;

class PaymentController {
    async handlePayStackPaymentResponse(req, res, next) {
        console.log('called paystack route');
        try {
            const crypto = require('crypto');
            const paystackSignature = req.headers['x-paystack-signature'];

            const hash = crypto
                .createHmac('sha512', PAYSTACK_SECRET_KEY)
                .update(JSON.stringify(req.body))
                .digest('hex');

            if (hash !== paystackSignature) {
                return res.status(401).json({ message: 'Unauthorized request' });
            }

            const event = req.body;

            const paymentData = event.data;

            const io = getIO();

            console.log(io, 'connected')

            console.log(event)

            io.emit('transaction.success', {
                reference: paymentData.reference,
                amount: paymentData.amount,
                status: 'success'
            });

            switch (event.event) {
                case 'charge.success':
                    console.log('charge successful:', paymentData);
                    io.emit('transaction.success', {
                        reference: paymentData.reference,
                        amount: paymentData.amount,
                        status: 'success'
                    });

                    break;

                case 'transfer.success':
                    console.log(event.data)
                    io.emit('transaction.success', {
                        reference: paymentData.reference,
                        amount: paymentData.amount,
                        status: 'success'
                    });
                    console.log('transfer successful:', paymentData);
                    break;

                case 'charge.failed':
                    // Handle failed charge
                    break;

                default:
                    console.log('Unhandled event type:', event.event);
            }

            return res.status(200).json({ message: 'Webhook processed successfully' });

        } catch (error) {
            console.error('Webhook processing error:', error);
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Error handling payment response';
            next(error);
        }
    }
}

export default new PaymentController();
