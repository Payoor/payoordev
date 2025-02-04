import express from 'express';
import OrderController from '../controllers/orderController';
import verifyToken from "../services/payoor/verifyToken";

const orderRoute = express();

orderRoute.get('/user/get/orders', verifyToken, OrderController.getUserOrders);

orderRoute.get('/user/get/order', verifyToken, OrderController.getOrder);

orderRoute.post('/user/create/order', verifyToken, OrderController.createOrder)

export default orderRoute;
