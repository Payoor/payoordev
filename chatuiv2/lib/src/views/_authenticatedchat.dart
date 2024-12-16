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
import 'package:chatuiv2/src/widgets/_productsizeselector.dart';
import 'package:chatuiv2/src/widgets/_cartdisplay.dart';
import 'package:chatuiv2/src/widgets/_ordersdisplay.dart';
import 'package:chatuiv2/src/widgets/_userdetailslist.dart';

import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_chatapiroutes.dart';
import 'package:chatuiv2/src/classes/_paystackroutes.dart';
import 'package:chatuiv2/src/classes/_socketservice.dart';

import 'package:chatuiv2/src/utils/_yeswords.dart';

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
  final FocusNode _focusNode = FocusNode();

  int _selectedPillIndex = 0;
  bool _isDrawerOpen = true;
  bool _showProducts = false;
  bool _payStackViewOpen = false;
  late StreamSubscription _subscription;
  bool _userOrdersOpen = false;
  bool _showCart = false;
  bool _paying = false;

  double _deliveryFee = 3700;
  double _serviceCharge = 3700;
  String _deliveryAddress = "";

  final List<String> _chatInputModes = ['address_confirmation'];

  String _currentChatInputMode = "";
  double _totalCartAmount = 0;

  final List<Map> pills = [
    {"label": "Cart", "action": "View Cart"},
    {"label": "Orders", "action": "Proceed to orders view"},
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

        Future(() {
          if (mounted) {
            confirmOrderDetails(orderReference);
            setState(() {
              _paying = false;
              _currentChatInputMode = "";
              _deliveryAddress = "";
            });
          }
        });
      }
    }, onError: (error) {
      print('Socket error: $error');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
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

  void _toggleUserOrders() {
    setState(() {
      _userOrdersOpen = !_userOrdersOpen;
    });
  }

  void closeProductSizeSelector() {
    print('view cart items');
    context.read<ResultListProvider>().setCurrentProduct(
        productData: <Map<String, dynamic>>[], productId: "", productName: "");
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
          // Change physics to prevent overscroll bounce which can contribute to jumpiness
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          // Add these properties to help stabilize the list
          itemCount: messagesList.length,
          cacheExtent: 9999, // Increase cache to prevent rebuilds
          itemBuilder: (context, index) {
            final message = messagesList[messagesList.length - 1 - index];

            // Wrap each message type in a container with constraints
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 50, // Set a minimum height
                maxHeight: message.isPayStackView && _payStackViewOpen
                    ? MediaQuery.of(context).size.height * 0.7
                    : double.infinity,
              ),
              child: _buildMessageContent(message, index, messagesList),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageContent(
      Message message, int index, List<Message> messagesList) {
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
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: PayStackViewContainer(
            url: message.paymentUrl ?? ''), // Add null check
      );
    }

    return Column(
      key: ValueKey(
          'message_content_${message.clienttimestamp?.millisecondsSinceEpoch}'),
      mainAxisSize: MainAxisSize.min, // Add this
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    'message_${message.clienttimestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}'),
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
                    _showProducts = message.isProductsDisplay;
                    _showCart = message.isCartView;
                  });
                },
              ),
            ),
          ),
        ),
        if (message.isCartView && _showCart && index == messagesList.length - 1)
          Column(
            children: [
              CartDisplay(),
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
                          'message_${message.clienttimestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}'),
                      text: "Service Fee: ₦ $_serviceCharge\n"
                          "Delivery Fee: ₦ $_deliveryFee\n"
                          "Total: ₦ ${_serviceCharge + _deliveryFee + _totalCartAmount}\n"
                          "Please confirm your current delivery address",
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
                          _showProducts = message.isProductsDisplay;
                          _showCart = message.isCartView;
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        if (message.isProductsDisplay &&
            _showProducts &&
            message.results.isNotEmpty &&
            index == messagesList.length - 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Container(
                padding: const EdgeInsets.all(8), child: ProductDisplay()),
          ),
      ],
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
                                        closeProductSizeSelector();
                                        _handleCartQuery(cart);
                                      } else if (action != null &&
                                          action == "Proceed to payment") {
                                        print('handle payment');
                                        //_handlePayment();
                                        //_handlePaymentLinkGeneration();
                                        //_confirmAddress();
                                        _handleCartQuery(cart);
                                        _handleAddressConfirmation();
                                      } else if (action != null &&
                                          action == "Proceed to orders view") {
                                        _toggleUserOrders();
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

  void _setInputText(String newText) {
    _controller.text = newText;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    _focusNode.requestFocus();
  }

  void _handleAddressConfirmation() async {
    final userData = context.read<AuthProv>().userData;

    if (mounted) {
      setState(() {
        _currentChatInputMode = _chatInputModes[0];
      });

      _setInputText(userData!['userAddress']);
    }
  }

  void _handlePaymentLinkGeneration() async {
    setState(() {
      _paying = true;
      _currentChatInputMode = "";
    });

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

    final response = await PayStackRoutes.generatePaymentLink(
        cartData, _deliveryAddress, _deliveryFee, _serviceCharge);

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
      if (_chatInputModes.isNotEmpty &&
          _currentChatInputMode == _chatInputModes[0]) {
        final messageText = _controller.text.trim();

        setState(() {
          _deliveryAddress = messageText;
        });

        final message = Message(
          text: messageText,
          isClient: true,
          isRead: false,
        );

        _controller.clear();

        context.read<MessageProvider>().addMessage(message);
        _scrollToBottom();

        _handlePaymentLinkGeneration();

        return;
      }

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

  void _handleCartQuery(CartProvider cartProvider) async {
    try {
      double totalAmount = 0.0;

      for (var item in cartProvider.items.values) {
        for (var unit in item.units.values) {
          totalAmount += unit.price * unit.quantity;
        }
      }

      setState(() {
        _totalCartAmount = totalAmount;
      });

      context.read<MessageProvider>().addMessage(Message(
            text: '',
            isClient: false,
            isRead: false,
            isLoading: true,
          ));

      _scrollToBottom();

      Message aiMessage;

      aiMessage = Message(
        text: "This is what your cart looks like at the moment",
        isCartView: true,
        isClient: false,
        isRead: false,
      );

      if (mounted) {
        context.read<MessageProvider>().removeLastMessage();
        context.read<MessageProvider>().addMessage(aiMessage);
        _scrollToBottom();
      }
    } catch (e) {
      print('Error handling cart query: $e');
    }
  }

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
          if (_userOrdersOpen)
            Positioned(child: OrderDisplay(onBackTap: (context) {
              _toggleUserOrders();
            })),
          Consumer<ResultListProvider>(
              builder: (context, resultListProvider, child) {
            List<Map<String, dynamic>> _current_product_data =
                resultListProvider.current_product_data;
            String _current_product_name =
                resultListProvider.current_product_name;
            String _current_product_id = resultListProvider.current_product_id;

            return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: resultListProvider.current_product_id.isEmpty
                    ? 0
                    : MediaQuery.of(context).size.height,
                child: resultListProvider.current_product_id.isEmpty
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        child: Container(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ProductSizeSelector(
                              productData: _current_product_data,
                              productId: _current_product_id,
                              productName: _current_product_name,
                              closeWidget: () {
                                closeProductSizeSelector();
                              },
                            ))));
          })
        ],
      ),
    );
  }
}
