import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todos/camera_screen.dart';
import 'todos/models/todo.dart';
import 'todos/preview_screen.dart';
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
        colorScheme: const ColorScheme.light(primary: _primarySwatch),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

const int _primaryColor = 0xFFFF7601;
const MaterialColor _primarySwatch = MaterialColor(_primaryColor, {
  50: Color(0xFFFFEFE1),
  100: Color(0xFFFFD6B3),
  200: Color(0xFFFFBB80),
  300: Color(0xFFFF9F4D),
  400: Color(0xFFFF8B27),
  500: Color(_primaryColor),
  600: Color(0xFFFF6E01),
  700: Color(0xFFFF6301),
  800: Color(0xFFFF5901),
  900: Color(0xFFFF4600),
});

// const int _accentColor = 0xFFFFF5F2;
// const MaterialColor _accentSwatch = MaterialColor(_accentColor, <int, Color>{
//   100: Color(0xFFFFFFFF),
//   200: Color(_accentColor),
//   400: Color(0xFFFFCDBF),
//   700: Color(0xFFFFB9A6),
// });

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
    PreviewScreen.route,
  ],
);
