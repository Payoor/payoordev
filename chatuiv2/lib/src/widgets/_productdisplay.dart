import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_productcard.dart';
import 'package:chatuiv2/src/widgets/_productsizeselector.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_product.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

class ProductDisplay extends StatefulWidget {
  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  bool _isDetailsVisible = false;
  int? _selectedProductIndex;
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

        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: results.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (results.isEmpty) return;

                    setState(() {
                      _selectedProductIndex = index;
                      _isDetailsVisible = true;

                      productId = results[index]["_id"];

                      productName = results[index]['data']?.isNotEmpty == true
                          ? results[index]['data'][0]["NAME"] ??
                              "Name not provided"
                          : "Name not provided";

                      try {
                        productData = results[index]['data']
                            .map<Map<String, dynamic>>((item) => {
                                  'id': item.hashCode,
                                  'name': item['NAME'],
                                  'price': double.tryParse(
                                          item['PRICE PER UNIT']
                                              .toString()
                                              .replaceAll(',', '')) ??
                                      0.0,
                                  'unit': item['UNIT'],
                                  'inStock': item['AVAILABILITY'] == 'YES'
                                })
                            .toList();
                      } catch (e) {
                        productData = [];
                      }
                    });
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity:
                        _visibleItems.length > index && _visibleItems[index]
                            ? 1.0
                            : 0.0,
                    curve: Curves.easeIn,
                    child: ProductCard(),
                  ),
                );
              },
            ),
            if (_isDetailsVisible)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.65,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      setState(() {
                        _isDetailsVisible = false;
                        _selectedProductIndex = null;
                      });
                    }
                  },
                  child: ProductSizeSelector(
                    productData: productData,
                    productId: productId,
                    productName: productName,
                    closeWidget: () {
                      setState(() {
                        _isDetailsVisible = false;
                      });
                    },
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
