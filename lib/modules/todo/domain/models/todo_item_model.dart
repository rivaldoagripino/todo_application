import 'dart:convert';

import 'package:uuid/uuid.dart';

enum TodoItemStatus {
  pending,
  inProgress,
  done,
}

class TodoItemModel {
  final String? id;
  final String title;
  final TodoItemStatus status;

  const TodoItemModel({
    this.id,
    required this.title,
    required this.status,
  });

  String generateId() {
    const uuid = Uuid();
    return uuid.v4().toString();
  }

  TodoItemModel copyWith({
    String? id,
    String? title,
    TodoItemStatus? status,
  }) {
    return TodoItemModel(
      id: id ?? generateId(),
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status.name,
    };
  }

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'],
      title: json['title'],
      status: TodoItemStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TodoItemStatus.pending,
      ),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory TodoItemModel.fromJsonString(String jsonString) {
    return TodoItemModel.fromJson(jsonDecode(jsonString));
  }
}
