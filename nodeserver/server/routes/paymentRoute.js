import PaymentController from '../controllers/paymentController';
import OrderController from '../controllers/orderController';

import verifyToken from "../middleware/user/verifyJWT";

const express = require('express');
const paymentRoute = express();

paymentRoute.post('/paystack/generate-payment-link', verifyToken, OrderController.createOrder, PaymentController.generatePaymentLink);

paymentRoute.post('/paystack/payment-response', PaymentController.handlePayStackPaymentResponse);

paymentRoute.post('/paystack/verify-payment', PaymentController.verifyPayment);

export default paymentRoute;
