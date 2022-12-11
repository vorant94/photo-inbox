import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inbox/inbox_screen.dart';
import 'inbox/todo_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Inbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: InboxScreen.route,
      routes: {
        InboxScreen.route: (_) => const InboxScreen(),
        TodoScreen.route: (_) => const TodoScreen(),
      },
    );
  }
}
