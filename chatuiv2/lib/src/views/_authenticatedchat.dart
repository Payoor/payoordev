import 'package:flutter/material.dart';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_headerrow.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class AuthenticatedChat extends StatefulWidget {
  const AuthenticatedChat({super.key});

  @override
  State<AuthenticatedChat> createState() => _AuthenticatedChatState();
}

class _AuthenticatedChatState extends State<AuthenticatedChat> {
  bool isInitialAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          isInitialAnimationComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColorDark,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRow(),
                  ],
                ))));
  }
}
