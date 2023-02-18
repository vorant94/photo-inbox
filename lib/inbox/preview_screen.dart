import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'inbox_screen.dart';
import 'state/todos.dart';

class PreviewScreen extends StatefulHookConsumerWidget
    implements PreviewScreenExtra {
  const PreviewScreen({
    super.key,
    required this.xImage,
  });

  @override
  final XFile xImage;

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();

  static const routeName = 'preview';
  static final route = GoRoute(
    name: PreviewScreen.routeName,
    path: '/preview',
    builder: (context, state) {
      final extra = state.extra;
      if (extra is! PreviewScreenExtra) {
        throw Exception('Expected XFile');
      }

      return PreviewScreen(xImage: extra.xImage);
    },
  );
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final fullScreenMode = useState(false);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => fullScreenMode.value = !fullScreenMode.value,
          child: Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Image.file(
                File(widget.xImage.path),
              ),
            ),
          ),
        ),
        floatingActionButton: fullScreenMode.value
            ? null
            : FloatingActionButton(
                onPressed: submit,
                child: const Icon(Icons.save),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: fullScreenMode.value
            ? null
            : BottomAppBar(
                child: Row(children: const []),
              ),
      ),
    );
  }

  Future<void> submit() async {
    final notifier = ref.read(todosProvider.notifier);

    await notifier.create(xImage: widget.xImage);

    if (mounted) {
      context.goNamed(InboxScreen.routeName);
    }
  }
}

class PreviewScreenExtra {
  const PreviewScreenExtra({
    required this.xImage,
  });

  final XFile xImage;
}
