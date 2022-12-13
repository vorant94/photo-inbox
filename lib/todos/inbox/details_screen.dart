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
      final todoId = state.params['todoId'];
      if (todoId is! String) {
        throw Exception('params[\'todoId\'] of type String must be set');
      }

      return DetailsScreen(todoId: int.parse(todoId));
    },
  );

  final int todoId;

  const DetailsScreen({
    required this.todoId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final todos = ref.watch(inboxProvider);
    final todo = todos.firstWhere((element) => element.id == todoId);

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
