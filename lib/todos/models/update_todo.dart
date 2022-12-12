import 'package:flutter/foundation.dart';

import 'todo.dart';
import 'todo_fields.dart';

@immutable
class UpdateTodo {
  final int id;
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  const UpdateTodo({
    required this.id,
    required this.imagePath,
    this.tag,
    bool? isCompleted,
  }) : isCompleted = isCompleted ?? false;

  UpdateTodo.fromTodo(Todo todo)
      : id = todo.id,
        imagePath = todo.imagePath,
        tag = todo.tag,
        isCompleted = todo.isCompleted;

  Map<String, Object?> toMap() => {
        TodoFields.id: id,
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
