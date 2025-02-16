import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';
import 'package:chatuiv2/src/providers/_messageprov.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_productroutes.dart';
import 'package:chatuiv2/src/classes/_serverresponse.dart';
import 'package:chatuiv2/src/classes/_message.dart';

import 'package:chatuiv2/src/views/_productoptions.dart';

class ProductCard extends StatefulWidget {
  final String productName;
  final String productTags;
  final void Function()? onProductTap;
  final void Function()? onFavoriteTap;
  static final Map<String, String> _imageCache = {};

  const ProductCard({
    super.key,
    required this.productName,
    required this.productTags,
    this.onProductTap,
    this.onFavoriteTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Future<String>? _imageUrlFuture;
  num variantCount = 0;
  bool _isbookmarked = false;
  bool _togglingBookMarks = false;
  String? productId;

  @override
  void initState() {
    super.initState();
    _getProductByName();
  }

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.productName != widget.productName) {
      _getProductByName();
    } else if (productId != null) {
      _checkIfProductInBookMarks(productId!);
    }
  }

  Future<void> _getTagResults(tag) async {
    try {
      context.read<MessageProvider>().addMessage(Message(
            text: '',
            isClient: false,
            isRead: false,
            isLoading: true,
          ));

      ServerResponse response = await ProductRoute.getSuggestion(tag);

      if (response.data['results'] != null) {
        final results = (response.data['results'] as List)
            .map((item) => Map<String, String>.from(item))
            .toList();

        List<String> suggestions =
            context.read<ResultListProvider>().suggested_prompts;
        context
            .read<ResultListProvider>()
            .updateSuggestedPrompts([tag, ...suggestions]);

        suggestions = context.read<ResultListProvider>().suggested_prompts;

        Message aiMessage;

        aiMessage = Message(
          text: 'Found some items in the $tag category',
          isProductsDisplay: true,
          tags: suggestions,
          isClient: false,
          isRead: false,
        );

        context.read<MessageProvider>().removeLastMessage();

        context.read<MessageProvider>().addMessage(aiMessage);

        context.read<ResultListProvider>().updateResults(
            total: results.length,
            results: results,
            suggested_prompts: suggestions);
      }
    } catch (e) {
      //print('Error fetching product: $e');
      // Handle error appropriately
    }
  }

  Future<void> _getProductByName() async {
    setState(() {
      _isbookmarked = false;
    });

    try {
      ServerResponse response =
          await ProductRoute.getProductByName(widget.productName);

      if (response.data['product_data'] != null) {
        Map<String, dynamic> product_data = response.data['product_data'];
        String product_id = product_data['_id'];
        int variant_count = response.data['product_data']['variantCount'] ?? 0;

        setState(() {
          productId = product_id;
          variantCount = variant_count;
        });

        _checkIfProductInBookMarks(product_id);
        setState(() {
          _imageUrlFuture = _getImageUrl();
        });
      }
    } catch (e) {
      //print('Error fetching product: $e');
    }
  }

  void _checkIfProductInBookMarks(String productId) async {
    final userId = context.read<AuthProv>().userData!["_id"];
    final response =
        await ProductRoute.checkIfProductInBookMarks(productId, userId);

    if (mounted) {
      setState(() {
        _isbookmarked = response.data['product_bookmarked'];
        _togglingBookMarks = false;
      });
    }
  }

  void _addProductToBookMarks(String productId) async {
    final userId = context.read<AuthProv>().userData!["_id"];

    setState(() {
      _togglingBookMarks = true;
    });

    final response =
        await ProductRoute.addProductToBookMarks(productId, userId);
    _checkIfProductInBookMarks(productId);
  }

  Future<String> _getImageUrl() async {
    if (productId == null) return '';

    if (ProductCard._imageCache.containsKey(productId)) {
      return ProductCard._imageCache[productId]!;
    }

    final response = await ProductRoute.getProductImage(productId!);
    final imageUrl = response.data['images'][0]["imageUrl"];
    ProductCard._imageCache[productId!] = imageUrl;
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.appSkyBlue.withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.transparent, // Makes the border faint
          width: 1.0, // Thin border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
            color: Colors.transparent,
            height: 200,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: double.infinity,
                      height: constraints.maxHeight * 0.8,
                      child: _imageUrlFuture == null
                          ? const Center(child: CircularProgressIndicator())
                          : FutureBuilder<String>(
                              future: _imageUrlFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError || !snapshot.hasData) {
                                  return const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  );
                                }

                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    );
                                  },
                                );
                              },
                            ),
                    );
                  }),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (productId != null) {
                        _addProductToBookMarks(productId!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _togglingBookMarks
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : Icon(
                              _isbookmarked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: _isbookmarked
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
          GestureDetector(
            onTap: () {
              if (productId != null) {
                context.read<ResultListProvider>().setCurrentProduct(
                      productId: productId!,
                      productName: widget.productName,
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductOptions(
                      closeWidget: () => Navigator.pop(context),
                      productName: widget.productName,
                      productId: productId!,
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(19),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View $variantCount ${variantCount > 1 ? 'Options' : 'Option'}",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 16, // Optional: adjust size
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          if (widget.productTags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.productTags.split(',').map((tag) {
                return GestureDetector(
                    onTap: () {
                      _getTagResults(tag.trim());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        tag.trim(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ));
              }).toList(),
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
