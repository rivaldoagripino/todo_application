import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';
import 'package:todo_application/core/theme/app_dimensions.dart';

class CustomFilterSegmentedButton extends StatefulWidget {
  const CustomFilterSegmentedButton({
    super.key,
    required this.selected,
  });

  final String selected;

  @override
  State<CustomFilterSegmentedButton> createState() =>
      _CustomFilterSegmentedButtonState();
}

class _CustomFilterSegmentedButtonState
    extends State<CustomFilterSegmentedButton> {
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.kMarginDefault),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.kMarginDefault),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'All', label: Text('All')),
            ButtonSegment(value: 'Pending', label: Text('Pending')),
            ButtonSegment(value: 'Done', label: Text('Done')),
          ],
          selected: {selected},
          onSelectionChanged: (newSelection) {
            setState(() => selected = newSelection.first);
          },
          showSelectedIcon: false,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 25, 113, 190);
              }
              return Colors.grey[300];
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.white;
              }
              return Colors.grey[500];
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            side: WidgetStateProperty.all(BorderSide.none),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            minimumSize: WidgetStateProperty.all(
              const Size.fromHeight(44),
            ),
          ),
        ),
      ),
    );
  }
}
