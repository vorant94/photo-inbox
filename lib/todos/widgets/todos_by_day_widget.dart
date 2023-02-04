import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';
import '../state/todos.dart';
import 'todos_grid_widget.dart';

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
              final label = DateFormat.yMMMEd().format(keys[index]);
              final todos = maps[keys[index]]!;

              return TodosByDayGridWidget(label: label, todos: todos);
            },
          );
  }
}

final _todosByDayProvider =
    Provider.autoDispose<Map<DateTime, List<Todo>>>((ref) {
  final todos = ref.watch(filteredTodosProvider);

  return groupBy(todos, (todo) {
    final date = todo.createdDate;

    return DateTime(date.year, date.month, date.day);
  });
});
