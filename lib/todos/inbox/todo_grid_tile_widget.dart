import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/todo.dart';
import '../todos_notifier.dart';
import 'details_screen.dart';

@immutable
class TodoGridTileWidget extends ConsumerWidget {
  final Todo todo;

  const TodoGridTileWidget({
    required this.todo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
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
                  foregroundColor:
                      Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCompleted(WidgetRef ref) {
    final notifier = ref.read(inboxProvider.notifier);
    notifier.toggleTodoCompleted(todo.id);
  }

  void _gotoDetails(BuildContext context) {
    context.pushNamed(DetailsScreen.routeName,
        params: {'todoId': todo.id.toString()});
  }
}
