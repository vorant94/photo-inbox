import 'package:flutter/foundation.dart';

import '../entities/entity.dart';
import 'todo_fields.dart';
import 'update_todo.dart';

@immutable
class Todo implements Entity {
  const Todo._({
    required this.id,
    required this.createdDate,
    required this.imagePath,
    this.tag,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo._(
      id: json[TodoFields.id],
      createdDate: DateTime.parse(json[TodoFields.createdDate]),
      imagePath: json[TodoFields.imagePath],
      tag: json[TodoFields.tag],
      isCompleted: json[TodoFields.isCompleted] == 1,
    );
  }

  @override
  final int id;
  @override
  final DateTime createdDate;
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  @override
  Todo copyWith({
    int? id,
    DateTime? createdDate,
    String? imagePath,
    String? tag,
    bool? isCompleted,
  }) {
    return Todo._(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      imagePath: imagePath ?? this.imagePath,
      tag: tag ?? this.tag,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  UpdateTodo toUpdate() => UpdateTodo.fromEntity(this);

  @override
  String toString() => 'Todo('
      'id: $id, '
      'createdDate: $createdDate, '
      'imagePath: $imagePath, '
      'tag: $tag, '
      'isCompleted: $isCompleted'
      ')';
}
