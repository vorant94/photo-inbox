import 'package:flutter/foundation.dart';

import 'todo_fields.dart';

@immutable
class Todo {
  final int id;
  final String imagePath;
  final DateTime createdDate;
  final String? tag;
  final bool isCompleted;

  const Todo._({
    required this.id,
    required this.imagePath,
    required this.createdDate,
    this.tag,
    bool? isCompleted,
  }) : isCompleted = isCompleted ?? false;

  // TODO add map validation here
  Todo.fromMap(Map<String, Object?> map)
      : id = map[TodoFields.id] as int,
        imagePath = map[TodoFields.imagePath] as String,
        createdDate = DateTime.parse(map[TodoFields.createdDate] as String),
        tag = map[TodoFields.tag] as String?,
        isCompleted = map[TodoFields.isCompleted] == 1;

  Todo copyWith({
    int? id,
    String? imagePath,
    DateTime? createdDate,
    String? tag,
    bool? isCompleted,
  }) {
    return Todo._(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      createdDate: createdDate ?? this.createdDate,
      tag: tag ?? this.tag,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object?> toMap() => {
        TodoFields.id: id,
        TodoFields.imagePath: imagePath,
        TodoFields.createdDate: createdDate.toIso8601String(),
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}

typedef TodoList = List<Todo>;
