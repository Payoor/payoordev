import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_productroutes.dart';

import 'package:chatuiv2/src/providers/_cartprov.dart';

class ProductSizeSelector extends StatefulWidget {
  final VoidCallback closeWidget;
  final String productName;
  final String productId;

  const ProductSizeSelector(
      {super.key,
      required this.closeWidget,
      required this.productName,
      required this.productId});

  @override
  State<ProductSizeSelector> createState() => _ProductSizeSelectorState();
}

class _ProductSizeSelectorState extends State<ProductSizeSelector> {
  late List<dynamic> productData = [];

  @override
  @override
  void initState() {
    super.initState();
    _loadVariants();
  }

  Future<void> _loadVariants() async {
    List<dynamic> variants =
        await _getProductVariants(widget.productId);
    setState(() {
      productData = variants;
    });
  }

  Future<List<dynamic>> _getProductVariants(productId) async {
    final response = await ProductRoute.getProductVariants(widget.productId);
    //print(response.data["product_variants"].runtimeType);
    return response.data["product_variants"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        //height: MediaQuery.of(context).size.height * 0.65,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productName, // Your text here
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      letterSpacing: 0.5,
                      height: 1.2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                  ElevatedButton(
                    onPressed: widget.closeWidget,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      minimumSize: const Size(24, 24),
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 20,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: productData.length,
                itemBuilder: (context, index) {
                  final item = productData[index];

                  return Container(
                    padding:
                        const EdgeInsets.all(5), // Added padding inside card
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Even spacing
                      children: [
                        Text(
                          item["unit"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "₦${item["price"].toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .decreaseItem(
                                        id: widget.productId,
                                        unit: item["unit"]);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                ),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Consumer<CartProvider>(
                                builder: (context, cart, child) => Text(
                                  "${cart.quantityAmount(unit: item['unit'], id: widget.productId)}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addItem(
                                  id: widget.productId,
                                  name: widget.productName,
                                  unit: item['unit'],
                                  price: item['price'],
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.green[100],
                                ),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
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
              )
            ],
          ),
        ));
  }
}
