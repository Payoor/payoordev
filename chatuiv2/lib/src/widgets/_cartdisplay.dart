import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_cartitem.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';

class CartDisplay extends StatefulWidget {
  const CartDisplay({
    Key? key,
    required this.onBackTap,
  }) : super(key: key);

  final Function(BuildContext) onBackTap;

  @override
  State<CartDisplay> createState() => _CartDisplayState();
}

class _CartDisplayState extends State<CartDisplay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      final Map<String, CartItem> cartData = cartProvider.items;

      double totalAmount = 0;
      for (var item in cartProvider.items.values) {
        for (var unit in item.units.values) {
          totalAmount += unit.price * unit.quantity;
        }
      }

      return LayoutBuilder(builder: (context, constraints) {
        return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: AppColors.primaryColorDark,
            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.primaryColorDark,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeaderRow(
                    headerName: "Cart",
                    onBurgerMenuTap: () => {},
                    showBackButton: true,
                    onBackTap: () => widget.onBackTap(context),
                  ),
                ),
              ),
              Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  bottom: 60,
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              ...cartData.values.map((item) {
                                return Container(
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
                                            // Changed from Row to Column
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                overflow: TextOverflow
                                                    .ellipsis, // Add this
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                width: constraints.maxWidth,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.grey[300]!,
                                                      width: .4,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 15),
                                                    child: Text(
                                                      'Units',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(height: 15),
                                              ...item.units.entries.map((unit) {
                                                return Container(
                                                  width: double.infinity,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                // Add this
                                                                flex: 3,
                                                                child: Text(
                                                                  '${unit.value.unit}: ${unit.value.quantity}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                // Add this
                                                                flex: 2,
                                                                child: Text(
                                                                  'Total ₦${unit.value.price.toStringAsFixed(2)}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  cartProvider.deleteUnit(
                                                                      id: item
                                                                          .id,
                                                                      unit: unit
                                                                          .value
                                                                          .unit);
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 24,
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: .5,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        cartProvider.decreaseItem(
                                                                            id: item
                                                                                .id,
                                                                            unit:
                                                                                unit.value.unit);
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            30,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          30, // Same fixed width
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                          left: BorderSide(
                                                                              color: Colors.white,
                                                                              width: 1),
                                                                          right: BorderSide(
                                                                              color: Colors.white,
                                                                              width: 1),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        // Center the text
                                                                        child:
                                                                            Text(
                                                                          '${unit.value.quantity}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        cartProvider.increaseItem(
                                                                            id: item
                                                                                .id,
                                                                            unit:
                                                                                unit.value.unit);
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            30,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              }),
                                            ])));
                              })
                            ],
                          )))),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: AppColors.primaryColorDark, // Add background color
                    padding: EdgeInsets.all(16), // Add padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '₦${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ))
            ]));
      });
    });
  }
}
