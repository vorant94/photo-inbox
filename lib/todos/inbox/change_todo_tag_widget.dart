import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/shared.dart';
import '../shared/todos_notifier.dart';

class ChangeTodoTagWidget extends ConsumerStatefulWidget {
  const ChangeTodoTagWidget({
    required this.todo,
    super.key,
  });

  final Todo todo;

  @override
  ConsumerState<ChangeTodoTagWidget> createState() =>
      _ChangeTodoTagWidgetState();
}

class _ChangeTodoTagWidgetState extends ConsumerState<ChangeTodoTagWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.tag);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomBarOffset = media.padding.bottom;
    final keyboardOffset = media.viewInsets.bottom;
    final bottom = max(bottomBarOffset, keyboardOffset);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(controller: _controller),
                ElevatedButton(
                  onPressed: _changeTodoTag,
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changeTodoTag() async {
    final notifier = ref.read(todosNotifier);
    final todo = widget.todo;
    final value = _controller.value.text;

    await notifier.changeTodoTag(todo.id, tag: value);

    if (mounted) Navigator.of(context).pop();
  }
}
