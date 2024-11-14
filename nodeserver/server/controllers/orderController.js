import Order from "../models/order";
import User from "../models/user";

class OrderController {

    async createOrder(req, res, next) {
        try {
            const { items } = req.body;

            const total = 500;

            if (req.user) {
                const validUser = await User.findOne({ _id: req.user.userId });

                if (validUser) {
                    const order = new Order({
                        userId: validUser._id,
                        total,
                        items
                    });

                    console.log('order', order);

                    req.total = total;
                    req.items = items;
                    req.email = validUser.email;

                    console.log('validUser', validUser, req.email, req.total)

                    next();
                } else {
                    res.status(500).json({
                        success: false,
                        message: 'Error creating order',
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

            /*const order = new Order({
                userId,
                total
            });

            await order.save();

            res.status(200).json({
                success: true,
                data: order,
                message: 'Order created successfully'
            });*/

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
            const orderId = req.params.id;

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

    async getOrders(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const total = await Order.countDocuments();

            const orders = await Order.find()
                .populate('userId', 'name email')
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            res.status(200).json({
                success: true,
                data: orders,
                pagination: {
                    currentPage: page,
                    totalPages: Math.ceil(total / limit),
                    totalItems: total,
                    itemsPerPage: limit
                }
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

    async getUserOrders(req, res) {

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