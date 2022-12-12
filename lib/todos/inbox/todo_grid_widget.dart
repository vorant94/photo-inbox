import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';
import 'todo_grid_tile_widget.dart';

@immutable
class TodoGridWidget extends StatelessWidget {
  final DateTime createdDate;
  final TodoList todos;

  const TodoGridWidget({
    required this.createdDate,
    required this.todos,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMEd().format(createdDate),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: todos
              .map((element) => TodoGridTileWidget(todo: element))
              .toList(),
        ),
      ],
    );
  }
}
