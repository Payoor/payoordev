import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:chat/utils/_themecolors.dart';

class WavyDotsLoading extends StatefulWidget {
  final Color color;
  final double size;

  const WavyDotsLoading({
    Key? key,
    this.color = Colors.blue,
    this.size = 50.0,
  }) : super(key: key);

  @override
  _WavyDotsLoadingState createState() => _WavyDotsLoadingState();
}

class _WavyDotsLoadingState extends State<WavyDotsLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, math.sin((_controller.value * 2 * math.pi) + (index * math.pi / 2)) * 10),
                child: Container(
                  width: widget.size / 7,
                  height: widget.size / 7,
                  decoration: const BoxDecoration(
                    color: ThemeColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}