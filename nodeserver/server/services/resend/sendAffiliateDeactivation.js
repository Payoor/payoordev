require('dotenv').config();
import { Resend } from "resend";

const resend = new Resend(`${process.env.RESEND_API_KEY}`);

async function sendAffiliateDeactivation({ email, affiliateCode, reason }) {
    try {
        const data = await resend.emails.send({
            from: "Payoor <updates@affiliate.payoor.store>",
            to: [`${email}`],
            subject: "Your Payoor Affiliate Account has been Deactivated",
            html: `
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Your Payoor Affiliate Account has been Deactivated</title>
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
                            Important Notice: Your Payoor affiliate account and affiliate code has been deactivated.
                          </p>
                          
                          <div style="background-color: #f8f8f8; border-radius: 6px; padding: 20px; text-align: center; margin-bottom: 20px;">
                            <span style="font-family: monospace; font-size: 24px; font-weight: bold; color: #666666;">
                              ${affiliateCode}
                            </span>
                            <p style="margin: 10px 0 0; color: #999999;">Deactivated</p>
                          </div>
                          
                          ${reason ? `
                          <p style="margin: 25px 0; color: #666666; font-size: 16px; line-height: 24px;">
                            <strong>Reason for deactivation:</strong> ${reason}
                          </p>
                          ` : ''}
                          
                          <p style="margin: 25px 0; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            If you believe this was done in error or would like to appeal this decision, please contact our support team.
                          </p>
                          
                          <div style="text-align: center; margin-bottom: 20px;">
                            <a href="https://payoor.store/contact" style="display: inline-block; padding: 12px 24px; background-color: rgba(36, 155, 72, 1); color: #ffffff; text-decoration: none; border-radius: 4px; font-weight: bold;">
                              Contact Support
                            </a>
                          </div>
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
        throw new Error('Failed to send affiliate deactivation email, please try again');
    }
}

export default sendAffiliateDeactivation;