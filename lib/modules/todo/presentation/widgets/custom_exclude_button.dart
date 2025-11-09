import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';

class CustomExcludeButton extends StatelessWidget {
  const CustomExcludeButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.red,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            size: 22,
            Icons.delete,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
