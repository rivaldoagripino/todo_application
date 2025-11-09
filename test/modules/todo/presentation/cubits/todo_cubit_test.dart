import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/core/app/page_state.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_cubit.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TodoCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    cubit = TodoCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('TodoCubit', () {
    test('initial state should be TodoState with default values', () {
      expect(cubit.state, const TodoState());
      expect(cubit.state.status, PageStatus.initial);
      expect(cubit.state.todoList, isEmpty);
      expect(cubit.state.selectedItems, isEmpty);
      expect(cubit.state.selectedFilter, 'All');
    });

    group('onFilterChanged', () {
      blocTest<TodoCubit, TodoState>(
        'should emit state with updated filter',
        build: () => cubit,
        act: (cubit) => cubit.onFilterChanged('Pending'),
        expect: () => [
          const TodoState(selectedFilter: 'Pending'),
        ],
      );

      blocTest<TodoCubit, TodoState>(
        'should emit state with Done filter',
        build: () => cubit,
        act: (cubit) => cubit.onFilterChanged('Done'),
        expect: () => [
          const TodoState(selectedFilter: 'Done'),
        ],
      );
    });

    group('addTodo', () {
      blocTest<TodoCubit, TodoState>(
        'should add new todo to the list',
        build: () => cubit,
        act: (cubit) async => await cubit.addTodo('Test Task', TodoItemStatus.pending),
        expect: () => [
          predicate<TodoState>((state) {
            return state.todoList.length == 1 &&
                state.todoList.first.title == 'Test Task' &&
                state.todoList.first.status == TodoItemStatus.pending;
          }),
        ],
      );

      blocTest<TodoCubit, TodoState>(
        'should add multiple todos',
        build: () => cubit,
        act: (cubit) async {
          await cubit.addTodo('Task 1', TodoItemStatus.pending);
          await cubit.addTodo('Task 2', TodoItemStatus.inProgress);
        },
        expect: () => [
          predicate<TodoState>((state) => state.todoList.length == 1),
          predicate<TodoState>((state) => state.todoList.length == 2),
        ],
      );
    });

    group('onSelectItem', () {
      final testItem = TodoItemModel(
        id: '1',
        title: 'Test',
        status: TodoItemStatus.pending,
      );

      blocTest<TodoCubit, TodoState>(
        'should add item to selectedItems when not selected',
        build: () => cubit,
        act: (cubit) => cubit.onSelectItem(testItem),
        expect: () => [
          TodoState(selectedItems: [testItem]),
        ],
      );

      blocTest<TodoCubit, TodoState>(
        'should remove item from selectedItems when already selected',
        build: () => cubit,
        seed: () => TodoState(selectedItems: [testItem]),
        act: (cubit) => cubit.onSelectItem(testItem),
        expect: () => [
          const TodoState(selectedItems: []),
        ],
      );

      blocTest<TodoCubit, TodoState>(
        'should toggle multiple items',
        build: () => cubit,
        act: (cubit) {
          final item1 = TodoItemModel(id: '1', title: 'Task 1', status: TodoItemStatus.pending);
          final item2 = TodoItemModel(id: '2', title: 'Task 2', status: TodoItemStatus.pending);
          cubit.onSelectItem(item1);
          cubit.onSelectItem(item2);
          cubit.onSelectItem(item1);
        },
        expect: () => [
          predicate<TodoState>((state) => state.selectedItems.length == 1),
          predicate<TodoState>((state) => state.selectedItems.length == 2),
          predicate<TodoState>((state) => state.selectedItems.length == 1),
        ],
      );
    });

    group('limitTitle', () {
      test('should return full title if length <= 20', () {
        expect(cubit.limitTitle('Short title'), 'Short title');
        expect(cubit.limitTitle('Exactly 20 chars!!!'), 'Exactly 20 chars!!!');
      });

      test('should truncate title if length > 20', () {
        expect(
          cubit.limitTitle('This is a very long title that exceeds 20 characters'),
          'This is a very long ...',
        );
      });
    });

    group('excludeTodo', () {
      blocTest<TodoCubit, TodoState>(
        'should remove selected items from todoList',
        build: () => cubit,
        seed: () {
          final item1 = TodoItemModel(id: '1', title: 'Task 1', status: TodoItemStatus.pending);
          final item2 = TodoItemModel(id: '2', title: 'Task 2', status: TodoItemStatus.pending);
          final item3 = TodoItemModel(id: '3', title: 'Task 3', status: TodoItemStatus.pending);
          return TodoState(
            todoList: [item1, item2, item3],
            selectedItems: [item1, item3],
          );
        },
        act: (cubit) async => await cubit.excludeTodo(),
        expect: () => [
          predicate<TodoState>((state) {
            return state.todoList.length == 1 &&
                state.todoList.first.id == '2' &&
                state.selectedItems.isEmpty;
          }),
        ],
      );

      blocTest<TodoCubit, TodoState>(
        'should clear selectedItems after exclusion',
        build: () => cubit,
        seed: () {
          final item = TodoItemModel(id: '1', title: 'Task', status: TodoItemStatus.pending);
          return TodoState(todoList: [item], selectedItems: [item]);
        },
        act: (cubit) async => await cubit.excludeTodo(),
        expect: () => [
          const TodoState(todoList: [], selectedItems: []),
        ],
      );
    });

    group('editTodo', () {
      blocTest<TodoCubit, TodoState>(
        'should update existing todo item',
        build: () => cubit,
        seed: () {
          final item = TodoItemModel(id: '1', title: 'Original', status: TodoItemStatus.pending);
          return TodoState(todoList: [item]);
        },
        act: (cubit) async {
          final updatedItem = TodoItemModel(
            id: '1',
            title: 'Updated',
            status: TodoItemStatus.done,
          );
          await cubit.editTodo(updatedItem);
        },
        expect: () => [
          predicate<TodoState>((state) {
            return state.todoList.length == 1 &&
                state.todoList.first.title == 'Updated' &&
                state.todoList.first.status == TodoItemStatus.done;
          }),
        ],
      );

      blocTest<TodoCubit, TodoState>(
        'should only update the item with matching id',
        build: () => cubit,
        seed: () {
          final item1 = TodoItemModel(id: '1', title: 'Task 1', status: TodoItemStatus.pending);
          final item2 = TodoItemModel(id: '2', title: 'Task 2', status: TodoItemStatus.pending);
          return TodoState(todoList: [item1, item2]);
        },
        act: (cubit) async {
          final updatedItem = TodoItemModel(
            id: '1',
            title: 'Updated Task 1',
            status: TodoItemStatus.done,
          );
          await cubit.editTodo(updatedItem);
        },
        expect: () => [
          predicate<TodoState>((state) {
            return state.todoList.length == 2 &&
                state.todoList[0].title == 'Updated Task 1' &&
                state.todoList[1].title == 'Task 2';
          }),
        ],
      );
    });
  });
}
