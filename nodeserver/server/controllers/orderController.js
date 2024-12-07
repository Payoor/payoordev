import Order from "../models/order";
import User from "../models/user";

class OrderController {

    async createOrder(req, res, next) {
        try {
            const { order } = req.body;
            const { user } = req;

            const total = order.totalAmount;
            const order_items = order.items
            const items = [];

            Object.entries(order_items).forEach(([id, item]) => {
                const product_data = {
                    product_id: id,
                    product_name: item.name,
                    product_units: item.units
                }

                items.push(product_data);
            });

            if (user) {
                const validUser = await User.findOne({ _id: user.userId });

                if (validUser) {

                    const order = new Order({
                        userId: validUser._id,
                        total,
                        items
                    });

                    req.total = total;
                    req.items = items;
                    req.email = validUser.email;
                    req.orderId = order._id;
                    req.userId = validUser._id;

                    await order.save();

                    next();
                } else {
                    res.status(500).json({
                        success: false,
                        message: 'Error creating order invalid user',
                        error: error.message
                    });
                }
            } else {
                res.status(500).json({
                    success: false,
                    message: 'Error creating order',
                    error: error.message
                });
            }

        } catch (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error creating order',
                error: error.message
            });
        }
    }

    async getOrder(req, res) {
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
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error fetching order',
                error: error.message
            });
        }
    }

    async getUserOrders(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const orders = await Order.find({ userId: req.user.userId }, { __v: 0 })
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = orders.length;

            res.status(200).json({
                message: 'Orders retrieved',
                page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                orders: orders,
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error fetching orders',
                error: error.message
            });
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

export default new OrderController();