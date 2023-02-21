import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/todos.dart';
import 'todos_by_day_grid_widget.dart';

class TodosByDayWidget extends ConsumerWidget {
  const TodosByDayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(todoDaysProvider);
    if (days.isEmpty) {
      return const Center(
        child: Text('Your Inbox is empty!'),
      );
    }

    return ListView.separated(
      itemCount: days.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        return TodosByDayGridWidget(day: days[index]);
      },
    );
  }
}
