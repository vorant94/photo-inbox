import 'package:flutter/material.dart';

const todoPopupMenuItems = [
  PopupMenuItem(
    value: TodoAction.delete,
    child: Text('Delete'),
  )
];

enum TodoAction {
  create,
  delete,
  complete,
  incomplete,
}

void showTodoActionSnackBar({
  required BuildContext context,
  required TodoAction action,
}) {
  late final String text;

  switch (action) {
    case TodoAction.delete:
      text = 'Todo deleted';
      break;
    case TodoAction.complete:
      text = 'Todo marked as completed';
      break;
    case TodoAction.incomplete:
      text = 'Todo marked as incomplete';
      break;
    case TodoAction.create:
      text = 'Todo created';
      break;
    default:
      throw Exception('Unexpected action: $action');
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
