import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

import 'state/todos.dart';
import 'widgets/todo_is_completed_icon_widget.dart';

class TodoDetailsScreen extends ConsumerStatefulWidget {
  const TodoDetailsScreen({
    required this.todoId,
    super.key,
  });

  final Id todoId;

  @override
  ConsumerState<TodoDetailsScreen> createState() => _TodoDetailsScreenState();

  static const routeName = 'todo-details';
  static final route = GoRoute(
    name: TodoDetailsScreen.routeName,
    path: '/todo-details/:todoId',
    builder: (context, state) =>
        TodoDetailsScreen(todoId: int.parse(state.params['todoId']!)),
  );
}

class _TodoDetailsScreenState extends ConsumerState<TodoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(todoProvider(widget.todoId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          TodoIsCompletedIconWidget(
            todo: todo,
            onTodoCompletedCallback: onTodoCompletedCallback,
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
        File(Todos.getTodoImageAbsolutePath(imageName: todo.imageName)),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  void onPopupMenuSelected(_PopupMenuActions value) {
    switch (value) {
      case _PopupMenuActions.delete:
        deleteTodo();
        break;
    }
  }

  void onTodoCompletedCallback() {
    final notifier = ref.read(todosProvider.notifier);

    final nextTodoId =
        notifier.findNextTodoIdForToday(currentId: widget.todoId);

    pushNextTodoOrPopSelf(
      nextTodoId: nextTodoId,
    );
  }

  Future<void> deleteTodo() async {
    final notifier = ref.read(todosProvider.notifier);

    final nextTodoId =
        notifier.findNextTodoIdForToday(currentId: widget.todoId);

    await notifier.delete(id: widget.todoId);
    if (!mounted) {
      return;
    }

    pushNextTodoOrPopSelf(nextTodoId: nextTodoId);
  }

  void pushNextTodoOrPopSelf({
    Id? nextTodoId,
  }) {
    if (nextTodoId == null) {
      context.pop();
      return;
    }

    context.pushReplacementNamed(
      TodoDetailsScreen.routeName,
      params: {'todoId': nextTodoId.toString()},
    );
  }
}

enum _PopupMenuActions {
  delete,
}
