import PaymentController from '../controllers/paymentController';
import OrderController from '../controllers/orderController';

import verifyToken from "../services/payoor/verifyToken";

const express = require('express');
const paymentRoute = express();

paymentRoute.post('/paystack/generate-payment-link', verifyToken, OrderController.createOrder, PaymentController.generatePaymentLink);

paymentRoute.post('/paystack/payment-response', PaymentController.handlePayStackPaymentResponse);

paymentRoute.post('/paystack/verify-payment', PaymentController.verifyPayment);

paymentRoute.post('/flutter/transfer', verifyToken, OrderController.createOrder, PaymentController.generateTransferDetails);

export default paymentRoute;
