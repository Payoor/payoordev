import moment from "moment";

import Order from "../models/order";
import User from "../models/user";

class OrderController {

    async createOrder(req, res, next) {
        try {
            const { order, order_address } = req.body;
            const { user } = req;

            console.log(order);

            const items = [];
            const cart_total = order.totalAmount;
            const delivery_fee = 3500;
            const service_charge = cart_total * 0.05;
            const order_items = order.items;
            const order_total = cart_total + delivery_fee + service_charge

            console.log(delivery_fee, service_charge, cart_total)

            Object.entries(order_items).forEach(([id, item]) => {
                const product_data = {
                    product_id: id,
                    product_name: item.name,
                    product_units: sanitizeUnitKeys(item.units)
                }

                items.push(product_data);
            });

            if (user) {
                const validUser = await User.findOne({ _id: user.userId });

                if (validUser) {
                    const order = new Order({
                        userId: validUser._id,
                        items,
                        order_address,
                        cart_total,
                        delivery_fee,
                        service_charge,
                        total: order_total,
                    });

                    await order.save();

                    console.log(order);
                    items.forEach(item => {
                        console.log(item.product_units)
                    })

                    const orderSummary = `Your order has been created. Below is your order summary:

Order Details
-----------------
Cart Total: ₦${cart_total.toLocaleString()}
Delivery Fee: ₦${delivery_fee.toLocaleString()}
Service Charge: ₦${service_charge.toLocaleString()}
Total Amount: ₦${order_total.toLocaleString()}

Delivery Address: ${order_address}

Please Click the Pay Button to make payment

Thank you for your order! We will keep you updated on its status.`;

                    const response = {
                        success: true,
                        data: {
                            message: 'Success response',
                            chatresponse: {
                                text: orderSummary,
                                isClient: false,
                                isRead: false,
                                payload: order
                            }
                        }
                    };

                    res.status(200).json(response);
                }
            } else {
                res.status(500).json({
                    success: false,
                    message: 'Error creating order invalid user',
                    error: error.message
                });
            }

        } catch (error) {
            console.log('error here', error, 'error here')
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
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const orders = await Order.find({ userId: req.user.userId }, { __v: 0 })
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            const formattedOrders = orders.map(order => ({
                ...order.toObject(),
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