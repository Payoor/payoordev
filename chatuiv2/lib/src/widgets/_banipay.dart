import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:chatuiv2/src/widgets/_ailoadingindicator.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_authapiroutes.dart';
import 'package:chatuiv2/src/classes/_jwtmanager.dart';
import 'package:chatuiv2/src/classes/_orderroutes.dart';

class BaniPay extends StatefulWidget {
  final String? orderId;
  final double height;
  final double width;

  const BaniPay({
    super.key,
    required this.orderId,
    this.height = double.infinity,
    this.width = double.infinity,
  });

  @override
  State<BaniPay> createState() => _BaniPayState();
}

class _BaniPayState extends State<BaniPay> {
  bool isLoading = true;
  String? error;
  Map<String, dynamic>? userData;
  dynamic orderData;
  bool isViewRegistered = false;
  static bool factoryRegistered = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final String? jwtToken = JwtManager.getToken();

      final userResponse = await AuthApiRoutes.getValidUser('$jwtToken');
      final orderResponse = await OrdersRoute.getUserOrder(widget.orderId!);

      setState(() {
        userData = userResponse.data['user'];
        orderData = orderResponse.data;
      });

      if (!factoryRegistered) {
        _registerViewFactory();
        factoryRegistered = true;
      }

      setState(() {
        isViewRegistered = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load user data';
        isLoading = false;
      });
    }
  }

  void _registerViewFactory() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('bani-iframe', (int viewId) {
      final iframe = html.IFrameElement()
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..srcdoc = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { 
      font-family: Arial, sans-serif; 
      padding: 16px;
      background-color: transparent;
    }
    .form-group { display: none; }
  </style>
</head>
<body>
  <form id="paymentForm">
    <div class="form-group">
      <input type="tel" id="phone-number" value="${userData?['phoneNumber'] ?? ''}" />
      <input type="email" id="email" value="${userData?['email'] ?? ''}" />
      <input type="number" id="amount" value="${orderData?['total'] ?? '200'}" />
      <input type="text" id="first-name" value="${userData?['name'] ?? ''}" />
      <input type="text" id="last-name" value="${userData?['name'] ?? ''}${userData?['name'] ?? ''}" />
    </div>
  </form>
  <script src="https://bani-assets.s3.eu-west-2.amazonaws.com/static/widget/js/window.js"></script>
  <script>
    window.onload = function() {
      const paymentForm = document.getElementById('paymentForm');
      const phoneNumber = document.getElementById('phone-number').value;
      const formattedPhone = "+234" + phoneNumber.replace(/^0+/, '');
  
      let handler = BaniPopUp({
        amount: document.getElementById('amount').value,
        phoneNumber: formattedPhone,
        email: document.getElementById('email').value,
        firstName: document.getElementById('first-name').value,
        lastName: document.getElementById('last-name').value,
        merchantKey: "pub_test_WXKQ08RC7YQDN0KR5JS39",
        metadata: {
          order_ref: "${widget.orderId}",
        },
        merchantRef: "ref-" + Math.random().toString(36).substr(2, 9),
        onClose: (response) => {
            console.log('Bani Close Event:', response);
            window.parent.postMessage({type: 'onClose', data: response}, '*');
        },
        callback: function(response) {
            console.log('Bani Success Event:', response);
            window.parent.postMessage({type: 'onSuccess', data: response}, '*');
        }
      });
      handler;
    };
  </script>
</body>
</html>
''';

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
            error = 'Failed to load payment interface';
            isLoading = false;
          });
        }
      });

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isViewRegistered) {
      return Container(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: AiLoadingIndicator(),
        ),
      );
    }

    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyBlack.withOpacity(.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const HtmlElementView(viewType: 'bani-iframe'),
          ),
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
