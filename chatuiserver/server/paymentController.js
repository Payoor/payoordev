if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;

class PaymentController {
    async generatePaymentLink(req, res) {
        try {
            const https = require('https');

            const { email, amount } = req.body;

            if (!email || !amount) {
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

                paystackResponse.on('end', () => {
                    res.status(200).json(JSON.parse(data));
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

            res.status(200).json({ message: 'Payment received' });
            if (event.event === 'charge.success') {
                const paymentData = event.data;

                console.log('Payment successful:', paymentData);

                res.status(200).json({ message: 'Payment successful' })
            }

        } catch (error) {
            console.log(error);
            const errorResponse = {
                success: false,
                data: {
                    message: error.message || 'Error handling payment response',
                    error: process.env.NODE_ENV === 'development' ? error.toString() : undefined,
                    timestamp: new Date().toISOString()
                }
            };

            res.status(500).json(errorResponse);
        }
    }
}

export default new PaymentController();
