import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/widgets/_productcard.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

import 'package:chatuiv2/src/classes/_productroutes.dart';
import 'package:chatuiv2/src/classes/_serverresponse.dart';

class ProductDisplay extends StatefulWidget {
  final bool showProducts; // Add this line

  const ProductDisplay({
    Key? key,
    required this.showProducts, // Add this line
  }) : super(key: key);

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
      final suggested_pills =
          context.read<ResultListProvider>().suggested_prompts;

      setState(() {
        _results = List.from(results);
        _isInitialized = true;
      });
      _animateItems();
    }
  }

  String _lastProcessedSuggestion = '';

  @override
  void didUpdateWidget(ProductDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    final suggestion = context.read<ResultListProvider>().current_suggestion;
    if (suggestion.isNotEmpty &&
        widget.showProducts &&
        suggestion != _lastProcessedSuggestion) {
      _lastProcessedSuggestion = suggestion;
      _getSuggestion(suggestion);
    }
  }

  Future<void> _getSuggestion(suggestion) async {
    try {
      ServerResponse response = await ProductRoute.getSuggestion(suggestion);

      if (response.data['results'] != null) {
        final results = response.data['results'];

        setState(() {
          _results = List.from(results);
        });
      }
    } catch (e) {
      print('Error fetching product: $e');
      // Handle error appropriately
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
    return Consumer<ResultListProvider>(builder: (context, provider, child) {
     /* String suggestion = provider.current_suggestion;
      if (suggestion.isNotEmpty) {
        if (widget.showProducts) {
          _getSuggestion(suggestion);
        }
      }*/

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

          final productName = _results[index];

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visibleItems.length > index && _visibleItems[index]
                ? 1.0
                : 0.0,
            curve: Curves.easeIn,
            child: ProductCard(
              productName: productName,
              onProductTap: () {
                /*context.read<ResultListProvider>().setCurrentProduct(
                      productId: productId, productName: productName);*/
              },
              onFavoriteTap: () {},
            ),
          );
        },
      );
    });
  }
}
