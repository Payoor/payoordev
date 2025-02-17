import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

enum CustomInputType { name, email, otp, phoneNumber, location, multiline }

class CustomInput extends StatefulWidget {
  final void Function(String) onInputChanged;
  final void Function() onInputFocus;
  final void Function() onInputBlur;
  final void Function(String) onSubmit;
  final CustomInputType inputType;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomInput({
    super.key,
    required this.onInputChanged,
    required this.onInputFocus,
    required this.onInputBlur,
    required this.onSubmit,
    required this.inputType,
    this.hintText,
    this.errorText,
    this.controller,
    this.focusNode,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  String? _errorText;
  bool _isValid = false;
  bool _hasClipboardContent = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _validateInput(_controller.text);
        _checkClipboard();
        widget.onInputFocus();
      } else {
        widget.onInputBlur();
      }
    });

    _controller.addListener(() {
      _validateInput(_controller.text);
      widget.onInputChanged(_controller.text);
    });

    // Initial clipboard check
    _checkClipboard();
  }

  Future<void> _checkClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      _hasClipboardContent = data?.text?.isNotEmpty ?? false;
    });
  }

  Future<void> _pasteContent() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      final currentPosition = _controller.selection.baseOffset;
      final text = _controller.text;
      final newText = text.replaceRange(
        currentPosition >= 0 ? currentPosition : text.length,
        currentPosition >= 0 ? _controller.selection.extentOffset : text.length,
        data!.text!,
      );

      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: currentPosition >= 0
              ? currentPosition + data.text!.length
              : newText.length,
        ),
      );

      _validateInput(newText);
      widget.onInputChanged(newText);
    }
  }

  void _validateInput(String value) {
    setState(() {
      _errorText = null;

      switch (widget.inputType) {
        case CustomInputType.email:
          final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
          _errorText = !emailRegex.hasMatch(value.trim())
              ? 'Please enter a valid email address'
              : null;
          break;

        case CustomInputType.otp:
          final otpRegex = RegExp(r'^\d{6}$');
          _errorText = !otpRegex.hasMatch(value.trim())
              ? 'Please enter a valid 6-digit OTP'
              : null;
          break;

        case CustomInputType.phoneNumber:
          final phoneRegex = RegExp(r'^([0]|[\+]234)[789][01]\d{8}$');
          _errorText = !phoneRegex.hasMatch(value.trim())
              ? 'Please enter a valid Nigerian phone number'
              : null;
          break;

        case CustomInputType.name:
          if (value.trim().length < 2) {
            _errorText = 'Name must be at least 2 characters';
          } else if (value.trim().length > 50) {
            _errorText = 'Name must be less than 50 characters';
          }
          break;

        case CustomInputType.location:
          if (value.trim().isEmpty) {
            _errorText = 'Location cannot be empty';
          } else if (value.trim().length < 3) {
            _errorText = 'Location must be at least 3 characters';
          }
          break;

        case CustomInputType.multiline:
          if (value.trim().isEmpty) {
            _errorText = 'Text cannot be empty';
          }
          break;
      }

      _isValid = _errorText == null && value.trim().isNotEmpty;
    });
  }

  void _handleSubmit() {
    if (_isValid) {
      widget.onSubmit(_controller.text.trim());
      _focusNode.unfocus();
      setState(() {
        _errorText = null;
      });
    }
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      counterText: "",
      filled: true,
      fillColor: AppColors.inputBlack,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: widget.inputType == CustomInputType.multiline ? 20 : 30,
      ),
      constraints: BoxConstraints(
        maxHeight: widget.inputType == CustomInputType.multiline ? 200 : 56,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.inputBlack,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      hintText: widget.hintText ?? _getDefaultHintText(),
      hintStyle: TextStyle(
        color: AppColors.white,
      ),
      errorText: _errorText ?? widget.errorText,
    );
  }

  String _getDefaultHintText() {
    switch (widget.inputType) {
      case CustomInputType.email:
        return 'Enter email address...';
      case CustomInputType.otp:
        return 'Enter 6-digit OTP...';
      case CustomInputType.phoneNumber:
        return 'Enter Nigerian phone number...';
      case CustomInputType.name:
        return 'Enter name...';
      case CustomInputType.location:
        return 'Enter location...';
      case CustomInputType.multiline:
        return 'Enter text...';
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case CustomInputType.email:
        return TextInputType.emailAddress;
      case CustomInputType.otp:
        return TextInputType.number;
      case CustomInputType.phoneNumber:
        return TextInputType.phone;
      case CustomInputType.name:
        return TextInputType.name;
      case CustomInputType.location:
        return TextInputType.streetAddress;
      case CustomInputType.multiline:
        return TextInputType.multiline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: widget.inputType == CustomInputType.multiline ? null : 1,
          minLines: widget.inputType == CustomInputType.multiline ? 3 : 1,
          maxLength: widget.inputType == CustomInputType.multiline
              ? 500
              : widget.inputType == CustomInputType.name
                  ? 50
                  : widget.inputType == CustomInputType.phoneNumber
                      ? 14
                      : null,
          keyboardType: _getKeyboardType(),
          onTap: _checkClipboard,
          enableInteractiveSelection: true,
          onSubmitted: (_) => _handleSubmit(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: _getInputDecoration().copyWith(
            contentPadding: EdgeInsets.only(
              left: 16,
              right: _hasClipboardContent
                  ? 96
                  : 56, // Extra space for paste button
              top: widget.inputType == CustomInputType.multiline ? 12 : 8,
              bottom: widget.inputType == CustomInputType.multiline ? 12 : 8,
            ),
          ),
        ),
        // Paste button
        if (_hasClipboardContent)
          Positioned(
            right: 50,
            top: 7,
            child: GestureDetector(
              onTap: _pasteContent,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.content_paste,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        // Submit button
        Positioned(
          right: 8,
          top: 7,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _isValid ? 1.0 : 0.5,
            child: GestureDetector(
              onTap: _isValid ? _handleSubmit : null,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isValid
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }
}
