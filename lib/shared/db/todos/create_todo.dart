import 'package:flutter/foundation.dart';

import 'todo_fields.dart';

@immutable
class CreateTodo {
  const CreateTodo({
    required this.imagePath,
    this.isCompleted = false,
  });

  final String imagePath;
  final bool isCompleted;

  Map<String, dynamic> toJson() => {
        TodoFields.imagePath: imagePath,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
