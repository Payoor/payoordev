import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatuiv2/src/providers/_authprov.dart';

class UserDetailsList extends StatelessWidget {
  final Function() triggerFunction;

  const UserDetailsList({
    super.key,
    required this.triggerFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProv>(
      builder: (context, authProv, child) {
        final userAddress = authProv.userData!.entries
            .firstWhere((entry) => entry.key == 'userAddress')
            .value;

        return GestureDetector(
          onTap: triggerFunction,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            child: Text(
              userAddress.toString(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
