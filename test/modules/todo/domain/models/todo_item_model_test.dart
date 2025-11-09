import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';

void main() {
  group('TodoItemModel', () {
    test('should create a TodoItemModel with required fields', () {
      const model = TodoItemModel(
        id: '1',
        title: 'Test Task',
        status: TodoItemStatus.pending,
      );

      expect(model.id, '1');
      expect(model.title, 'Test Task');
      expect(model.status, TodoItemStatus.pending);
    });

    test('should create a TodoItemModel without id', () {
      const model = TodoItemModel(
        title: 'Test Task',
        status: TodoItemStatus.pending,
      );

      expect(model.id, isNull);
      expect(model.title, 'Test Task');
      expect(model.status, TodoItemStatus.pending);
    });

    group('generateId', () {
      test('should generate a valid UUID', () {
        const model = TodoItemModel(
          title: 'Test',
          status: TodoItemStatus.pending,
        );

        final id = model.generateId();

        expect(id, isNotEmpty);
        expect(id.length, 36);
        expect(id.contains('-'), true);
      });

      test('should generate different IDs each time', () {
        const model = TodoItemModel(
          title: 'Test',
          status: TodoItemStatus.pending,
        );

        final id1 = model.generateId();
        final id2 = model.generateId();

        expect(id1, isNot(id2));
      });
    });

    group('copyWith', () {
      test('should generate new id when id is null', () {
        const model = TodoItemModel(
          title: 'Test',
          status: TodoItemStatus.pending,
        );

        final copied = model.copyWith();

        expect(copied.id, isNotNull);
        expect(copied.title, model.title);
        expect(copied.status, model.status);
      });

      test('should keep existing id when not provided', () {
        const model = TodoItemModel(
          id: '123',
          title: 'Test',
          status: TodoItemStatus.pending,
        );

        final copied = model.copyWith();

        expect(copied.id, '123');
        expect(copied.title, model.title);
        expect(copied.status, model.status);
      });

      test('should update title', () {
        const model = TodoItemModel(
          id: '1',
          title: 'Original',
          status: TodoItemStatus.pending,
        );

        final copied = model.copyWith(title: 'Updated');

        expect(copied.title, 'Updated');
        expect(copied.id, model.id);
        expect(copied.status, model.status);
      });

      test('should update status', () {
        const model = TodoItemModel(
          id: '1',
          title: 'Test',
          status: TodoItemStatus.pending,
        );

        final copied = model.copyWith(status: TodoItemStatus.done);

        expect(copied.status, TodoItemStatus.done);
        expect(copied.id, model.id);
        expect(copied.title, model.title);
      });

      test('should update id', () {
        const model = TodoItemModel(
          id: '1',
          title: 'Test',
          status: TodoItemStatus.pending,
        );

        final copied = model.copyWith(id: '2');

        expect(copied.id, '2');
        expect(copied.title, model.title);
        expect(copied.status, model.status);
      });

      test('should update multiple fields', () {
        const model = TodoItemModel(
          id: '1',
          title: 'Original',
          status: TodoItemStatus.pending,
        );

        final copied = model.copyWith(
          title: 'Updated',
          status: TodoItemStatus.done,
        );

        expect(copied.title, 'Updated');
        expect(copied.status, TodoItemStatus.done);
        expect(copied.id, model.id);
      });
    });

    group('toJson', () {
      test('should convert model to JSON map', () {
        const model = TodoItemModel(
          id: '1',
          title: 'Test Task',
          status: TodoItemStatus.pending,
        );

        final json = model.toJson();

        expect(json, {
          'id': '1',
          'title': 'Test Task',
          'status': 'pending',
        });
      });

      test('should handle different statuses', () {
        const model1 = TodoItemModel(
          id: '1',
          title: 'Task',
          status: TodoItemStatus.inProgress,
        );
        const model2 = TodoItemModel(
          id: '2',
          title: 'Task',
          status: TodoItemStatus.done,
        );

        expect(model1.toJson()['status'], 'inProgress');
        expect(model2.toJson()['status'], 'done');
      });
    });

    group('fromJson', () {
      test('should create model from JSON map', () {
        final json = {
          'id': '1',
          'title': 'Test Task',
          'status': 'pending',
        };

        final model = TodoItemModel.fromJson(json);

        expect(model.id, '1');
        expect(model.title, 'Test Task');
        expect(model.status, TodoItemStatus.pending);
      });

      test('should handle different statuses', () {
        final json1 = {'id': '1', 'title': 'Task', 'status': 'inProgress'};
        final json2 = {'id': '2', 'title': 'Task', 'status': 'done'};

        final model1 = TodoItemModel.fromJson(json1);
        final model2 = TodoItemModel.fromJson(json2);

        expect(model1.status, TodoItemStatus.inProgress);
        expect(model2.status, TodoItemStatus.done);
      });

      test('should default to pending for unknown status', () {
        final json = {
          'id': '1',
          'title': 'Test Task',
          'status': 'unknown',
        };

        final model = TodoItemModel.fromJson(json);

        expect(model.status, TodoItemStatus.pending);
      });
    });

    group('toJsonString', () {
      test('should convert model to JSON string', () {
        const model = TodoItemModel(
          id: '1',
          title: 'Test Task',
          status: TodoItemStatus.pending,
        );

        final jsonString = model.toJsonString();

        expect(jsonString, isA<String>());
        final decoded = jsonDecode(jsonString);
        expect(decoded['id'], '1');
        expect(decoded['title'], 'Test Task');
        expect(decoded['status'], 'pending');
      });
    });

    group('fromJsonString', () {
      test('should create model from JSON string', () {
        const jsonString = '{"id":"1","title":"Test Task","status":"pending"}';

        final model = TodoItemModel.fromJsonString(jsonString);

        expect(model.id, '1');
        expect(model.title, 'Test Task');
        expect(model.status, TodoItemStatus.pending);
      });

      test('should handle round-trip conversion', () {
        const original = TodoItemModel(
          id: '1',
          title: 'Test Task',
          status: TodoItemStatus.inProgress,
        );

        final jsonString = original.toJsonString();
        final restored = TodoItemModel.fromJsonString(jsonString);

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.status, original.status);
      });
    });
  });

  group('TodoItemStatus', () {
    test('should have three status values', () {
      expect(TodoItemStatus.values.length, 3);
      expect(TodoItemStatus.values, contains(TodoItemStatus.pending));
      expect(TodoItemStatus.values, contains(TodoItemStatus.inProgress));
      expect(TodoItemStatus.values, contains(TodoItemStatus.done));
    });

    test('should have correct names', () {
      expect(TodoItemStatus.pending.name, 'pending');
      expect(TodoItemStatus.inProgress.name, 'inProgress');
      expect(TodoItemStatus.done.name, 'done');
    });
  });
}
