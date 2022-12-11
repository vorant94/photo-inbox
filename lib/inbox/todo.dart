import 'package:flutter/foundation.dart';

@immutable
class Todo {
  final String id;
  final String imageUrl;
  final DateTime createdDate;
  final String? tag;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.imageUrl,
    required this.createdDate,
    this.tag,
    isCompleted,
  }) : isCompleted = isCompleted ?? false;

  Todo copyWith({
    String? id,
    String? imageUrl,
    DateTime? createdDate,
    String? tag,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      createdDate: createdDate ?? this.createdDate,
      tag: tag ?? this.tag,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
