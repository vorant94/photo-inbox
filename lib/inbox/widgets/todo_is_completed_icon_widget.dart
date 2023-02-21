import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/todo_popup_menu_items.dart';
import '../models/todo.dart';
import '../state/todos.dart';

class TodoIsCompletedIconWidget extends ConsumerStatefulWidget {
  const TodoIsCompletedIconWidget({
    required this.todo,
    this.onTodoCompletedCallback,
    super.key,
  });

  final Todo todo;
  final VoidCallback? onTodoCompletedCallback;

  @override
  ConsumerState<TodoIsCompletedIconWidget> createState() =>
      _TodoIsCompletedIconWidgetState();
}

class _TodoIsCompletedIconWidgetState
    extends ConsumerState<TodoIsCompletedIconWidget> {
  Future<void> _toggleIsCompleted() async {
    final notifier = ref.read(todosProvider.notifier);

    final isCompleted = await notifier.toggleIsCompleted(id: widget.todo.id);

    if (mounted) {
      showTodoActionSnackBar(
        context: context,
        action: isCompleted ? TodoAction.complete : TodoAction.incomplete,
      );
    }

    if (!isCompleted || widget.onTodoCompletedCallback == null) {
      return;
    }

    widget.onTodoCompletedCallback!();
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.primary;

    return IconButton(
      icon: const Icon(Icons.circle_outlined),
      selectedIcon: const Icon(Icons.check_circle),
      isSelected: widget.todo.isCompleted,
      onPressed: () => _toggleIsCompleted(),
      style: IconButton.styleFrom(
        foregroundColor: foregroundColor,
      ),
    );
  }
}
