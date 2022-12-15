import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/db/tables/todos_table.dart';
import '../../shared/io/directory.dart';
import 'show_all_mode_notifier.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  final _imagesDir = 'todo-images';
  final _table = TodosTable();

  Future<void> toggleTodoCompleted(int todoId) async {
    final prev = state.firstWhere((todo) => todo.id == todoId);
    final update =
        prev.copyWith({TodoFields.isCompleted: !prev.isCompleted}).toUpdate();
    final curr = await _table.update(update);

    state = state.map((todo) => todo.id == todoId ? curr : todo).toList();
  }

  Future<void> fetchTodos() async {
    state = await _table.getMany();
  }

  Future<void> createTodo({
    required File cacheImage,
    String? tag,
  }) async {
    final docDirPath = (await getApplicationDocumentsDirectory()).path;
    final imagesDirPath = join(docDirPath, _imagesDir);
    await Directory(imagesDirPath).ensure();

    final cacheImageName = basename(cacheImage.path);
    final imagePath = join(imagesDirPath, cacheImageName);
    final image = await cacheImage.copy(imagePath);

    try {
      final create = CreateTodo(imagePath: image.path, tag: tag);
      final todo = await _table.create(create);

      state = [todo, ...state];
    } catch (e) {
      await image.delete();
      rethrow;
    }
  }
}

final todosProvider = Provider<List<Todo>>((ref) {
  final allTodos = ref.watch(_todosProvider);
  final showAllMode = ref.watch(showAllModeProvider);

  return showAllMode
      ? allTodos
      : allTodos.where((todo) => !todo.isCompleted).toList();
});

final todoProvider = Provider.family<Todo, int>((ref, todoId) =>
    ref.watch(_todosProvider).firstWhere((todo) => todo.id == todoId));

final todosNotifier = _todosProvider.notifier;

final _todosProvider =
    StateNotifierProvider<TodosNotifier, List<Todo>>((ref) => TodosNotifier());
