import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_onboardinput.dart';
import 'package:chatuiv2/src/widgets/_createlistbtn.dart';
import 'package:chatuiv2/src/widgets/_onboardingslider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_review.dart';

import 'package:chatuiv2/src/providers/_onboardingprov.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isCreateListBtnActive = false;
  final ScrollController _scrollController = ScrollController();

  String listInput = "";

  final TextEditingController _multilineController = TextEditingController();

  final List<String> textArray = [
    "Make a grocery",
    "list and leave",
    "the rest to us"
  ];

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

  void handleInputChange(String value) {
    setState(() {
      listInput = value;
      isCreateListBtnActive =
          value.trim().length >= 3 && value.trim().length <= 500;
    });
  }

  void handleInputBlur() {
    print('Input lost focus');
  }

  void handleInputFocus() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          MediaQuery.of(context).size.height * 0.2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
              body: SingleChildScrollView(
                  controller: _scrollController,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: Container(
                          color: AppColors.primaryColor,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15, right: 15, left: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/payoorlogo.png',
                                          width: constraints.maxWidth * 0.2,
                                          height: constraints.maxHeight * 0.05,
                                          fit: BoxFit.contain,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Image.asset(
                                            'assets/burger.png',
                                            width: constraints.maxWidth * 0.1,
                                            height: constraints.maxHeight * 0.1,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Column(
                                      children: textArray
                                          .map((text) => Text(
                                                text,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic,
                                                  height: 1.2,
                                                  color: AppColors.white,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    OnboardInput(
                                      onInputChanged: handleInputChange,
                                      onInputFocus: handleInputFocus,
                                      onInputBlur: handleInputBlur,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Consumer<OnboardingProv>(
                                        builder:
                                            (context, onboardingProv, child) {
                                          return CreateListBtn(
                                            isCreateListBtnActive:
                                                isCreateListBtnActive,
                                            onTap: () {
                                              onboardingProv.onboardingMessage =
                                                  listInput;
                                              print(
                                                  'Button tapped with input: ${onboardingProv.onboardingMessage}');
                                              Navigator.pushNamed(
                                                  context, '/auth');
                                            },
                                          );
                                        },
                                      ),
                                    ),
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
                                    )
                                  ],
                                ),
                              ),
                              OnboardingSlider(
                                reviews: reviews,
                                slideDuration: const Duration(seconds: 5),
                              ),
                            ],
                          )))));
        }));
  }
}
