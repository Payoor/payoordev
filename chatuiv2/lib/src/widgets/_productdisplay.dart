import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_productcard.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

import 'package:chatuiv2/src/classes/_productroutes.dart';

class ProductDisplay extends StatefulWidget {
  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  final List<bool> _visibleItems = [];
  List<dynamic> _results = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && _results.isEmpty) {
      final results = context.read<ResultListProvider>().results;
      setState(() {
        _results = List.from(results);
        _isInitialized = true;
      });
      _animateItems();
    }
  }

  void _animateItems() {
    _visibleItems.clear();
    _visibleItems.addAll(List.generate(_results.length, (_) => false));

    for (var i = 0; i < _results.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          setState(() {
            if (i < _visibleItems.length) {
              _visibleItems[i] = true;
            }
          });
        }
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _results.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (_results.isEmpty) return const SizedBox();

        final product = _results[index];
        final String productName = product['product_name'];
        final String productId = product['_id'];

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity:
              _visibleItems.length > index && _visibleItems[index] ? 1.0 : 0.0,
          curve: Curves.easeIn,
          child: ProductCard(
            productName: productName,
            productId: productId,
            onProductTap: () {
              context.read<ResultListProvider>().setCurrentProduct(
                  productId: productId, productName: productName);
            },
            onFavoriteTap: () {},
          ),
        );
      },
    );
  }
}
