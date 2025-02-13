import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_productroutes.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/views/_cartdisplay.dart';

import 'package:chatuiv2/src/providers/_cartprov.dart';

class ProductOptions extends StatefulWidget {
  final VoidCallback closeWidget;
  final String productName;
  final String productId;

  const ProductOptions({
    Key? key,
    required this.closeWidget,
    required this.productName,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductOptions> createState() => _ProductOptionsState();
}

class _ProductOptionsState extends State<ProductOptions> {
  late List<dynamic> productData = [];

  @override
  void initState() {
    super.initState();
    _loadVariants();
  }

  Future<void> _loadVariants() async {
    try {
      print("Loading variants for product ID: ${widget.productId}");
      List<dynamic> variants = await _getProductVariants();
      print("Loaded variants: $variants");
      setState(() {
        productData = variants;
      });
    } catch (e) {
      print("Error loading variants: $e");
    }
  }

  Future<List<dynamic>> _getProductVariants() async {
    final response = await ProductRoute.getProductVariants(widget.productId);
    //print("API Response: ${response.data}");
    return response.data["product_variants"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundWhite,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: AppColors.primaryBackgroundWhite,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.primaryBackgroundWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: HeaderRow(
                      headerName: widget.productName,
                      onBurgerMenuTap: () => {},
                      showBackButton: true,
                      onBackTap: () {
                        widget.closeWidget();
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: productData.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: productData.length,
                            itemBuilder: (context, index) {
                              final item = productData[index];
                              final itemPrice = (item["price"] != null &&
                                      item["price"] is num)
                                  ? item["price"]
                                  : 1;

                              return Consumer<CartProvider>(
                                builder: (context, cart, child) {
                                  final int quantity = cart.quantityAmount(
                                    unit: item['unit'],
                                    id: widget.productId,
                                  );

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      color: quantity > 0
                                          ? AppColors.primaryColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        width: 1.0,
                                        color: AppColors.primaryColor
                                            .withOpacity(0.6),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["unit"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: quantity > 0
                                                      ? Colors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 14),
                                              Text(
                                                '₦$itemPrice',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: quantity > 0
                                                      ? Colors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => cart.decreaseItem(
                                                id: widget.productId,
                                                unit: item["unit"],
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey[400]!),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.transparent,
                                                ),
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: quantity > 0
                                                        ? Colors.white
                                                        : AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 6,
                                              ),
                                              child: Text(
                                                "$quantity",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800,
                                                  color: quantity > 0
                                                      ? Colors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => cart.addItem(
                                                id: widget.productId,
                                                name: widget.productName,
                                                unit: item['unit'],
                                                price: itemPrice,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey[400]!),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.green[100],
                                                ),
                                                child: Text(
                                                  "+",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              ;
                            },
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackgroundWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return ElevatedButton(
                          onPressed: cart.totalAmount == 0
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartDisplayScreen(
                                        closeWidget: () =>
                                            Navigator.pop(context),
                                      ),
                                    ),
                                  );
                                },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppColors.primaryColor.withAlpha(128);
                                }
                                return AppColors.primaryColor;
                              },
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '₦${cart.totalAmount}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
