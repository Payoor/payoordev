import 'package:flutter/material.dart';
import 'dart:async';

import 'package:chat/classes/_review.dart';

import 'package:chat/widgets/_onboardingslide.dart';

class OnboardingSlider extends StatefulWidget {
  final List<Review> reviews;
  final Duration slideDuration;

  const OnboardingSlider({
    Key? key,
    required this.reviews,
    this.slideDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _OnboardingSliderState createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.slideDuration, (Timer timer) {
      if (_currentPage < widget.reviews.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, // Set a specific height
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.reviews.length,
        itemBuilder: (context, index) {
          return OnboardingSlide(
            review: widget.reviews[index]
          );
        },
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
  }
}
