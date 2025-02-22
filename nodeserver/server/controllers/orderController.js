import moment from "moment";
const { v4: uuidv4 } = require('uuid');

import Order from "../models/order";

import redisClient from "../configs/redisClient";

class OrderController {

    async createOrder(req, res, next) {
        try {
            const { order } = req.body;
            const { user } = req;

            const user_data_redis_store = `userdata:${user.userId.toString()}`;


            const completedOrders = await redisClient.get(`${user_data_redis_store}:completed_orders`);

            //console.log(completedOrders, 'completedOrders');

            const ORDERS_KEY = `orders:${user.userId}`;

            const items = [];
            const cart_total = order.totalAmount;
            const delivery_fee = completedOrders && completedOrders == 0 ? 0 : 3500;
            const service_charge = cart_total * 0.05;
            const order_items = order.items;
            const order_total = cart_total + delivery_fee + service_charge;

            Object.entries(order_items).forEach(([id, item]) => {
                const product_data = {
                    product_id: id,
                    product_name: item.name,
                    product_units: sanitizeUnitKeys(item.units)
                }
                items.push(product_data);
            });


            const userData = await redisClient.hGetAll(user_data_redis_store);

            if (userData) {
                const userAddress = await redisClient.hGet(user_data_redis_store, 'userAddress');
                const order_id = uuidv4();

                const newOrder = {  // Renamed from order to newOrder
                    _id: order_id,
                    userId: user.userId,
                    items,
                    order_address: userAddress,
                    cart_total,
                    delivery_fee,
                    service_charge,
                    total: order_total,
                    status: 'pending',
                    createdAt: Date.now(),
                    delivery_date: 'order incomplete',
                    reference: ''
                }

                const serializedOrder = JSON.stringify(newOrder);

                //console.log('About to push to Redis...');
                const newLength = await redisClient.rPush(ORDERS_KEY, serializedOrder);
                //console.log('Redis push complete, new length:', newLength);

                const orderSummary = `Your order has been created. Below is your order summary:
    
    Order Details
    -----------------
    Cart Total: ₦${cart_total.toLocaleString()}
    Delivery Fee: ₦${delivery_fee.toLocaleString()}
    Service Charge: ₦${service_charge.toLocaleString()}
    Total Amount: ₦${order_total.toLocaleString()}
    Status: Pending Payment
    Delivery Address: ${userAddress}
    
    Please Click the Pay Button to make payment
    
    Click the pay now button to complete payment.`;

    console.log(newOrder, completedOrders, 'newOrder')

                const response = {
                    success: true,
                    data: {
                        message: 'Success response',
                        chatresponse: {
                            text: orderSummary,
                            orderStatus: newOrder.status,  // Updated to use newOrder
                            orderId: newOrder._id,         // Updated to use newOrder
                            isClient: false,
                            isRead: false,
                            payload: newOrder              // Updated to use newOrder
                        }
                    }
                };

                res.status(200).json(response);
            } else {
                res.status(404).json({
                    success: false,
                    message: 'Error creating order invalid user',
                    error: 'User data not found'  // Fixed error reference
                });
            }
        } catch (error) {
            console.log('Error creating order:', error);
            error.statusCode = 400;
            error.payoorDevErrorMessage = 'Error creating order';
            next(error);
        }
    }

    async getOrder(req, res, next) {
        try {
            const orderId = req.query.id;

            const order = await Order.findById(orderId)
                .populate('userId', 'name email');

            if (!order) {
                return res.status(404).json({
                    success: false,
                    message: 'Order not found'
                });
            }

            res.status(200).json({
                success: true,
                data: order
            });

        } catch (error) {
            console.log('error here', error, 'error here')
            error.statusCode = 400;
            error.payoorDevErrorMessage = 'Error fetching order';
            next(error);
        }
    }

    async getUserOrders(req, res, next) {
        try {
            const { status } = req.query;

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            //console.log(status, 'status')

            let orders;

            if (status === 'pending') {
                const ORDERS_KEY = `orders:${req.user.userId}`;

                const pendingOrders = [];

                const serializedOrders = await redisClient.lRange(ORDERS_KEY, 0, -1);
                if (serializedOrders && serializedOrders.length > 0) {
                    pendingOrders.push(...serializedOrders.map(order => JSON.parse(order)));
                }

                orders = pendingOrders;
            } else {
                orders = await Order.find(
                    {
                        userId: req.user.userId,
                        status
                    },
                    { __v: 0 }
                )
                    .sort({ createdAt: -1 })
                    .skip(skip)
                    .limit(limit);
            }

            //console.log(orders)
            const formattedOrders = orders.map(order => ({
                ...(order.toObject ? order.toObject() : order),
                createdAt: moment(order.createdAt).format('MMM D, YYYY • h:mm A')
            }));

            const total = orders.length;

            const data = {
                message: 'Orders retrieved',
                page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: formattedOrders,
            }

            res.status(200).json({
                success: true,
                data
            });

        } catch (error) {
            console.log('error here', error, 'error here')
            error.statusCode = 400;
            error.payoorDevErrorMessage = 'Error fetching orders';
            next(error);
        }
    }

    async getUserOrder(req, res, next) {
        try {
            const { orderId } = req.query;
            const { user } = req;

            if (!orderId) {
                const error = new Error('Order ID is required');
                error.statusCode = 400;
                throw error;
            }

            const ORDERS_KEY = `orders:${user.userId}`;
            const serializedOrders = await redisClient.lRange(ORDERS_KEY, 0, -1);

            if (serializedOrders && serializedOrders.length > 0) {
                const orderIndex = serializedOrders.findIndex(orderStr =>
                    orderStr.includes(orderId)
                );

                if (orderIndex !== -1) {
                    const orderStr = serializedOrders[orderIndex];
                    const order = JSON.parse(orderStr);

                    return res.status(200).json({
                        success: true,
                        message: 'Order retrieved successfully',
                        data: order
                    });
                }
            }

            const order = await Order.findOne({ _id: orderId });

            if (!order) {
                const error = new Error('Order not found');
                error.statusCode = 404;
                throw error;
            }

            return res.status(200).json({
                success: true,
                message: 'Order retrieved successfully',
                data: order
            });

        } catch (error) {
            console.error('Error fetching order:', error);
            error.statusCode = error.statusCode || 400;
            error.payoorDevErrorMessage = 'Error fetching order';
            next(error);
        }
    }

    async getPendingOrder(req, res, next) {
        try {
            const orderId = req.query.id;
            if (!orderId) {
                const error = new Error('Order ID is required');
                error.statusCode = 400;
                throw error;
            }

            const PENDING_ORDER_ID = `pending:${orderId}`;
            const storedOrder = await redisClient.get(PENDING_ORDER_ID);

            if (!storedOrder) {
                const error = new Error('Pending order not found');
                error.statusCode = 404;
                throw error;
            }

            const order = JSON.parse(storedOrder);

            console.log(order, 'this is the order that we want to pay for')

            res.status(200).json({
                status: 'success',
                data: order
            });

        } catch (error) {
            console.error('Error fetching order:', error);
            error.statusCode = error.statusCode || 400;
            error.payoorDevErrorMessage = 'Error fetching order';
            next(error);
        }
    }

    async updateDeliveryDateandAddress(req, res, next) {
        try {
            const { order_id, delivery_date, delivery_address } = req.body;
            const { user } = req;

            if (!order_id || !delivery_date) {
                const error = new Error('Order ID and delivery date are required');
                error.statusCode = 400;
                throw error;
            }

            const ORDERS_KEY = `orders:${user.userId}`;

            const serializedOrders = await redisClient.lRange(ORDERS_KEY, 0, -1);

            if (!serializedOrders || serializedOrders.length === 0) {
                const error = new Error('No orders found');
                error.statusCode = 404;
                throw error;
            }

            const orderIndex = serializedOrders.findIndex(orderStr => orderStr.includes(order_id));

            if (orderIndex === -1) {
                const error = new Error('Order not found');
                error.statusCode = 404;
                throw error;
            }

            const orderStr = serializedOrders[orderIndex];
            const parsedOrder = JSON.parse(orderStr);
            const updatedOrder = {
                ...parsedOrder,
                delivery_date,
                order_address: delivery_address,
                updatedAt: Date.now()
            };

            await redisClient.lSet(ORDERS_KEY, orderIndex, JSON.stringify(updatedOrder));

            const PENDING_ORDER_ID = `pending:${updatedOrder._id}`;

            console.log(PENDING_ORDER_ID, 'PENDING_ORDER_ID')

            await redisClient.set(PENDING_ORDER_ID, JSON.stringify(updatedOrder), {
                EX: 60 * 60 // 1 hour
            });

            const storedOrder = await redisClient.get(PENDING_ORDER_ID);
            const order = JSON.parse(storedOrder);

            //console.log(order, 'stored pending order');

            return res.status(200).json({
                success: true,
                message: 'Delivery date and address updated successfully',
                data: {
                    order
                }
            });

        } catch (error) {
            console.error('Error updating order:', error);
            error.statusCode = error.statusCode || 400;
            error.payoorDevErrorMessage = 'Error updating order delivery date and address';
            next(error);
        }
    }
}

function getTotalAmount(text) {
    const totalPattern = /Total:\s([\d,]+)\sNaira/;
    const match = text.match(totalPattern);

    if (match) {
        return parseInt(match[1].replace(/,/g, ''), 10);
    } else {
        return null;
    }
}

function sanitizeUnitKeys(units) {
    const sanitizedUnits = {};

    Object.entries(units).forEach(([key, value]) => {
        const sanitizedKey = key.replace(/\./g, '_');
        sanitizedUnits[sanitizedKey] = value;
    });

    return sanitizedUnits;
}


export default new OrderController();
