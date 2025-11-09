import 'package:equatable/equatable.dart';
import 'package:todo_application/core/app/page_state.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';

class TodoState extends Equatable {
  final PageStatus status;
  final List<TodoItemModel> todoList;
  final List<TodoItemModel> selectedItems;
  final String selectedFilter;

  const TodoState({
    this.status = PageStatus.initial,
    this.todoList = const [],
    this.selectedItems = const [],
    this.selectedFilter = 'All',
  });

  List<TodoItemModel> get filteredTodoList {
    if (selectedFilter == 'All') {
      return todoList;
    } else if (selectedFilter == 'Pending') {
      return todoList.where((todo) => todo.status == TodoItemStatus.pending).toList();
    } else if (selectedFilter == 'Done') {
      return todoList.where((todo) => todo.status == TodoItemStatus.done).toList();
    }
    return todoList;
  }

  @override
  List<Object?> get props => [
        status,
        todoList,
        selectedItems,
        selectedFilter,
      ];

  TodoState copyWith({
    PageStatus? status,
    List<TodoItemModel>? todoList,
    List<TodoItemModel>? selectedItems,
    String? selectedFilter,
  }) {
    return TodoState(
      status: status ?? this.status,
      todoList: todoList ?? this.todoList,
      selectedItems: selectedItems ?? this.selectedItems,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
