import 'package:flutter/foundation.dart';

import '../entities/create_entity.dart';
import 'todo_fields.dart';

@immutable
class CreateTodo implements CreateEntity {
  const CreateTodo({
    required this.imagePath,
    this.tag,
    this.isCompleted = false,
  });

  final String imagePath;
  final String? tag;
  final bool isCompleted;

  @override
  Map<String, dynamic> toJson() => {
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
