import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class OnboardInput extends StatefulWidget {
  final void Function(String) onInputChanged;
  final void Function() onInputFocus;
  final void Function() onInputBlur; // Added for focus out

  const OnboardInput({
    super.key,
    required this.onInputChanged,
    required this.onInputFocus,
    required this.onInputBlur,
  });

  @override
  State<OnboardInput> createState() => _OnboardInputState();
}

class _OnboardInputState extends State<OnboardInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onInputFocus();
      } else {
        widget.onInputBlur();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      maxLines: null,
      minLines: 3,
      maxLength: 500,
      onChanged: widget.onInputChanged,
      onSubmitted: (_) {
        _focusNode.unfocus(); // Unfocus when done is pressed
      },
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: AppColors.backgroundColor, // Background color
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        constraints: BoxConstraints(
          maxHeight: 200, // Maximum height it can grow to
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Removes the default border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        hintText: 'Create a list...',
        hintStyle: TextStyle(
          color: AppColors.primaryColor.withOpacity(.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
