import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/todos/inbox/change_todo_tag_widget.dart';

import '../../shared/shared.dart';
import '../shared/todos_notifier.dart';

@immutable
class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();

  static const routeName = '/todo';
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  var _isFullscreenMode = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TodoScreenArguments;
    final todoId = args.todoId;

    final todo = ref.watch(todoProvider(todoId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: _isFullscreenMode
          ? null
          : AppBar(
              actions: [
                IconButton(
                  onPressed: () => _openChangeTagDialog(todo),
                  icon: const Icon(Icons.local_offer),
                ),
              ],
            ),
      body: GestureDetector(
        onTap: _toggleFullscreenMode,
        child: Image.file(
          File(todo.imagePath),
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  void _toggleFullscreenMode() {
    setState(() => _isFullscreenMode = !_isFullscreenMode);
  }

  Future<void> _openChangeTagDialog(Todo todo) async {
    if (mounted) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ChangeTodoTagWidget(todo: todo),
      );
    }
  }
}

@immutable
class TodoScreenArguments {
  const TodoScreenArguments({
    required this.todoId,
  });

  final int todoId;
}
