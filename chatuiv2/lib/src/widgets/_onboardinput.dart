import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class OnboardInput extends StatefulWidget {
  final void Function(String) onInputChanged;
  final void Function() onInputFocus;
  final void Function() onInputBlur;

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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1024;

    return TextField(
      focusNode: _focusNode,
      maxLines: null,
      minLines: isDesktop ? 7 : 3,
      maxLength: 500,
      textAlignVertical: TextAlignVertical.top,
      onChanged: widget.onInputChanged,
      enableInteractiveSelection: true,
      onSubmitted: (_) {
        _focusNode.unfocus();
      },
      style: TextStyle(
        color: Colors.white,
        fontSize: isDesktop ? 20 : 16,
      ),
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: AppColors.inputBlack,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24 : 16,
          vertical: isDesktop ? 20 : 12,
        ),
        isDense: true, // This helps reduce extra padding
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isDesktop ? 20 : 12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isDesktop ? 20 : 12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isDesktop ? 20 : 12),
          borderSide: BorderSide(
            color: AppColors.inputBlack,
            width: isDesktop ? 3 : 2,
          ),
        ),
        hintText: 'Create a list...',
        hintStyle: TextStyle(
          color: AppColors.white,
          fontSize: isDesktop ? 20 : 16,
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
