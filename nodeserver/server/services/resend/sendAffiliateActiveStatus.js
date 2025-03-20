require('dotenv').config();
import { Resend } from "resend";

const resend = new Resend(`${process.env.RESEND_API_KEY}`);

async function sendAffiliateActiveStatus({ email, affiliateCode }) {
    try {
        const data = await resend.emails.send({
            from: "Payoor <updates@affiliate.payoor.store>",
            to: [`${email}`],
            subject: "Your Payoor Affiliate Application is Approved",
            html: `
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Your Payoor Affiliate Application is Approved</title>
            </head>
            <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
              <table role="presentation" cellpadding="0" cellspacing="0" style="width: 100%; background-color: #f4f4f4; padding: 20px;">
                <tr>
                  <td align="center">
                    <table role="presentation" cellpadding="0" cellspacing="0" style="max-width: 600px; width: 100%; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                      <!-- Header -->
                      <tr>
                        <td style="background-color: rgba(36, 155, 72, 1); padding: 30px 0; text-align: center;">
                        </td>
                      </tr>
                      
                      <!-- Content -->
                      <tr>
                        <td style="padding: 40px 30px;">
                          <p style="margin: 0 0 30px; color: #666666; font-size: 18px; line-height: 24px; text-align: center;">
                            Congratulations! Your application to the Payoor affiliate program has been accepted.
                          </p>
                          <p style="margin: 0 0 20px; color: #666666; font-size: 18px; line-height: 24px; text-align: center;">
                            Your affiliate coupon code is:
                          </p>
                          <div style="background-color: #f8f8f8; border-radius: 6px; padding: 20px; text-align: center; margin-bottom: 20px;">
                            <span style="font-family: monospace; font-size: 32px; font-weight: bold; letter-spacing: 4px; color: rgba(36, 155, 72, 1);">
                              ${affiliateCode}
                            </span>
                          </div>
                          
                          <!--<p style="margin: 25px 0; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            Need more affiliate codes? Generate them here:
                          </p>
                          
                          <div style="text-align: center; margin-bottom: 20px;">
                            <a href="https://payoor.store/affiliateprogram/generate-codes" style="display: inline-block; padding: 12px 24px; background-color: rgba(36, 155, 72, 1); color: #ffffff; text-decoration: none; border-radius: 4px; font-weight: bold;">
                              Generate More Codes
                            </a>
                          </div>-->
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
        throw new Error('Failed to send affiliate approval email, please try again');
    }
}

export default sendAffiliateActiveStatus;