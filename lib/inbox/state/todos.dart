import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/core/date_time.dart';
import '../../shared/state/show_completed.dart';
import '../models/todo.dart';

part 'todos.g.dart';

@riverpod
class Todos extends _$Todos {
  @override
  List<Todo> build() {
    final isar = GetIt.I<Isar>();

    isar.todos
        .where()
        .sortByCreatedDateDesc()
        .findAll()
        .then((value) => state = value);

    return [];
  }

  Future<void> create({
    required XFile xImage,
    required double aspectRatio,
  }) async {
    final isar = GetIt.I<Isar>();

    final imageName = basename(xImage.path);
    final imageAbsolutePath =
        Todos.getTodoImageAbsolutePath(imageName: imageName);
    await xImage.saveTo(imageAbsolutePath);

    final todo = await isar.writeTxn(() async {
      final todo = Todo()
        ..imageName = imageName
        ..aspectRatio = aspectRatio;

      final id = await isar.todos.put(todo);
      return await isar.todos.get(id) as Todo;
    });

    state = [todo, ...state];
  }

  Future<bool> toggleIsCompleted({
    required Id id,
  }) async {
    final isar = GetIt.I<Isar>();

    final update = await isar.writeTxn(() async {
      final todo = await isar.todos.get(id);
      if (todo == null) throw Exception('Todo not found');

      todo.isCompleted = !todo.isCompleted;
      await isar.todos.put(todo);

      return todo;
    });

    state = state.map((prev) => prev.id == id ? update : prev).toList();

    return update.isCompleted;
  }

  Future<void> delete({
    required Id id,
  }) async {
    final isar = GetIt.I<Isar>();

    await isar.writeTxn(() async {
      final todo = await isar.todos.get(id);
      if (todo == null) throw Exception('Todo not found');

      await isar.todos.delete(id);
    });

    state = state.where((todo) => todo.id != id).toList();
  }

  Id? findNextTodoIdForToday({
    required Id currentId,
  }) {
    final currentIndex = state.indexWhere((todo) => todo.id == currentId);
    if (currentIndex == -1) return null;

    final currentTodo = state[currentIndex];
    final nextTodo = _findNextUncompletedTodo(currentIndex: currentIndex);
    if (nextTodo == null) return null;

    if (currentTodo.createdDate.isSameDate(nextTodo.createdDate)) {
      return nextTodo.id;
    }

    return null;
  }

  Todo? _findNextUncompletedTodo({
    required currentIndex,
  }) {
    if (currentIndex == 0) return null;

    final nextTodo = state[currentIndex - 1];
    if (!nextTodo.isCompleted) {
      return nextTodo;
    }

    return _findNextUncompletedTodo(currentIndex: currentIndex - 1);
  }

  static late final String imagesDirPath;

  static String getTodoImageAbsolutePath({
    required String imageName,
  }) {
    return join(imagesDirPath, imageName);
  }
}

@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  final allTodos = ref.watch(todosProvider);
  final showCompleted = ref.watch(showCompletedProvider);

  return showCompleted
      ? allTodos
      : allTodos.where((todo) => !todo.isCompleted).toList();
}

@riverpod
List<DateTime> todoDays(TodoDaysRef ref) {
  final todos = ref.watch(filteredTodosProvider);

  return groupBy(todos, (todo) {
    final date = todo.createdDate;

    return DateTime(date.year, date.month, date.day);
  }).keys.toList();
}

@riverpod
List<Todo> todosByDay(TodosByDayRef ref, DateTime day) {
  final todos = ref.watch(filteredTodosProvider);

  return todos
      .where((todo) => todo.createdDate.isSameDate(day))
      .sortedBy((element) => element.createdDate);
}
