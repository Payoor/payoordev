import Transaction from "../models/transaction";
import Order from "../models/order";

import redisClient from "../configs/redisClient";
import getOrderDetails from '../services/payoor/getOrderDetails';
import updateUserAddress from '../services/payoor/updateUserAddress';

import sendAffiliateCouponUsageAlert from "../services/resend/sendAffiliateCouponUsageAlert";

import Affiliate from "../models/affiliate";
import Coupon from "../models/coupon"

const https = require('https');
const crypto = require('crypto');

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config();
}

const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;
const FLUTTERWAVE_SECRET_KEY = process.env.FLUTTERWAVE_SECRET_KEY;

class PaymentController {
    async generateTransferDetails(req, res, next) {
        try {
            const { email, total, orderId, userId, name } = req;
            const { delivery_fee, service_charge } = req.body;

            const amount = total;

            if (!email || !amount) {
                console.log('email and amount are required')
                return res.status(400).json({
                    message: 'email and amount are required'
                })
            }

            if (typeof delivery_fee !== 'number' || typeof service_charge !== 'number' || typeof amount !== 'number') {
                throw new Error('All amounts must be numbers');
            }

            const amountTotal = (delivery_fee + service_charge + amount).toFixed(2);
            const tx_ref = generateTransactionReference()
            const params = JSON.stringify({
                amount: amountTotal,
                email: email,
                currency: "NGN",
                tx_ref: tx_ref,
                fullname: name,
            });

            console.log(params)

            const options = {
                hostname: 'api.flutterwave.com',
                port: 443,
                path: '/v3/charges?type=bank_transfer',
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${FLUTTERWAVE_SECRET_KEY}`,
                    'Content-Type': 'application/json',
                    'accept': 'application/json'
                }
            };

            const flutterwaveReq = https.request(options, (flutterwaveRes) => {
                let data = '';

                flutterwaveRes.on('data', (chunk) => {
                    data += chunk;
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

                flutterwaveRes.on('end', async () => {
                    console.log('Response:', data);

                    const transfer_reference = JSON.parse(data).meta.authorization.transfer_reference;

                    response.data.account_number = JSON.parse(data).meta.authorization.transfer_account;
                    response.data.bank = JSON.parse(data).meta.authorization.transfer_bank;
                    response.data.amount = JSON.parse(data).meta.authorization.transfer_amount;
                    response.data.transfer_reference = transfer_reference;
                    response.data.transaction_reference = tx_ref;

                    res.status(200).json(response);

                    const transaction = new Transaction({
                        initiatorId: userId,
                        orderId: orderId,
                        amount: amount,
                        reference: tx_ref
                    });

                    await transaction.save();

                    await Order.findOneAndUpdate(
                        { _id: orderId },
                        {
                            $set: {
                                reference: tx_ref
                            }
                        },
                        {
                            new: true,
                            runValidators: true,
                        },
                    );
                });
            });

            flutterwaveReq.on('error', (error) => {
                console.log(error)
                return res.status(400).json({
                    message: 'Error generating bank transfer details'
                });
            });

            flutterwaveReq.write(params);
            flutterwaveReq.end();

        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to generate bank transfer details';
            next(error);
        }

    }

    async handleFlutterwavePaymentResponse(req, res, next) {
        try {
            const secretHash = process.env.FLUTTERWAVE_SECRET_HASH;
            const signature = req.headers["verif-hash"];

            if (!signature || signature !== secretHash) {
                return res.status(401).json({
                    success: false,
                    message: "Unauthorized request"
                });
            }

            const event = req.body;
            const paymentData = req.body.data;

            if (event.event === "charge.completed" && event.data.status === "successful") {
                const txRef = paymentData.tx_ref;

                console.log("Payment received for:", txRef);

                await Transaction.findOneAndUpdate(
                    { reference: txRef },
                    {
                        $set: {
                            status: "verified"
                        }
                    },
                    {
                        new: true,
                        runValidators: true,
                    },
                );

                /*const mailResponse = await sendTransactionVerification({
                    email: paymentData.customer.email,
                    amount: formatAmount(paymentData.amount)
                });*/

                return res.status(200).json({
                    success: true,
                    message: "Payment verified successfully",
                    mailResponse
                });
            }

            console.log('Unhandled event type:', event.event);

        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed verify payment';
            next(error);
        }
    }

    async generatePaymentLink(req, res, next) {
        try {
            const { email, total, orderId, userId } = req;
            const { delivery_fee, service_charge } = req.body;
            //const { order, user } = res.locals;

            const amount = total;

            //console.log('amount', amount);

            if (!email || !amount) {
                console.log('email and amount are required')
                return res.status(400).json({
                    message: 'email and amount are required'
                })
            }

            if (typeof delivery_fee !== 'number' || typeof service_charge !== 'number' || typeof amount !== 'number') {
                throw new Error('All amounts must be numbers');
            }

            const amountTotal = 1000; //(delivery_fee + service_charge + amount).toFixed(2);

            const params = JSON.stringify({
                "email": email,
                "amount": Math.round(amountTotal * 100), // this conversion can be done either on the client side or server side.
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
                    console.log('data here', data);
                    const transaction_reference = JSON.parse(data).data.reference;

                    response.data.authorization_url = JSON.parse(data).data.authorization_url;
                    response.data.transaction_reference = transaction_reference;
                    response.data.access_code = JSON.parse(data).data.access_code;

                    //console.log(response);


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
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed to generate payment link';
            next(error);
        }
    }

    async handlePayStackPaymentResponse(req, res) {
        try {
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

            await Transaction.findOneAndUpdate(
                { reference: paymentData.reference },
                {
                    $set: {
                        status: "verified"
                    }
                },
                {
                    new: true,
                    runValidators: true,
                },
            );

            const mailResponse = await sendTransactionVerification({
                email: paymentData.customer.email,
                amount: formatAmount(paymentData.amount / 100)
            });

            return res.status(200).json({
                message: 'Webhook processed successfully',
                mailResponse
            });


        } catch (error) {
            console.log('error here', error, 'error here')
            error.payoorDevErrorMessage = 'Failed verify payment';
            next(error);
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

    async handleBaniPayment(req, res) {
        try {
            const merchant_private_key = process.env.MERCHANT_PRIVATE_KEY_BANI;
            const headers = req.headers;
            const body = req.rawBody;

            // Validate request body
            if (!body) {
                console.log('no body');
                return res.status(400).json({
                    status: false,
                    message: "No body provided"
                });
            }

            // Validate signature header
            if (!headers["bani-hook-signature"]) {
                return res.status(400).json({
                    status: false,
                    message: "No signature provided"
                });
            }

            // Verify signature
            const sig = Buffer.from(headers["bani-hook-signature"], "utf8");
            const hmac = crypto.createHmac("sha256", merchant_private_key);
            const digest = Buffer.from(hmac.update(body).digest("hex"), "utf8");

            if (sig.length !== digest.length || !crypto.timingSafeEqual(digest, sig)) {
                return res.status(401).json({
                    status: false,
                    message: "Invalid signature"
                });
            }

            const webhookData = JSON.parse(body);
            const { order_ref } = webhookData.data.custom_data;
            const paymentStatus = webhookData.data.pay_status;

            //console.log(order_ref, 'order_ref');

            if (paymentStatus === 'paid') {
                // Use direct key lookup instead of list search
                const PENDING_ORDER_ID = `pending:${order_ref}`;
                const storedOrder = await redisClient.get(PENDING_ORDER_ID);

                if (!storedOrder) {
                    console.error('Order not found:', order_ref);
                    return res.status(404).json({
                        status: false,
                        message: "Order not found"
                    });
                }

                const order = JSON.parse(storedOrder);
                const { _id, metadata, ...orderWithoutId } = order;

                console.log(metadata, 'metadata')
                const { affiliatecode } = metadata;

                const newMongoOrder = new Order({
                    ...orderWithoutId,
                    reference: webhookData.data.transaction_ref,
                    status: 'processing',
                    metadata
                });

                await Promise.all([
                    newMongoOrder.save(),
                    redisClient.del(PENDING_ORDER_ID)
                ]);

                getOrderDetails(newMongoOrder._id);

                const { total } = newMongoOrder;
                const payout = total * 0.1;

                if (affiliatecode) {
                    updateAffiliate(affiliatecode, total, payout)
                }

                const user_id = newMongoOrder.userId;
                const user_current_address = newMongoOrder.order_address;

                console.log(newMongoOrder, 'newMongoOrder======newMongoOrder======newMongoOrder')

                updateUserAddress(user_id, user_current_address);

                return res.status(200).json({
                    status: true,
                    message: "Payment processed successfully",
                    data: {
                        order: newMongoOrder
                    }
                });
            }

            return res.status(200).json({
                status: true,
                message: "Webhook received"
            });

        } catch (error) {
            console.error('Webhook processing error:', error);
            return res.status(500).json({
                status: false,
                message: "Error processing webhook",
                error: error.message
            });
        }
    }
}

export default new PaymentController();

const generateTransactionReference = () => {
    let text = "";
    let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (let i = 0; i < 10; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

const formatAmount = (amount) => {
    const formatter = new Intl.NumberFormat("en-NG", {
        style: "currency",
        currency: "NGN",
        minimumFractionDigits: 0,
    });

    return formatter.format(amount);
}


async function updateAffiliate(coupon, amountSpent, payout) {
    try {
        const couponCode = await Coupon.findOne({ code: coupon });
        const affiliate = await Affiliate.findOne({ coupon: coupon });

        couponCode.usedCount = couponCode.usedCount + 1;

        await couponCode.save();

        if (couponCode && affiliate) {
            console.log(couponCode, affiliate)
            const { email, } = affiliate
            await sendAffiliateCouponUsageAlert({ email, affiliateCode: coupon, amountSpent, payout })
        }
    } catch (error) {
        console.log(error)
    }
}