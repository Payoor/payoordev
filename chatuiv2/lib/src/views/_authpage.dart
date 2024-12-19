import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:chatuiv2/src/widgets/_custominput.dart';
import 'package:chatuiv2/src/widgets/_typewritertext.dart';
import 'package:chatuiv2/src/widgets/_animatedcartloader.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_authmessages.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';

import 'package:chatuiv2/src/providers/_onboardingprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late PageController _pageController;
  late TextEditingController _inputController;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int currentPage = 0;
  Map<int, bool> submittedResponses = {};

  // Form data storage
  String name = '';
  String email = '';
  String otp = '';
  String phone = '';
  String location = '';
  String shoppingList = '';

  bool isLoading = false;
  String? errorMessage;

  bool shouldResetTypewriter = false;
  String? customMessage;

  bool get isEmailSubmitting => (currentPage == 0) == true && isLoading;
  bool get isOtpVerifying => (currentPage == 1) == true && isLoading;

  bool canMoveToNextPage() {
    switch (currentPage) {
      case 0:
        return email.isNotEmpty && submittedResponses[0] == true;
      case 1:
        return otp.isNotEmpty && submittedResponses[1] == true;
      case 2:
        return name.isNotEmpty && submittedResponses[2] == true;
      case 3:
        return phone.isNotEmpty && submittedResponses[3] == true;
      case 4:
        return location.isNotEmpty && submittedResponses[4] == true;
      case 5:
        return shoppingList.isNotEmpty && submittedResponses[5] == true;
      default:
        return false;
    }
  }

  void showError(String message) {
    setState(() {
      shouldResetTypewriter = true;
      customMessage = message;
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            shouldResetTypewriter = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //final onboardingProv =
      Provider.of<OnboardingProv>(context, listen: false);
      //shoppingList = onboardingProv.onboardingMessage;
      if (shoppingList.isNotEmpty) {
        submittedResponses[5] = true;
      }
    });

    _pageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    if (_pageController.hasClients && _pageController.page == 5.0) {
      if (_inputController.text != shoppingList && shoppingList.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _inputController.text = shoppingList;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentPage == 5) {
      final onboardingProv =
          Provider.of<OnboardingProv>(context, listen: false);
      if (onboardingProv.onboardingMessage.isNotEmpty &&
          _inputController.text != onboardingProv.onboardingMessage) {
        // _inputController.text = onboardingProv.onboardingMessage;
      }
    }
  }

  CustomInputType _getInputTypeForPage(int page) {
    switch (page) {
      case 0:
        return CustomInputType.email; // Email first
      case 1:
        return CustomInputType.otp; // OTP second
      case 2:
        return CustomInputType.name; // Name third
      case 3:
        return CustomInputType.phoneNumber;
      case 4:
        return CustomInputType.location;
      case 5:
        return CustomInputType.multiline;
      default:
        return CustomInputType.email;
    }
  }

  String _getHintTextForPage(int page) {
    switch (page) {
      case 0:
        return 'Enter your email address...';
      case 1:
        return 'Enter the 6-digit OTP...';
      case 2:
        return 'Enter your full name...';
      case 3:
        return 'Enter your Nigerian phone number...';
      case 4:
        return 'Enter your delivery address...';
      case 5:
        return 'List your typical grocery items...';
      default:
        return '';
    }
  }

  String _getStepTitle(int page) {
    switch (page) {
      case 0:
        return 'Step 1';
      case 1:
        return 'Verification';
      case 2:
        return 'Step 2';
      case 3:
        return 'Step 3';
      case 4:
        return 'Step 4';
      case 5:
        return 'Final Step';
      default:
        return '';
    }
  }

  void _handleInputChange(String value) {
    /*setState(() {
      switch (currentPage) {
        case 0:
          email = value;
          break;
        case 1:
          otp = value;
          break;
        case 2:
          name = value;
          break;
        case 3:
          phone = value;
          break;
        case 4:
          location = value;
          break;
        case 5:
          shoppingList = value;
          break;
      }
    });*/
  }

  String _getCurrentValue() {
    switch (currentPage) {
      case 0:
        return email;
      case 1:
        return otp;
      case 2:
        return name;
      case 3:
        return phone;
      case 4:
        return location;
      case 5:
        return shoppingList;
      default:
        return '';
    }
  }

  Future<void> _handleSubmit(String value) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      switch (currentPage) {
        case 0:
          try {
            setState(() {
              email = value;
              submittedResponses[0] = true;
            });

            _inputController.clear();
            final response = await AuthApiRoutes.getOtp(value);

            if (canMoveToNextPage()) {
              nextPage();
            }
          } catch (e) {
            setState(() {
              email = "";
              submittedResponses[0] = false;
              errorMessage = 'Failed to send OTP. Please try again.';
            });
            showError(
                'That didn\'t work. Please try entering your email again.');
            return;
          }
          break;

        case 1:
          try {
            setState(() {
              otp = value;
              submittedResponses[1] = true;
            });

            _inputController.clear();
            dynamic response = await AuthApiRoutes.verifyOtp(email, value);

            bool userExists = response.data['userExists'];

            if (canMoveToNextPage() && !userExists) {
              nextPage();
            } else {
              final authProv = Provider.of<AuthProv>(context, listen: false);
              String userId = response.data['id'];
              authProv.userId = userId;

              response = await AuthApiRoutes.getJWT(userId);

              if (response.success) {
                final String userJWT = response.data['token'];

                authProv.jwt = userJWT;

                JwtManager.saveToken(userJWT);

                authProv.checkForUser();

                await _fadeController.forward();

                Navigator.pushNamed(context, '/authchat');
              } else {
                Navigator.pushNamed(context, '/');
              }
            }
          } catch (e) {
            setState(() {
              otp = "";
              submittedResponses[1] = false;
              errorMessage = 'Invalid OTP. Please try again.';
            });
            showError('Incorrect OTP. Please try entering it again.');
            _inputController.clear();
            return;
          }
          break;

        case 2:
          setState(() {
            name = value;
            submittedResponses[2] = true;
          });
          _inputController.clear();
          if (canMoveToNextPage()) {
            nextPage();
          }
          break;

        case 3:
          setState(() {
            phone = value;
            submittedResponses[3] = true;
          });
          _inputController.clear();
          if (canMoveToNextPage()) {
            nextPage();
          }
          break;

        case 4:
          setState(() {
            location = value;
            submittedResponses[4] = true;
          });
          _inputController.clear();
          if (canMoveToNextPage()) {
            nextPage();
          }
          break;

        case 5:
          setState(() {
            shoppingList = value;
            submittedResponses[5] = true;
          });
          _inputController.clear();
          _handleFormComplete();
          break;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await AuthApiRoutes.getOtp(email);
      // Maybe show success message
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to resend OTP. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleFormComplete() async {
    final formData = {
      'name': name,
      'email': email,
      'otp': otp,
      'phone': phone,
      'location': location,
      'shoppingList': shoppingList,
    };

    try {
      final response = await AuthApiRoutes.handleSignUp(
        name: name,
        email: email,
        otp: otp,
        phone: phone,
        location: location,
        shoppingList: shoppingList,
      );

      //print(response.data['user']);
      final authProv = Provider.of<AuthProv>(context, listen: false);
      authProv.userId = response.data['user']['id'];
      authProv.userData = response.data['user'];

      print(authProv.userData);

      if (response.success) {
        await _fadeController.forward();

        Navigator.pushNamed(context, '/welcome');
      }
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = 'Failed to complete signup. Please try again.';
      });
      showError(
          'Network error during signup. Please check your connection and try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleInputFocus() {
    _animationController.forward();
  }

  void handleInputBlur() {
    _animationController.reverse();
  }

  void nextPage() {
    if (currentPage < 5 && canMoveToNextPage()) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildPageContent(int index) {
    String getUserResponse() {
      switch (index) {
        case 0:
          return email;
        case 1:
          return otp;
        case 2:
          return name;
        case 3:
          return phone;
        case 4:
          return location;
        case 5:
          return shoppingList;
        default:
          return '';
      }
    }

    String getMessage() {
      if (shouldResetTypewriter) return '';
      if (customMessage != null && (index == 0 || index == 1)) {
        return customMessage!;
      }
      return index == 1
          ? AuthMessages.getOtpMessage()
          : AuthMessages.getMessageForInputType(_getInputTypeForPage(index));
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (index > 0)
                GestureDetector(
                  onTap: previousPage,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              if (index > 0)
                SizedBox(
                  width: 10,
                ),
              Text(
                _getStepTitle(index),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          TypewriterText(
            key: ValueKey('${index}_${customMessage}_${shouldResetTypewriter}'),
            text: getMessage(),
            style: TextStyle(
              fontSize: 16,
              color: customMessage != null && (index == 0 || index == 1)
                  ? Colors.red.withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
            ),
            duration: Duration(milliseconds: 1500),
            showCursor: true,
          ),
          if ((isEmailSubmitting && index == 0) ||
              (isOtpVerifying && index == 1)) ...[
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: AnimatedCartLoader(),
            ),
          ],
          if (submittedResponses[index] == true &&
              getUserResponse().isNotEmpty) ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.only(top: 17, bottom: 17),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visitor:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    getUserResponse(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (index == 1)
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: TextButton(
                onPressed: isLoading ? null : _handleResendOtp,
                child: InkWell(
                  onTap: isLoading ? null : _handleResendOtp,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white.withOpacity(isLoading ? 0.5 : 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Colors.white.withOpacity(isLoading ? 0.5 : 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      resizeToAvoidBottomInset: false,
      body: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                right: 20,
                left: 20,
                top: 40,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PageView.builder(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: buildPageContent(index),
                        );
                      },
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomPadding * _animation.value,
                    child: child!,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: CustomInput(
                    controller: _inputController,
                    inputType: _getInputTypeForPage(currentPage),
                    onInputChanged: _handleInputChange,
                    onInputFocus: handleInputFocus,
                    onInputBlur: handleInputBlur,
                    onSubmit: _handleSubmit,
                    hintText: _getHintTextForPage(currentPage),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _animationController.dispose();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
