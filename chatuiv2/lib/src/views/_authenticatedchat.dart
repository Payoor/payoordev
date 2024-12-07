import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'dart:async';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';
import 'package:chatuiv2/src/widgets/_paystackviewcontainer.dart';
import 'package:chatuiv2/src/widgets/_productdisplay.dart';

import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_chatapiroutes.dart';
import 'package:chatuiv2/src/classes/_paystackroutes.dart';
import 'package:chatuiv2/src/classes/_socketservice.dart';

class AuthenticatedChat extends StatefulWidget {
  const AuthenticatedChat({super.key});

  @override
  State<AuthenticatedChat> createState() => _AuthenticatedChatState();
}

class _AuthenticatedChatState extends State<AuthenticatedChat>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool isInitialAnimationComplete = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _controller = TextEditingController();
  int _selectedPillIndex = 0;
  bool _isDrawerOpen = true;
  bool _showProducts = false;
  bool _payStackViewOpen = false;
  late StreamSubscription _subscription;

  final List<Map> pills = [
    {"label": "Cart", "action": "View Cart"},
    {"label": "Pay", "action": "Proceed to payment"},
  ];

  @override
  void initState() {
    super.initState();
    _startInitialAnimation();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().addListener(() {
        _scrollToBottom();
      });
    });

    _subscription = SocketService.transactionStream.listen((data) {
      if (data["reference"] == null) return;
      final String orderReference = data["reference"];

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        closePaystackView(context);
        SocketService.disconnectFromSocketServer();

        Future(() => confirmOrderDetails(orderReference));
      }
    }, onError: (error) {
      print('Socket error: $error');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void initializeSocket() {
    SocketService.connectToSocketServer();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startInitialAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isInitialAnimationComplete = true;
        });
      }
    });
  }

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void closePaystackView(BuildContext context) {
    setState(() {
      _payStackViewOpen = false;
    });

    Provider.of<CartProvider>(context, listen: false).clear();

    SocketService.disconnectFromSocketServer();
  }

  void confirmOrderDetails(order_reference) async {
    if (mounted) {
      setState(() {
        _showProducts = false;
      });

      context.read<MessageProvider>().addMessage(Message(
            text: '',
            isClient: false,
            isRead: false,
            isLoading: true,
          ));
      _scrollToBottom();
    }

    final response = await ChatApiRoutes.getOrderDetails(order_reference);

    if (response?.data != null && response.data['chatresponse'] != null) {
      final chatResponse = response.data['chatresponse'];

      Message aiMessage;

      aiMessage = Message(
        text: chatResponse['text'] ?? 'Sorry, I could not process that.',
        isClient: false,
        isRead: false,
      );

      context.read<MessageProvider>().removeLastMessage();
      context.read<MessageProvider>().addMessage(aiMessage);
      _scrollToBottom();
    }
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-300 + (300 * _animationController.value), 0),
          child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 50),
                ListTile(
                  title: Text(
                    'Menu Item 1',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _toggleDrawer();
                  },
                ),
                ListTile(
                  title: Text(
                    'Menu Item 2',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _toggleDrawer();
                    // Add navigation logic
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration get _inputDecoration => InputDecoration(
        counterText: "",
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 23,
        ),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(width: .5, opacity: 1.0),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.5),
            width: .5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: .5,
          ),
        ),
        hintText: "Create a list",
        hintStyle: TextStyle(
          color: AppColors.primaryColor.withOpacity(.5),
        ),
      );

  OutlineInputBorder _buildBorder({double width = .5, double opacity = 0.3}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.transparent.withOpacity(opacity),
        width: width,
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedHeader(),
            Expanded(
              child: _renderMessages(),
            ),
            _buildPillsSlide(),
            _buildTextField(),
          ],
        ),
      ),
    );
  }

  Widget _renderMessages() {
    return Selector<MessageProvider, List<Message>>(
      selector: (_, provider) => provider.messages,
      builder: (context, messages, child) {
        final messagesList = messages.toList().reversed.toList();

        return ListView.builder(
          controller: _scrollController,
          reverse: false,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: messagesList.length,
          itemBuilder: (context, index) {
            final message = messagesList[messagesList.length - 1 - index];

            if (message.isClient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }

            if (message.isLoading) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: AiLoadingIndicator(),
              );
            }

            if (message.isPayStackView && _payStackViewOpen) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PayStackViewContainer(url: message.paymentUrl),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, // Takes full width
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
                              'message_${message.clienttimestamp.millisecondsSinceEpoch}'),
                          text: message.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          duration: Duration(milliseconds: 1500),
                          showCursor: true,
                          scrollController: _scrollController,
                          onTap: () {},
                          onComplete: () {
                            setState(() {
                              _showProducts = true;
                            });
                          },
                        )),
                  ),
                ),
                if (message.isProductsDisplay &&
                    _showProducts &&
                    message.results.isNotEmpty &&
                    index == messagesList.length - 1) ...[
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          child: ProductDisplay())),
                ]
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedOpacity(
      opacity: isInitialAnimationComplete ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: HeaderRow(),
    );
  }

  Widget _buildPillsSlide() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20, top: 20),
        child: Row(
          children: [
            Consumer<ResultListProvider>(
              builder: (context, resultList, child) {
                final suggested_prompts = [
                  ...pills,
                  ...resultList.suggested_prompts
                ];

                return Row(
                  children: [
                    ...List.generate(
                      suggested_prompts.length,
                      (index) => Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          return suggested_prompts[index]['label'] == "Cart" &&
                                      cart.itemCount == 0 ||
                                  suggested_prompts[index]['label'] == "Pay" &&
                                      cart.itemCount == 0
                              ? SizedBox()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: InkWell(
                                    onTap: () {
                                      final action =
                                          suggested_prompts[index]['action'];
                                      if (action != null &&
                                          action == "View Cart") {
                                        _handleCartQuery();
                                      } else if (action != null &&
                                          action == "Proceed to payment") {
                                        print('handle payment');
                                        //_handlePayment();
                                        _handlePaymentLinkGeneration();
                                      } else {
                                        _selectedPillIndex = index;
                                        print(suggested_prompts[index]['text']);
                                        setState(() {});
                                      }
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            suggested_prompts[index]['label'] ??
                                                '',
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.6),
                                            ),
                                          ),
                                        ),
                                        if (suggested_prompts[index]['label'] ==
                                                'Cart' &&
                                            cart.itemCount > 0)
                                          Positioned(
                                            top: -8,
                                            right: -8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .red, // or any color you prefer
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Consumer<CartProvider>(
                                                builder:
                                                    (context, cart, child) =>
                                                        Text(
                                                  '${cart.itemCount}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          TextField(
            controller: _controller,
            maxLines: 15,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: _inputDecoration,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onSubmitted: _handleSubmit,
          ),
          Positioned(
            right: 8,
            bottom: 12,
            child: SizedBox(
              width: 35,
              height: 35,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  final opacity = value.text.trim().isNotEmpty ? 1.0 : 0.4;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(opacity),
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: AppColors.primaryColor.withOpacity(opacity),
                      shape: const CircleBorder(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: _handleSend,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white.withOpacity(opacity),
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty) {
      _handleSend();
    }
  }

  void _handlePaymentLinkGeneration() async {
    final cartData =
        Provider.of<CartProvider>(context, listen: false).createCartPayload();
    if (mounted) {
      context.read<MessageProvider>().addMessage(Message(
            text: '',
            isClient: false,
            isRead: false,
            isLoading: true,
          ));

      _scrollToBottom();
    }

    final response = await PayStackRoutes.generatePaymentLink(cartData);

    if (response.success) {
      final String? paymentUrl = response.data['authorization_url'];
      //final transactionReference = response.data['transaction_reference'];

      if (paymentUrl != null) {
        context.read<MessageProvider>().removeLastMessage();

        setState(() {
          _payStackViewOpen = true;
        });

        initializeSocket();

        if (mounted) {
          context.read<MessageProvider>().addMessage(Message(
                text: "Creating Payment link",
                paymentUrl: paymentUrl,
                isClient: false,
                isRead: false,
                isPayStackView: true,
              ));

          _scrollToBottom();
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening payment link...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleSend() async {
    if (_controller.text.trim().isNotEmpty) {
      try {
        final messageText = _controller.text.trim();
        final message = Message(
          text: messageText,
          isClient: true,
          isRead: false,
        );

        _controller.clear();

        if (mounted) {
          setState(() {
            _showProducts = false;
          });

          context.read<MessageProvider>().addMessage(message);
          _scrollToBottom();

          context.read<MessageProvider>().addMessage(Message(
                text: '',
                isClient: false,
                isRead: false,
                isLoading: true,
              ));
          _scrollToBottom();
        }

        final response = await ChatApiRoutes.sendUserMessage(message);

        if (response?.data?['chatresponse'] != null) {
          final chatResponse = response.data['chatresponse'];
          //print(chatResponse);

          Message aiMessage;
          if (chatResponse['results'] != null) {
            List<Map<String, dynamic>> parsedResults = [];
            List<Map<String, dynamic>> suggestedPrompts = [];

            if (chatResponse['results'] is List) {
              parsedResults = (chatResponse['results'] as List).map((item) {
                return Map<String, dynamic>.from(item);
              }).toList();
            }

            if (chatResponse['suggested_prompts'] is List) {
              suggestedPrompts =
                  (chatResponse['suggested_prompts'] as List).map((item) {
                return Map<String, dynamic>.from(item);
              }).toList();
            }

            context.read<ResultListProvider>().updateResults(
                total: parsedResults.length,
                results: parsedResults,
                suggested_prompts: suggestedPrompts);

            final results = context.read<ResultListProvider>().results;

            aiMessage = Message(
              text: chatResponse['text'] ?? 'Sorry, I could not process that.',
              results: results,
              isProductsDisplay: true,
              isClient: false,
              isRead: false,
            );
          } else {
            aiMessage = Message(
              text: chatResponse['text'] ?? 'Sorry, I could not process that.',
              isClient: false,
              isRead: false,
            );
          }

          if (mounted) {
            context.read<MessageProvider>().removeLastMessage();
            context.read<MessageProvider>().addMessage(aiMessage);
            //_scrollToBottom();
          }
        } else {
          if (mounted) {
            context.read<MessageProvider>().removeLastMessage();
            final errorMessage = Message(
              text: 'Sorry, there was an error processing your message.',
              isClient: false,
              isRead: false,
            );
            context.read<MessageProvider>().addMessage(errorMessage);
          }
        }
      } catch (e) {
        print('Error in _handleSend: $e');
        if (mounted) {
          final errorMessage = Message(
            text: 'Sorry, an error occurred. Please try again.',
            isClient: false,
            isRead: false,
          );
          context.read<MessageProvider>().removeLastMessage();
          context.read<MessageProvider>().addMessage(errorMessage);
          _scrollToBottom();
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _handleCartQuery() async {
    try {
      final cartData =
          Provider.of<CartProvider>(context, listen: false).createCartPayload();

      context.read<MessageProvider>().addMessage(Message(
            text: '',
            isClient: false,
            isRead: false,
            isLoading: true,
          ));
      _scrollToBottom();

      final response = await ChatApiRoutes.getCartDetails(cartData);

      if (response?.data != null && response.data['chatresponse'] != null) {
        final chatResponse = response.data['chatresponse'];

        Message aiMessage;

        aiMessage = Message(
          text: chatResponse['text'] ?? 'Sorry, I could not process that.',
          isClient: false,
          isRead: false,
        );

        if (mounted) {
          context.read<MessageProvider>().removeLastMessage();
          context.read<MessageProvider>().addMessage(aiMessage);
          _scrollToBottom();
        }
      } else {
        if (mounted) {
          context.read<MessageProvider>().removeLastMessage();
          final errorMessage = Message(
            text: 'Sorry, there was an error processing your message.',
            isClient: false,
            isRead: false,
          );
          context.read<MessageProvider>().addMessage(errorMessage);
        }
      }
    } catch (e) {
      print('Error handling cart query: $e');
    }
  }

  void _handlePayment() async {}

  Widget _buildWatermarkOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Opacity(
            opacity: 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 320),
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: TypewriterText(
                    text: "How may I help with your shopping list?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      height: 1.2,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                AnimatedOpacity(
                    opacity: isInitialAnimationComplete ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/payoorcart.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      color: Colors.black.withOpacity(0.5),
                      colorBlendMode: BlendMode.srcATop,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildDrawer(),
          _buildWatermarkOverlay(),
          _buildMainContent(),
        ],
      ),
    );
  }
}
