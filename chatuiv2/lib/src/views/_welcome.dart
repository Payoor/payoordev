import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_headerrow.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isInitialAnimationComplete = false;
  bool isLoading = true;

  String? error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchJWT();
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          // isInitialAnimationComplete = true;
        });
      }
    });
  }

  Future<void> _fetchJWT() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final authProv = Provider.of<AuthProv>(context, listen: false);
      final userId = authProv.userId;

      if (userId != null) {
        final response = await AuthApiRoutes.getJWT(userId);

        if (response.success) {
          authProv.jwt = response.data['token'];

          JwtManager.saveToken(response.data['token']);
        } else {
          setState(() {
            error = response.data['message'] ?? 'Failed to get JWT';
          });
        }
      } else {
        setState(() {
          error = 'User ID not found';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching JWT: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*AnimatedOpacity(
                opacity: isInitialAnimationComplete ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: HeaderRow(),
              ),*/
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    AnimatedOpacity(
                      opacity: isInitialAnimationComplete ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 500),
                      child: TypewriterText(
                        text: "Welcome to Payoor",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                    SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: isInitialAnimationComplete ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 500),
                      child: TypewriterText(
                        text: "Your personal shopping assistant",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                    SizedBox(height: 40),
                    AnimatedOpacity(
                      opacity: isInitialAnimationComplete ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What we offer:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildFeatureItem(
                            "Smart Shopping Lists",
                            "Create and manage your shopping lists efficiently",
                          ),
                          _buildFeatureItem(
                            "Personal Assistance",
                            "Get help finding the best deals and products",
                          ),
                          _buildFeatureItem(
                            "Easy Navigation",
                            "Find what you need, when you need it",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: isInitialAnimationComplete ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isInitialAnimationComplete = true;
                      });

                      Future.delayed(const Duration(milliseconds: 2500), () {
                        Navigator.pushReplacementNamed(context, '/authchat');
                      });
                    },
                    child: Consumer<AuthProv>(
                      builder: (context, authProv, child) {
                        final jwt = authProv.jwt;

                        return jwt != null
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "Get Started",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColorDark,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                    child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColorDark,
                                    strokeWidth: 2,
                                  ),
                                )),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: TypewriterText(
                      text: title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      duration: Duration(milliseconds: 1500)),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
