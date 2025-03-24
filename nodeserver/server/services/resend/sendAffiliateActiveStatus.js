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
                            Your affiliate link is:
                          </p>
                          <div style="background-color: #f8f8f8; border-radius: 6px; padding: 20px; text-align: center; margin-bottom: 20px;">
                            <span style="font-family: monospace; font-size: 32px; font-weight: bold; letter-spacing: 4px; color: rgba(36, 155, 72, 1);">
                            https://payoor.store?affiliatecode=${affiliateCode}
                            </span>
                          </div>
                          
                          <p style="margin: 30px 0 10px; color: #333333; font-size: 18px; font-weight: bold; text-align: center;">
                            How to Start Earning:
                          </p>
                          <ul style="color: #666666; font-size: 16px; line-height: 24px; padding-left: 20px;">
                            <li>✅ Share your link with friends, family, and followers.</li>
                            <li>✅ Earn 11% commission instantly when they make a purchase.</li>
                            <li>✅ Get an extra ₦15,000 instantly when 10 people you refer make a purchase within a week!</li>
                          </ul>
                          
                          <p style="margin: 20px 0; color: #333333; font-size: 16px; font-weight: bold; text-align: center;">
                            Bonus Tip: First-time users get FREE delivery, making it easier for them to try Payoor! 🚀
                          </p>
                          
                          <p style="margin: 25px 0; color: #666666; font-size: 16px; line-height: 24px; text-align: center;">
                            Start sharing now and watch your earnings grow.
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
    throw new Error('Failed to send affiliate approval email, please try again');
  }
}


export default sendAffiliateActiveStatus;