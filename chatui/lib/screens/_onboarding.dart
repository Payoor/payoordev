import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/main.dart';

import 'package:chat/widgets/_header.dart';
import 'package:chat/widgets/_onboardingheader.dart';
import 'package:chat/widgets/_onboardingslider.dart';
import 'package:chat/widgets/_sidenav.dart';

import 'package:chat/providers/_message_provider.dart';

import 'package:chat/classes/_review.dart';
import 'package:chat/classes/_message.dart';

import 'package:chat/utils/_themecolors.dart';

import 'package:chat/classes/_storagemanager.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final int maxLines = 5;
  bool createList = false;
  String listContent = "";

  //dev
  late StorageManager _storageManager;

  final List<Review> reviews = [
    Review(
      imageUrl: 'assets/dude.jpg',
      name: 'John Doe',
      content:
          'Payoor has revolutionized my shopping experience. It\'s so convenient!',
    ),
    Review(
      imageUrl: 'assets/dude2.jpg',
      name: 'Jane Smith',
      content:
          'I love how easy it is to manage my payments with Payoor. Highly recommended!',
    ),
    Review(
      imageUrl: 'assets/gal.jpg',
      name: 'Mike Johnson',
      content:
          'Payoor has saved me so much time on grocery shopping. It\'s a game-changer!',
    ),
    Review(
      imageUrl: 'assets/gal2.jpg',
      name: 'Mike Johnson',
      content:
          'Payoor has saved me so much time on grocery shopping. It\'s a game-changer!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.offset + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.offset - 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onTextChanged() {
    String list = _textController.text;

    if (list.isNotEmpty) {
      setState(() {
        createList = true;
        listContent = list;
      });
    } else {
      setState(() {
        createList = false;
        listContent = "";
      });
    }
  }

  Future<void> _navigateToChatScreen() async {
    await Future.microtask(() {});

    NavigationService.navigateTo('/chatscreen');
  }

  /*Future<void> testWebAppJWTSave() async {
    _storageManager = await StorageManager.create();

    print(_storageManager);

    await _storageManager.getJwt();
  }*/

  @override
  Widget build(BuildContext context) {
    //testWebAppJWTSave();

    return PopScope(
        canPop: !_focusNode.hasFocus,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
            return;
          }
          Navigator.of(context).pop(result);
        },
        child: GestureDetector(
            onTap: () {
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: ThemeColors.primaryColor,
              resizeToAvoidBottomInset: false,
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    children: [
                      SafeArea(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: ThemeColors.primaryColor,
                          ),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                children: [
                                  HeaderWidget(
                                    constraints: constraints,
                                  ),
                                  const OnboardingHeader(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 15.0, right: 15.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      decoration: BoxDecoration(
                                        color:
                                            ThemeColors.black.withOpacity(.8),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      width: constraints.maxWidth,
                                      child: TextFieldTapRegion(
                                        child: SingleChildScrollView(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              minHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlueAccent
                                                  .withOpacity(0),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                color: Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _textController,
                                              focusNode: _focusNode,
                                              maxLines: null,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter message',
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                border: InputBorder.none,
                                              ),
                                              style: const TextStyle(
                                                color: ThemeColors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Consumer<MessageProvider>(builder:
                                      (context, messageProvider, child) {
                                    return GestureDetector(
                                        onTap: () async {
                                          if (!createList ||
                                              listContent.isEmpty) {
                                            return;
                                          }

                                          Message message = Message(
                                              value: listContent,
                                              isUser: true,
                                              isLoggedIn: false,
                                              jwt: "",
                                              username: 'Visitor',
                                              timeStamp: DateTime.now()
                                                  .toIso8601String());

                                          messageProvider.addMessage(message);

                                          _navigateToChatScreen();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0,
                                              left: 15.0,
                                              right: 15.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: createList
                                                      ? Colors.white
                                                      : Colors.white
                                                          .withOpacity(.4),
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 24),
                                                child: Text(
                                                  'Create list',
                                                  style: TextStyle(
                                                    color: createList
                                                        ? Colors.white
                                                        : Colors.white
                                                            .withOpacity(.4),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  }),
                                  Center(
                                    child: Image.asset(
                                      'assets/bike.png',
                                      width: MediaQuery.of(context)
                                          .size
                                          .width, // Set the desired width
                                      height: 180, // Set the desired height
                                      fit: BoxFit
                                          .contain, // Adjust how the image fits within its bounds
                                    ),
                                  ),
                                  OnboardingSlider(
                                    reviews: reviews,
                                    slideDuration: const Duration(seconds: 5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomSideNav(),
                      // You can add more Stack children here for overlays or floating elements
                    ],
                  );
                },
              ),
            )));
  }
}
