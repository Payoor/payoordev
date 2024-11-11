import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class HeaderRow extends StatelessWidget {
  final VoidCallback? onBurgerMenuTap;

  const HeaderRow({
    Key? key,
    this.onBurgerMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Payoor",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
          ),
          GestureDetector(
            onTap: onBurgerMenuTap,
            child: Icon(
              Icons.menu,
              color: AppColors.primaryColor,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
