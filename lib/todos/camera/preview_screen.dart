import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/create_todo.dart';
import '../todos_notifier.dart';

@immutable
class PreviewScreen extends ConsumerStatefulWidget {
  static const routeName = 'preview';
  static final route = GoRoute(
    name: PreviewScreen.routeName,
    path: '/${PreviewScreen.routeName}',
    builder: (context, state) {
      if (state.extra is! File) {
        throw Exception('extra of type File must be set');
      }

      return PreviewScreen(file: state.extra as File);
    },
  );

  final File file;

  const PreviewScreen({
    required this.file,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                widget.file,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
            IconButton(
              onPressed: _createTodo,
              icon: const Icon(Icons.save),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createTodo() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;
    final filename = path.basename(widget.file.path);
    final filePath = path.join(fileDir, filename);
    await widget.file.copy(filePath);

    final createTodo = CreateTodo(imagePath: filePath);
    final notifier = ref.read(inboxProvider.notifier);
    await notifier.createTodo(createTodo);

    if (mounted) context.pop();
  }
}
