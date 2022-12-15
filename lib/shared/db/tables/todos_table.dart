import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../with_tnx.dart';
import 'entities_table.dart';

@immutable
class TodosTable implements EntitiesTable<Todo, CreateTodo, UpdateTodo> {
  static const _instance = TodosTable._();

  @override
  final name = 'todos';

  factory TodosTable() {
    return _instance;
  }

  const TodosTable._();

  @override
  Future<List<Todo>> getMany({
    List<int>? ids,
    Transaction? tnx,
  }) async {
    return await withTnx((tnx) async {
      String where = '';
      List<Object?> whereArgs = [];

      if (ids != null) {
        where += '${TodoFields.id} IN(?)';
        whereArgs.add(ids.join(', '));
      }

      final maps = await tnx.query(
        name,
        where: where.isEmpty ? null : where,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: '${TodoFields.createdDate} DESC',
      );

      return maps.map((map) => Todo.fromJson(map)).toList();
    }, tnx);
  }

  @override
  Future<Todo> getOne(int id, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final todos = await getMany(ids: [id], tnx: tnx);

      if (todos.isEmpty) throw Exception('Not found');
      return todos.first;
    }, tnx);
  }

  @override
  Future<Todo> create(CreateTodo createTodo, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final id = await tnx.insert(
        name,
        createTodo.toJson(),
      );
      return getOne(id, tnx: tnx);
    }, tnx);
  }

  @override
  Future<Todo> update(UpdateTodo todo, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final count = await tnx.update(
        name,
        todo.toJson(),
        where: '${TodoFields.id} = ?',
        whereArgs: [todo.id],
      );

      if (count != 1) throw Exception('Not found');

      return getOne(todo.id, tnx: tnx);
    }, tnx);
  }
}

@immutable
class Todo implements Entity {
  @override
  final int id;
  @override
  final DateTime createdDate;
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  const Todo._({
    required this.id,
    required this.createdDate,
    required this.imagePath,
    this.tag,
    required this.isCompleted,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json[TodoFields.id],
        createdDate = DateTime.parse(json[TodoFields.createdDate]),
        imagePath = json[TodoFields.imagePath],
        tag = json[TodoFields.tag],
        isCompleted = json[TodoFields.isCompleted] == 1;

  @override
  Todo copyWith(Map<String, dynamic> json) {
    return Todo._(
      id: json[TodoFields.id] ?? id,
      createdDate: json[TodoFields.createdDate] ?? createdDate,
      imagePath: json[TodoFields.imagePath] ?? imagePath,
      tag: json[TodoFields.tag] ?? tag,
      isCompleted: json[TodoFields.isCompleted] ?? isCompleted,
    );
  }

  @override
  UpdateTodo toUpdate() => UpdateTodo.fromEntity(this);
}

@immutable
class CreateTodo implements CreateEntity {
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  const CreateTodo({
    required this.imagePath,
    this.tag,
    this.isCompleted = false,
  });

  @override
  Map<String, dynamic> toJson() => {
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}

@immutable
class UpdateTodo implements UpdateEntity {
  @override
  final int id;
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  UpdateTodo.fromEntity(Todo todo)
      : id = todo.id,
        imagePath = todo.imagePath,
        tag = todo.tag,
        isCompleted = todo.isCompleted;

  @override
  Map<String, dynamic> toJson() => {
        TodoFields.id: id,
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}

@immutable
class TodoFields {
  static const id = EntityFields.id;
  static const createdDate = EntityFields.createdDate;
  static const imagePath = 'imagePath';
  static const tag = 'tag';
  static const isCompleted = 'isCompleted';

  const TodoFields._();
}
