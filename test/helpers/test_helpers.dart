import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';

class TestHelpers {
  static TodoItemModel createTodoItem({
    String? id,
    String title = 'Test Task',
    TodoItemStatus status = TodoItemStatus.pending,
  }) {
    return TodoItemModel(
      id: id ?? '1',
      title: title,
      status: status,
    );
  }

  static List<TodoItemModel> createTodoList({int count = 3}) {
    return List.generate(
      count,
      (index) => TodoItemModel(
        id: '${index + 1}',
        title: 'Task ${index + 1}',
        status: index % 2 == 0 ? TodoItemStatus.pending : TodoItemStatus.done,
      ),
    );
  }

  static List<TodoItemModel> createTodoListWithStatus({
    required int count,
    required TodoItemStatus status,
  }) {
    return List.generate(
      count,
      (index) => TodoItemModel(
        id: '${index + 1}',
        title: 'Task ${index + 1}',
        status: status,
      ),
    );
  }
}
