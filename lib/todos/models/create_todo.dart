import 'package:flutter/foundation.dart';

import 'todo_fields.dart';

@immutable
class CreateTodo {
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  const CreateTodo({
    required this.imagePath,
    this.tag,
    bool? isCompleted,
  }) : isCompleted = isCompleted ?? false;

  Map<String, Object?> toMap() => {
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
