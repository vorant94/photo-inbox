import 'package:flutter/material.dart';

import '../models/todo.dart';
import 'todo_grid_tile_widget.dart';

class TodosByDayGridWidget extends StatelessWidget {
  const TodosByDayGridWidget({
    required this.label,
    required this.todos,
    super.key,
  });

  final String label;
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
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
