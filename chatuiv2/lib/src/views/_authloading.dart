import 'package:flutter/material.dart';

import 'package:chatuiv2/src/views/_landingscreen.dart';
import 'package:chatuiv2/src/views/_authenticatedchat.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';

class AuthLoading extends StatefulWidget {
  const AuthLoading({super.key});

  @override
  State<AuthLoading> createState() => _AuthLoadingState();
}

class _AuthLoadingState extends State<AuthLoading> {
  Future<String?>? _authFuture;
  String? _error = null;
  bool _isLoading = true;

  dynamic user = null;

  @override
  void initState() {
    super.initState();
    _checkForUser();
  }

  Future<void> _checkForUser() async {
    final String? jwtToken = JwtManager.getToken();

    if (jwtToken == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      return;
    }

    if (jwtToken.isNotEmpty) {
      final response = await AuthApiRoutes.getValidUser(jwtToken);

      final userData = response.data['user'];

      if (userData != null) {
        if (mounted) {
          setState(() {
            user = userData;
            _isLoading = false;
            _error = null;
          });
        }
      } else {
        setState(() {
          user = null;
          _isLoading = false;
          _error = null;
        });
      }
    }
  }

  Widget _buildLoadingIndicator() {
    return Scaffold(
        backgroundColor: AppColors.primaryColorDark,
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: Container()));
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
    if (!_isLoading && user == null) {
      return LandingScreen();
    }

    if (_isLoading && user == null) {
      return _buildLoadingIndicator();
    }

    if (!_isLoading && user != null) {
      return AuthenticatedChat();
    }

    if (_error != null) {
      return _buildError();
    }

    return Scaffold(
        backgroundColor: AppColors.primaryColorDark,
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: Container()));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
