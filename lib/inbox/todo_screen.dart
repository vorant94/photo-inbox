import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inbox_notifier.dart';

class TodoScreen extends ConsumerWidget {
  static const route = '/todo';

  const TodoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final args = ModalRoute.of(context)!.settings.arguments as TodoArguments;
    final todo = ref
        .watch(inboxProvider)
        .todos
        .firstWhere((item) => item.id == args.todoId);

    return Scaffold(
      body: Image.network(
        todo.imageUrl,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

class TodoArguments {
  final String todoId;

  TodoArguments(this.todoId);
}
