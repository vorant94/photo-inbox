import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/todos/inbox/todo_completed_icon_widget.dart';

import '../../shared/shared.dart';
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
            child: TodoCompletedIconWidget(todo: todo),
          ),
        ],
      ),
    );
  }

  void _gotoDetails(BuildContext context) {
    Navigator.of(context).pushNamed(
      TodoScreen.routeName,
      arguments: TodoScreenArguments(todoId: todo.id),
    );
  }
}
