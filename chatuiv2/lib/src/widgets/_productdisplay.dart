import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_productcard.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

class ProductDisplay extends StatefulWidget {
  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  final List<bool> _visibleItems = [];
  late List<Map<String, dynamic>> productData;
  late String productId;
  late String productName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateItems();
    });
  }

  void _animateItems() {
    final results = context.read<ResultListProvider>().results;
    _visibleItems.clear();
    _visibleItems.addAll(List.generate(results.length, (_) => false));

    for (var i = 0; i < results.length; i++) {
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

  Widget build(BuildContext context) {
    return Consumer<ResultListProvider>(
      builder: (context, resultList, child) {
        final results = resultList.results;

        if (_visibleItems.length != results.length) {
          _animateItems();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: results.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (results.isEmpty) return const SizedBox();

            final product = results[index];
            final String productName = product['product_name'];
            final String productId = product['_id'];

            List<Map<String, dynamic>> productData = [];

            try {
              productData = product['data']
                  .map<Map<String, dynamic>>((item) => {
                        'id': productId,
                        'name': productName,
                        'price': double.tryParse(
                                item['price'].toString().replaceAll(',', '')) ??
                            0.0,
                        'unit': item['unit'],
                        'inStock': item['availability'] == 'YES'
                      })
                  .toList();
            } catch (e) {
              productData = [];
            }

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _visibleItems.length > index && _visibleItems[index]
                  ? 1.0
                  : 0.0,
              curve: Curves.easeIn,
              child: ProductCard(
                productName: productName,
                productId: productId,
                onProductTap: () {
                  context.read<ResultListProvider>().setCurrentProduct(
                      productData: productData,
                      productId: productId,
                      productName: productName);
                },
                onFavoriteTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}
