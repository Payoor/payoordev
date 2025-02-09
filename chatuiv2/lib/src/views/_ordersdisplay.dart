import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_orderroutes.dart';
import 'package:chatuiv2/src/classes/_appcolors.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_orderitem.dart';

class OrderDisplay extends StatefulWidget {
  const OrderDisplay({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderDisplay> createState() => _OrderDisplayState();
}

class _OrderDisplayState extends State<OrderDisplay> {
  int _page = 0;
  int _totalPages = 0;
  int _totalCount = 0;
  int _itemsPerPage = 0;
  bool _isLoading = true;
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _getUserOrders();
  }

  void _getUserOrders() async {
    try {
      final response = await OrdersRoute.getUserOrders();
      if (response?.data != null) {
        setState(() {
          _page = response.data['page'];
          _totalPages = response.data['totalPages'];
          _totalCount = response.data['totalCount'];
          _itemsPerPage = response.data['itemsPerPage'];
          _orders = response.data['orders'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: AppColors.primaryColorDark,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.primaryColorDark,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeaderRow(
                    headerName: "Orders",
                    onBurgerMenuTap: () => {},
                    showBackButton: true,
                    onBackTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        if (_isLoading) ...[
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ] else if (_orders.isEmpty) ...[
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No orders made yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          ..._orders.map((order) => OrderItem(order)).toList(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
