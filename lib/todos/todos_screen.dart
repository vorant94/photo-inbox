import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './state/show_all_mode.dart';
import './widgets/todos_by_day_widget.dart';
import 'camera_screen.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAllMode = ref.watch(showAllModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _PopupMenuAction.toggleShowAllMode,
                child: Text(showAllMode ? 'Show uncompleted only' : 'Show all'),
              )
            ],
            onSelected: (_PopupMenuAction value) =>
                _onPopupMenuSelected(ref, value),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTodo(context),
        child: const Icon(Icons.add),
      ),
      body: const TodosByDayWidget(),
    );
  }

  void _onPopupMenuSelected(WidgetRef ref, _PopupMenuAction value) {
    switch (value) {
      case _PopupMenuAction.toggleShowAllMode:
        final notifier = ref.read(showAllModeProvider.notifier);
        notifier.toggle();
        break;
    }
  }

  Future<void> _createTodo(BuildContext context) async {
    context.pushNamed(CameraScreen.routeName);
  }

  static const routeName = 'todos';
  static final route = GoRoute(
    name: TodosScreen.routeName,
    path: '/todos',
    builder: (context, state) => const TodosScreen(),
  );
}

enum _PopupMenuAction {
  toggleShowAllMode,
}
