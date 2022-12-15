import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/db/tables/todos_table.dart';
import 'todo_grid_tile_widget.dart';

@immutable
class TodoGridWidget extends StatelessWidget {
  final DateTime createdDate;
  final List<Todo> todos;

  const TodoGridWidget({
    required this.createdDate,
    required this.todos,
    super.key,
  });

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
          children:
              todos.map((todo) => TodoGridTileWidget(todo: todo)).toList(),
        ),
      ],
    );
  }
}
