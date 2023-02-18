import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../shared/common/drawer.dart';
import '../shared/state/show_completed.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(showCompletedProvider);
    final showcompletedNotifier = ref.watch(showCompletedProvider.notifier);

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
              onChanged: (value) => showcompletedNotifier.toggle(),
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
