import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'todos/camera/camera_screen.dart';
import 'todos/camera/preview_screen.dart';
import 'todos/inbox/inbox_screen.dart';
import 'todos/inbox/todo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraScreen.cameras = await availableCameras();

  runApp(const ProviderScope(child: MyApp()));
}

@immutable
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
      routerConfig: _routerConfig,
    );
  }
}

final _routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // the goal is to use here namedLocation, but
      // using context.namedLocation ends up in error for some reason
      // (it seems there is no GoRouter yet at this moment in the context)
      redirect: (context, state) => state.namedLocation(InboxScreen.routeName),
    ),
    InboxScreen.route,
    TodoScreen.route,
    CameraScreen.route,
    PreviewScreen.route,
  ],
);
