import 'package:flutter/material.dart';

import 'package:chatuiv2/main.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class HeaderRow extends StatelessWidget {
  final VoidCallback? onBurgerMenuTap;
  final String headerName;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const HeaderRow({
    Key? key,
    this.onBurgerMenuTap,
    this.headerName = "Payoor",
    this.showBackButton = false,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBackButton)
                    GestureDetector(
                      onTap: onBackTap ?? () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  Text(
                    headerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  sideNavVisible.value = true;
                },
                child: Icon(
                  Icons.menu,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
