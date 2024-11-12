import PaymentController from './paymentController';

const express = require('express');
const paymentRoute = express();

paymentRoute.post('/paystack/generate-payment-link', PaymentController.generatePaymentLink);

export default paymentRoute;
