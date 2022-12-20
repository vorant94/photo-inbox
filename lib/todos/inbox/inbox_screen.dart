import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../camera/camera_screen.dart';
import '../shared/show_all_mode_notifier.dart';
import '../shared/todos_notifier.dart';
import 'todos_by_day_widget.dart';
import 'todos_by_tag_widget.dart';

@immutable
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();

  static const routeName = '/inbox';
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  var _currentTabIndex = 0;
  final _tabs = const [TodosByDayWidget(), TodosByTagWidget()];

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
        onPressed: _goToCamera,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: _tabs[_currentTabIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _changeCurrentTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.discount),
            label: 'Tags',
          ),
        ],
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

  void _goToCamera() {
    Navigator.of(context).pushReplacementNamed(CameraScreen.routeName);
  }

  void _changeCurrentTabIndex(int value) {
    setState(() => _currentTabIndex = value);
  }
}

enum _PopupMenuActions {
  toggleShowAllMode,
}
