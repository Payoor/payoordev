import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_review.dart';
import 'package:chatuiv2/src/classes/_appcolors.dart';

class OnboardingSlide extends StatefulWidget {
  final Review review;

  const OnboardingSlide({
    super.key,
    required this.review,
  });

  @override
  State<OnboardingSlide> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlide> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Container(
      height: MediaQuery.of(context).size.height * (isDesktop ? 0.5 : 0.4),
      decoration: const BoxDecoration(
        color: AppColors.blue1,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: isDesktop ? 40.0 : 24.0,
          left: isDesktop ? 60.0 : 20.0,
          right: isDesktop ? 60.0 : 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                widget.review.imageUrl,
                width: isDesktop ? 100 : 80,
                height: isDesktop ? 100 : 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 8),
            Text(
              widget.review.name,
              style: TextStyle(
                fontSize: isDesktop ? 30 : 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            SizedBox(height: isDesktop ? 8 : 6),
            Text(
              widget.review.content,
              style: TextStyle(
                fontSize: isDesktop ? 20 : 16,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: AppColors.fontColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
