import 'package:flutter_test/flutter_test.dart';
import 'package:todo_application/core/app/page_state.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_state.dart';

void main() {
  group('TodoState', () {
    test('should have correct default values', () {
      const state = TodoState();

      expect(state.status, PageStatus.initial);
      expect(state.todoList, isEmpty);
      expect(state.selectedItems, isEmpty);
      expect(state.selectedFilter, 'All');
    });

    test('should support value equality', () {
      const state1 = TodoState();
      const state2 = TodoState();

      expect(state1, state2);
    });

    test('should not be equal when properties differ', () {
      const state1 = TodoState(selectedFilter: 'All');
      const state2 = TodoState(selectedFilter: 'Pending');

      expect(state1, isNot(state2));
    });

    group('copyWith', () {
      test('should copy with new status', () {
        const state = TodoState();
        final newState = state.copyWith(status: PageStatus.loading);

        expect(newState.status, PageStatus.loading);
        expect(newState.todoList, state.todoList);
        expect(newState.selectedItems, state.selectedItems);
        expect(newState.selectedFilter, state.selectedFilter);
      });

      test('should copy with new todoList', () {
        const state = TodoState();
        final newTodoList = [
          TodoItemModel(id: '1', title: 'Task 1', status: TodoItemStatus.pending),
        ];
        final newState = state.copyWith(todoList: newTodoList);

        expect(newState.todoList, newTodoList);
        expect(newState.status, state.status);
      });

      test('should copy with new selectedItems', () {
        const state = TodoState();
        final newSelectedItems = [
          TodoItemModel(id: '1', title: 'Task 1', status: TodoItemStatus.pending),
        ];
        final newState = state.copyWith(selectedItems: newSelectedItems);

        expect(newState.selectedItems, newSelectedItems);
        expect(newState.status, state.status);
      });

      test('should copy with new selectedFilter', () {
        const state = TodoState();
        final newState = state.copyWith(selectedFilter: 'Done');

        expect(newState.selectedFilter, 'Done');
        expect(newState.status, state.status);
      });

      test('should keep original values when null is passed', () {
        const state = TodoState(
          status: PageStatus.success,
          selectedFilter: 'Pending',
        );
        final newState = state.copyWith();

        expect(newState.status, state.status);
        expect(newState.selectedFilter, state.selectedFilter);
      });
    });

    group('filteredTodoList', () {
      final todoList = [
        TodoItemModel(id: '1', title: 'Task 1', status: TodoItemStatus.pending),
        TodoItemModel(id: '2', title: 'Task 2', status: TodoItemStatus.done),
        TodoItemModel(id: '3', title: 'Task 3', status: TodoItemStatus.inProgress),
        TodoItemModel(id: '4', title: 'Task 4', status: TodoItemStatus.pending),
        TodoItemModel(id: '5', title: 'Task 5', status: TodoItemStatus.done),
      ];

      test('should return all items when filter is "All"', () {
        final state = TodoState(todoList: todoList, selectedFilter: 'All');

        expect(state.filteredTodoList, todoList);
        expect(state.filteredTodoList.length, 5);
      });

      test('should return only pending items when filter is "Pending"', () {
        final state = TodoState(todoList: todoList, selectedFilter: 'Pending');

        expect(state.filteredTodoList.length, 2);
        expect(
          state.filteredTodoList.every((item) => item.status == TodoItemStatus.pending),
          true,
        );
      });

      test('should return only done items when filter is "Done"', () {
        final state = TodoState(todoList: todoList, selectedFilter: 'Done');

        expect(state.filteredTodoList.length, 2);
        expect(
          state.filteredTodoList.every((item) => item.status == TodoItemStatus.done),
          true,
        );
      });

      test('should return all items for unknown filter', () {
        final state = TodoState(todoList: todoList, selectedFilter: 'Unknown');

        expect(state.filteredTodoList, todoList);
        expect(state.filteredTodoList.length, 5);
      });

      test('should return empty list when todoList is empty', () {
        const state = TodoState(todoList: [], selectedFilter: 'Pending');

        expect(state.filteredTodoList, isEmpty);
      });
    });

    group('props', () {
      test('should include all properties', () {
        final item = TodoItemModel(id: '1', title: 'Task', status: TodoItemStatus.pending);
        final state = TodoState(
          status: PageStatus.success,
          todoList: [item],
          selectedItems: [item],
          selectedFilter: 'Done',
        );

        expect(state.props, [
          PageStatus.success,
          [item],
          [item],
          'Done',
        ]);
      });
    });
  });
}
