import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chat/utils/_themecolors.dart';

import 'package:flutter/material.dart';

class PhoneNumber extends StatelessWidget {
  final String phoneNumber;

  const PhoneNumber({super.key, required this.phoneNumber});

  List<String> _splitPhoneNumber(String number) {
    return number.split('');
  }

  @override
  Widget build(BuildContext context) {
    // Convert the phone number to an array
    List<String> phoneNumberArray = _splitPhoneNumber(phoneNumber);

    return Row(
      children: List.generate(
          phoneNumberArray.length,
          (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 40.0,
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: ThemeColors.white2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(phoneNumberArray[index])),
              )),
    );
  }
}
