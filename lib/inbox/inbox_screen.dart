import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shared/common/drawer.dart';
import 'camera_screen.dart';
import 'widgets/todos_by_day_widget.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  Future<void> _createTodo(BuildContext context) async {
    context.goNamed(CameraScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      drawer: drawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTodo(context),
        child: const Icon(Icons.add),
      ),
      body: const TodosByDayWidget(),
    );
  }

  static const routeName = 'inbox';
  static final route = GoRoute(
    name: InboxScreen.routeName,
    path: '/inbox',
    builder: (context, state) => const InboxScreen(),
  );
}
