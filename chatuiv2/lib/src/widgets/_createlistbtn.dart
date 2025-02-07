import 'package:flutter/material.dart';

class CreateListBtn extends StatelessWidget {
  final bool isCreateListBtnActive;
  final VoidCallback onTap;

  const CreateListBtn({
    super.key,
    required this.isCreateListBtnActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;

    return MouseRegion(
      cursor: isCreateListBtnActive
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isCreateListBtnActive ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : 24,
            vertical: isDesktop ? 16 : 12,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: isCreateListBtnActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                width: .8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Get started',
              style: TextStyle(
                color: isCreateListBtnActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: isDesktop ? 20 : 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
