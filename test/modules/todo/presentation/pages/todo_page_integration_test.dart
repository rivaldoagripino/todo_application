import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TodoPage Integration Tests', () {
    late TodoCubit cubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cubit = TodoCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('should integrate addTodo and editTodo correctly', () async {
      await cubit.addTodo('Task 1', TodoItemStatus.pending);
      
      expect(cubit.state.todoList.length, 1);
      expect(cubit.state.todoList.first.title, 'Task 1');
      
      final itemToEdit = cubit.state.todoList.first;
      final updatedItem = itemToEdit.copyWith(
        title: 'Updated Task 1',
        status: TodoItemStatus.done,
      );
      
      await cubit.editTodo(updatedItem);
      
      expect(cubit.state.todoList.length, 1);
      expect(cubit.state.todoList.first.title, 'Updated Task 1');
      expect(cubit.state.todoList.first.status, TodoItemStatus.done);
    });

    test('should integrate addTodo, select and exclude correctly', () async {
      await cubit.addTodo('Task 1', TodoItemStatus.pending);
      await cubit.addTodo('Task 2', TodoItemStatus.pending);
      await cubit.addTodo('Task 3', TodoItemStatus.pending);
      
      expect(cubit.state.todoList.length, 3);
      
      final itemToDelete = cubit.state.todoList[1];
      cubit.onSelectItem(itemToDelete);
      
      expect(cubit.state.selectedItems.length, 1);
      
      await cubit.excludeTodo();
      
      expect(cubit.state.todoList.length, 2);
      expect(cubit.state.selectedItems.length, 0);
      expect(cubit.state.todoList.any((item) => item.id == itemToDelete.id), false);
    });

    test('should filter todos correctly', () async {
      await cubit.addTodo('Task 1', TodoItemStatus.pending);
      await cubit.addTodo('Task 2', TodoItemStatus.done);
      await cubit.addTodo('Task 3', TodoItemStatus.pending);
      
      expect(cubit.state.todoList.length, 3);
      
      cubit.onFilterChanged('Pending');
      expect(cubit.state.filteredTodoList.length, 2);
      
      cubit.onFilterChanged('Done');
      expect(cubit.state.filteredTodoList.length, 1);
      
      cubit.onFilterChanged('All');
      expect(cubit.state.filteredTodoList.length, 3);
    });

    test('should handle multiple selections and exclusions', () async {
      await cubit.addTodo('Task 1', TodoItemStatus.pending);
      await cubit.addTodo('Task 2', TodoItemStatus.pending);
      await cubit.addTodo('Task 3', TodoItemStatus.pending);
      await cubit.addTodo('Task 4', TodoItemStatus.pending);
      
      final item1 = cubit.state.todoList[0];
      final item3 = cubit.state.todoList[2];
      
      cubit.onSelectItem(item1);
      cubit.onSelectItem(item3);
      
      expect(cubit.state.selectedItems.length, 2);
      
      await cubit.excludeTodo();
      
      expect(cubit.state.todoList.length, 2);
      expect(cubit.state.selectedItems.length, 0);
    });

    test('should persist data through SharedPreferences', () async {
      await cubit.addTodo('Persistent Task', TodoItemStatus.pending);
      
      final newCubit = TodoCubit();
      await newCubit.onInit();
      await Future.delayed(const Duration(seconds: 3));
      
      expect(newCubit.state.todoList.isNotEmpty, true);
      
      newCubit.close();
    });
  });
}
