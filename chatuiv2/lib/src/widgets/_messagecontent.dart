import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_productroutes.dart';
import 'package:chatuiv2/src/classes/_serverresponse.dart';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_productdisplay.dart';

import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_banipayprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';

import 'package:chatuiv2/src/utils/_global_keys.dart';

//cart.itemCount > 0
class MessageContent extends StatefulWidget {
  final Message message;
  final ScrollController scrollController;
  final int index;
  final List<Message> messagesList;
  final double deliveryFee;
  final List<String> tags;

  const MessageContent({
    Key? key,
    required this.message,
    required this.scrollController,
    required this.index,
    required this.messagesList,
    required this.deliveryFee,
    required this.tags,
  }) : super(key: key);

  @override
  State<MessageContent> createState() => _MessageContentState();
}

class _MessageContentState extends State<MessageContent> {
  bool _showProducts = true;
  bool isBaniPayOpen = false;
  //int value = 0;
  int previousMessageLength = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final messageProvider = context.watch<MessageProvider>();

    if (messageProvider.messages.length != previousMessageLength) {
      previousMessageLength = messageProvider.messages.length;
      setState(() {
        //value = value + 1;
        //_showProducts = false;
      });
    }
  }

  void _setCurrentMessage(int index) {
    context.read<MessageProvider>().setCurrentMessage(index);
  }

  void _handleMessageInteraction() {
    context.read<ResultListProvider>().updateSuggestedPrompts(widget.tags);
    //_getSuggestions(widget.tags[0]);
    _setCurrentMessage(widget.index);
  }

  Future<void> _getSuggestions(String suggestion) async {
    try {
      ServerResponse response = await ProductRoute.getSuggestion(suggestion);
      if (response.data['results'] != null) {
        final results = (response.data['results'] as List)
            .map((item) => Map<String, String>.from(item))
            .toList();

        final suggestions =
            context.read<ResultListProvider>().suggested_prompts;

        context
            .read<ResultListProvider>()
            .setCurrentSuggestions(suggestion: suggestion);

        context.read<ResultListProvider>().updateResults(
            total: results.length,
            results: results,
            suggested_prompts: suggestions);
      }
    } catch (e) {
      // Handle error appropriately
    }
  }

  void openBaniPay(String? orderId) {
    context.read<BaniPayProvider>().setCurrentOrder('$orderId');
    setState(() {
      isBaniPayOpen = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _showProducts = widget.message.isProductsDisplay;

    keys['$widget.key'] = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, messageProvider, child) {
        final isLastMessage = widget.index == widget.messagesList.length - 1;
        final isCurrentMessage =
            messageProvider.currentMessageIndex == widget.index;
        final shouldShowProducts = isLastMessage;

        return Column(
            key: widget.key,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TypewriterText(
                            key: widget.key,
                            text: widget.message.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            duration: Duration(milliseconds: 1500),
                            showCursor: true,
                            scrollController: widget.scrollController,
                            onTap: () {
                              setState(() {
                                //_showProducts = !_showProducts;
                              });

                              _handleMessageInteraction();

                              scrollToSection('$widget.key');
                            },
                            onComplete: () {
                              setState(() {
                                _showProducts =
                                    widget.message.isProductsDisplay;
                              });

                              _handleMessageInteraction();
                            },
                          ))),
                ),
                widget.message.isProductsDisplay &&
                            shouldShowProducts &&
                            isCurrentMessage ||
                        isCurrentMessage
                    ? Positioned(
                        top: 13,
                        right: 10,
                        child: Icon(
                          _showProducts
                              ? Icons.view_list
                              : Icons.view_agenda_outlined,
                          color: AppColors.primaryColor.withOpacity(0.8),
                          size: 17,
                        ),
                      )
                    : SizedBox(),
              ]),
              widget.message.isProductsDisplay &&
                          shouldShowProducts &&
                          isCurrentMessage ||
                      isCurrentMessage
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Visibility(
                              visible: _showProducts || isCurrentMessage,
                              maintainState: true,
                              child: shouldShowProducts || isCurrentMessage
                                  ? ProductDisplay(showProducts: _showProducts)
                                  : SizedBox())),
                    )
                  : SizedBox(),
            ]);
      },
    );
  }
}
