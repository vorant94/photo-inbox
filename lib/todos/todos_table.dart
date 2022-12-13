import 'package:flutter/foundation.dart';
import 'package:mobile/shared/db/create_db.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/db/db.dart';
import '../shared/db/table.dart';

@immutable
class TodoTable extends Table<Todo, CreateTodo, UpdateTodo> {
  static const _instance = TodoTable._();

  factory TodoTable() {
    return _instance;
  }

  const TodoTable._();

  @override
  Future<List<Todo>> getAll([Transaction? tnx]) async {
    return await Db.withTnx((tnx) async {
      final maps = await tnx.query(todosTableName);

      return maps.map((map) => Todo.fromJson(map)).toList();
    }, tnx);
  }

  @override
  Future<Todo> getOne(int id, [Transaction? tnx]) async {
    return await Db.withTnx((tnx) async {
      final maps = await tnx.query(
        todosTableName,
        where: '${TodoFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) throw Exception('Not found');
      return Todo.fromJson(maps.first);
    }, tnx);
  }

  @override
  Future<Todo> insert(CreateTodo createTodo, [Transaction? tnx]) async {
    return await Db.withTnx((tnx) async {
      final id = await tnx.insert(
        todosTableName,
        createTodo.toJson(),
      );
      return getOne(id, tnx);
    }, tnx);
  }

  @override
  Future<Todo> update(UpdateTodo todo, [Transaction? tnx]) async {
    return await Db.withTnx((tnx) async {
      final count = await tnx.update(
        todosTableName,
        todo.toJson(),
        where: '${TodoFields.id} = ?',
        whereArgs: [todo.id],
      );

      if (count != 1) throw Exception('Not found');

      return getOne(todo.id, tnx);
    }, tnx);
  }
}

class Todo extends Entity {
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  const Todo._({
    required int id,
    required DateTime createdDate,
    required this.imagePath,
    this.tag,
    required this.isCompleted,
  }) : super(id: id, createdDate: createdDate);

  Todo.fromJson(Map<String, dynamic> json)
      : imagePath = json[TodoFields.imagePath],
        tag = json[TodoFields.tag],
        isCompleted = json[TodoFields.isCompleted] == 1,
        super.fromJson(json);

  @override
  Todo copyWith(Map<String, dynamic> json) {
    return Todo._(
      id: json['id'] ?? id,
      imagePath: json['imagePath'] ?? imagePath,
      createdDate: json['createdDate'] ?? createdDate,
      tag: json['tag'] ?? tag,
      isCompleted: json['isCompleted'] ?? isCompleted,
    );
  }

  @override
  UpdateTodo toUpdate() => UpdateTodo.fromEntity(this);
}

class CreateTodo extends CreateEntity {
  final String imagePath;
  final String? tag;
  final bool isCompleted;

  const CreateTodo({
    required this.imagePath,
    this.tag,
    bool? isCompleted,
  })  : isCompleted = isCompleted ?? false,
        super();

  @override
  Map<String, dynamic> toJson() => {
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}

class UpdateTodo extends UpdateEntity {
  late final String imagePath;
  late final String? tag;
  late final bool isCompleted;

  UpdateTodo.fromEntity(Todo todo)
      : imagePath = todo.imagePath,
        tag = todo.tag,
        isCompleted = todo.isCompleted,
        super.fromEntity(todo);

  @override
  Map<String, dynamic> toJson() => {
        TodoFields.id: id,
        TodoFields.imagePath: imagePath,
        TodoFields.tag: tag,
        TodoFields.isCompleted: isCompleted ? 1 : 0,
      };
}
