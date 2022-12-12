import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/create_todo.dart';
import 'models/todo.dart';
import 'models/update_todo.dart';
import 'todos_table.dart';

class TodosNotifier extends StateNotifier<TodoList> {
  final table = TodoTable();

  TodosNotifier() : super([]);

  Future<void> toggleTodoCompleted(int todoId) async {
    var todo = state.firstWhere((element) => element.id == todoId);
    todo = todo.copyWith(isCompleted: !todo.isCompleted);
    final curr = await table.update(UpdateTodo.fromTodo(todo));

    state =
        state.map((element) => element.id == todoId ? curr : element).toList();
  }

  Future<void> fetchTodos() async {
    state = await table.getAll();
  }

  Future<void> createTodo(CreateTodo createTodo) async {
    final todo = await table.insert(createTodo);

    state = [...state, todo];
  }
}

final inboxProvider = StateNotifierProvider<TodosNotifier, TodoList>((ref) {
  return TodosNotifier();
});
