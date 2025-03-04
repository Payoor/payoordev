import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:chatuiv2/src/providers/_resultlistprov.dart';

class ProductsRender extends StatefulWidget {
  final ScrollController scrollController;

  const ProductsRender({
     required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsRender> createState() => _ProductsRenderState();
}

class _ProductsRenderState extends State<ProductsRender> {
  static const _pageSize = 10;

  //final


  @override
  Widget build(BuildContext context) {
    return Consumer<ResultListProvider>(builder: (context, provider, child) {
      return Container(
        color: Colors.red,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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

                return Container(child: Text('product Item'));
              }),
          Container(
            child: Text('we load new items here'),
          )
        ],
      ));
    });
  }
}
