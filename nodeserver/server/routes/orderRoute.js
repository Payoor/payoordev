import express from 'express';
import OrderController from '../controllers/orderController';
import verifyJWT from '../middleware/user/verifyJWT';

const orderRoute = express();

orderRoute.get('/user/get/orders', verifyJWT, OrderController.getUserOrders);

orderRoute.get('/user/get/order', verifyJWT, OrderController.getOrder);

export default orderRoute;
