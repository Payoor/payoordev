import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_appcolors.dart';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_productdisplay.dart';
import 'package:chatuiv2/src/widgets/_cartdisplay.dart';

import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';

//cart.itemCount > 0
class MessageContent extends StatefulWidget {
  final Message message;
  final ScrollController scrollController;
  final int index;
  final List<Message> messagesList;
  final double deliveryFee;

  const MessageContent(
      {Key? key,
      required this.message,
      required this.scrollController,
      required this.index,
      required this.messagesList,
      required this.deliveryFee})
      : super(key: key);

  @override
  State<MessageContent> createState() => _MessageContentState();
}

class _MessageContentState extends State<MessageContent> {
  bool _showProducts = false;
  bool _showCart = false;
  int value = 0;
  int previousMessageLength = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final messageProvider = context.watch<MessageProvider>();

    if (messageProvider.messages.length != previousMessageLength) {
      previousMessageLength = messageProvider.messages.length;
      setState(() {
        value = value + 1;
        _showProducts = false;
        _showCart = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showProducts = widget.message.isProductsDisplay;
    _showCart = widget.message.isCartView;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, messageProvider, child) {
        return Column(
            key: ValueKey(
                'message_content_${widget.message.clienttimestamp?.millisecondsSinceEpoch}'),
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.greyBlack.withOpacity(.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TypewriterText(
                            key: ValueKey(
                                'message_${widget.message.clienttimestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}'),
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
                                _showProducts = !_showProducts;
                              });
                            },
                            onComplete: () {
                              setState(() {
                                _showProducts =
                                    widget.message.isProductsDisplay;
                                _showCart = widget.message.isCartView;
                              });
                            },
                          ))),
                ),
                widget.message.isProductsDisplay
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
              if (widget.message.isCartView && _showCart)
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Column(
                      children: [
                        CartDisplay(),
                        cartProvider.itemCount > 0
                            ? Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.greyBlack.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TypewriterText(
                                      key: ValueKey(
                                          'message_${widget.message.clienttimestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}'),
                                      text:
                                          "Cart Total: ₦ ${cartProvider.totalAmount}\n",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      duration: Duration(milliseconds: 1500),
                                      showCursor: true,
                                      scrollController: widget.scrollController,
                                      onTap: () {},
                                      onComplete: () {
                                        setState(() {
                                          _showProducts =
                                              widget.message.isProductsDisplay;
                                          _showCart = widget.message.isCartView;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    );
                  },
                ),
              if (widget.message.isProductsDisplay &&
                  widget.message.results.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Visibility(
                          visible:
                              _showProducts,
                          maintainState: true,
                          child: ProductDisplay())),
                ),
            ]);
      },
    );
  }
}
