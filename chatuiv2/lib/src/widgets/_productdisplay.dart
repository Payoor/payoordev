import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:chatuiv2/src/widgets/_productcard.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_productroutes.dart';

class ProductDisplay extends StatefulWidget {
  final bool showProducts;

  const ProductDisplay({
    Key? key,
    required this.showProducts,
  }) : super(key: key);

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _AnimatedProductCard extends StatefulWidget {
  final String productName;
  final String productTags;
  final String productId;
  final int index;

  const _AnimatedProductCard({
    Key? key,
    required this.productName,
    required this.productTags,
    required this.productId,
    required this.index,
  }) : super(key: key);

  @override
  State<_AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<_AnimatedProductCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, _visible ? 0 : 20, 0),
        curve: Curves.easeOut,
        child: ProductCard(
          productName: widget.productName,
          productTags: widget.productTags,
          productId: widget.productId,
          onProductTap: () {},
          onFavoriteTap: () {},
        ),
      ),
    );
  }
}

class _ProductDisplayState extends State<ProductDisplay> {
  Future<void> _fetchMoreProducts() async {
    final provider = Provider.of<ResultListProvider>(context, listen: false);

    if (provider.loading || provider.results.length >= provider.totaldocs) {
      return;
    }

    try {
      print('get more products');
      provider.setLoading(true);
      final int currentOffset = provider.results.length;
      final int pageSize = 10;

      ServerResponse response = await ProductRoute.getMoreProducts(
          currentOffset, pageSize, provider.aiquery);

      if (response.success) {
        final data = response.data;

        //print(data);

        final List<dynamic> newResults = [
          ...provider.results,
          ...data['results']
        ];

        provider.updateResults(
          total: newResults.length,
          totaldocs: data['totaldocs'] ?? provider.totaldocs,
          results: newResults,
          suggested_prompts: provider.suggested_prompts,
        );
      }
    } catch (e) {
      print('Error fetching more products: $e');
      // Handle exception
    } finally {
      // Always set loading to false when done, whether successful or not
      provider.setLoading(false);
    }
  }

  @override
  void didUpdateWidget(ProductDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultListProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.results.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final Map<String, dynamic> productData =
                    provider.results[index];
                final productName = productData['name'] ?? '';
                final productTags = productData['metadata'] ?? '';
                final productId = productData['_id'] ?? '';

                return VisibilityDetector(
                  key: Key(productId),
                  onVisibilityChanged: (visibilityInfo) {
                    var visiblePercentage =
                        visibilityInfo.visibleFraction * 100;
                    print('Widget visibility: ${visiblePercentage.round()}%');

                    if (visiblePercentage > 50 &&
                        index == provider.results.length - 1) {
                      _fetchMoreProducts();
                    }
                  },
                  child: _AnimatedProductCard(
                    productName: productName,
                    productTags: productTags,
                    productId: productId,
                    index: index,
                  ),
                );
              },
            ),
            if (provider.loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
