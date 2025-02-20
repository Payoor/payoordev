import 'package:flutter/material.dart';

import 'package:chatuiv2/main.dart';

import 'package:chatuiv2/src/classes/_appcolors.dart';

class HeaderRow extends StatelessWidget {
  final VoidCallback? onBurgerMenuTap;
  final String headerName;
  final bool showBackButton;
  final bool showBurger;
  final VoidCallback? onBackTap;

  const HeaderRow({
    Key? key,
    this.onBurgerMenuTap,
    this.headerName = "Payoor",
    this.showBackButton = false,
    this.showBurger = true,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBackTap ?? () => Navigator.pop(context),
                child: Row(
                  children: [
                    if (showBackButton)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                          size: 24,
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
              ),
              if (showBurger)
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
              else
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/'),
                  child: Image.asset(
                    'assets/payoorcart.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    color: AppColors.primaryColor,
                    colorBlendMode: BlendMode.srcATop,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
