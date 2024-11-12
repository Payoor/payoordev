import 'package:chatuiv2/src/widgets/_custominput.dart';

class AuthMessages {
  static String getEmailMessage() {
    return "What's your email address? We'll send you an otp as well as important updates here";
  }

  static String getOtpMessage() {
    return "We just sent you an otp pls send it back to confirm your email. Please check your spam if it doesn't appear in your inbox";
  }

  static String getPhoneMessage() {
    return "Add your Nigerian phone number for order updates and delivery notifications";
  }

  static String getNameMessage() {
    return "Tell us your name so we can personalize your shopping experience";
  }

  static String getLocationMessage() {
    return "Where would you like your groceries delivered? Enter your delivery address";
  }

  static String getShoppingListMessage() {
    return "What items do you typically look for when grocery shopping? List them below";
  }

  static String getMessageForInputType(CustomInputType type) {
    switch (type) {
      case CustomInputType.name:
        return getNameMessage();
      case CustomInputType.email:
        return getEmailMessage();
      case CustomInputType.otp:
        return getOtpMessage();
      case CustomInputType.phoneNumber:
        return getPhoneMessage();
      case CustomInputType.location:
        return getLocationMessage();
      case CustomInputType.multiline:
        return getShoppingListMessage();
    }
  }
}
