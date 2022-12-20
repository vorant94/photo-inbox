import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/todos_notifier.dart';

// stateful widget oly for reasons of async usage of context in _createTodo
// (since there is non context.mounted as of now for stateless widgets)
@immutable
class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();

  static const routeName = '/preview';
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PreviewScreenArguments;
    final cacheImage = args.cacheImage;

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                cacheImage,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
            IconButton(
              onPressed: () => _createTodo(cacheImage),
              icon: const Icon(Icons.save),
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createTodo(File cacheImage) async {
    final notifier = ref.read(todosNotifier);

    await notifier.createTodo(cacheImage: cacheImage);
    await cacheImage.delete();
    if (mounted) Navigator.of(context).pop();
  }
}

@immutable
class PreviewScreenArguments {
  const PreviewScreenArguments({
    required this.cacheImage,
  });

  final File cacheImage;
}
