import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';

class PayStackViewContainer extends StatefulWidget {
  final String? url;
  final double height;
  final double width;

  PayStackViewContainer({
    required this.url,
    this.height = double.infinity,
    this.width = double.infinity,
  });

  @override
  _PayStackViewContainerState createState() => _PayStackViewContainerState();
}

class _PayStackViewContainerState extends State<PayStackViewContainer> {
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _registerViewFactory();
  }

  void _registerViewFactory() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      final iframe = html.IFrameElement()
        ..src = widget.url
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%';

      iframe.onLoad.listen((event) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });

      iframe.onError.listen((event) {
        if (mounted) {
          setState(() {
            error = 'Failed to load page';
            isLoading = false;
          });
        }
      });

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          HtmlElementView(viewType: 'iframe'),
          if (isLoading)
            Container(
              width: double.infinity,
              child: Center(
                child: AiLoadingIndicator(),
              ),
            ),
          if (error != null)
            Center(
              child: Text(error!),
            ),
        ],
      ),
    );
  }
}
