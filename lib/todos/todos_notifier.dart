import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../shared/db/tables/todos_table.dart';
import '../shared/io/directory.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  static final provider = StateNotifierProvider<TodosNotifier, List<Todo>>(
      (ref) => TodosNotifier());

  static const imagesDir = 'todo-images';

  static final _instance = TodosNotifier._();

  final table = TodosTable();

  factory TodosNotifier() {
    return _instance;
  }

  TodosNotifier._() : super([]);

  Future<void> toggleTodoCompleted(int todoId) async {
    final prev = state.firstWhere((todo) => todo.id == todoId);
    final update =
        prev.copyWith({TodoFields.isCompleted: !prev.isCompleted}).toUpdate();
    final curr = await table.update(update);

    state = state.map((todo) => todo.id == todoId ? curr : todo).toList();
  }

  Future<void> fetchTodos() async {
    state = await table.getMany();
  }

  Future<void> createTodo({
    required File cacheImage,
    String? tag,
  }) async {
    final docDirPath = (await getApplicationDocumentsDirectory()).path;
    final imagesDirPath = join(docDirPath, TodosNotifier.imagesDir);
    await Directory(imagesDirPath).ensure();

    final cacheImageName = basename(cacheImage.path);
    final imagePath = join(imagesDirPath, cacheImageName);
    final image = await cacheImage.copy(imagePath);

    try {
      final create = CreateTodo(imagePath: image.path, tag: tag);
      final todo = await table.create(create);

      state = state..add(todo);
    } catch (e) {
      await image.delete();
      rethrow;
    }
  }
}
