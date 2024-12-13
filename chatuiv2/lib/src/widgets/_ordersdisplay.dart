import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_orderroutes.dart';
import 'package:chatuiv2/src/classes/_appcolors.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_orderitem.dart';

class OrderDisplay extends StatefulWidget {
  final Function(BuildContext) onBackTap;

  const OrderDisplay({
    Key? key,
    required this.onBackTap,
  }) : super(key: key);

  @override
  State<OrderDisplay> createState() => _OrderDisplayState();
}

class _OrderDisplayState extends State<OrderDisplay> {
  int _page = 0;
  int _totalPages = 0;
  int _totalCount = 0;
  int _itemsPerPage = 0;
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
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
                  onBackTap: () => widget.onBackTap(context),
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
                      SizedBox(
                        height: 50,
                      ),
                      ..._orders.map((order) => OrderItem(order)).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
