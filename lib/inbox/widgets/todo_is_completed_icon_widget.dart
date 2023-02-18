import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/todo.dart';
import '../state/todos.dart';

class TodoIsCompletedIconWidget extends ConsumerWidget {
  const TodoIsCompletedIconWidget({
    required this.todo,
    this.onTodoCompletedCallback,
    super.key,
  });

  final Todo todo;
  final VoidCallback? onTodoCompletedCallback;

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

  Future<void> _toggleIsCompleted(WidgetRef ref) async {
    final notifier = ref.read(todosProvider.notifier);

    final isCompleted = await notifier.toggleIsCompleted(id: todo.id);
    if (!isCompleted || onTodoCompletedCallback == null) {
      return;
    }

    onTodoCompletedCallback!();
  }
}
