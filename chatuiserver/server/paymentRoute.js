import PaymentController from './paymentController';

const express = require('express');
const paymentRoute = express();

paymentRoute.post('/paystack/generate-payment-link', PaymentController.generatePaymentLink);

paymentRoute.post('/paystack/payment-response', PaymentController.handlePayStackPaymentResponse);

export default paymentRoute;
