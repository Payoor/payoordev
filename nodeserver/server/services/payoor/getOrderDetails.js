import Order from '../../models/order';
import User from '../../models/user';

import redisClient from "../../configs/redisClient";

import sendPaymentConfirmation from '../resend/sendPaymentConfirmation';

async function getOrderDetails(orderid) {
    try {
        const order = await Order.findOne({ _id: orderid })
            .populate('userId', 'email name');

        if (order) {
            const itemsWithUnits = getItemUnits(order.items);
            const user_name = order.userId.name;
            const user_email = order.userId.email;
            const order_address = order.order_address;
            const total = order.total;

            const user = await User.findById(order.userId);
            const user_data_redis_store = `userdata:${user._id.toString()}`;

            user.completed_orders = (user.completed_orders ?? 0) + 1;
            await user.save();

            await redisClient.set(
                `${user_data_redis_store}:completed_orders`,
                user.completed_orders
            );

            console.log(user_name, user_email, itemsWithUnits, order_address, total);
            sendPaymentConfirmation({
                email: user_email,
                orderdetails: {
                    total,
                    items: itemsWithUnits,
                    order_address
                }
            });
        }
    } catch (error) {
        console.error('Error updating completed orders:', error);
    }
}

function getItemUnits(items) {
    return items.map(item => {
        const { product_name, product_units } = item;

        const units = Object.entries(product_units).map(([unitName, details]) => ({
            unit_name: unitName,
            price: details.price,
            quantity: details.quantity,
            total: details.price * details.quantity
        }));

        return {
            product_name,
            product_units: units
        };
    });
}

export default getOrderDetails