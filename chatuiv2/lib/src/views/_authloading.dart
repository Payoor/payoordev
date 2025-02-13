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
  static const _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _checkForUser();
  }

  void _checkForUser() {
    Future.microtask(
      () => context.read<AuthProv>().checkForUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProv>(
      builder: (context, authProv, _) {
        return AnimatedSwitcher(
          duration: _animationDuration,
          child: _buildPage(authProv),
        );
      },
    );
  }

  Widget _buildPage(AuthProv authProv) {
    if (authProv.isLoading) {
      return const _LoadingIndicator();
    }

    if (authProv.error) {
      return const LandingScreen();
    }

    if (authProv.userData != null) {
      return const AuthenticatedChat();
    }

    return const LandingScreen();
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryBackgroundWhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
}
