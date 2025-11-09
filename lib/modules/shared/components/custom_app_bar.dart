import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';
import 'package:todo_application/core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.nunitoBold18.copyWith(
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkBlue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
