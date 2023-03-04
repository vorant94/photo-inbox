import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inbox/camera_screen.dart';
import 'inbox/inbox_screen.dart';
import 'inbox/models/todo.dart';
import 'inbox/preview_screen.dart';
import 'inbox/state/todos.dart';
import 'inbox/todo_details_screen.dart';
import 'preferences/preferences_screen.dart';
import 'shared/io/directory.dart';
import 'shared/isar/perform_migration.ts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraScreen.cameras = await availableCameras();

  final isar = await Isar.open([TodoSchema]);
  GetIt.I.registerSingleton(isar);
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());

  final docDirPath = (await getApplicationDocumentsDirectory()).path;
  final imagesDirPath = join(docDirPath, _imagesDirName);
  await Directory(imagesDirPath).ensure();
  Todos.imagesDirPath = imagesDirPath;

  await isar.performMigration();

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

const _imagesDirName = 'todo-images';

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
          CameraScreen.route.path,
    ),
    InboxScreen.route,
    TodoDetailsScreen.route,
    CameraScreen.route,
    PreviewScreen.route,
    PreferencesScreen.route,
  ],
);
