import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../state/todos.dart';

class TodoIsCompletedIconWidget extends ConsumerWidget {
  const TodoIsCompletedIconWidget({
    required this.todo,
    this.isInverse = true,
    super.key
  });

  final Todo todo;
  final bool isInverse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final foregroundColor = isInverse ? inversePrimary : null;

    return IconButton(
      icon: const Icon(Icons.circle_outlined),
      selectedIcon: const Icon(Icons.check_circle),
      isSelected: todo.isCompleted,
      onPressed: () => _toggleIsCompleted(ref),
      style: IconButton.styleFrom(
        foregroundColor: foregroundColor,
      ),
    );
  }

  void _toggleIsCompleted(WidgetRef ref) {
    final notifier = ref.read(todosProvider.notifier);

    notifier.toggleIsCompleted(todo.id);
  }
}
