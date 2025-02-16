import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/providers/_banipayprov.dart';

class SwipeUpWidget extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final Duration animationDuration;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  const SwipeUpWidget({
    Key? key,
    required this.child,
    this.minHeight = 100.0,
    this.maxHeight = 400.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onOpen,
    this.onClose,
  }) : super(key: key);

  @override
  SwipeUpWidgetState createState() => SwipeUpWidgetState();
}

class SwipeUpWidgetState extends State<SwipeUpWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Automatically open the widget after a brief delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        open();
      });
    });

    _heightAnimation = Tween<double>(
      begin: widget.minHeight,
      end: widget.maxHeight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method to programmatically open the widget
  void open() {
    if (!_isOpen) {
      _controller.forward();
      _isOpen = true;
      widget.onOpen?.call();
    }
  }

  // Method to programmatically close the widget
  void close() {
    if (_isOpen) {
      _controller.reverse();
      _isOpen = false;
      widget.onClose?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final delta = details.primaryDelta ?? 0;
        final newValue =
            _controller.value - (delta / (widget.maxHeight - widget.minHeight));
        _controller.value = newValue.clamp(0.0, 1.0);
      },
      onVerticalDragEnd: (details) {
        if (_controller.value > 0.5) {
          open();
        } else {
          close();
        }
      },
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return Container(
            height: _heightAnimation.value,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHandle(),
                Expanded(child: widget.child),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}

// Example usage:
class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final GlobalKey<SwipeUpWidgetState> _swipeKey =
      GlobalKey<SwipeUpWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your main content here
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SwipeUpWidget(
              key: _swipeKey,
              minHeight: 100,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Swipe Up Content'),
                    // Add your content here
                  ],
                ),
              ),
              onOpen: () {
                //print('Widget opened');
              },
              onClose: () {
                //print('Widget closed');
                Provider.of<BaniPayProvider>(context, listen: false)
                    .setCurrentOrder(null);
              },
            ),
          ),
          // Example button to programmatically control the widget
          Positioned(
            top: 50,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Toggle the widget programmatically
                if (_swipeKey.currentState != null) {
                  if (_swipeKey.currentState!._isOpen) {
                    _swipeKey.currentState!.close();
                  } else {
                    _swipeKey.currentState!.open();
                  }
                }
              },
              child: Icon(Icons.swap_vert),
            ),
          ),
        ],
      ),
    );
  }
}
