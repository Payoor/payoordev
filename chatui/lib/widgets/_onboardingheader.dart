import 'package:flutter/material.dart';

import 'package:chat/utils/_themecolors.dart';

class OnboardingHeader extends StatefulWidget {
  const OnboardingHeader({super.key});

  @override
  State<OnboardingHeader> createState() => _OnboardingHeaderState();
}

class _OnboardingHeaderState extends State<OnboardingHeader> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(left: 20, right: 30, top: 40),
        child: Column(
          children: [
            Text("Make a grocery",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  height: 1.2,
                  color: ThemeColors.white2,
                )),
            Text("list and leave",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  height: 1.2,
                  color: ThemeColors.white2,
                )),
            Text("the rest to us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  height: 1.2,
                  color: ThemeColors.white2,
                ))
          ],
        ));
  }
}
