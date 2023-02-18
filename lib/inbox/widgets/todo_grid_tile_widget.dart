import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/todo.dart';
import '../state/todos.dart';
import '../todo_details_screen.dart';
import 'todo_is_completed_icon_widget.dart';

class TodoGridTileWidget extends ConsumerWidget {
  const TodoGridTileWidget({
    required this.todo,
    required this.index,
    super.key,
  });

  final Todo todo;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _gotoTodo(context),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: Image.file(
              File(Todos.getTodoImageAbsolutePath(imageName: todo.imageName)),
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
            child: TodoIsCompletedIconWidget(todo: todo),
          ),
        ],
      ),
    );
  }

  void _gotoTodo(BuildContext context) {
    context.pushNamed(
      TodoDetailsScreen.routeName,
      extra: TodoDetailsScreenExtra(
        index: index,
        day: todo.createdDate,
      ),
    );
  }
}
