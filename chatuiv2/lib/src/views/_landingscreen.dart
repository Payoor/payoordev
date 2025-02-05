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
      'text': 'Rice & Grains',
    },
    {
      'image': 'assets/chai_seed.jpeg',
      'text': 'Oils & Fats',
    },
    {
      'image': 'assets/bournvita.jpeg',
      'text': 'Spices & Seasonings',
    },
    {
      'image': 'assets/fruits.png',
      'text': 'Vegetables',
    },
    {
      'image': 'assets/fruit_basket.jpeg',
      'text': 'Proteins & Meat',
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

  Positioned handleTextPosition(num index, item) {
    switch (index) {
      case 0:
        return Positioned(
          left: 15,
          top: 15,
          right: 120,
          bottom: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      case 1:
        return Positioned(
          left: 15,
          top: 15,
          right: 140, // More space for the image
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: const TextStyle(
                  fontSize: 17, // Slightly larger
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 13, // Slightly larger
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      case 2:
        return Positioned(
          left: 15,
          top: 15,
          right: 160, // Even more space for the image
          bottom: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: const TextStyle(
                  fontSize: 17, // Largest
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 13, // Largest
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      default:
        return Positioned(
          left: 15,
          top: 15,
          right: 120,
          bottom: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.header,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
    }
  }

  Positioned handleImageSize(num index, item) {
    switch (index) {
      case 0:
        return Positioned(
          right: -10,
          top: -5,
          bottom: -5,
          width: 150,
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
          width: 150, // Different width for second item
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
          width: 200, // Different width for last item
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
          width: 150,
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
                                      const Text(
                                        'Shop for Food ingredients and Groceries at the lowest possible prices',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          height: 1.3, // 21.61px ÷ 24px = ~0.9
                                          letterSpacing: 0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight: 48,
                                          maxHeight: double.infinity,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.customGreen,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.8,
                                          children: groceryItems.map((item) {
                                            return Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height:
                                                      80, // Increased height
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                    // Centers the image in the container
                                                    child: Image.asset(
                                                      item['image']!,
                                                      height:
                                                          60, // Increased image size
                                                      width:
                                                          60, // Increased image size to maintain aspect ratio
                                                      fit: BoxFit
                                                          .contain, // Ensures image scales properly
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  item['text']!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    height:
                                                        1.2, // Controls line height (12px × 1.2 = 14.4px line height)
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Why Payoor?',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            height:
                                                1.2, // Controls line height (12px × 1.2 = 14.4px line height)
                                            color: AppColors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
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
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Psst... Here is why we are your best buddy for fresh food stuff and quality grocery.',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height:
                                                1.2, // Controls line height (12px × 1.2 = 14.4px line height)
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
                                              height:
                                                  180, // Fixed container height - adjust as needed
                                              padding: const EdgeInsets.only(
                                                  top: 0,
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 0),
                                              /*const EdgeInsets.only(
                                                            top: 20,
                                                            left: 20,
                                                            right: 0,
                                                            bottom: 20),*/
                                              decoration: BoxDecoration(
                                                color: item.color,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  handleTextPosition(
                                                      index, item),
                                                  handleImageSize(index, item)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    25), // Space between containers
                                          ],
                                        );
                                      }),
                                    ],
                                  ))
                            ],
                          )))));
        }));
  }
}
