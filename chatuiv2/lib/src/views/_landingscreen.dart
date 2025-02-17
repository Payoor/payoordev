import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

import 'package:chatuiv2/src/utils/_global_keys.dart';

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

  List<Map<String, dynamic>> faqItems(bool isDesktop) {
    return [
      {
        'title': ['What is Payoor?'],
        'content': [
          'Payoor is an online grocery assistant that helps you with your all your grocery and market needs.'
        ],
      },
      {
        'title': ['How long do deliveries take?'],
        'content': [
          'Deliveries take 48hours from checkout and you can set future delivery day.'
        ],
      },
      {
        'title': ['Which locations do we currently service?'],
        'content': [
          'Currently, we  only deliver to some parts of Lagos, although we expanding rapidly across Nigeria,',
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.8),
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'We currently deliver to \n'),
                ...[
                  'Magodo',
                  'Ikeja',
                  'Victoria Island',
                  'Ogudu',
                  'Ikate',
                  'Lekki (Phase 1)',
                  'Lagos Island',
                  'Maryland',
                  'Mushin',
                  'Ogba',
                  'Oshodi',
                  'Opebi/Allen',
                  'Oshodi-Isolo',
                  'Omole',
                  'Shomolu',
                  'Surulere',
                  'Victoria Island',
                  'Yaba',
                  'Berger',
                  'Ojota',
                  'Ketu'
                ]
                    .map((location) => [
                          TextSpan(
                            text: location,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: isDesktop ? 16 : 14,
                            ),
                          ),
                          TextSpan(text: ', '),
                        ])
                    .expand((spans) => spans)
                    .toList()
                  ..removeLast(),
              ],
            ),
          ),
        ],
      },
      {
        'title': ['What is Service charge?'],
        'content': [
          "The service fee is a consumer fee that appears on the price breakdown at checkout on the payoor app. Unlike other consumer fees, the service fee depends on your order's subtotal, that is, a very small percentage of your bill excluding the delivery fee. It also does not apply to all restaurants on our platform."
        ],
      },
      {
        'title': ['What is Shop by Recipe?'],
        'content': [
          "The service fee is a consumer fee that appears on the price breakdown at checkout on the payoor app. Unlike other consumer fees, the service fee depends on your order's subtotal, that is, a very small percentage of your bill excluding the delivery fee. It also does not apply to all restaurants on our platform."
        ],
      }
    ];
  }

  final List<String> textArray = [
    "Hi, I am Payoor",
    "Make a grocery",
    "list and leave the",
    "rest to me"
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
            "We deliver all you need for home-cooked meals, saving you market hassle and stress",
        color: const Color(0xFFA8D1F0),
        imageUrl: 'assets/sample_dish.png'),
    ShopInfoItem(
        header: 'Best prices, great quality',
        description:
            'We offer unbeatable prices and the best quality you can find anywhere.',
        color: const Color(0xFFF0E7A8),
        imageUrl: 'assets/paper_basket.png'),
    ShopInfoItem(
        header: 'Packaged with love and care',
        description:
            "We deliver your order in pristine condition, ensuring it's clean and ready to use straight out of the box.",
        color: const Color(0xFFF0BAA8),
        imageUrl: 'assets/paper_box.png'),
  ];

  final List<Map<String, String>> groceryItems = [
    {
      'image': 'assets/chicken_lap.png',
      'text': 'Meat and Frozen Food',
    },
    {
      'image': 'assets/chai_seed.jpeg',
      'text': 'Soups and Stews',
    },
    {
      'image': 'assets/bournvita.png',
      'text': 'Beverages',
    },
    {
      'image': 'assets/fruits.png',
      'text': 'Fruits',
    },
    {
      'image': 'assets/fruit_basket.jpeg',
      'text': 'Farmers market',
    },
    {
      'image': 'assets/pepper_container.png',
      'text': 'Spices and packaged foods',
    },
  ];

  void handleInputChange(String value) {
    setState(() {
      listInput = value;
      isCreateListBtnActive =
          value.trim().length >= 3 && value.trim().length <= 500;
    });
  }

  Widget withResponsivePadding({
    required Widget child,
    required bool isDesktop,
    EdgeInsets desktopPadding = const EdgeInsets.symmetric(horizontal: 100),
    EdgeInsets mobilePadding = const EdgeInsets.all(0),
  }) {
    return Padding(
      padding: isDesktop ? desktopPadding : mobilePadding,
      child: child,
    );
  }

  Positioned handleTextPosition(num index, item, isDesktop) {
    switch (index) {
      case 0:
        return Positioned(
          left: isDesktop ? 40 : 15,
          top: isDesktop ? 40 : 15,
          right: isDesktop ? 300 : 120,
          bottom: isDesktop ? 40 : 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: TextStyle(
                  fontSize: isDesktop ? 34 : 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: isDesktop ? 26 : 13,
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      case 1:
        return Positioned(
          left: isDesktop ? 40 : 15,
          top: isDesktop ? 40 : 15,
          right: isDesktop ? 280 : 140, // More space for the image
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: TextStyle(
                  fontSize: isDesktop ? 34 : 17, // Slightly larger
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: isDesktop ? 26 : 13, // Slightly larger
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      case 2:
        return Positioned(
          left: isDesktop ? 40 : 15,
          top: isDesktop ? 40 : 15,
          right: isDesktop ? 400 : 160,
          bottom: isDesktop ? 40 : 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: TextStyle(
                  fontSize: isDesktop ? 34 : 17, // Largest
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: isDesktop ? 26 : 13, // Largest
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      default:
        return Positioned(
          left: isDesktop ? 40 : 15,
          top: isDesktop ? 40 : 15,
          right: isDesktop ? 320 : 160,
          bottom: isDesktop ? 40 : 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: TextStyle(
                  fontSize: isDesktop ? 34 : 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: isDesktop ? 26 : 13,
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
    }
  }

  Positioned handleImageSize(num index, item, isDesktop) {
    switch (index) {
      case 0:
        return Positioned(
          right: -10,
          top: -5,
          bottom: -5,
          width: isDesktop ? 300 : 150,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(item.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      case 1:
        return Positioned(
          right: -10,
          top: -10,
          bottom: 0,
          width: isDesktop ? 300 : 150, // Different width for second item
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(item.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      case 2:
        return Positioned(
          right: -25,
          top: -20,
          bottom: -30,
          width: isDesktop ? 400 : 200, // Different width for last item
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(item.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      default:
        return Positioned(
          // Default case
          right: 0,
          top: 0,
          bottom: 0,
          width: isDesktop ? 300 : 150,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(item.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
    }
  }

  void handleInputBlur() {
    //print('Input lost focus');
  }

  void launchUrl(String url) async {
    if (kIsWeb) {
      bool isDesktop = MediaQuery.of(context).size.width >= 1024;

      if (isDesktop) {
        html.window.open(url, '_blank');
      } else {
        html.window.location.href = url;
      }
    }
  }

  EdgeInsetsGeometry getCustomPadding(double screenWidth) {
    if (screenWidth >= 1024) {
      return EdgeInsets.only(top: 15, right: 120, left: 120);
    } else {
      return EdgeInsets.only(top: 15, right: 15, left: 15);
    }
  }

  Widget _returnMenu(screenWidth, constraints) {
    if (screenWidth >= 1024) {
      return Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                scrollToSection('contact');
              },
              child: Text(
                'Contact',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 90),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                scrollToSection('faq');
              },
              child: Text(
                'FAQs',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 90),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Text(
                'About Us',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 90),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/auth');
              },
              child: Text(
                'Sign Up/Sign In',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return GestureDetector(
        onTap: () {
          sideNavVisible.value = true;
        },
        child: Image.asset(
          'assets/burger.png',
          width: constraints.maxWidth * 0.1,
          height: constraints.maxHeight * 0.1,
          fit: BoxFit.contain,
        ),
      );
    }
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1024;

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
                                padding: getCustomPadding(screenWidth),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {}, // Navigate to home
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Image.asset(
                                                'assets/payoorlogo.png',
                                                width:
                                                    constraints.maxWidth * 0.2,
                                                height: constraints.maxHeight *
                                                    0.05,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        _returnMenu(screenWidth, constraints),
                                      ],
                                    ),
                                    isDesktop
                                        ? SizedBox(
                                            height: 100,
                                          )
                                        : SizedBox(
                                            height: 40,
                                          ),
                                    Column(
                                      children: textArray
                                          .map((text) => Text(
                                                text,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: isDesktop
                                                      ? 55
                                                      : 35, // Smaller font for mobile
                                                  fontWeight: isDesktop
                                                      ? FontWeight.w500
                                                      : FontWeight
                                                          .w400, // Slightly lighter weight for mobile
                                                  fontStyle: FontStyle.italic,
                                                  height: isDesktop
                                                      ? 1.2
                                                      : 1.1, // Tighter line height for mobile
                                                  color: AppColors.white,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                    isDesktop
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : SizedBox(
                                            height: 40,
                                          ),
                                    withResponsivePadding(
                                      isDesktop: isDesktop,
                                      desktopPadding: EdgeInsets.only(
                                          left: 100, right: 100),
                                      mobilePadding: EdgeInsets.all(0),
                                      child: OnboardInput(
                                        onInputChanged: handleInputChange,
                                        onInputFocus: handleInputFocus,
                                        onInputBlur: handleInputBlur,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    withResponsivePadding(
                                      isDesktop: isDesktop,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Consumer<OnboardingProv>(
                                          builder:
                                              (context, onboardingProv, child) {
                                            return CreateListBtn(
                                              isCreateListBtnActive:
                                                  isCreateListBtnActive,
                                              onTap: () {
                                                onboardingProv
                                                        .onboardingMessage =
                                                    listInput;
                                                /*print(
                                                    'Button tapped with input: ${onboardingProv.onboardingMessage}');*/
                                                Navigator.pushNamed(
                                                    context, '/auth');
                                              },
                                            );
                                          },
                                        ),
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
                              withResponsivePadding(
                                  isDesktop: isDesktop,
                                  desktopPadding: const EdgeInsets.symmetric(
                                      horizontal: 220),
                                  mobilePadding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: isDesktop ? 50 : 10,
                                      ),
                                      Text(
                                        'Shop for Food ingredients and Groceries at the lowest possible prices',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: isDesktop ? 55 : 24,
                                          fontWeight: FontWeight.w500,
                                          height: 1.3, // 21.61px ÷ 24px = ~0.9
                                          letterSpacing: 0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: isDesktop ? 40 : 30,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.customGreen,
                                          borderRadius: BorderRadius.circular(
                                              isDesktop ? 13 : 10),
                                        ),
                                        padding: isDesktop
                                            ? EdgeInsets.all(32)
                                            : EdgeInsets.all(13),
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          double itemWidth =
                                              constraints.maxWidth / 4.5;

                                          return GridView.count(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            crossAxisCount: 3,
                                            mainAxisSpacing:
                                                isDesktop ? 35 : 35,
                                            crossAxisSpacing:
                                                isDesktop ? 80 : 30,
                                            childAspectRatio: isDesktop
                                                ? 1.2
                                                : 1, // Adjusted to help remove bottom space
                                            children: groceryItems.map((item) {
                                              return Container(
                                                // Wrapped in Container instead of Column
                                                child: Stack(
                                                  // Using Stack instead of Column
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Positioned(
                                                      top: 0,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: itemWidth,
                                                            height:
                                                                itemWidth * 0.8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      isDesktop
                                                                          ? 10
                                                                          : 6),
                                                            ),
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
                                                                item['image']!,
                                                                height:
                                                                    itemWidth *
                                                                        0.36,
                                                                width:
                                                                    itemWidth *
                                                                        0.36,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: isDesktop
                                                                ? 20
                                                                : 10,
                                                          ),
                                                          Container(
                                                            width: itemWidth *
                                                                0.8, // Control the width (80% of the item width)
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item['text']!,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        isDesktop
                                                                            ? 15
                                                                            : 10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  softWrap:
                                                                      true,
                                                                  maxLines:
                                                                      2, // Optional: limit number of lines
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    /*Positioned(
                                                      bottom: 0,
                                                      child: ,
                                                    ),*/
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      /*Text(
                                        'Why Payoor?',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            height:
                                                1.2, // Controls line height (12px × 1.2 = 14.4px line height)
                                            color: AppColors.white),
                                        textAlign: TextAlign.center,
                                      ),*/
                                      SizedBox(
                                        height: 20,
                                      ),
                                      withResponsivePadding(
                                        desktopPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 300),
                                        isDesktop: isDesktop,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          clipBehavior: Clip
                                              .hardEdge, // This ensures the image respects the border radius
                                          child: Image.asset(
                                            'assets/like.png',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Psst... Here is why we are your best buddy for fresh food stuff and quality grocery.',
                                        style: TextStyle(
                                            fontSize: isDesktop
                                                ? 40
                                                : 14, // Increased to 20 for desktop
                                            fontWeight: FontWeight.w500,
                                            height: 1.2,
                                            color: AppColors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      ...shopInfo
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;
                                        final lastIndex = shopInfo.length - 1;

                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: isDesktop
                                                  ? 360
                                                  : 180, // Fixed container height - adjust as needed
                                              padding: const EdgeInsets.only(
                                                  top: 0,
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 0),
                                              decoration: BoxDecoration(
                                                color: item.color,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  handleTextPosition(
                                                      index, item, isDesktop),
                                                  handleImageSize(
                                                      index, item, isDesktop)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    25), // Space between containers
                                          ],
                                        );
                                      }),
                                      Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9F9F9),
                                            border: Border.all(
                                              color: AppColors
                                                  .white, // Border color
                                              width: 2.0, // Border width
                                            ),

                                            borderRadius: BorderRadius.circular(
                                                12), // Border radius
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                left: isDesktop ? 50 : 15,
                                                right: isDesktop ? 50 : 15,
                                                top: isDesktop ? 100 : 30,
                                                bottom: isDesktop ? 50 : 15,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'FAQ',
                                                    style: TextStyle(
                                                      fontSize:
                                                          isDesktop ? 38 : 24,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  SizedBox(height: 40),
                                                  Container(
                                                    key: keys['faq'],
                                                    child: Column(
                                                      children:
                                                          faqItems(isDesktop)
                                                              .map(
                                                                  (item) =>
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding:
                                                                            EdgeInsets.all(20),
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                16),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.black,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(bottom: 12),
                                                                              child: Text(
                                                                                item['title']![0],
                                                                                style: TextStyle(
                                                                                  fontSize: isDesktop ? 20 : 16,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.black,
                                                                                  height: 1.2,
                                                                                  letterSpacing: 0.5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: isDesktop ? 20 : 15,
                                                                            ),
                                                                            ...List.generate(
                                                                              item['content']!.length,
                                                                              (index) => Padding(
                                                                                padding: EdgeInsets.only(
                                                                                  bottom: index < item['content']!.length - 1 ? 8.0 : 0,
                                                                                ),
                                                                                child: item['content']![index] is String
                                                                                    ? Text(
                                                                                        item['content']![index],
                                                                                        style: TextStyle(
                                                                                          fontSize: isDesktop ? 16 : 14,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color: Colors.black.withOpacity(0.8),
                                                                                          height: 1.5,
                                                                                          letterSpacing: 0.3,
                                                                                        ),
                                                                                      )
                                                                                    : item['content']![index], // For RichText widget
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ))
                                                              .toList(),
                                                    ),
                                                  )
                                                ],
                                              )))
                                    ],
                                  )),
                              SizedBox(height: 40),
                              Container(
                                  key: keys['contact'],
                                  padding: EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Get in touch at contact@payoor.store',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: isDesktop ? 18 : 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              height: 1.5,
                                              letterSpacing: 0.3,
                                            ),
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
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        launchUrl(twitterUrl),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      color: Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        'assets/twitter.svg',
                                                        width: 24.0,
                                                        height: 24.0,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AppColors
                                                              .twitterColor,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        launchUrl(instagramUrl),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      color: Colors.transparent,
                                                      child: CustomPaint(
                                                        size: Size(24.0, 24.0),
                                                        painter: InstagramPainter(
                                                            color: AppColors
                                                                .instagramColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )))
                                      ]))
                            ],
                          )))));
        }));
  }
}
