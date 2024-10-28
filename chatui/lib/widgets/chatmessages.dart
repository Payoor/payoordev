import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/widgets/_messagebubble.dart';
import 'package:chat/widgets/_wavydotsloading.dart';

import 'package:chat/providers/_message_provider.dart';

import 'package:chat/classes/_message.dart';

class ChatMessages extends StatelessWidget {
  final ScrollController scrollController;
  final BoxConstraints constraints;
  final bool payoorIsTyping;

  const ChatMessages(
      {Key? key,
      required this.scrollController,
      required this.constraints,
      required this.payoorIsTyping})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      bottom: MediaQuery.of(context).viewInsets.bottom +
          MediaQuery.of(context).size.height * 0.2,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              children: [
                const SizedBox(height: 46),
                Expanded(
                  child: Consumer<MessageProvider>(
                    builder: (context, messageProvider, child) {
                      List<Message> messages = messageProvider.messages;
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: messages[index].isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                MessageBubble(
                                  message: messages[index],
                                  constraints: constraints,
                                ),
                                messages[index].isUser &&
                                        index == messages.length - 1 &&
                                        payoorIsTyping
                                    ? Container(
                                        width: double.infinity,
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            WavyDotsLoading(),
                                          ],
                                        ))
                                    : const SizedBox()
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
