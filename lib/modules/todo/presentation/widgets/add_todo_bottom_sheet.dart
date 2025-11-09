import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';
import 'package:todo_application/core/theme/app_dimensions.dart';
import 'package:todo_application/core/theme/app_text_styles.dart';

class AddTodoBottomSheet extends StatefulWidget {
  const AddTodoBottomSheet({
    super.key,
    required this.onAdd,
  });

  final Function(String) onAdd;

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _titleController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateButtonState);
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.kMarginMedium),
          topRight: Radius.circular(AppDimensions.kMarginMedium),
        ),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.kMarginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.kMarginMedium),
            Text(
              'Add Task',
              style: AppTextStyles.nunitoBold20,
            ),
            const SizedBox(height: AppDimensions.kMarginMedium),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Task title',
                hintStyle: AppTextStyles.nunitoRegular16.copyWith(
                  color: Colors.grey[400],
                ),
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.kMarginDefault,
                  vertical: AppDimensions.kMarginDefault,
                ),
              ),
              style: AppTextStyles.nunitoRegular16,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        widget.onAdd(_titleController.text.trim());
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Add Task',
                  style: AppTextStyles.nunitoBold16.copyWith(
                    color:
                        _isButtonEnabled ? AppColors.white : Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
