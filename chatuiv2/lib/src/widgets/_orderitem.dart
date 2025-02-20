import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:chatuiv2/src/providers/_banipayprov.dart';

class OrderItem extends StatefulWidget {
  final dynamic order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  String _formatPrice(dynamic price) {
    if (price == null) return '0.00';

    // Convert to number format with thousands separator
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(price);
  }

  String _formatDate(String dateStr) {
    try {
      return dateStr.split('T')[0];
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade800; // Warm orange for waiting
      case 'processing':
        return Colors.blue.shade700; // Blue for in-progress
      case 'completed':
        return Colors.green.shade700; // Green for success
      case 'cancelled':
        return Colors.red.shade700; // Red for cancelled
      default:
        return Colors.grey.shade700; // Grey for unknown status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order #${widget.order['_id'].toString().substring(widget.order['_id'].toString().length - 6)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _getStatusColor(widget.order['status'])
                                            .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.order['status'] ?? 'N/A',
                                    style: TextStyle(
                                      color: _getStatusColor(
                                          widget.order['status']),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.order['createdAt'] ?? 'N/A',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                if (_isExpanded) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Items
                        const Text(
                          'Order Items',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...((widget.order['items'] as List?) ?? []).map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['product_name'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ...(item['product_units'] as Map?)?.entries.map(
                                          (unit) => Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Text(
                                              '${unit.key}: ${unit.value['quantity']}x \$${_formatPrice(unit.value['price'])}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ) ??
                                    [],
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        // Order Summary
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text(
                                '\$${_formatPrice(widget.order['cart_total'])}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee'),
                            Text(
                                '\$${_formatPrice(widget.order['delivery_fee'])}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Service Charge'),
                            Text(
                                '\$${_formatPrice(widget.order['service_charge'])}'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${_formatPrice(widget.order['total'])}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (widget.order['status']?.toLowerCase() ==
                            'pending') ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implement order completion logic
                                //print('Complete order: ${widget.order['_id']}');

                                Provider.of<BaniPayProvider>(context,
                                        listen: false)
                                    .setCurrentOrder(widget.order['_id']);

                                if (mounted && widget.order['_id'] != null) {
                                  Navigator.pushNamed(context, '/confirmorder',
                                      arguments: {
                                        'orderId': widget.order['_id']
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 19),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Complete Order',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (widget.order['delivery_date'] != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Delivery Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Delivery Date: ${_formatDate(widget.order['delivery_date'])}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
