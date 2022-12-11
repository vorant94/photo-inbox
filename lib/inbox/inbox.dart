import 'package:flutter/foundation.dart';

import 'todo.dart';

@immutable
class Inbox {
  final bool isShowAllMode;
  final List<Todo> todos;

  Inbox({
    isShowAllMode,
    todos,
  })  : isShowAllMode = isShowAllMode ?? true,
        todos = todos ?? [];

  Inbox copyWith({
    bool? isShowAllMode,
    List<Todo>? todos,
  }) {
    return Inbox(
      isShowAllMode: isShowAllMode ?? this.isShowAllMode,
      todos: todos ?? this.todos,
    );
  }
}
