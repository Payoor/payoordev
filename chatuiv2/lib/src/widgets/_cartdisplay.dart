import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_cartitem.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';

class CartDisplay extends StatefulWidget {
  const CartDisplay({
    Key? key,
  }) : super(key: key);

  @override
  State<CartDisplay> createState() => _CartDisplayState();
}

class _CartDisplayState extends State<CartDisplay> {
  final List<bool> _visibleItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateItems();
    });
  }

  void _animateItems() {
    final items = context.read<CartProvider>().items;
    _visibleItems.clear();
    _visibleItems.addAll(List.generate(items.length, (_) => false));

    for (var i = 0; i < items.length; i++) {
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
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      final Map<String, CartItem> cartData = cartProvider.items;

      final List<CartItem> items = cartData.values.toList();

      if (_visibleItems.length != items.length) {
        _animateItems();
      }

      double totalAmount = 0;
      for (var item in cartProvider.items.values) {
        for (var unit in item.units.values) {
          totalAmount += unit.price * unit.quantity;
        }
      }

      return Container(
        width: double.infinity,
        color: AppColors.primaryColorDark,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // This is key - makes Column wrap its content
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min, // This too
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...items.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final CartItem item = entry.value;

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _visibleItems.length > index &&
                                    _visibleItems[index]
                                ? 1.0
                                : 0.0,
                            curve: Curves.easeIn,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: .4,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[300]!,
                                            width: .4,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          'Units',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ...item.units.entries.map((unit) {
                                      return Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      '${unit.value.unit}: ${unit.value.quantity}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Total ₦${unit.value.price.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartProvider.deleteUnit(
                                                        id: item.id,
                                                        unit: unit.value.unit,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: .5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartProvider
                                                                .decreaseItem(
                                                              id: item.id,
                                                              unit: unit
                                                                  .value.unit,
                                                            );
                                                          },
                                                          child: SizedBox(
                                                            width: 30,
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border(
                                                              left: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1),
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${unit.value.quantity}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartProvider
                                                                .increaseItem(
                                                              id: item.id,
                                                              unit: unit
                                                                  .value.unit,
                                                            );
                                                          },
                                                          child: SizedBox(
                                                            width: 30,
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
