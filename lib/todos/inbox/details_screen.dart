import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../todos_notifier.dart';

@immutable
class DetailsScreen extends ConsumerWidget {
  static const routeName = 'details';
  static final route = GoRoute(
    name: DetailsScreen.routeName,
    path: '/${DetailsScreen.routeName}/:todoId',
    builder: (context, state) {
      final todoId = state.params['todoId']!;

      return DetailsScreen(todoId: int.parse(todoId));
    },
  );

  final int todoId;

  const DetailsScreen({
    required this.todoId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(TodosNotifier.provider);

    final todo = todos.firstWhere((todo) => todo.id == todoId);

    return Scaffold(
      body: Image.file(
        File(todo.imagePath),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
