import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/todos.dart';
import 'todo_grid_tile_widget.dart';

class TodosByDayGridWidget extends ConsumerWidget {
  const TodosByDayGridWidget({
    required this.day,
    super.key,
  });

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosByDayProvider(day));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMEd().format(day),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children: todos.mapIndexed((index, todo) {
            return TodoGridTileWidget(
              index: index,
              todo: todo,
            );
          }).toList(),
        ),
      ],
    );
  }
}
