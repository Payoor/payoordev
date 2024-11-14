import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';

class WebViewContainer extends StatefulWidget {
  final String url;
  final double height;
  final double width;

  WebViewContainer({
    required this.url,
    this.height = 500,
    this.width = double.infinity,
  });

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
 bool isLoading = true;
 String? error;

 @override
 Widget build(BuildContext context) {
   // ignore: undefined_prefixed_name
   ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
     final iframe = html.IFrameElement()
       ..src = widget.url
       ..style.border = 'none'
       ..style.height = '100%'
       ..style.width = '100%';
       
     // Add load listener
     iframe.onLoad.listen((event) {
       setState(() {
         isLoading = false;
       });
     });

     // Add error listener
     iframe.onError.listen((event) {
       setState(() {
         error = 'Failed to load page';
         isLoading = false;
       });
     });

     return iframe;
   });

   return Container(
     height: widget.height, 
     width: widget.width,
     child: Stack(
       children: [
         HtmlElementView(viewType: 'iframe'),
         if (isLoading)
           Container(
            width: double.infinity,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AiLoadingIndicator(),
              ],
             )
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