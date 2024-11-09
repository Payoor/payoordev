import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final bool showCursor;
  final TextAlign textAlign;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 2000),
    this.showCursor = true,
    this.textAlign = TextAlign.left,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showCursor = true;
  bool _isTypingComplete = false;
  Timer? _cursorTimer;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.text.length.toDouble(),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isTypingComplete = true;
            _showCursor = false;
          });
          _cursorTimer?.cancel();
        }
      });

    _controller.forward();

    if (widget.showCursor) {
      _cursorTimer = Timer.periodic(
        const Duration(milliseconds: 500),
        (timer) {
          if (mounted && !_isTypingComplete) {
            setState(() {
              _showCursor = !_showCursor;
            });
          }
        },
      );
    }
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() {
        _isTypingComplete = false;
        _showCursor = true;
      });

      _controller.reset();
      _animation = Tween<double>(
        begin: 0,
        end: widget.text.length.toDouble(),
      ).animate(_controller);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _animation.value.toInt());

    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            children: [
              Text(
                displayText,
                key: _textKey,
                style: widget.style,
                textAlign: widget.textAlign,
                softWrap: true,
              ),
              if (widget.showCursor && _showCursor && !_isTypingComplete)
                Text(
                  '|',
                  style: widget.style?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
