import 'package:flutter/material.dart';

import 'package:chat/utils/_themecolors.dart';

import 'package:chat/widgets/attachmentoptions.dart';
import 'package:chat/widgets/_chattextfield.dart';
import 'package:chat/widgets/_sendbutton.dart';

import 'package:chat/classes/_customformstate.dart';

class ChatInputWidget extends StatelessWidget {
  final TextEditingController textController;
  final bool isInputReady;
  final VoidCallback onSendMessage;
  final CustomFormState currentFormState;

  const ChatInputWidget({
    Key? key,
    required this.textController,
    required this.isInputReady,
    required this.onSendMessage,
    required this.currentFormState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.1,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColors.black.withOpacity(.9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ChatTextField(
                          textController: textController,
                          currentFormState: currentFormState),
                    ),
                    SendButton(
                      isInputReady: isInputReady,
                      onSendMessage: onSendMessage,
                    ),
                  ],
                ),
                if (currentFormState.inputType == 'isLoggedInInput')
                  const AttachmentOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
