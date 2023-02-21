import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'common/todo_popup_menu_items.dart';
import 'inbox_screen.dart';
import 'state/todos.dart';

class PreviewScreen extends ConsumerStatefulWidget
    implements PreviewScreenExtra {
  const PreviewScreen({
    super.key,
    required this.xImage,
    required this.aspectRatio,
  });

  @override
  final XFile xImage;
  @override
  final double aspectRatio;

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

      return PreviewScreen(
        xImage: extra.xImage,
        aspectRatio: extra.aspectRatio,
      );
    },
  );
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  var fullScreenMode = false;

  void toggleFullScreen() {
    setState(() {
      fullScreenMode = !fullScreenMode;
    });
  }

  Future<void> submit() async {
    final notifier = ref.read(todosProvider.notifier);

    await notifier.create(
      xImage: widget.xImage,
      aspectRatio: widget.aspectRatio,
    );

    if (mounted) {
      showTodoActionSnackBar(context: context, action: TodoAction.create);
      context.goNamed(InboxScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => toggleFullScreen(),
          child: Center(
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Image.file(
                File(widget.xImage.path),
              ),
            ),
          ),
        ),
        floatingActionButton: fullScreenMode
            ? null
            : FloatingActionButton(
                onPressed: submit,
                child: const Icon(Icons.save),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: fullScreenMode
            ? null
            : BottomAppBar(
                child: Row(children: const []),
              ),
      ),
    );
  }
}

class PreviewScreenExtra {
  const PreviewScreenExtra({
    required this.xImage,
    required this.aspectRatio,
  });

  final XFile xImage;
  final double aspectRatio;
}
