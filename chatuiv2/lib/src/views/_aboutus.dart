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

  Widget _buildHeading(String text, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 32 : 24),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isDesktop ? 48 : 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: AppColors.white,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildBody(String text, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 32 : 24),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isDesktop ? 20 : 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildHeader(BoxConstraints constraints, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.only(bottom: isDesktop ? 24 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/'),
              child: Image.asset(
                'assets/payoorlogo.png',
                width: isDesktop ? 180 : constraints.maxWidth * 0.22,
                height: isDesktop ? 48 : constraints.maxHeight * 0.06,
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (!isDesktop)
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
          if (isDesktop)
            Row(
              children: [
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
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool isDesktop = constraints.maxWidth >= 1024;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 120 : 24.0,
                vertical: isDesktop ? 32 : 16.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  maxWidth: isDesktop ? 1200 : double.infinity,
                ),
                child: Container(
                  color: AppColors.primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(constraints, isDesktop),
                      SizedBox(height: isDesktop ? 32 : 16),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 80 : 0,
                          vertical: 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeading('About Payoor', isDesktop),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                vertical: isDesktop ? 48 : 32,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(isDesktop ? 24 : 16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: isDesktop ? 20 : 15,
                                    offset: Offset(0, isDesktop ? 12 : 8),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset(
                                'assets/like.png',
                                width: double.infinity,
                                height: isDesktop ? 500 : null,
                                fit: BoxFit.cover,
                              ),
                            ),
                            _buildHeading('Our Story', isDesktop),
                            _buildBody(
                                'On May 22nd, 2023, Payoor was born out of a simple but powerful truth, grocery shopping can be stressful, and one of our founders "does not like stress". After one too many exhausting market runs, the thought became clear: There has to be a faster, easier way to get fresh groceries for home-cooked meals.',
                                isDesktop),
                            _buildBody(
                                'That single frustration sparked a journey that took over a year of research, development, and fine-tuning to create Payoor; a smart, seamless grocery shopping experience designed for people who value their time but still want quality, fresh ingredients.',
                                isDesktop),
                            _buildHeading('Our Mission', isDesktop),
                            _buildBody(
                                "To make grocery shopping fast, effortless, and stress-free by providing a smart, clean, and convenient way to get fresh food straight to your kitchen. We believe that every meal shouldn't a stressful and tragic backstory.",
                                isDesktop),
                            _buildHeading('Our Vision', isDesktop),
                            _buildBody(
                                'To redefine how people shop for groceries by making convenience, freshness, and simplicity the new standard one home-cooked meal at a time.',
                                isDesktop),
                          ],
                        ),
                      ),
                      SizedBox(height: isDesktop ? 48 : 32),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
