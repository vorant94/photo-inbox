import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/db/tables/todos_table.dart';
import '../todos_notifier.dart';
import 'todo_screen.dart';

@immutable
class TodoGridTileWidget extends ConsumerWidget {
  const TodoGridTileWidget({
    required this.todo,
    super.key,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;

    return GestureDetector(
      onTap: () => _gotoDetails(context),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: Image.file(
              File(todo.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, -0.25),
                colors: [Colors.grey, Colors.transparent],
              ),
            ),
            constraints: const BoxConstraints.expand(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.circle_outlined),
              selectedIcon: const Icon(Icons.check_circle),
              isSelected: todo.isCompleted,
              onPressed: () => _toggleCompleted(ref),
              style: IconButton.styleFrom(
                foregroundColor: inversePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCompleted(WidgetRef ref) {
    final notifier = ref.read(todosNotifier);

    notifier.toggleTodoCompleted(todo.id);
  }

  void _gotoDetails(BuildContext context) {
    context.pushNamed(
      TodoScreen.routeName,
      params: {'todoId': todo.id.toString()},
    );
  }
}
