import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_resultlistprov.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_productroutes.dart';
import 'package:chatuiv2/src/classes/_serverresponse.dart';

class ProductCard extends StatefulWidget {
  final String productName;
  //final String productId;
  final void Function()? onProductTap;
  final void Function()? onFavoriteTap;
  static final Map<String, String> _imageCache = {};

  const ProductCard(
      {super.key,
      required this.productName,
      //required this.productId,
      this.onProductTap,
      this.onFavoriteTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late Future<String> _imageUrlFuture;
  bool _isbookmarked = false;
  bool _togglingBookMarks = false;
  late String productId;

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
      _checkIfProductInBookMarks(productId);
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

        setState(() {
          productId = product_id;
        });

        _checkIfProductInBookMarks(productId);
        _imageUrlFuture = _getImageUrl();
      }
    } catch (e) {
      print('Error fetching product: $e');
      // Handle error appropriately
    }
  }

  void _checkIfProductInBookMarks(productId) async {
    final userId = context.read<AuthProv>().userData!["_id"];
    final response =
        await ProductRoute.checkIfProductInBookMarks(productId, userId);

    //print(response.data['product_bookmarked']);

    setState(() {
      _isbookmarked = response.data['product_bookmarked'];
      _togglingBookMarks = false;
    });
  }

  void _addProductToBookMarks(productId) async {
    final userId = context.read<AuthProv>().userData!["_id"];

    setState(() {
      _togglingBookMarks = true;
    });

    final response =
        await ProductRoute.addProductToBookMarks(productId, userId);

    //print(response.data);
    _checkIfProductInBookMarks(productId);
  }

  Future<String> _getImageUrl() async {
    // Check cache first
    if (ProductCard._imageCache.containsKey(productId)) {
      return ProductCard._imageCache[productId]!;
    }

    // Fetch if not in cache
    final response = await ProductRoute.getProductImage(productId);
    final imageUrl = response.data['images'][0]["imageUrl"];

    // Store in cache
    ProductCard._imageCache[productId] = imageUrl;

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    child: FutureBuilder<String>(
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
                          loadingBuilder: (context, child, loadingProgress) {
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
                  ),
                ),
                // Rest of your Stack children remain the same
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {
                      _addProductToBookMarks(productId);
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
                                    : AppColors.white,
                              )),
                  ),
                ),
                Positioned(
                  bottom: 0,
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
                            color: Colors.white,
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
          ),
          GestureDetector(
            onTap: () {
              context.read<ResultListProvider>().setCurrentProduct(
                  productId: productId, productName: widget.productName);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View Options",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
