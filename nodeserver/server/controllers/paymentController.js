import Transaction from "../models/transaction";
import Order from "../models/order";

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;

class PaymentController {
    async generatePaymentLink(req, res) {
        try {
            const https = require('https');

            const { email, total, orderId, userId } = req;
            //const { order, user } = res.locals;

            const amount = total;

            if (!email || !amount) {
                console.log('email and amount are required')
                return res.status(400).json({
                    message: 'email and amount are required'
                })
            }

            const params = JSON.stringify({
                "email": email,
                "amount": amount * 100, // this conversion can be done either on the client side or server side.
                // channels: ["bank_transfer"]
            });

            const options = {
                hostname: 'api.paystack.co',
                port: 443,
                path: '/transaction/initialize',
                method: 'POST',
                headers: {
                    Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
                    'Content-Type': 'application/json'
                }
            };

            const paystackRequest = https.request(options, paystackResponse => {
                let data = ''

                paystackResponse.on('data', (chunk) => {
                    data += chunk
                });

                const response = {
                    success: true,
                    data: {
                        message: 'Success response',
                        chatresponse: {
                            text: "this is an AI response",
                            isClient: false,
                            isRead: false,
                        }
                    }
                };

                paystackResponse.on('end', async () => {
                    const transaction_reference = JSON.parse(data).data.reference;

                    response.data.authorization_url = JSON.parse(data).data.authorization_url;
                    response.data.transaction_reference = transaction_reference;
                    response.data.access_code = JSON.parse(data).data.access_code;

                    console.log(response);


                    res.status(200).json(response);

                    const transaction = new Transaction({
                        initiatorId: userId,
                        orderId: orderId,
                        amount: amount,
                        reference: transaction_reference
                    });

                    transaction.save();

                    const order_update = await Order.findOneAndUpdate(
                        { _id: orderId },
                        {
                            $set: {
                                reference: transaction_reference
                            }
                        },
                        {
                            new: true,
                            runValidators: true
                        }
                    );
                })


            }).on('error', error => {
                console.log(error)
                return res.status(400).json({
                    message: 'Error generating payment link'
                });
            });

            paystackRequest.write(params);
            paystackRequest.end();

        } catch (error) {
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to generate payment link',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }

    async handlePayStackPaymentResponse(req, res) {
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

            switch (event.event) {
                case 'charge.success':
                    console.log('charge successful:', paymentData);
                    break;

                case 'transfer.success':
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
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Error handling payment response',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            return res.status(500).json(errorResponse);
        }
    }

    async verifyPayment(req, res) {

        try {

            const https = require('https');
            const { transactionReference } = req.body;

            const options = {
                hostname: 'api.paystack.co',
                port: 443,
                path: `/transaction/verify/${transactionReference}`,
                method: 'GET',
                headers: {
                    Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`
                }
            }

            const transaction = await Transaction.findOne({ reference: transactionReference })

            if (!transaction) {
                return res.status(404).json({
                    message: 'Transaction not found.'
                })
            }

            const verificationRequest = https.request(options, verificationResponse => {
                let data = ''

                verificationResponse.on('data', (chunk) => {
                    data += chunk
                });

                const response = {
                    success: true,
                    data: {
                        message: 'Payment verified!',
                        chatresponse: {
                            text: "this is an AI response",
                            isClient: false,
                            isRead: false,
                        }
                    }
                };

                verificationResponse.on('end', () => {
                    console.log(JSON.parse(data))

                    transaction.status = 'verified';
                    transaction.paymentDate = new Date(JSON.parse(data).data.paid_at);
                    transaction.save();

                    res.status(200).json(response);
                })

            }).on('error', error => {
                console.log(error)
                return res.status(400).json({
                    message: 'Error verifying payment'
                });
            })

            verificationRequest.end();
        } catch (error) {
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Failed to verify payment',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }

    }
}

export default new PaymentController();
