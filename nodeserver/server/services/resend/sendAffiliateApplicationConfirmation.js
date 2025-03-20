require('dotenv').config();
import { Resend } from "resend";

const resend = new Resend(`${process.env.RESEND_API_KEY}`);

async function sendAffiliateApplicationConfirmation({ email }) {
    try {
        const data = await resend.emails.send({
            from: "Payoor <confirmation@affiliate.payoor.store>",
            to: [`${email}`],
            subject: "Your Payoor Affiliate Application Has Been Received",
            html: `
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Payoor Affiliate Application Received</title>
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
                          <p style="margin: 0 0 20px; color: #666666; font-size: 18px; line-height: 24px; text-align: center;">
                            Thank you for applying to the Payoor Affiliate Program!
                          </p>
                          <p style="margin: 0 0 20px; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            We've received your application and it's currently being reviewed by our team.
                          </p>
                          <div style="background-color: #f8f8f8; border-radius: 6px; padding: 20px; text-align: center; margin: 30px 0;">
                            <p style="margin: 0; color: #666666; font-size: 16px; font-weight: bold;">
                              What happens next?
                            </p>
                            <p style="margin: 10px 0 0; color: #666666; font-size: 16px;">
                              You'll receive another email once your application has been reviewed. If approved, we'll provide you with your unique affiliate code.
                            </p>
                          </div>
                          <p style="margin: 20px 0 0; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            Thank you for your interest in partnering with Payoor!
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
        throw new Error('Failed to send affiliate application confirmation email, please try again');
    }
}

export default sendAffiliateApplicationConfirmation;