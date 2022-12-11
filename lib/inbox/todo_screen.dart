import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inbox_notifier.dart';

class TodoScreen extends ConsumerWidget {
  static const route = 'todo';

  final String todoId;

  const TodoScreen({
    required this.todoId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(inboxProvider);
    final todos = state.todos;
    final todo = todos.firstWhere((element) => element.id == todoId);

    return Scaffold(
      body: Image.network(
        todo.imageUrl,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
