import 'package:flutter/foundation.dart';

import 'todo.dart';
import 'todo_fields.dart';

@immutable
class UpdateTodo {
  UpdateTodo.fromEntity(Todo todo)
      : id = todo.id,
        imagePath = todo.imagePath,
        isCompleted = todo.isCompleted;

  final int id;
  final String imagePath;
  final bool isCompleted;

  Map<String, dynamic> toJson() => {
        TodoFields.id: id,
        TodoFields.imagePath: imagePath,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
