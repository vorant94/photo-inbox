import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/create_todo.dart';
import 'models/todo.dart';
import 'models/todo_fields.dart';
import 'models/update_todo.dart';

@immutable
class TodoTable {
  static const _instance = TodoTable._();

  final _dbFilename = 'photo-inbox.db';
  final _tableName = 'todos';

  factory TodoTable() {
    return _instance;
  }

  const TodoTable._();

  Future<TodoList> getAll() async {
    return await _withDb((db) async {
      final maps = await db.query(_tableName);

      return maps.map((map) => Todo.fromMap(map)).toList();
    });
  }

  Future<Todo> getOne(int id) async {
    return await _withDb((db) async {
      final maps = await db.query(
        _tableName,
        where: '${TodoFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) throw Exception('Not found');
      return Todo.fromMap(maps.first);
    });
  }

  Future<Todo> insert(CreateTodo createTodo) async {
    return await _withDb((db) async {
      final id = await db.insert(
        _tableName,
        createTodo.toMap(),
      );
      return getOne(id);
    });
  }

  Future<Todo> update(UpdateTodo todo) async {
    return await _withDb((db) async {
      final count = await db.update(
        _tableName,
        todo.toMap(),
        where: '${TodoFields.id} = ?',
        whereArgs: [todo.id],
      );

      if (count != 1) throw Exception('Not found');

      return getOne(todo.id);
    });
  }

  Future<T> _withDb<T>(Future<T> Function(Database db) callback) async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _dbFilename);
    final db = await openDatabase(dbPath, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableName (
        ${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TodoFields.imagePath} TEXT NOT NULL,
        ${TodoFields.createdDate} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
        ${TodoFields.tag} TEXT,
        ${TodoFields.isCompleted} BOOLEAN DEFAULT 0 NOT NULL CHECK (${TodoFields.isCompleted} IN (0, 1)))
      ''');
    }, version: 1);
    final result = await callback(db);

    await db.close();
    return result;
  }
}
