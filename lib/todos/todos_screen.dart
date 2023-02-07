import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/todos/camera_screen.dart';

import './state/show_all_mode.dart';
import './state/todos.dart';
import './widgets/todos_by_day_widget.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();

  static const routeName = 'todos';
  static final route = GoRoute(
    name: TodosScreen.routeName,
    path: '/todos',
    builder: (context, state) => const TodosScreen(),
  );
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  @override
  void initState() {
    super.initState();

    final notifier = ref.read(todosProvider.notifier);

    notifier.fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    final showAllMode = ref.watch(showAllModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _PopupMenuActions.toggleShowAllMode,
                child: Text(showAllMode ? 'Show uncompleted only' : 'Show all'),
              )
            ],
            onSelected: _onPopupMenuSelected,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTodo,
        child: const Icon(Icons.add),
      ),
      body: const SafeArea(
        child: TodosByDayWidget(),
      ),
    );
  }

  void _onPopupMenuSelected(_PopupMenuActions value) {
    switch (value) {
      case _PopupMenuActions.toggleShowAllMode:
        final notifier = ref.read(showAllModeProvider.notifier);
        notifier.toggle();
        break;
    }
  }

  Future<void> _createTodo() async {
    context.pushNamed(CameraScreen.routeName);
  }
}

enum _PopupMenuActions {
  toggleShowAllMode,
}
