import 'package:flutter/foundation.dart';

import '../entities/update_entity.dart';
import 'todo.dart';
import 'todo_fields.dart';

@immutable
class UpdateTodo implements UpdateEntity {
  UpdateTodo.fromEntity(Todo todo)
      : id = todo.id,
        imagePath = todo.imagePath,
        tag = todo.tag,
        isCompleted = todo.isCompleted;

  @override
  final int id;
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  @override
  Map<String, dynamic> toJson() => {
        TodoFields.id: id,
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
