import 'package:flutter/material.dart';

import 'package:chat/classes/_review.dart';

import 'package:chat/utils/_themecolors.dart';

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: ThemeColors.blue1, // Background color
      ),
      //padding: const EdgeInsets.all(16.0), // Add padding around the container
      child: Padding(
        padding: const EdgeInsets.only(
            top: 40.0,
            left: 60.0,
            right: 60.0), // Add padding around the column
        child: Column(
          /*mainAxisAlignment:
              MainAxisAlignment.center, */ // Center the content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the content horizontally
          children: [
            ClipOval(
              child: Image.asset(
                widget.review.imageUrl,
                width: 100, // Set the width of the circle
                height: 100, // Set the height of the circle (same as width)
                fit: BoxFit.cover, // Ensure the image covers the circle area
              ),
            ),
            const SizedBox(
                height: 12), // Add space between the image and the name
            Text(
              widget.review.name,
              style: const TextStyle(
                fontSize: 30, // Set the font size
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic, // Set the font weight
                color: Colors.black, // Set the text color
              ),
            ),
            const SizedBox(
                height: 8), // Add space between the name and the description
            Text(
              widget.review.content,
              style: const TextStyle(
                fontSize: 20, // Set the font size
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: ThemeColors.fontColor, // Set the text color
                height: 1.5, // Adjust the line height
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ],
        ),
      ),
    );
  }
}
