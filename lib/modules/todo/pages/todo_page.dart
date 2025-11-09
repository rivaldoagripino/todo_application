import 'package:flutter/material.dart';
import 'package:todo_application/core/theme/app_colors.dart';
import 'package:todo_application/core/theme/app_dimensions.dart';
import 'package:todo_application/modules/shared/components/custom_app_bar.dart';
import 'package:todo_application/modules/todo/widgets/custom_add_button.dart';
import 'package:todo_application/modules/todo/widgets/custom_filter_segmented_button.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'To do list'),
      body: Container(
        color: AppColors.lightGray,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const CustomFilterSegmentedButton(selected: 'All'),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.kMarginDefault,
                vertical: AppDimensions.kMarginDefault,
              ),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.red,
                    height: 8,
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.only(right: AppDimensions.kMarginDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomAddButton(
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
