import 'dart:io';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/io/directory.dart';
import '../models/todo.dart';
import 'show_all_mode.dart';

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
  }) async {
    final isar = GetIt.I<Isar>();

    final imageName = basename(xImage.path);
    final imageAbsolutePath =
        await getTodoImageAbsolutePath(imageName: imageName);
    await xImage.saveTo(imageAbsolutePath);

    final todo = await isar.writeTxn(() async {
      final todo = Todo()..imageName = imageName;

      final id = await isar.todos.put(todo);
      return await isar.todos.get(id) as Todo;
    });

    state = [todo, ...state];
  }

  Future<void> toggleIsCompleted({
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
}

@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  final allTodos = ref.watch(todosProvider);
  final showAllMode = ref.watch(showAllModeProvider);

  return showAllMode
      ? allTodos
      : allTodos.where((todo) => !todo.isCompleted).toList();
}

@riverpod
Map<DateTime, List<Todo>> todosByDay(TodosByDayRef ref) {
  final todos = ref.watch(filteredTodosProvider);

  return groupBy(todos, (todo) {
    final date = todo.createdDate;

    return DateTime(date.year, date.month, date.day);
  });
}

final todoProvider = Provider.autoDispose.family<Todo, Id>((ref, todoId) {
  ref.listen<List<Todo>>(
    filteredTodosProvider,
    (previous, next) {
      final todo = next.firstWhereOrNull((t) => t.id == todoId);
      if (todo != null) {
        ref.state = todo;
      }
    },
    fireImmediately: true,
  );
  return ref.state;
});

// TODO find a better place for this
Future<String> getTodoImageAbsolutePath({
  required String imageName,
}) async {
  final docDirPath = (await getApplicationDocumentsDirectory()).path;
  final imagesDirPath = join(docDirPath, _imagesDir);
  await Directory(imagesDirPath).ensure();
  final imageAbsolutePath = join(imagesDirPath, imageName);

  return imageAbsolutePath;
}

const _imagesDir = 'todo-images';
