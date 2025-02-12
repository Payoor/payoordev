import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class AnimatedCartLoader extends StatefulWidget {
  const AnimatedCartLoader({
    super.key,
    this.size = 25,
  });

  final double size;

  @override
  State<AnimatedCartLoader> createState() => _AnimatedCartLoaderState();
}

class _AnimatedCartLoaderState extends State<AnimatedCartLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(_animation),
      child: Image.asset(
        'assets/payoorcart.png',
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        color: AppColors.primaryColor,
        colorBlendMode: BlendMode.srcATop,
      ),
    );
  }
}
