import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/core/app/page_state.dart';
import 'package:todo_application/core/theme/app_colors.dart';
import 'package:todo_application/core/theme/app_dimensions.dart';
import 'package:todo_application/core/theme/app_text_styles.dart';
import 'package:todo_application/modules/shared/components/custom_app_bar.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_cubit.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_state.dart';
import 'package:todo_application/modules/todo/presentation/widgets/add_todo_bottom_sheet.dart';
import 'package:todo_application/modules/todo/presentation/widgets/custom_add_button.dart';
import 'package:todo_application/modules/todo/presentation/widgets/custom_exclude_button.dart';
import 'package:todo_application/modules/todo/presentation/widgets/custom_filter_segmented_button.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ModularCubitState<TodoPage, TodoCubit> {
  @override
  void initState() {
    super.initState();
    cubit.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'To do list'),
      body: BlocBuilder<TodoCubit, TodoState>(
        bloc: cubit,
        builder: (context, state) {
          if (state.status == PageStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            color: AppColors.lightGray,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                CustomFilterSegmentedButton(
                  selected: state.selectedFilter,
                  onSelectionChanged: (value) {
                    cubit.onFilterChanged(value);
                  },
                ),
                Visibility(
                  visible: state.filteredTodoList.isEmpty,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: AppDimensions.kMarginMedium),
                    child: Text(
                      'No tasks found',
                      style: AppTextStyles.nunitoRegular16,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.kMarginDefault,
                    vertical: AppDimensions.kMarginDefault,
                  ),
                  child: ListView.builder(
                    itemCount: state.filteredTodoList.length,
                    itemBuilder: (context, index) {
                      final todo = state.filteredTodoList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.kMarginDefault),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.kMarginDefault,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: state.selectedItems.contains(todo),
                                onChanged: (value) => cubit.onSelectItem(todo),
                              ),
                              Text(
                                cubit.limitTitle(todo.title),
                                style: AppTextStyles.nunitoRegular16,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                      right: AppDimensions.kMarginDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: state.selectedItems.isNotEmpty,
                        child: CustomExcludeButton(
                          onPressed: () => cubit.excludeTodo(),
                        ),
                      ),
                      Visibility(
                        visible: state.selectedItems.isEmpty,
                        child: CustomAddButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return AddTodoBottomSheet(
                                onAdd: (title) {
                                  cubit.addTodo(title);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
