require('dotenv').config();

import { Resend } from "resend";

const resend = new Resend(`${process.env.RESEND_API_KEY}`);

async function sendPaymentConfirmation({ email, orderdetails }) {
    try {
        if (email) {
            const generateOrderItemsHTML = (items) => {
                let itemsHTML = items.map(item => {
                    const unitsHTML = item.product_units.map(unit => `
                        <tr>
                            <td style="font-size: 14px; color: #666666; padding: 4px 0;">${unit.unit_name} × ${unit.quantity}</td>
                            <td align="right" style="font-size: 14px;">₦${unit.total.toLocaleString()}</td>
                        </tr>
                    `).join('');
 
                    return `
                        <tr>
                            <td style="padding: 15px 0 5px 0; border-top: 1px solid #eee;">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="font-size: 16px; font-weight: bold; padding-bottom: 10px;">${item.product_name}</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                ${unitsHTML}
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    `;
                }).join('');
 
                // Calculate grand total
                const grandTotal = items.reduce((total, item) =>
                    total + item.product_units.reduce((itemTotal, unit) => itemTotal + unit.total, 0)
                    , 0);
 
                // Add total row
                itemsHTML += `
                    <tr>
                        <td style="border-top: 1px solid #000000; padding-top: 15px; margin-top: 15px;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="font-size: 16px; font-weight: bold;">Total</td>
                                    <td align="right" style="font-size: 16px; font-weight: bold;">₦${orderdetails.total.toLocaleString()}</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                `;
 
                return itemsHTML;
            };
 
            const data = await resend.emails.send({
                from: "Payoor <confirmation@order.payoor.store>",
                to: [`${email}`],
                subject: "Order payment confirmed",
                html: `
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                    <title>Order Payment Confirmed!</title>
                </head>
                <body style="margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif; background-color: #ffffff;">
                    <!-- Email wrapper -->
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #ffffff;">
                        <tr>
                            <td align="center" style="padding: 0;">
                                <!-- Header/Jumbotron -->
                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #249B48;">
                                    <tr>
                                        <td align="center" style="padding: 40px 0;">
                                            
                                        </td>
                                    </tr>
                                </table>
                
                                <!-- Main Content -->
                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #ffffff;">
                                    <tr>
                                        <td style="padding: 40px 20px;">
                                            <!-- Order Confirmed Header -->
                                            <h1 style="color: #333333; text-align: center; margin: 0 0 30px 0; text-transform: uppercase; font-size: 26px;">Order Confirmed</h1>
                
                                            <!-- Order Details -->
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 30px;">
                                                <tr>
                                                    <td style="background-color: #f9f9f9; padding: 20px; border-radius: 4px;">
                                                        <!-- Order Items -->
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            ${generateOrderItemsHTML(orderdetails.items)}
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                
                                            <!-- Delivery Address -->
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 30px;">
                                                <tr>
                                                    <td align="center" style="padding: 15px; color: #000000; font-size: 16px;">
                                                        To be delivered to ${orderdetails.order_address}
                                                    </td>
                                                </tr>
                                            </table>
                
                                            <!-- Delivery Image -->
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="center">
                                                       
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </body>
                </html>
                `
            });
 
            console.log(data, 'data');
            return data;
        } else {
            throw new Error('email sending failed, try again');
        }
    } catch (error) {
        throw new Error('email sending failed, try again');
    }
 }

export default sendPaymentConfirmation;