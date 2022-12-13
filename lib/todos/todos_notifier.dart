import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todos_table.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  final table = TodoTable();

  TodosNotifier() : super([]);

  Future<void> toggleTodoCompleted(int todoId) async {
    final todo = state.firstWhere((element) => element.id == todoId);
    final update = todo.copyWith({'isCompleted': !todo.isCompleted}).toUpdate();
    final curr = await table.update(update);

    state =
        state.map((element) => element.id == todoId ? curr : element).toList();
  }

  Future<void> fetchTodos() async {
    state = await table.getAll();
  }

  Future<void> createTodo(CreateTodo createTodo) async {
    try {
      final todo = await table.insert(createTodo);
      state = [...state, todo];
    } catch (e) {
      await File(createTodo.imagePath).delete();
      rethrow;
    }
  }
}

final inboxProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
