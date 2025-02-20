import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/classes/_orderroutes.dart';
import 'package:chatuiv2/src/classes/_appcolors.dart';

import 'package:chatuiv2/src/providers/_banipayprov.dart';

import 'package:chatuiv2/src/widgets/_headerrow.dart';
import 'package:chatuiv2/src/widgets/_orderitem.dart';
import 'package:chatuiv2/src/views/_banipay.dart';
import 'package:chatuiv2/src/widgets/_swipeupwidget.dart';

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
  String _selectedStatus = "pending";
  List<dynamic> _orders = [];
  final GlobalKey<SwipeUpWidgetState> _swipeKeyOrderItem =
      GlobalKey<SwipeUpWidgetState>();

  @override
  void initState() {
    super.initState();
    _getUserOrders();
  }

  void _getUserOrders() async {
    try {
      final response = await OrdersRoute.getUserOrders(_selectedStatus);
      if (response?.data != null) {
        setState(() {
          _page = response.data['page'];
          _totalPages = response.data['totalPages'];
          _totalCount = response.data['totalCount'];
          _itemsPerPage = response.data['itemsPerPage'];
          _orders = response.data['orders'];
          _isLoading = false;
        });

        //print(_orders);
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
      backgroundColor: AppColors.primaryBackgroundWhite,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: AppColors.primaryBackgroundWhite,
          child: Stack(
            children: [
              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.primaryBackgroundWhite,
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

              // Order Status Menu
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatusTab(
                            "Pending", _selectedStatus == "pending"),
                        const SizedBox(width: 10),
                        _buildStatusTab(
                            "Processing", _selectedStatus == "processing"),
                        const SizedBox(width: 10),
                        _buildStatusTab(
                            "Completed", _selectedStatus == "completed"),
                      ],
                    ),
                  ),
                ),
              ),

              // Orders List
              Positioned(
                top: 120, // Increased to accommodate the menu
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
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
                                  color: AppColors.black,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No orders made yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else
                          ..._getFilteredOrders()
                              .map((order) => OrderItem(order))
                              .toList(),
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

// Add this helper method for the status tabs
  Widget _buildStatusTab(String status, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status.toLowerCase();
          _getUserOrders();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.greyBlack,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.greyBlack,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

// Add this helper method to filter orders based on status
  List _getFilteredOrders() {
    return _orders
        .where((order) =>
            order['status'].toLowerCase() == _selectedStatus.toLowerCase())
        .toList();
  }
}
