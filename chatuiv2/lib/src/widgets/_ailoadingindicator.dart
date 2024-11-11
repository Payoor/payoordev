import 'package:flutter/material.dart';

import 'package:chatuiv2/src/widgets/_animatedcartloader.dart';

class AiLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: AnimatedCartLoader(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
