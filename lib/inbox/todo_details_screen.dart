import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../shared/state/show_completed.dart';
import 'common/todo_popup_menu_items.dart';
import 'models/todo.dart';
import 'state/todos.dart';
import 'widgets/todo_is_completed_icon_widget.dart';

class TodoDetailsScreen extends ConsumerStatefulWidget
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
  var fullScreenMode = false;
  late int currentTodoIndex;

  @override
  void initState() {
    currentTodoIndex = widget.index;

    super.initState();
  }

  toggleFullScreen() {
    setState(() {
      fullScreenMode = !fullScreenMode;
    });
  }

  onPageChanged({required int index}) {
    setState(() {
      currentTodoIndex = index;
    });
  }

  void onTodoCompletedCallback() {
    final showCompleted = ref.read(showCompletedProvider);
    if (showCompleted) {
      carouselController.nextPage();
    }
  }

  void onTodoActionSelected({
    required TodoAction action,
    required Todo todo,
  }) {
    switch (action) {
      case TodoAction.delete:
        deleteTodo(todo: todo);
        break;
      default:
        throw Exception('Unexpected action: $action');
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

    showTodoActionSnackBar(context: context, action: TodoAction.delete);
  }

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

    final todo = todos[currentTodoIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: fullScreenMode ? Colors.black : null,
      appBar: fullScreenMode
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
                  itemBuilder: (context) => todoPopupMenuItems,
                  onSelected: (action) =>
                      onTodoActionSelected(action: action, todo: todo),
                )
              ],
            ),
      body: GestureDetector(
        onTap: () => toggleFullScreen(),
        child: Center(
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              aspectRatio: todo.aspectRatio,
              initialPage: currentTodoIndex,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) => onPageChanged(index: index),
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
}

class TodoDetailsScreenExtra {
  const TodoDetailsScreenExtra({
    required this.index,
    required this.day,
  });

  final int index;
  final DateTime day;
}
