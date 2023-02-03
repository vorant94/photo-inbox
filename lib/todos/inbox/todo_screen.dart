import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/todos/inbox/todo_completed_icon_widget.dart';

import '../shared/todos_notifier.dart';

@immutable
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
    ModalRoute.of(context)!.settings.arguments as TodoScreenArguments;
    final todoId = args.todoId;

    final todo = ref.watch(todoProvider(todoId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          TodoCompletedIconWidget(todo: todo),
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

  static const routeName = '/todo';
}

@immutable
class TodoScreenArguments {
  const TodoScreenArguments({
    required this.todoId,
  });

  final int todoId;
}
