import 'package:flutter/foundation.dart';

import 'todo_fields.dart';
import 'update_todo.dart';

@immutable
class Todo {
  const Todo._({
    required this.id,
    required this.createdDate,
    required this.imagePath,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo._(
      id: json[TodoFields.id],
      createdDate: DateTime.parse(json[TodoFields.createdDate]),
      imagePath: json[TodoFields.imagePath],
      isCompleted: json[TodoFields.isCompleted] == 1,
    );
  }

  final int id;
  final DateTime createdDate;
  final String imagePath;
  final bool isCompleted;

  Todo copyWith({
    int? id,
    DateTime? createdDate,
    String? imagePath,
    bool? isCompleted,
  }) {
    return Todo._(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      imagePath: imagePath ?? this.imagePath,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  UpdateTodo toUpdate() => UpdateTodo.fromEntity(this);

  @override
  String toString() => 'Todo('
      'id: $id, '
      'createdDate: $createdDate, '
      'imagePath: $imagePath, '
      'isCompleted: $isCompleted'
      ')';
}
