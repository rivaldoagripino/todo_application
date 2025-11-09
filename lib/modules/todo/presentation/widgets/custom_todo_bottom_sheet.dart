import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';
import 'package:todo_application/core/theme/app_dimensions.dart';
import 'package:todo_application/core/theme/app_text_styles.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';

class CustomTodoBottomSheet extends StatefulWidget {
  const CustomTodoBottomSheet({
    super.key,
    this.todoItem,
    this.onAdd,
    this.onEdit,
  });

  final TodoItemModel? todoItem;
  final Function(String, TodoItemStatus)? onAdd;
  final Function(TodoItemModel)? onEdit;

  @override
  State<CustomTodoBottomSheet> createState() => _CustomTodoBottomSheetState();
}

class _CustomTodoBottomSheetState extends State<CustomTodoBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  bool _isButtonEnabled = false;
  TodoItemStatus _selectedStatus = TodoItemStatus.pending;

  @override
  void initState() {
    super.initState();
    if (widget.todoItem != null) {
      _titleController.text = widget.todoItem!.title;
      _selectedStatus = widget.todoItem!.status;
      _isButtonEnabled = true;
    }
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
              widget.todoItem != null ? 'Edit Task' : 'Add Task',
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
            const SizedBox(height: AppDimensions.kMarginMedium),
            Text(
              'Status',
              style: AppTextStyles.nunitoBold16,
            ),
            const SizedBox(height: AppDimensions.kMarginSmall),
            Wrap(
              spacing: 8,
              children: TodoItemStatus.values.map((status) {
                final isSelected = _selectedStatus == status;
                return ChoiceChip(
                  label: Text(_getStatusLabel(status)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  backgroundColor: AppColors.lightGray,
                  selectedColor: AppColors.darkBlue,
                  labelStyle: AppTextStyles.nunitoRegular12.copyWith(
                    color: isSelected ? AppColors.white : Colors.grey[700],
                  ),
                  checkmarkColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  pressElevation: 0,
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        if (widget.todoItem != null) {
                          final updatedItem = widget.todoItem!.copyWith(
                            title: _titleController.text.trim(),
                            status: _selectedStatus,
                          );
                          widget.onEdit?.call(updatedItem);
                        } else {
                          widget.onAdd?.call(
                              _titleController.text.trim(), _selectedStatus);
                        }
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
                  widget.todoItem != null ? 'Save' : 'Add Task',
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

  String _getStatusLabel(TodoItemStatus status) {
    switch (status) {
      case TodoItemStatus.pending:
        return 'Pending';
      case TodoItemStatus.inProgress:
        return 'In Progress';
      case TodoItemStatus.done:
        return 'Done';
    }
  }
}
