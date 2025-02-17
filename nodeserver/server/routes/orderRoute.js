import express from 'express';
import OrderController from '../controllers/orderController';
import verifyToken from "../services/payoor/verifyToken";

const orderRoute = express();

orderRoute.get('/user/get/orders', verifyToken, OrderController.getUserOrders);

orderRoute.get('/user/get/order', verifyToken, OrderController.getOrder);

orderRoute.get('/user/get/client/order', verifyToken, OrderController.getUserOrder)

orderRoute.post('/user/create/order', verifyToken, OrderController.createOrder)

orderRoute.post('/user/update/order/delivery-date-address', verifyToken, OrderController.updateDeliveryDateandAddress)

export default orderRoute;
