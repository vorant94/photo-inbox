import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inbox_notifier.dart';
import 'todo.dart';
import 'todo_grid_widget.dart';

class InboxScreen extends ConsumerStatefulWidget {
  static const route = 'inbox';

  const InboxScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  var _isShowAllMode = true;

  Map<DateTime, List<Todo>> _groupItemsByDate(List<Todo> todos) {
    final filteredTodos =
        _isShowAllMode ? todos : todos.where((element) => !element.isCompleted);
    return groupBy(filteredTodos, (element) => element.createdDate);
  }

  void _onPopupMenuSelected(_InboxPopupMenuActions value) {
    switch (value) {
      case _InboxPopupMenuActions.toggleShowAllMode:
        setState(() {
          _isShowAllMode = !_isShowAllMode;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(inboxProvider);
    final todoGroups = _groupItemsByDate(todos);
    final groupKeys = todoGroups.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _InboxPopupMenuActions.toggleShowAllMode,
                child:
                    Text(_isShowAllMode ? 'Show uncompleted only' : 'Show all'),
              )
            ],
            onSelected: (value) => _onPopupMenuSelected(value),
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

enum _InboxPopupMenuActions {
  toggleShowAllMode,
}
