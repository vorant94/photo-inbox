import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/shared.dart';
import '../shared/todos_notifier.dart';

class TodoCompletedIconWidget extends ConsumerWidget {
  const TodoCompletedIconWidget({
    required this.todo,
    super.key
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    return IconButton(
      icon: const Icon(Icons.circle_outlined),
      selectedIcon: const Icon(Icons.check_circle),
      isSelected: todo.isCompleted,
      onPressed: () => _toggleCompleted(ref),
      style: IconButton.styleFrom(
        foregroundColor: inversePrimary,
      ),
    );
  }

  void _toggleCompleted(WidgetRef ref) {
    final notifier = ref.read(todosNotifier);

    notifier.toggleTodoCompleted(todo.id);
  }
}
