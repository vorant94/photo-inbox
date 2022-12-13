import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../todos_notifier.dart';
import '../todos_table.dart';

@immutable
class PreviewScreen extends ConsumerStatefulWidget {
  static const routeName = 'preview';
  static final route = GoRoute(
    name: PreviewScreen.routeName,
    path: '/${PreviewScreen.routeName}',
    builder: (context, state) {
      final tempFile = state.extra;
      if (tempFile is! File) {
        throw Exception('extra of type File must be set');
      }

      return PreviewScreen(tempFile: tempFile);
    },
  );

  final File tempFile;

  const PreviewScreen({
    required this.tempFile,
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
                widget.tempFile,
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
    final tempFile = widget.tempFile;
    final notifier = ref.read(inboxProvider.notifier);

    final fileDir = (await getApplicationDocumentsDirectory()).path;
    final filename = path.basename(tempFile.path);
    final filePath = path.join(fileDir, filename);

    try {
      final copy = await tempFile.copy(filePath);

      await notifier.createTodo(CreateTodo(imagePath: copy.path));

      await tempFile.delete();
      if (mounted) context.pop();
    } catch (e) {
      final copy = File(filePath);
      await copy.delete();
      rethrow;
    }
  }
}
