import PaymentController from '../controllers/paymentController';

const express = require('express');
const paymentRoute = express();

paymentRoute.post('/paystack/payment-response', PaymentController.handlePayStackPaymentResponse);

export default paymentRoute;