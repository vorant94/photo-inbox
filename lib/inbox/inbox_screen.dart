import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inbox_notifier.dart';
import 'todo.dart';
import 'todo_grid_widget.dart';

class InboxScreen extends ConsumerWidget {
  static const route = '/inbox';

  const InboxScreen({
    Key? key,
  }) : super(key: key);

  Map<DateTime, List<Todo>> _groupItemsByDate(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.read(inboxProvider);
    final isShowAllMode = state.isShowAllMode;
    final todos = state.todos;

    final filteredTodos =
        isShowAllMode ? todos : todos.where((element) => !element.isCompleted);
    return groupBy(filteredTodos, (element) => element.createdDate);
  }

  void _onPopupMenuSelected(
    BuildContext context,
    WidgetRef ref,
    InboxPopupMenuActions value,
  ) {
    switch (value) {
      case InboxPopupMenuActions.toggleShowAllMode:
        final notifier = ref.read(inboxProvider.notifier);
        notifier.toggleShowAllMode();
        break;
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(inboxProvider);
    final isShowAllMode = state.isShowAllMode;
    final todoGroups = _groupItemsByDate(context, ref);
    final groupKeys = todoGroups.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: InboxPopupMenuActions.toggleShowAllMode,
                child:
                    Text(isShowAllMode ? 'Show uncompleted only' : 'Show all'),
              )
            ],
            onSelected: (value) => _onPopupMenuSelected(context, ref, value),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: groupKeys.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (_, index) {
            final createdDate = groupKeys[index];
            final todos = todoGroups[groupKeys[index]]!;
            return TodoGridWidget(
              createdDate: createdDate,
              todos: todos,
            );
          },
        ),
      ),
    );
  }
}

enum InboxPopupMenuActions {
  toggleShowAllMode,
}
