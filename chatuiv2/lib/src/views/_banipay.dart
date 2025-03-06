import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';
import 'package:chatuiv2/src/widgets/_headerrow.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';
import 'package:chatuiv2/src/classes/_orderroutes.dart';

import 'package:chatuiv2/src/providers/_banipayprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';

class BaniPay extends StatefulWidget {
  final String? orderId;
  final String? paymentLink;
  final double height;
  final double width;

  const BaniPay({
    required Key key,
    required this.orderId,
    required this.paymentLink,
    this.height = double.infinity,
    this.width = double.infinity,
  });

  @override
  State<BaniPay> createState() => _BaniPayState();
}

class _BaniPayState extends State<BaniPay> {
  bool isLoading = true;
  bool isIframeLoading = true;
  String? error;
  bool isViewRegistered = false;
  String? paymentUrl;
  final String viewType = 'bani-iframe';

  // Flag to avoid registering view factory more than once
  static bool viewFactoryRegistered = false;

  @override
  void initState() {
    super.initState();

    // Register view factory outside of the build method
    _registerViewFactory();

    // Set payment URL
    paymentUrl = widget.paymentLink;

    // Set up message listener
    html.window.onMessage.listen((event) {
      if (event.data is Map) {
        final data = event.data as Map;
        if (data['type'] == 'onSuccess') {
          _handlePaymentSuccess(widget.orderId);
        }
      }
    });

    // Set initial state after setup
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          isViewRegistered = true;
          isLoading = false;
        });
      }
    });
  }

  void _handlePaymentSuccess(dynamic orderId) {
    context.read<BaniPayProvider>().setCurrentOrder(null);
    context.read<CartProvider>().clear();
    Navigator.pushNamed(context, '/');
  }

  void _registerViewFactory() {
    // Only register the view factory once
    if (!viewFactoryRegistered) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%';

        // We'll set the src when the element is created, not during registration

        // Register iframe lifecycle events
        iframe.onLoad.listen((event) {
          // Use Future.delayed to avoid setState during build
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                isIframeLoading = false;
              });
            }
          });
        });

        iframe.onError.listen((event) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                error = 'Failed to load payment interface';
                isIframeLoading = false;
              });
            }
          });
        });

        return iframe;
      });

      viewFactoryRegistered = true;
    }
  }

  // Function to set the iframe src when it's created
  void _updateIframeSrc() {
    final iframes = html.document.getElementsByTagName('iframe');
    for (var i = 0; i < iframes.length; i++) {
      // Cast to IFrameElement to access src property
      final iframe = iframes[i] as html.IFrameElement;
      if (iframe.src!.isEmpty && paymentUrl != null) {
        iframe.src = paymentUrl!;
      }
    }
  }

  @override
  void didUpdateWidget(BaniPay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the payment link changed, update it
    if (widget.paymentLink != oldWidget.paymentLink) {
      setState(() {
        paymentUrl = widget.paymentLink;
        isIframeLoading = true;
      });

      // Schedule iframe update after this build cycle
      Future.delayed(Duration.zero, _updateIframeSrc);
    }
  }

  @override
  Widget build(BuildContext context) {
    // After the iframe is inserted into the DOM, update its src attribute
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIframeSrc();
    });

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? Center(child: AiLoadingIndicator())
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.primaryBackgroundWhite,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: HeaderRow(
                          headerName: "Order Completion",
                          onBurgerMenuTap: () => {},
                          showBackButton: true,
                          showBurger: false,
                          onBackTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Container(
                              color: AppColors.primaryBackgroundWhite,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  // Always include the HtmlElementView once registered
                                  if (isViewRegistered)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBackgroundWhite,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child:
                                          HtmlElementView(viewType: viewType),
                                    ),

                                  // Show loading indicator while iframe is loading
                                  if (isIframeLoading)
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AiLoadingIndicator(),
                                          SizedBox(height: 16),
                                          Text(
                                            "Loading payment interface...",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Show error if loading fails
                                  if (error != null)
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 48,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            error!,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                error = null;
                                                isIframeLoading = true;
                                              });
                                              // Schedule iframe update after this build cycle
                                              Future.delayed(Duration.zero,
                                                  _updateIframeSrc);
                                            },
                                            child: Text("Try Again"),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
