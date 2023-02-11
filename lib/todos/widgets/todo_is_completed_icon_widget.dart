import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../state/todos.dart';

class TodoIsCompletedIconWidget extends ConsumerWidget {
  const TodoIsCompletedIconWidget({
    required this.todo,
    super.key,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foregroundColor = Theme.of(context).colorScheme.primary;

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

    notifier.toggleIsCompleted(id: todo.id);
  }
}
