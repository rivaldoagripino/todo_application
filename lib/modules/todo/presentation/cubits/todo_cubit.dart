import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/core/app/page_state.dart';
import 'package:todo_application/core/config/cache/custom_shared_preferences.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  Future onInit() async {
    emit(state.copyWith(status: PageStatus.loading));
    _getTodoList();
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: PageStatus.success));
  }

  Future _getTodoList() async {
    CustomSharedPreferences.getTodoList().then((value) {
      emit(state.copyWith(todoList: value));
    });
  }

  void onFilterChanged(String value) {
    emit(state.copyWith(selectedFilter: value));
  }

  Future<void> addTodo(String title, TodoItemStatus status) async {
    final newTodo = TodoItemModel(
      title: title,
      status: status,
    ).copyWith();

    final updatedList = [...state.todoList, newTodo];
    emit(state.copyWith(todoList: updatedList));

    await CustomSharedPreferences.setTodoList(updatedList);
  }

  void onSelectItem(TodoItemModel item) {
    if (state.selectedItems.contains(item)) {
      final updatedList = state.selectedItems.where((i) => i != item).toList();
      emit(state.copyWith(selectedItems: updatedList));
    } else {
      final updatedList = [...state.selectedItems, item];
      emit(state.copyWith(selectedItems: updatedList));
    }
  }

  String limitTitle(String title) {
    if (title.length > 20) {
      return '${title.substring(0, 20)}...';
    }
    return title;
  }

  Future<void> excludeTodo() async {
    final updatedList =
        state.todoList.where((i) => !state.selectedItems.contains(i)).toList();
    await CustomSharedPreferences.removeTodoItem(state.selectedItems);
    emit(state.copyWith(todoList: updatedList, selectedItems: []));
  }
}
