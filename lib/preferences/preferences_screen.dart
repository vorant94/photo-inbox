import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/common/drawer.dart';
import '../shared/state/show_all_mode.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAllMode = ref.watch(showAllModeProvider);
    final showAllModeNotifier = ref.watch(showAllModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      drawer: drawer(context),
      body: Column(
        children: [
          ListTile(
            title: const Text('Show all mode'),
            trailing: Switch(
              value: showAllMode,
              onChanged: (value) => showAllModeNotifier.toggle(),
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
