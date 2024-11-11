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
    return MouseRegion(
      cursor: isCreateListBtnActive
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isCreateListBtnActive ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              'Create list',
              style: TextStyle(
                color: isCreateListBtnActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
