import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/shared.dart';
import '../shared/todos_notifier.dart';
import 'todos_by_day_grid_widget.dart';

class TodosByDayWidget extends ConsumerWidget {
  const TodosByDayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maps = ref.watch(_todosByDayProvider);
    final keys = maps.keys.toList();

    return maps.isEmpty
        ? const Center(
            child: Text('Your Inbox is empty!'),
          )
        : ListView.separated(
            itemCount: keys.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final day = keys[index];
              final todos = maps[keys[index]]!;

              return TodosByDayGridWidget(day: day, todos: todos);
            },
          );
  }
}

final _todosByDayProvider = Provider<Map<DateTime, List<Todo>>>((ref) {
  final todos = ref.watch(todosProvider);

  return groupBy(todos, (todo) {
    final date = todo.createdDate;

    return DateTime(date.year, date.month, date.day);
  });
});
