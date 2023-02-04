import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import 'todos/models/todo.dart';
import 'todos/todos_screen.dart';
import 'todos/todo_screen.dart';

Future<void> main() async {
  GetIt.I.registerSingleton(await Isar.open([TodoSchema]));

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
      initialRoute: TodosScreen.routeName,
      routes: {
        TodosScreen.routeName: (context) => const TodosScreen(),
        TodoScreen.routeName: (context) => const TodoScreen(),
      },
    );
  }
}
