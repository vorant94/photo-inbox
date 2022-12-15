import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../todos_notifier.dart';

@immutable
class TodoScreen extends ConsumerWidget {
  const TodoScreen({
    required this.todoId,
    super.key,
  });

  final int todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoProvider(todoId));

    return Scaffold(
      body: Image.file(
        File(todo.imagePath),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  static const routeName = 'doto';
  static final route = GoRoute(
    name: TodoScreen.routeName,
    path: '/${TodoScreen.routeName}/:todoId',
    builder: (context, state) {
      final todoId = state.params['todoId']!;

      return TodoScreen(todoId: int.parse(todoId));
    },
  );
}
