import PaymentController from '../controllers/paymentController';
import OrderController from '../controllers/orderController';

import verifyToken from "../services/payoor/verifyToken";

const express = require('express');
const paymentRoute = express();

paymentRoute.post('/paystack/generate-payment-link', verifyToken, OrderController.createOrder, PaymentController.generatePaymentLink);

paymentRoute.post('/paystack/payment-response', PaymentController.handlePayStackPaymentResponse);

paymentRoute.post('/paystack/verify-payment', PaymentController.verifyPayment);

paymentRoute.post('/flutter/transfer', verifyToken, OrderController.createOrder, PaymentController.generateTransferDetails);

paymentRoute.post('/flutter/verify-payment', PaymentController.handleFlutterwavePaymentResponse);

paymentRoute.post('/bani/payment-response', PaymentController.handleBaniPayment);

paymentRoute.post('/v2/paystack/generate-paystack-link', PaymentController.generatePayStackLink)

export default paymentRoute;
