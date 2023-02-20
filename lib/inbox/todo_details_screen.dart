import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../shared/state/show_completed.dart';
import 'models/todo.dart';
import 'state/todos.dart';
import 'widgets/todo_is_completed_icon_widget.dart';

class TodoDetailsScreen extends StatefulHookConsumerWidget
    implements TodoDetailsScreenExtra {
  const TodoDetailsScreen({
    required this.index,
    required this.day,
    super.key,
  });

  @override
  final int index;
  @override
  final DateTime day;

  @override
  ConsumerState<TodoDetailsScreen> createState() => _TodoDetailsScreenState();

  static const routeName = 'todo-details';
  static final route = GoRoute(
    name: TodoDetailsScreen.routeName,
    path: '/todo-details',
    builder: (context, state) {
      final extra = state.extra;
      if (extra is! TodoDetailsScreenExtra) {
        throw Exception('Expected TodoDetailsScreenExtra');
      }

      return TodoDetailsScreen(index: extra.index, day: extra.day);
    },
  );
}

class _TodoDetailsScreenState extends ConsumerState<TodoDetailsScreen> {
  final carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosByDayProvider(widget.day));
    if (todos.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No todos for this day.'),
        ),
      );
    }

    final fullScreenMode = useState(false);
    final currentTodoIndex = useState(widget.index);
    final todo = todos[currentTodoIndex.value];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: fullScreenMode.value ? Colors.black : null,
      appBar: fullScreenMode.value
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                DateFormat.MMMEd().format(widget.day),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: [
                TodoIsCompletedIconWidget(
                  todo: todo,
                  onTodoCompletedCallback: onTodoCompletedCallback,
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: _PopupMenuAction.delete,
                      child: Text('Delete'),
                    )
                  ],
                  onSelected: (action) =>
                      onPopupMenuSelected(action: action, todo: todo),
                )
              ],
            ),
      body: GestureDetector(
        onTap: () => fullScreenMode.value = !fullScreenMode.value,
        child: Center(
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              aspectRatio: 9 / 16,
              initialPage: currentTodoIndex.value,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) => currentTodoIndex.value = index,
            ),
            items: todos
                .map((todo) => Image.file(
                      File(Todos.getTodoImageAbsolutePath(
                        imageName: todo.imageName,
                      )),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void onTodoCompletedCallback() {
    final showCompleted = ref.read(showCompletedProvider);
    if (showCompleted) {
      carouselController.nextPage();
    }
  }

  void onPopupMenuSelected({
    required _PopupMenuAction action,
    required Todo todo,
  }) {
    switch (action) {
      case _PopupMenuAction.delete:
        deleteTodo(todo: todo);
        break;
    }
  }

  void deleteTodo({required Todo todo}) {
    final todos = ref.read(todosByDayProvider(widget.day));
    final notifier = ref.read(todosProvider.notifier);

    final isLastTodo = todos.length == 1;

    notifier.delete(id: todo.id);

    if (isLastTodo) {
      context.pop();
    }
  }
}

enum _PopupMenuAction {
  delete,
}

class TodoDetailsScreenExtra {
  const TodoDetailsScreenExtra({
    required this.index,
    required this.day,
  });

  final int index;
  final DateTime day;
}
