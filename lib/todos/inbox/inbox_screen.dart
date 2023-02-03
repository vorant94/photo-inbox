import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/show_all_mode_notifier.dart';
import '../shared/todos_notifier.dart';
import 'todos_by_day_widget.dart';

@immutable
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();

  static const routeName = '/inbox';
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final notifier = ref.read(todosNotifier);

    notifier.fetchTodos();
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
        final notifier = ref.read(showAllModeNotifier);
        notifier.toggleShowAllMode();
        break;
    }
  }

  Future<void> _createTodo() async {
    final notifier = ref.read(todosNotifier);

    final xfile = await _picker.pickImage(source: ImageSource.camera);
    if(xfile == null) {
      return;
    }

    final file = File(xfile.path);
    await notifier.createTodo(cacheImage: file);
  }
}

enum _PopupMenuActions {
  toggleShowAllMode,
}
