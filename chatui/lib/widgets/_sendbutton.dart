import 'package:flutter/material.dart';

import 'package:chat/utils/_themecolors.dart';

class SendButton extends StatelessWidget {
  final bool isInputReady;
  final VoidCallback onSendMessage;

  const SendButton({
    Key? key,
    required this.isInputReady,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isInputReady ? onSendMessage : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isInputReady
              ? ThemeColors.primaryColor
              : ThemeColors.primaryColor.withOpacity(.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_upward,
          size: 20.0,
          color: isInputReady
              ? ThemeColors.white
              : ThemeColors.white.withOpacity(.4),
        ),
      ),
    );
  }
}