import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_productcard.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

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
  final int index;

  const _AnimatedProductCard({
    Key? key,
    required this.productName,
    required this.productTags,
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
          onProductTap: () {},
          onFavoriteTap: () {},
        ),
      ),
    );
  }
}

class _ProductDisplayState extends State<ProductDisplay> {
  @override
  void didUpdateWidget(ProductDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultListProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
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
            final Map<String, String> productData = provider.results[index];
            final productName = productData['name'] ?? '';
            final productTags = productData['tags'] ?? '';

            return _AnimatedProductCard(
              productName: productName,
              productTags: productTags,
              index: index,
            );
          },
        );
      },
    );
  }
}