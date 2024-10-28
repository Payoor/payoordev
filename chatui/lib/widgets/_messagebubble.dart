import 'package:flutter/material.dart';

import 'package:chat/classes/_message.dart';

import 'package:chat/utils/_themecolors.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final BoxConstraints constraints;
  final bool includeWidget;

  const MessageBubble(
      {super.key,
      required this.message,
      required this.constraints,
      this.includeWidget = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            message.username.isEmpty
                ? 'Visitor'
                : message.isUser
                    ? message.username
                    : "Payoor",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ThemeColors.white2,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: message.isUser
                ? ThemeColors.black.withOpacity(.5)
                : ThemeColors.white2.withOpacity(1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: message.isUser || !includeWidget
                  ? Text(message.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: message.isUser
                            ? ThemeColors.white2
                            : ThemeColors.primaryColor,
                      ))
                  : Column(
                      children: [
                        Text(message.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: message.isUser
                                  ? ThemeColors.white2
                                  : ThemeColors.primaryColor,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print("Request new");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Adjust curvature here
                                  side: const BorderSide(
                                    color: ThemeColors
                                        .primaryColor, // Border color
                                    width: .8, // Border width
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                                backgroundColor: ThemeColors
                                    .white2, // Change this to your preferred color
                              ),
                              child: const Text(
                                "Request new otp",
                                style: TextStyle(
                                  fontSize: 13.0, // Adjust text size if needed
                                  fontWeight: FontWeight
                                      .w400, // Optional: make the text bold
                                  color: ThemeColors.primaryColor, // Text color
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
        )
      ],
    ));
  }
}
