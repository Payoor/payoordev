import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_cartitem.dart';
import 'package:chatuiv2/src/classes/_orderroutes.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';

import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_banipayprov.dart';

class CartDisplayScreen extends StatefulWidget {
  final VoidCallback closeWidget;

  const CartDisplayScreen({
    Key? key,
    required this.closeWidget,
  }) : super(key: key);

  @override
  State<CartDisplayScreen> createState() => _CartDisplayScreenState();
}

class _CartDisplayScreenState extends State<CartDisplayScreen> {
  final List<bool> _visibleItems = [];
  bool isLoading = false;

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

  Future<bool> _createOrder() async {
    final authProvider = Provider.of<AuthProv>(context, listen: false);
    final String userAddress =
        authProvider.userData?['userAddress'] ?? 'Set delivery address';
    final cartData =
        Provider.of<CartProvider>(context, listen: false).createCartPayload();

    try {
      final response = await OrdersRoute.createOrder(cartData, userAddress);

      if (!mounted) return false;

      if (response.success) {
        if (response.data['chatresponse'] != null) {
          final chatResponse = response.data['chatresponse'];
          final orderId = chatResponse['orderId']?.toString();
          if (orderId != null) {
            context.read<BaniPayProvider>().setCurrentOrder(orderId);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: AppColors.primaryColorDark,
            child: Stack(
              children: [
                // Header
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
                      onBackTap: () {
                        widget.closeWidget();
                      },
                    ),
                  ),
                ),
                // Content
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
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

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...items.asMap().entries.map((entry) {
                                    final int index = entry.key;
                                    final CartItem item = entry.value;

                                    return AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      opacity: _visibleItems.length > index &&
                                              _visibleItems[index]
                                          ? 1.0
                                          : 0.0,
                                      curve: Curves.easeIn,
                                      child: Container(
                                        width: double.infinity,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey[300]!,
                                              width: .4,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 20),
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
                                                child: const Padding(
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
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              ...item.units.entries.map((unit) {
                                                return Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
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
                                                            flex: 2,
                                                            child: Text(
                                                              'Total ₦${unit.value.price.toStringAsFixed(2)}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
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
                                                      const SizedBox(
                                                          height: 15),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              cartProvider
                                                                  .deleteUnit(
                                                                id: item.id,
                                                                unit: unit
                                                                    .value.unit,
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                              size: 24,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 15,
                                                              vertical: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
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
                                                                  onTap: () {
                                                                    cartProvider
                                                                        .decreaseItem(
                                                                      id: item
                                                                          .id,
                                                                      unit: unit
                                                                          .value
                                                                          .unit,
                                                                    );
                                                                  },
                                                                  child:
                                                                      const SizedBox(
                                                                    width: 30,
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 30,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      left: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              1),
                                                                      right: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      '${unit.value.quantity}',
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    cartProvider
                                                                        .increaseItem(
                                                                      id: item
                                                                          .id,
                                                                      unit: unit
                                                                          .value
                                                                          .unit,
                                                                    );
                                                                  },
                                                                  child:
                                                                      const SizedBox(
                                                                    width: 30,
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                    ],
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
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorDark,
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
                          onPressed: () async {
                            setState(() {
                              isLoading =
                                  true; // Add this boolean to your state
                            });

                            try {
                              await _createOrder();
                              if (mounted) {
                                Navigator.pushNamed(context, '/confirmorder');
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to create order: ${e.toString()}')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 25,
                                horizontal: 20), // Added horizontal padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Make Payment',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '₦${cart.totalAmount}', // Fixed string interpolation
                                      style: const TextStyle(
                                        // Added const
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
