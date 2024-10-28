import 'package:flutter/material.dart';

import 'package:chat/widgets/_header.dart';
import 'package:chat/widgets/chatmessages.dart';
import 'package:chat/widgets/_chatinputwidget.dart';
import 'package:chat/widgets/_sidenav.dart';

import 'package:chat/utils/_themecolors.dart';

import 'package:chat/classes/_basechatclass.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseChatClass<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: ThemeColors.primaryColor,
              ),
              child: Stack(
                children: [
                  HeaderWidget(constraints: constraints),
                  ChatMessages(
                    scrollController: scrollController,
                    constraints: constraints,
                    payoorIsTyping: payoorIsTyping
                  ),
                  ChatInputWidget(
                    textController: textController,
                    isInputReady: isInputReady,
                    onSendMessage: sendMessage,
                    currentFormState: currentFormState
                  ),
                  CustomSideNav(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}