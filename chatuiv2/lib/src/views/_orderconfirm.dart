import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';
import 'package:chatuiv2/src/classes/_orderroutes.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_addresseslist.dart';
import 'package:chatuiv2/src/widgets/_banipay.dart';
import 'package:chatuiv2/src/widgets/_swipeupwidget.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';
import 'package:chatuiv2/src/providers/_cartprov.dart';
import 'package:chatuiv2/src/providers/_googleplaces.dart';
import 'package:chatuiv2/src/providers/_banipayprov.dart';

class OrderConfirm extends StatefulWidget {
  final String? orderId;

  const OrderConfirm({this.orderId, super.key});

  @override
  State<OrderConfirm> createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<SwipeUpWidgetState> _swipeKey =
      GlobalKey<SwipeUpWidgetState>();

  String selectedTime = '';
  String selectedAddress = "";
  bool _isSettingDeliveryDate = false;

  final List<String> deliveryTimes = () {
    final List<String> dates = [];
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 2));
    final DateFormat formatter = DateFormat('EEEE d MMM');

    for (int i = 0; i < 7; i++) {
      final DateTime date = tomorrow.add(Duration(days: i));
      dates.add(formatter.format(date));
    }

    return dates;
  }();

  bool _confirmingAddress = false;
  bool _openBaniPay = false;

  setOrderDeliveryDate(String selectedDate) async {
    try {
      final orderId = context.read<BaniPayProvider>().currentOrder;
      if (orderId == null) {
        throw Exception('No order ID available');
      }

      final DateFormat inputFormatter = DateFormat('EEEE d MMM');
      final DateTime parsedDate = inputFormatter.parse(selectedDate);

      final DateTime dateWithYear =
          DateTime(DateTime.now().year, parsedDate.month, parsedDate.day);

      final String formattedDate = dateWithYear.toIso8601String();

      final response =
          await OrdersRoute.updateDeliveryDate(orderId, formattedDate);

      if (response?.data != null) {
        //print(response.data);
      } else {
        throw Exception('Failed to update delivery date.');
      }
    } catch (e) {
      print('Error setting delivery date: $e');
      rethrow;
    }
  }

  void openAddressList() {
    setState(() {
      _confirmingAddress = true;
    });
  }

  void closeAddressList() {
    setState(() {
      _confirmingAddress = false;
    });
  }

  void selectAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProv>(context, listen: false);
    final String userAddress =
        authProvider.userData?['userAddress'] ?? 'Set delivery address';

    selectAddress(userAddress);
    context.read<BaniPayProvider>().setCurrentOrder(widget.orderId);
    

    _controller.addListener(() {
      context.read<GooglePlaces>().searchPlaces(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration get _inputDecoration => InputDecoration(
        counterText: "",
        filled: true,
        fillColor: AppColors.inputBlack,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 23,
        ),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(width: .5, opacity: 1.0),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.5),
            width: .5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: .5,
          ),
        ),
        hintText: "Enter an address",
        hintStyle: TextStyle(
          color: AppColors.white,
        ),
      );

  OutlineInputBorder _buildBorder({double width = .5, double opacity = 0.3}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: AppColors.inputBlack,
        width: width,
      ),
    );
  }

  void handleBaniPayOpen(String? orderId) {
    setState(() {
      _openBaniPay = true;
    });
  }

  Widget buildBaniPaySwipeUp() {
    return Consumer<BaniPayProvider>(
      builder: (context, baniPayProvider, child) {
        if (baniPayProvider.currentOrder != null && _openBaniPay) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SwipeUpWidget(
              key: _swipeKey,
              minHeight: 15,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              child: BaniPay(orderId: baniPayProvider.currentOrder),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return Consumer<AuthProv>(builder: (context, authProv, child) {
        return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: AppColors.primaryBackgroundWhite,
            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.primaryBackgroundWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeaderRow(
                    headerName: "Order Confirmation",
                    onBurgerMenuTap: () => {},
                    showBackButton: true,
                    onBackTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Consumer<CartProvider>(builder: (context, cart, child) {
                final num deliveryFee = 3500;

                return Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        const Text('Your Order Summary',
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 20,
                                            )),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            openAddressList();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 16),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 10,
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            10), // spacing between icon and text
                                                    Expanded(
                                                      child: Text(
                                                        selectedAddress,
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontSize: 14,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Delivery Address',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 10,
                                                        )),
                                                    SizedBox()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 16),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.grey[300]!,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text('Pick a Delivery Date',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors.black,
                                                    )),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Column(
                                                  children: deliveryTimes
                                                      .map(
                                                          (time) =>
                                                              GestureDetector(
                                                                onTap: _isSettingDeliveryDate
                                                                    ? null
                                                                    : () async {
                                                                        setState(
                                                                            () {
                                                                          _isSettingDeliveryDate =
                                                                              true;
                                                                        });
                                                                        try {
                                                                          await setOrderDeliveryDate(
                                                                              time);
                                                                          setState(
                                                                              () {
                                                                            selectedTime =
                                                                                time;
                                                                          });
                                                                        } finally {
                                                                          setState(
                                                                              () {
                                                                            _isSettingDeliveryDate =
                                                                                false;
                                                                          });
                                                                        }
                                                                      },
                                                                child: Opacity(
                                                                  opacity:
                                                                      _isSettingDeliveryDate
                                                                          ? 0.5
                                                                          : 1.0,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            16),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              18,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                Border.all(
                                                                              color: AppColors.primaryColor,
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Container(
                                                                              height: 10,
                                                                              width: 10,
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: selectedTime == time ? AppColors.primaryColor : Colors.transparent,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                            time,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: AppColors.black,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ))
                                                      .toList(),
                                                )
                                              ],
                                            )),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 16, 0, 16),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Sub-total',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .primaryColor,
                                                      )),
                                                  Text(
                                                    '₦${cart.totalAmount}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Delivery Fee',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .primaryColor,
                                                      )),
                                                  Text(
                                                    '₦$deliveryFee',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Service Charge',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .primaryColor,
                                                      )),
                                                  Text(
                                                    '₦${cart.totalAmount * 0.05}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Total',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .primaryColor,
                                                      )),
                                                  Text(
                                                    '₦${(cart.totalAmount * 0.05) + deliveryFee + cart.totalAmount}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 150,
                                        )
                                      ],
                                    ),
                                  ],
                                ))))
                  ]),
                );
              }),
              if (_confirmingAddress)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.primaryBackgroundWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height *
                          0.8, // Increased max height
                      minHeight: 100,
                    ),
                    child: SingleChildScrollView(
                      // Added ScrollView
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Added to prevent unnecessary expansion
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // Added to handle text overflow
                                child: Text(
                                  'Delivery Address',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Added overflow handling
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  closeAddressList();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 17,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 40),
                          TextField(
                            maxLines: null, // Changed to null to auto-adjust
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: _controller,
                            decoration: _inputDecoration,
                            style: const TextStyle(
                                color: Colors
                                    .white), // Changed from Colors.black to Colors.white
                            cursorColor: Colors.white,

                            onChanged: (value) {
                              print(value);
                            },
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            enabled: true,
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            // Added to handle large content
                            child: AddressesList(
                              onLocationSelected: (updatedAddress) {
                                selectAddress(updatedAddress);
                                closeAddressList();
                              },
                              onAddressSelected: (addressData) {
                                String value = addressData['address']!;
                                selectAddress(value);
                                closeAddressList();
                                context.read<GooglePlaces>().clearPredictions();
                              },
                            ),
                          )
                        ],
                      ),
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
                        onPressed:
                            selectedAddress.isEmpty || selectedTime.isEmpty
                                ? null
                                : () {
                                    handleBaniPayOpen(widget.orderId);
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
                                      vertical: 25, horizontal: 20)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: Text('Confirm Order',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                      );
                    },
                  ),
                ),
              ),
              buildBaniPaySwipeUp(),
            ]));
      });
    }));
  }
}
