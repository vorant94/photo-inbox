import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/shared.dart';
import 'show_all_mode_notifier.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  final _imagesDir = 'todo-images';

  Future<void> toggleTodoCompleted(int todoId) async {
    final todosTable = GetIt.I<TodosTable>();

    final prev = state.firstWhere((todo) => todo.id == todoId);
    final update = prev.copyWith(isCompleted: !prev.isCompleted).toUpdate();
    final curr = await todosTable.update(update);

    state = state.map((todo) => todo.id == todoId ? curr : todo).toList();
  }

  Future<void> fetchTodos() async {
    final todosTable = GetIt.I<TodosTable>();

    state = await todosTable.getMany();
  }

  Future<void> createTodo({
    required File cacheImage,
    String? tag,
  }) async {
    final todosTable = GetIt.I<TodosTable>();

    final docDirPath = (await getApplicationDocumentsDirectory()).path;
    final imagesDirPath = join(docDirPath, _imagesDir);
    await Directory(imagesDirPath).ensure();

    final cacheImageName = basename(cacheImage.path);
    final imagePath = join(imagesDirPath, cacheImageName);
    final image = await cacheImage.copy(imagePath);

    try {
      final create = CreateTodo(imagePath: image.path, tag: tag);
      final todo = await todosTable.create(create);

      state = [todo, ...state];
    } catch (e) {
      await image.delete();
      rethrow;
    }
  }

  Future<void> changeTodoTag(
    int todoId, {
    String? tag,
  }) async {
    final todosTable = GetIt.I<TodosTable>();

    final prev = state.firstWhere((todo) => todo.id == todoId);
    if (tag == prev.tag) return;

    final update = prev.copyWith(tag: tag).toUpdate();
    final curr = await todosTable.update(update);

    state = state.map((todo) => todo.id == todoId ? curr : todo).toList();
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
