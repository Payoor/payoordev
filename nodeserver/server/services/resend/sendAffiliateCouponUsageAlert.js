require('dotenv').config();
import { Resend } from "resend";

const resend = new Resend(`${process.env.RESEND_API_KEY}`);

async function sendAffiliateCouponUsageAlert({ email, affiliateCode, amountSpent, payout }) {
    try {
        const data = await resend.emails.send({
            from: "Payoor <updates@affiliate.payoor.store>",
            to: [`${email}`],
            subject: "Your Affiliate Coupon Was Just Used! 💰",
            html: `
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Your Affiliate Coupon Was Used</title>
            </head>
            <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
              <table role="presentation" cellpadding="0" cellspacing="0" style="width: 100%; background-color: #f4f4f4; padding: 20px;">
                <tr>
                  <td align="center">
                    <table role="presentation" cellpadding="0" cellspacing="0" style="max-width: 600px; width: 100%; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                      <!-- Header -->
                      <tr>
                        <td style="background-color: rgba(36, 155, 72, 1); padding: 30px 0; text-align: center;">
                          <h1 style="margin: 0; color: #ffffff; font-size: 24px; line-height: 30px;">
                            Your Affiliate Coupon Was Used!
                          </h1>
                        </td>
                      </tr>
                      
                      <!-- Content -->
                      <tr>
                        <td style="padding: 40px 30px;">
                          <p style="margin: 0 0 20px; color: #666666; font-size: 18px; line-height: 24px; text-align: center;">
                            Great news! Someone just used your affiliate coupon code.
                          </p>
                          
                          <div style="background-color: #f8f8f8; border-radius: 6px; padding: 20px; margin-bottom: 20px;">
                            <p style="margin: 0 0 10px; color: #666666; font-size: 16px; line-height: 24px;">
                              <strong>Coupon Code:</strong> 
                              <span style="font-family: monospace; font-size: 18px; color: rgba(36, 155, 72, 1);">
                                ${affiliateCode}
                              </span>
                            </p>
                            <p style="margin: 0 0 10px; color: #666666; font-size: 16px; line-height: 24px;">
                              <strong>Amount Spent:</strong> $${amountSpent}
                            </p>
                            <p style="margin: 0; color: #666666; font-size: 16px; line-height: 24px;">
                              <strong>Your Payout:</strong> 
                              <span style="font-weight: bold; color: rgba(36, 155, 72, 1);">
                                $${payout}
                              </span>
                            </p>
                          </div>
                          
                          <p style="margin: 25px 0 15px; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            This payout will be added to your affiliate account and included in your next payment.
                          </p>
                          
                          <p style="margin: 0 0 20px; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            Keep sharing your affiliate code to earn more!
                          </p>
                        </td>
                      </tr>
                      
                      <!-- Footer -->
                      <tr>
                        <td style="padding: 20px 30px; background-color: #f8f8f8; text-align: center;">
                          <p style="margin: 0; color: #999999; font-size: 14px;">
                            This is an automated message, please do not reply to this email.
                          </p>
                          <p style="margin: 10px 0 0; color: #999999; font-size: 14px;">
                            © 2025 Payoor. All rights reserved.
                          </p>
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
    } catch (error) {
        console.error('Email sending error:', error);
        throw new Error('Failed to send affiliate coupon usage alert email');
    }
}

export default sendAffiliateCouponUsageAlert;