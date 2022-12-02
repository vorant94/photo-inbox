import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inbox/inbox.dart';
import 'inbox/inbox_item_screen.dart';
import 'inbox/inbox_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => Inbox(),
    child: const MyApp(),
  ));
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
        InboxItemScreen.route: (_) => const InboxItemScreen(),
      },
    );
  }
}
