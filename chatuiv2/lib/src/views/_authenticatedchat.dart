import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';

import 'package:chatuiv2/src/providers/_messageprov.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_message.dart';
import 'package:chatuiv2/src/classes/_chatapiroutes.dart';

class AuthenticatedChat extends StatefulWidget {
  const AuthenticatedChat({super.key});

  @override
  State<AuthenticatedChat> createState() => _AuthenticatedChatState();
}

class _AuthenticatedChatState extends State<AuthenticatedChat>
    with TickerProviderStateMixin {
  bool isInitialAnimationComplete = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _controller = TextEditingController();
  int _selectedPillIndex = 0;
  bool _isDrawerOpen = true;

  final List<String> pills = [
    'Create a shopping list',
    'Create a diet plan',
    'Find out grocery prices'
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
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
          // Set reverse to false since we want normal order
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
                    color: AppColors.backgroundColor.withOpacity(.5),
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

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
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
                  )),
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
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              ...List.generate(
                pills.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      // Handle pill selection
                      _selectedPillIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        pills[index],
                        style: TextStyle(
                          color: Colors.white.withOpacity(.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
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
          context.read<MessageProvider>().addMessage(message);

          context.read<MessageProvider>().addMessage(Message(
                text: '',
                isClient: false,
                isRead: false,
                isLoading: true,
              ));
        }

        final response = await ChatApiRoutes.sendUserMessage(message);

        if (response?.data != null && response.data['chatresponse'] != null) {
          final chatResponse = response.data['chatresponse'];

          final aiMessage = Message(
            text: chatResponse['text'] ?? 'Sorry, I could not process that.',
            isClient: false,
            isRead: false,
          );

          // print(chatResponse);
          //print('chatResponse');

          if (mounted) {
            context.read<MessageProvider>().removeLastMessage();
            context.read<MessageProvider>().addMessage(aiMessage);
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
                    text: "How may I help you?",
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
