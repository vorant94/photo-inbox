import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../todos_notifier.dart';

@immutable
class PreviewScreen extends ConsumerStatefulWidget {
  static const routeName = 'preview';
  static final route = GoRoute(
    name: PreviewScreen.routeName,
    path: '/${PreviewScreen.routeName}',
    builder: (context, state) {
      final cacheImage = state.extra;
      if (cacheImage is! File) {
        throw Exception('extra of type File must be set');
      }

      return PreviewScreen(cacheImage: cacheImage);
    },
  );

  final File cacheImage;

  const PreviewScreen({
    required this.cacheImage,
    super.key,
  });

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
                widget.cacheImage,
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
    final cacheImage = widget.cacheImage;
    final notifier = ref.read(TodosNotifier.provider.notifier);

    await notifier.createTodo(cacheImage: cacheImage);
    await cacheImage.delete();
    if (mounted) context.pop();
  }
}
