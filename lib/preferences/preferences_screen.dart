import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/common/drawer.dart';
import '../shared/state/show_completed.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  void _toggleShowCompleted({required WidgetRef ref}) {
    final showCompletedNotifier = ref.watch(showCompletedProvider.notifier);

    showCompletedNotifier.toggle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(showCompletedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      drawer: drawer(context),
      body: Column(
        children: [
          ListTile(
            title: const Text('Show completed Todos as well'),
            trailing: Switch(
              value: showCompleted,
              onChanged: (value) => _toggleShowCompleted(ref: ref),
            ),
          ),
        ],
      ),
    );
  }

  static const routeName = 'preferences';
  static final route = GoRoute(
    name: PreferencesScreen.routeName,
    path: '/preferences',
    builder: (context, state) => const PreferencesScreen(),
  );
}
