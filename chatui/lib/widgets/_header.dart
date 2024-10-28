import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/providers/_sidenav_provider.dart';

class HeaderWidget extends StatelessWidget {
  final BoxConstraints constraints;

  const HeaderWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/payoorlogo.png',
            width: constraints.maxWidth * 0.2,
            height: constraints.maxHeight * 0.05,
            fit: BoxFit.contain,
          ),
          GestureDetector(
            onTap: () {
              context.read<SideNavProvider>().toggleSideNav();
            },
            child: Image.asset(
              'assets/burger.png',
              width: constraints.maxWidth * 0.1,
              height: constraints.maxHeight * 0.1,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
