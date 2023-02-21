import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common/todo_popup_menu_items.dart';
import '../models/todo.dart';
import '../state/todos.dart';
import '../todo_details_screen.dart';
import 'todo_is_completed_icon_widget.dart';

class TodoGridTileWidget extends ConsumerStatefulWidget {
  const TodoGridTileWidget({
    required this.todo,
    required this.index,
    super.key,
  });

  final Todo todo;
  final int index;

  @override
  ConsumerState<TodoGridTileWidget> createState() => _TodoGridTileWidgetState();
}

class _TodoGridTileWidgetState extends ConsumerState<TodoGridTileWidget> {
  var _tapPosition = Offset.zero;

  void _gotoTodo() {
    context.pushNamed(
      TodoDetailsScreen.routeName,
      extra: TodoDetailsScreenExtra(
        index: widget.index,
        day: widget.todo.createdDate,
      ),
    );
  }

  void _showContextMenu() async {
    final paintBounds =
        Overlay
            .of(context)
            .context
            .findRenderObject()
            ?.paintBounds;
    if (paintBounds == null) {
      return;
    }

    final action = await showMenu<TodoAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, paintBounds.size.width, paintBounds.size.height),
      ),
      items: todoPopupMenuItems,
    );
    if (action == null) {
      return;
    }

    onTodoActionSelected(action: action);
  }

  void onTodoActionSelected({required TodoAction action}) {
    switch (action) {
      case TodoAction.delete:
        _deleteTodo();
        break;
      default:
        throw Exception('Unexpected action: $action');
    }
  }

  Future<void> _deleteTodo() async {
    final notifier = ref.read(todosProvider.notifier);

    await notifier.delete(id: widget.todo.id);

    if (mounted) {
      showTodoActionSnackBar(
        context: context,
        action: TodoAction.delete,
      );
    }
  }

  void _saveTapPosition({required TapDownDetails details}) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _gotoTodo(),
      onLongPress: () => _showContextMenu(),
      onTapDown: (details) => _saveTapPosition(details: details),
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: Image.file(
              File(Todos.getTodoImageAbsolutePath(
                  imageName: widget.todo.imageName)),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, -0.25),
                colors: [Colors.grey, Colors.transparent],
              ),
            ),
            constraints: const BoxConstraints.expand(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: TodoIsCompletedIconWidget(todo: widget.todo),
          ),
        ],
      ),
    );
  }
}
