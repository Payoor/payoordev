import express from 'express';
import OrderController from '../controllers/orderController';
import verifyToken from "../services/payoor/verifyToken";

const orderRoute = express();

orderRoute.get('/user/get/orders', verifyToken, OrderController.getUserOrders);

orderRoute.get('/user/get/order', verifyToken, OrderController.getOrder);

orderRoute.get('/user/get/client/order', verifyToken, OrderController.getUserOrder);

orderRoute.get('/user/get/pending/order', verifyToken, OrderController.getPendingOrder);

orderRoute.post('/user/create/order', verifyToken, OrderController.createOrder);

orderRoute.post('/v2/user/create/order/', verifyToken, OrderController.saveOrderToRedis);

orderRoute.post('/v2/user/confirm/order/', verifyToken, OrderController.confirmOrder);

orderRoute.post('/user/update/order/delivery-date-address', verifyToken, OrderController.updateDeliveryDateandAddress);

export default orderRoute;
