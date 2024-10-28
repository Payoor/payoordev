import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chat/utils/_themecolors.dart';

import 'package:chat/classes/_customformstate.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController textController;
  final CustomFormState currentFormState;

  const ChatTextField({
    super.key,
    required this.textController,
    required this.currentFormState,
  });

  @override
  ChatTextFieldState createState() => ChatTextFieldState();
}

class ChatTextFieldState extends State<ChatTextField> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;
  double _height = 40.0;

  late TextInputType keyboardType;

  @override
  void initState() {
    super.initState();
    _controller = widget.textController;
    _controller.addListener(_updateHeight);

    keyboardType = widget.currentFormState.keyboardType;
  }

  void _updateHeight() {
    setState(() {
      _height = _calculateHeight();
    });
  }

  double _calculateHeight() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: _controller.text,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: widget.currentFormState.maxLines,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 32);

    return textPainter.height + 20.0; // Add some padding
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height:
            _height.clamp(40.0, 40.0 * (widget.currentFormState.maxLines ?? 5)),
        constraints: BoxConstraints(
          maxHeight: 40.0 * (widget.currentFormState.maxLines ?? 10),
        ),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.transparent,
            width: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: null,
            keyboardType: widget.currentFormState.keyboardType,
            textInputAction: keyboardType != TextInputType.multiline
                ? null
                : TextInputAction.newline,
            maxLength: widget.currentFormState.maxLength,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  widget.currentFormState.maxLength)
            ],
            decoration: InputDecoration(
              hintText: widget.currentFormState.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              border: InputBorder.none,
              counterText: '',
            ),
            style: const TextStyle(
              color: ThemeColors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHeight);
    _focusNode.dispose();
    super.dispose();
  }
}
