import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
//import 'dart:html' as html;
import 'dart:async';

import 'package:chatuiv2/src/views/_landingscreen.dart';
import 'package:chatuiv2/src/views/_cartdisplay.dart';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';
import 'package:chatuiv2/src/widgets/_paystackviewcontainer.dart';
import 'package:chatuiv2/src/widgets/_messagecontent.dart';
import 'package:chatuiv2/src/widgets/_addresseslist.dart';
import 'package:chatuiv2/src/widgets/_swipeupwidget.dart';

import 'package:chatuiv2/src/providers/_messageprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_onboardingprov.dart';
import 'package:chatuiv2/src/providers/_googleplaces.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_chatapiroutes.dart';
import 'package:chatuiv2/src/classes/_paystackroutes.dart';
import 'package:chatuiv2/src/classes/_orderroutes.dart';
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
  final FocusNode _focusNode = FocusNode();

  final GlobalKey<SwipeUpWidgetState> _swipeKey =
      GlobalKey<SwipeUpWidgetState>();

  int _selectedPillIndex = 0;
  bool _isDrawerOpen = true;
  bool _showProducts = false;
  bool _payStackViewOpen = false;
  late StreamSubscription _subscription;
  bool _userOrdersOpen = false;
  bool _showCart = false;
  bool _paying = false;
  bool _confirmingAddress = false;
  bool _showPayButton = false;

  double _deliveryFee = 3700;
  double _serviceCharge = 0;
  String _deliveryAddress = "";

  String currentSuggestion = "";

  List<String> resultTags = [];

  final List<String> _chatInputModes = ['address_confirmation'];

  String _currentChatInputMode = "";

  final List<Map> pills = [];

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

    _handleOnboardingMessage();

    _controller.addListener(() {
      //print(_controller.text);

      if (_currentChatInputMode == _chatInputModes[0]) {
        if (!_confirmingAddress) {
          setState(() {
            _confirmingAddress = true;
          });
        }
        context.read<GooglePlaces>().searchPlaces(_controller.text);
      }
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

  void _handleOnboardingMessage() {
    final onboardingProv = Provider.of<OnboardingProv>(context, listen: false);
    String message = onboardingProv.onboardingMessage;

    _setInputText(message);
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

  void closePaystackView(BuildContext context) {
    setState(() {
      _payStackViewOpen = false;
    });

    Provider.of<CartProvider>(context, listen: false).clear();

    SocketService.disconnectFromSocketServer();
  }

  void _getSuggestions(current_suggestion) {
    setState(() {
      currentSuggestion = current_suggestion;
    });

    //print(currentSuggestion);
    context
        .read<ResultListProvider>()
        .setCurrentSuggestions(suggestion: currentSuggestion);
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
          color: AppColors.white,
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

  Widget _buildLoadingIndicator() {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer<AuthProv>(
      builder: (context, authProv, child) {
        if (authProv.userData != null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                // ✅ Moved Column outside of Expanded
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedHeader(),
                  Expanded(
                    // ✅ Now it's properly placed inside Column
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: _renderMessages(),
                        ),
                        if (_confirmingAddress)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.3,
                                minHeight: 100,
                              ),
                              child: AddressesList(
                                onLocationSelected: (updatedAddress) {
                                  _setInputText(updatedAddress);
                                },
                                onAddressSelected: (addressData) {
                                  String value = addressData['address']!;
                                  _setInputText(value);
                                  setState(() {
                                    _confirmingAddress = false;
                                  });
                                  context
                                      .read<GooglePlaces>()
                                      .clearPredictions();
                                },
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  _buildPillsSlide(),
                  _buildTextField(),
                ],
              ),
            ),
          );
        }

        if (authProv.error) {
          return LandingScreen();
        }

        if (authProv.isLoading) {
          return _buildLoadingIndicator();
        }

        return LandingScreen();
      },
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
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: messagesList.length,
          cacheExtent: 9999,
          itemBuilder: (context, index) {
            final message = messagesList[messagesList.length - 1 - index];

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
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.black,
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

    return MessageContent(
        message: message,
        scrollController: _scrollController,
        index: index,
        messagesList: messagesList,
        deliveryFee: _deliveryFee);
  }

  Widget _buildAnimatedHeader() {
    return AnimatedOpacity(
      opacity: isInitialAnimationComplete ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: HeaderRow(onBurgerMenuTap: () {}),
    );
  }

  Icon conditionalIconForPillsSlide(label) {
    switch (label) {
      case 'Cart':
        return Icon(
          Icons.shopping_cart_outlined,
          size: 15,
          color: AppColors.primaryColor,
        );
      case 'Orders':
        return Icon(
          Icons.receipt_long_outlined,
          size: 15,
          color: AppColors.primaryColor,
        );
      case 'Checkout':
        return Icon(
          Icons.shopping_cart_checkout,
          size: 15,
          color: AppColors.primaryColor,
        );
      case 'Pay':
        return Icon(
          Icons.payment_outlined,
          size: 15,
          color: AppColors.primaryColor,
        );
      case 'Support':
        return Icon(
          Icons.headset_mic_outlined,
          size: 15,
          color: AppColors.primaryColor,
        );
      default:
        return const Icon(
          Icons.local_offer,
          size: 15,
          color: AppColors.primaryColor,
        );
    }
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
                final pill_slide_array = [...pills, ...resultTags];

                return Row(
                  children: [
                    ...List.generate(
                      pill_slide_array.length,
                      (index) => Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final currentPill = pill_slide_array[index];
                          final String label = currentPill is Map
                              ? currentPill['label'] ?? ''
                              : '${currentPill.toString()} suggestions';

                          final String action = currentPill is Map
                              ? currentPill['action'] ?? ''
                              : currentPill.toString();

                          final isEmptyCart =
                              label == "Cart" && cart.itemCount == 0;
                          final shouldShowPay =
                              label == "Pay" && !_showPayButton;
                          final shouldShowCheckout = label == "Checkout" &&
                              (cart.itemCount == 0 || _showPayButton);

                          return isEmptyCart ||
                                  shouldShowPay ||
                                  shouldShowCheckout
                              ? SizedBox()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: InkWell(
                                    onTap: () {
                                      if (action == "View Cart") {
                                      } else if (action == "Checkout") {
                                        //print('handle payment');
                                        //_handlePayment();
                                        //_handlePaymentLinkGeneration();
                                        //_confirmAddress();
                                      } else if (action ==
                                          "Proceed to orders view") {
                                        _toggleUserOrders();
                                      } else {
                                        _selectedPillIndex = index;

                                        //print(suggested_prompts[index]['text']);
                                        _getSuggestions(currentPill);
                                      }
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                currentPill == currentSuggestion
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
                                            border: Border.all(
                                              color: AppColors.primaryColor,
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                label,
                                                style: TextStyle(
                                                  color: currentPill ==
                                                          currentSuggestion
                                                      ? AppColors.white
                                                      : AppColors.primaryColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              conditionalIconForPillsSlide(
                                                  label)
                                            ],
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

  Widget buildCartButton() {
    return Positioned(
        bottom: 140,
        right: 20,
        child: Consumer<CartProvider>(
          builder: (context, cart, child) => Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cart.itemCount > 0
                      ? AppColors.primaryColor.withOpacity(1)
                      : AppColors.primaryColor.withOpacity(.5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: cart.itemCount > 0
                      ? Colors.white.withOpacity(1)
                      : Colors.white.withOpacity(.5),
                  iconSize: 20,
                  onPressed: () {
                    if (cart.itemCount > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartDisplayScreen(
                            closeWidget: () => Navigator.pop(context),
                            //totalAmount: cart.totalAmount,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              cart.itemCount > 0
                  ? Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: IgnorePointer(
          ignoring: false,
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
                onChanged: (value) {},
                enableInteractiveSelection: true,
                enableSuggestions: true, // Add this
                enabled: true,
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
          )),
    );
  }

  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty) {
      _handleSend();
    }
  }

  void _setInputText(String newText) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );

      _focusNode.requestFocus();
    });
  }

  void _createOrder() async {
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

    try {
      final response =
          await OrdersRoute.createOrder(cartData, _deliveryAddress);

      if (!mounted) return;

      context.read<MessageProvider>().removeLastMessage();

      if (response.success) {
        if (response.data['chatresponse'] != null) {
          final chatResponse = response.data['chatresponse'];

          print(chatResponse);

          final aiMessage = Message(
            text: chatResponse['text'] ?? 'Sorry, I could not process that.',
            isClient: false,
            isRead: false,
            orderId: chatResponse['orderId'],
            isOrderSummary: true,
          );

          context.read<MessageProvider>().addMessage(aiMessage);
          setState(() {
            _showPayButton = true;
          });
          _scrollToBottom(); // You might want to scroll after adding the new message
        }
      } else {
        // Handle unsuccessful response
        context.read<MessageProvider>().addMessage(Message(
              text: 'Failed to create order. Please try again.',
              isClient: false,
              isRead: false,
            ));
      }
    } catch (e) {
      if (!mounted) return;

      // Handle any errors during the order creation
      context.read<MessageProvider>().removeLastMessage();
      context.read<MessageProvider>().addMessage(Message(
            text:
                'An error occurred while creating your order. Please try again.',
            isClient: false,
            isRead: false,
          ));
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
        //print('just sent the address');
        final messageText = _controller.text.trim();

        setState(() {
          _deliveryAddress = messageText;
          _confirmingAddress = false;
          _currentChatInputMode = "";
        });

        final message = Message(
          text: messageText,
          isClient: true,
          isRead: false,
        );

        _controller.clear();

        context.read<MessageProvider>().addMessage(message);
        _scrollToBottom();

        //_handlePaymentLinkGeneration();
        _createOrder();

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

          print(chatResponse);

          Message aiMessage;
          if (chatResponse['results'] != null) {
            List<String> results = (chatResponse['results'] as List)
                .map((item) => item.toString())
                .toList();

            List<String> result_tags = (chatResponse['result_tags'] as List)
                .map((item) => item.toString())
                .toList();

            print(results);
            print(result_tags);

            setState(() {
              resultTags = result_tags;
              currentSuggestion = result_tags[0];
            });

            context.read<ResultListProvider>().updateResults(
                total: results.length,
                results: results,
                suggested_prompts: result_tags);

            final resultsRender = context.read<ResultListProvider>().results;

            aiMessage = Message(
              text: chatResponse['text'] ?? 'Sorry, I could not process that.',
              results: resultsRender.isNotEmpty ? resultsRender : [],
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

  Widget _buildWatermarkOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Opacity(
            opacity: 0.3,
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
                      color: AppColors.greenDark,
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
                      color: AppColors.greenDark,
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
          _buildWatermarkOverlay(),
          Positioned.fill(child: _buildMainContent()),
          buildCartButton(),
        ],
      ),
    );
  }
}
