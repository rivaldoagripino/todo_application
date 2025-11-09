import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.white),
          shape: BoxShape.circle,
          color: AppColors.darkBlue,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            size: 22,
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
