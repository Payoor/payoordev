import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

enum CustomInputType {
  name,
  email,
  otp, // Added OTP type
  phoneNumber,
  location,
  multiline
}

class CustomInput extends StatefulWidget {
  final void Function(String) onInputChanged;
  final void Function() onInputFocus;
  final void Function() onInputBlur;
  final void Function(String) onSubmit; // New submit handler
  final CustomInputType inputType;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomInput(
      {super.key,
      required this.onInputChanged,
      required this.onInputFocus,
      required this.onInputBlur,
      required this.onSubmit, // New required parameter
      required this.inputType,
      this.hintText,
      this.errorText,
      this.controller,
      this.focusNode});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  String? _errorText;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _validateInput(_controller.text);
        widget.onInputFocus();
      } else {
        widget.onInputBlur();
      }
    });

    _controller.addListener(() {
      _validateInput(_controller.text);
      widget.onInputChanged(_controller.text);
    });
  }

  void _validateInput(String value) {
    //print('validate this $value');
    setState(() {
      _errorText = null;

      switch (widget.inputType) {
        case CustomInputType.email:
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
          );
          _errorText = !emailRegex.hasMatch(value.trim())
              ? 'Please enter a valid email address'
              : null;
          break;

        case CustomInputType.otp: // Add OTP validation
          final otpRegex = RegExp(r'^\d{6}$'); // Assuming 6-digit OTP
          _errorText = !otpRegex.hasMatch(value.trim())
              ? 'Please enter a valid 6-digit OTP'
              : null;
          break;

        case CustomInputType.phoneNumber:
          // Nigerian phone number format: +234 or 0 followed by 9 digits
          final phoneRegex = RegExp(
            r'^([0]|[\+]234)[789][01]\d{8}$',
          );
          _errorText = !phoneRegex.hasMatch(value.trim())
              ? 'Please enter a valid Nigerian phone number'
              : null;
          break;

        case CustomInputType.name:
          if (value.trim().length < 2) {
            _errorText = 'Name must be at least 2 characters';
          } else if (value.trim().length > 50) {
            _errorText = 'Name must be less than 50 characters';
          } else {
            _errorText = null;
          }
          break;

        case CustomInputType.location:
          if (value.trim().isEmpty) {
            _errorText = 'Location cannot be empty';
          } else if (value.trim().length < 3) {
            _errorText = 'Location must be at least 3 characters';
          } else {
            _errorText = null;
          }
          break;

        case CustomInputType.multiline:
          if (value.trim().isEmpty) {
            _errorText = 'Text cannot be empty';
          } else {
            _errorText = null;
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
      fillColor: AppColors.backgroundColor,
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
          color: Colors.transparent,
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
        color: AppColors.primaryColor.withOpacity(.5),
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
          onChanged: (value) {
            //print('here $value');
            //_validateInput(value);
            //widget.onInputChanged(value);
          },
          enableInteractiveSelection: true,
          onSubmitted: (_) {
            _handleSubmit();
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: _getInputDecoration().copyWith(
            // Add padding to accommodate the button
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 56, // Space for button
              top: widget.inputType == CustomInputType.multiline ? 12 : 8,
              bottom: widget.inputType == CustomInputType.multiline ? 12 : 8,
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
