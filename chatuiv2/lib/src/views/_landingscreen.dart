import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import 'package:flutter_svg/flutter_svg.dart';

import 'package:chatuiv2/main.dart';

import 'package:chatuiv2/src/widgets/_onboardinput.dart';
import 'package:chatuiv2/src/widgets/_createlistbtn.dart';
import 'package:chatuiv2/src/widgets/_onboardingslider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_review.dart';
import 'package:chatuiv2/src/classes/_shopinfoitem.dart';
import 'package:chatuiv2/src/classes/_socialmediapainters.dart';

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
  final String twitterUrl = 'https://x.com/Mypayoor';
  final String instagramUrl = 'https://www.instagram.com/mypayoor/';

  final TextEditingController _multilineController = TextEditingController();

  final List<String> textArray = [
    "Make a grocery",
    "list and leave",
    "the rest to us"
  ];

  final List<Review> reviews = [
    Review(
      imageUrl: 'assets/dude.jpeg',
      name: 'Efe Tobore',
      content:
          'Payoor is fast and reliable. The user experience is in a league of its own',
    ),
    Review(
      imageUrl: 'assets/dude2.jpeg',
      name: 'Imam Adetona',
      content: "It's seamless and clean",
    ),
  ];

  final List<ShopInfoItem> shopInfo = [
    ShopInfoItem(
      header: 'Every meal deserves a great story',
      description:
          'We take away the hassle of market runs and deliver everything you need for your home cooked meals, whenever you want it.',
      color: Color(0xFFA8D1F0),
    ),
    ShopInfoItem(
      header: 'Best prices, great quality',
      description:
          'We offer unbeatable prices and the best quality you can find anywhere.',
      color: Color(0xFFF0E7A8),
    ),
    ShopInfoItem(
      header: 'Packaged with love and care',
      description:
          'We ensure that all your order come in the cleanest and pristine condition possible.. we take extra effort to make your items extra clean and ready to use right off the box',
      color: Color(0xFFF0BAA8),
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

  void launchUrl(String url) {
    html.window.location.href = url; // Opens in same tab for mobile web
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
                                          onTap: () {
                                            sideNavVisible.value = true;
                                          },
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
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 15,
                                            left: 15,
                                            right: 15,
                                            bottom: 15),
                                        child: Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  launchUrl(twitterUrl),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                color: Colors.transparent,
                                                child: SvgPicture.asset(
                                                  'assets/twitter.svg',
                                                  width: 24.0,
                                                  height: 24.0,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors.twitterColor,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            GestureDetector(
                                              onTap: () =>
                                                  launchUrl(instagramUrl),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                    12.0), // Enlarged padding for better touch
                                                color: Colors
                                                    .transparent, // For touch area without visual change
                                                child: CustomPaint(
                                                  size: Size(24.0, 24.0),
                                                  painter: InstagramPainter(
                                                      color: AppColors
                                                          .instagramColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))),
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
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 25, left: 15, right: 15, bottom: 15),
                                  child: Column(
                                    children: [
                                      ...shopInfo
                                          .map((item) => Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    decoration: BoxDecoration(
                                                      color: item.color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.header,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                AppColors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 13),
                                                        Text(
                                                          item.description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                AppColors.black,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                          25), // Space between containers
                                                ],
                                              ))
                                          .toList(),
                                    ],
                                  ))
                            ],
                          )))));
        }));
  }
}
