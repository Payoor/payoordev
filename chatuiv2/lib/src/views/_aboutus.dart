import 'package:flutter/material.dart';

import 'package:chatuiv2/main.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class AboutPayoor extends StatefulWidget {
  const AboutPayoor({super.key});

  @override
  State<AboutPayoor> createState() => _AboutPayoorState();
}

class _AboutPayoorState extends State<AboutPayoor> {
  final ScrollController _scrollController = ScrollController();

  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: AppColors.white,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildBody(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
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
          return SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              width: constraints.maxWidth,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Container(
                  color: AppColors.primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with logo and menu
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/payoorlogo.png',
                              width: constraints.maxWidth * 0.22,
                              height: constraints.maxHeight * 0.06,
                              fit: BoxFit.contain,
                            ),
                            GestureDetector(
                              onTap: () {
                                sideNavVisible.value = true;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/burger.png',
                                  width: constraints.maxWidth * 0.12,
                                  height: constraints.maxHeight * 0.12,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // About Payoor heading
                      _buildHeading('About Payoor'),

                      // Hero image
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/like.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Our Story section
                      _buildHeading('Our Story'),
                      _buildBody(
                          'On May 22nd, 2023, Payoor was born out of a simple but powerful truth, grocery shopping can be stressful, and one of our founders "does not like stress". After one too many exhausting market runs, the thought became clear: There has to be a faster, easier way to get fresh groceries for home-cooked meals.'),
                      _buildBody(
                          'That single frustration sparked a journey that took over a year of research, development, and fine-tuning to create Payoor; a smart, seamless grocery shopping experience designed for people who value their time but still want quality, fresh ingredients.'),

                      // Our Mission section
                      _buildHeading('Our Mission'),
                      _buildBody(
                          "To make grocery shopping fast, effortless, and stress-free by providing a smart, clean, and convenient way to get fresh food straight to your kitchen. We believe that every meal shouldn't a stressful and tragic backstory."),

                      // Our Vision section
                      _buildHeading('Our Vision'),
                      _buildBody(
                          'To redefine how people shop for groceries by making convenience, freshness, and simplicity the new standard one home-cooked meal at a time.'),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
