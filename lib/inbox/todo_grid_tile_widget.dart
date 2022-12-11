import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'inbox_notifier.dart';
import 'todo.dart';
import 'todo_screen.dart';

class TodoGridTileWidget extends ConsumerWidget {
  final Todo todo;

  const TodoGridTileWidget({
    required this.todo,
    Key? key,
  }) : super(key: key);

  void _toggleCompleted(WidgetRef ref) {
    final notifier = ref.read(inboxProvider.notifier);
    notifier.toggleTodoCompleted(todo.id);
  }

  void _gotoTodo(BuildContext context) {
    context.pushNamed(TodoScreen.route, params: {'todoId': todo.id});
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return GestureDetector(
      onTap: () => _gotoTodo(context),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: Image.network(
              todo.imageUrl,
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
                  foregroundColor:
                      Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );
  }
}
