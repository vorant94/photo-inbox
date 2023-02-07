import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

import 'state/todos.dart';
import 'widgets/todo_is_completed_icon_widget.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({
    required this.todoId,
    super.key,
  });

  final Id todoId;

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();

  static const routeName = 'todo';
  static final route = GoRoute(
    name: TodoScreen.routeName,
    path: '/todo/:todoId',
    builder: (context, state) =>
        TodoScreen(todoId: int.parse(state.params['todoId']!)),
  );
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(todoProvider(widget.todoId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          TodoIsCompletedIconWidget(
            todo: todo,
            isInverse: false,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _PopupMenuActions.delete,
                child: Text('Delete'),
              )
            ],
            onSelected: onPopupMenuSelected,
          )
        ],
      ),
      body: Image.file(
        File(todo.imagePath),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  void onPopupMenuSelected(_PopupMenuActions value) {
    switch (value) {
      case _PopupMenuActions.delete:
        final notifier = ref.read(todosProvider.notifier);
        notifier.delete(id: widget.todoId);
        context.pop();
        break;
    }
  }
}

enum _PopupMenuActions {
  delete,
}
