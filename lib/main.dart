import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'shared/shared.dart';
import 'todos/todos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton(const TodosTable());

  runApp(const ProviderScope(child: MyApp()));
}

@immutable
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
      initialRoute: InboxScreen.routeName,
      routes: {
        InboxScreen.routeName: (context) => const InboxScreen(),
        TodoScreen.routeName: (context) => const TodoScreen(),
      },
    );
  }
}
