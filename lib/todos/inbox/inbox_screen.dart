import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/db/tables/todos_table.dart';
import '../camera/camera_screen.dart';
import '../todos_notifier.dart';
import 'todo_grid_widget.dart';

@immutable
class InboxScreen extends ConsumerStatefulWidget {
  static const routeName = 'inbox';
  static final route = GoRoute(
    name: InboxScreen.routeName,
    path: '/${InboxScreen.routeName}',
    builder: (context, state) => const InboxScreen(),
  );

  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  var _isShowAllMode = true;

  @override
  void initState() {
    super.initState();

    final notifier = ref.read(TodosNotifier.provider.notifier);

    notifier.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(TodosNotifier.provider);

    final todoGroups = _groupItemsByDate(todos);
    final groupKeys = todoGroups.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _PopupMenuActions.toggleShowAllMode,
                child:
                    Text(_isShowAllMode ? 'Show uncompleted only' : 'Show all'),
              )
            ],
            onSelected: _onPopupMenuSelected,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCamera,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: groupKeys.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
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

  Map<DateTime, List<Todo>> _groupItemsByDate(List<Todo> todos) {
    final filteredTodos =
        _isShowAllMode ? todos : todos.where((element) => !element.isCompleted);
    return groupBy(filteredTodos, (element) {
      final createdDate = element.createdDate;
      final startOfCreatedDateDay =
          DateTime(createdDate.year, createdDate.month, createdDate.day);
      return startOfCreatedDateDay;
    });
  }

  void _onPopupMenuSelected(_PopupMenuActions value) {
    switch (value) {
      case _PopupMenuActions.toggleShowAllMode:
        setState(() => _isShowAllMode = !_isShowAllMode);
        break;
    }
  }

  void _goToCamera() {
    context.goNamed(CameraScreen.routeName);
  }
}

enum _PopupMenuActions {
  toggleShowAllMode,
}
