import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'inbox/inbox_screen.dart';
import 'inbox/todo_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final _routerConfig = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        // the goal is to use here namedLocation, but
        // using context.namedLocation ends up in error for some reason
        // (it seems there is no GoRouter yet at this moment in the context)
        redirect: (context, state) => state.namedLocation(InboxScreen.route),
      ),
      GoRoute(
        name: InboxScreen.route,
        path: '/${InboxScreen.route}',
        builder: (context, state) => const InboxScreen(),
      ),
      GoRoute(
        name: TodoScreen.route,
        path: '/${TodoScreen.route}/:todoId',
        builder: (context, state) =>
            TodoScreen(todoId: state.params['todoId']!),
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Photo Inbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: _routerConfig,
    );
  }
}
