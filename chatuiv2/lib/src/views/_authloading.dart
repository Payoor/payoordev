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
  String? _error = null;
  bool _isLoading = true;

  dynamic user = null;

  @override
  void initState() {
    super.initState();
    _checkForUser();
  }

  Future<void> _checkForUser() async {
    try {
      final String? jwtToken = JwtManager.getToken();

      if (jwtToken == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            user = null;
          });
        }

        return;
      }

      if (jwtToken.isNotEmpty) {
        final response = await AuthApiRoutes.getValidUser(jwtToken);

        final userData = response.data['user'];

        Provider.of<AuthProv>(context, listen: false).userData = userData;

        if (userData != null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              user = userData;
            });
          }
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          user = null;
        });
      }
    }
  }

  Widget _buildLoadingIndicator() {
    return Scaffold(
        backgroundColor: AppColors.primaryColorDark,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                    child: Text(
                  "loading...",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                )))));
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error: $_error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checkForUser,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    if (user != null) {
      return AuthenticatedChat();
    }

    if (_error != null) {
      return _buildError();
    }

    return LandingScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
