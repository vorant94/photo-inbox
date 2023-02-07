import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mobile/todos/camera_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todos/models/todo.dart';
import 'todos/todo_screen.dart';
import 'todos/todos_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraScreen.cameras = await availableCameras();

  GetIt.I.registerSingleton(await Isar.open([TodoSchema]));
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Photo Inbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // TODO how to use here named redirect?
      redirect: (BuildContext context, GoRouterState state) =>
          TodosScreen.route.path,
    ),
    TodosScreen.route,
    TodoScreen.route,
    CameraScreen.route,
  ],
);
