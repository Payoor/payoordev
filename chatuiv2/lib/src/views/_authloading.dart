import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/views/_landingscreen.dart';
import 'package:chatuiv2/src/views/_authenticatedchat.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';

class AuthLoading extends StatefulWidget {
  const AuthLoading({super.key});

  @override
  State<AuthLoading> createState() => _AuthLoadingState();
}

class _AuthLoadingState extends State<AuthLoading> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AuthProv>().checkForUser(),
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

  Widget _buildError() {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Error: There was an error. Please try again',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<AuthProv>().checkForUser(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    print(screenWidth);
    print("==========screen width========");

    if (screenWidth >= 1024) {
      print('screen width has approached desktop');
    }

    return Consumer<AuthProv>(
      builder: (context, authProv, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildPage(authProv),
        );
      },
    );
  }

  Widget _buildPage(AuthProv authProv) {
    if (authProv.isLoading) {
      return _buildLoadingIndicator();
    }

    if (authProv.error) {
      return LandingScreen();
    }

    if (authProv.userData != null) {
      return const AuthenticatedChat();
    }

    return const LandingScreen();
  }
}
