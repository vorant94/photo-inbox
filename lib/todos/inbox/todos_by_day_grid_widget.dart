import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/db/tables/todos_table.dart';
import 'todo_grid_tile_widget.dart';

@immutable
class TodosByDayGridWidget extends StatelessWidget {
  const TodosByDayGridWidget({
    required this.day,
    required this.todos,
    super.key,
  });

  final DateTime day;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMEd().format(day),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children:
              todos.map((todo) => TodoGridTileWidget(todo: todo)).toList(),
        ),
      ],
    );
  }
}
