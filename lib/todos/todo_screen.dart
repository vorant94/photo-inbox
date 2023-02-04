import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/todo_is_completed_icon_widget.dart';

import 'models/todo.dart';
import 'state/todos.dart';

@immutable
class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();

  static const routeName = '/todo';
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TodoScreenArguments;
    final todoId = args.todoId;

    final todo = ref.watch(_todoProvider(todoId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
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
            onSelected: (_PopupMenuActions value) =>
                _onPopupMenuSelected(value, todo),
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

  void _onPopupMenuSelected(
    _PopupMenuActions value,
    Todo todo,
  ) {
    switch (value) {
      case _PopupMenuActions.delete:
        final notifier = ref.read(todosProvider.notifier);
        notifier.delete(todo.id);
        Navigator.of(context).pop();
        break;
    }
  }
}

class TodoScreenArguments {
  const TodoScreenArguments({
    required this.todoId,
  });

  final int todoId;
}

final _todoProvider = Provider.autoDispose.family<Todo, int>((ref, todoId) =>
    ref.watch(filteredTodosProvider).firstWhere((todo) => todo.id == todoId));

enum _PopupMenuActions {
  delete,
}
