import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/io/directory.dart';
import '../models/todo.dart';
import 'show_all_mode.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  final _imagesDir = 'todo-images';

  Future<void> fetchAll() async {
    final isar = GetIt.I<Isar>();

    state = await isar.todos.where().findAll();
  }

  Future<void> create({
    required XFile xImage,
  }) async {
    final isar = GetIt.I<Isar>();

    final docDirPath = (await getApplicationDocumentsDirectory()).path;
    final imagesDirPath = join(docDirPath, _imagesDir);
    await Directory(imagesDirPath).ensure();
    final imageName = basename(xImage.path);
    final imagePath = join(imagesDirPath, imageName);
    await xImage.saveTo(imagePath);

    final id = await isar.writeTxn(() async {
      final todo = Todo()..imagePath = imagePath;

      return await isar.todos.put(todo);
    });

    final todo = await isar.todos.get(id);
    if (todo == null) throw Exception('Todo not found');

    state = [...state, todo];
  }

  Future<void> toggleIsCompleted(int id) async {
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

  Future<void> delete(int id) async {
    final isar = GetIt.I<Isar>();

    await isar.writeTxn(() async {
      final todo = await isar.todos.get(id);
      if (todo == null) throw Exception('Todo not found');

      await isar.todos.delete(id);
    });

    state = state.where((todo) => todo.id != id).toList();
  }
}

final filteredTodosProvider = Provider.autoDispose<List<Todo>>((ref) {
  final allTodos = ref.watch(todosProvider);
  final showAllMode = ref.watch(showAllModeProvider);

  return showAllMode
      ? allTodos
      : allTodos.where((todo) => !todo.isCompleted).toList();
});

final todosProvider =
    StateNotifierProvider.autoDispose<TodosNotifier, List<Todo>>(
        (ref) => TodosNotifier());
