import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../with_tnx.dart';
import 'create_todo.dart';
import 'todo.dart';
import 'todo_fields.dart';
import 'update_todo.dart';

@immutable
class TodosTable {
  static const name = 'todos';

  const TodosTable();

  Future<List<Todo>> getMany({
    List<int>? ids,
    Transaction? tnx,
  }) async {
    return await withTnx((tnx) async {
      String where = '';

      if (ids != null) {
        where +=
            'WHERE ${TodosTable.name}.${TodoFields.id} IN(${ids.join(', ')})';
      }

      final query = '''
        SELECT ${TodosTable.name}.${TodoFields.id} AS ${TodoFields.id},
               ${TodosTable.name}.${TodoFields.createdDate} AS ${TodoFields.createdDate},
               ${TodoFields.imagePath},
               ${TodoFields.isCompleted}
        FROM ${TodosTable.name}
        $where
        ORDER BY ${TodoFields.createdDate} DESC;
      ''';

      final maps = await tnx.rawQuery(query);

      return maps.map((map) => Todo.fromJson(map)).toList();
    }, tnx);
  }

  Future<Todo> getOne(int id, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final todos = await getMany(ids: [id], tnx: tnx);

      if (todos.isEmpty) throw Exception('Not found');
      return todos.first;
    }, tnx);
  }

  Future<Todo> create(CreateTodo createTodo, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final json = createTodo.toJson();

      final id = await tnx.insert(
        TodosTable.name,
        json,
      );

      return getOne(id, tnx: tnx);
    }, tnx);
  }

  Future<Todo> update(UpdateTodo updateTodo, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final json = updateTodo.toJson();

      final count = await tnx.update(
        TodosTable.name,
        json,
        where: '${TodoFields.id} = ?',
        whereArgs: [updateTodo.id],
      );

      if (count != 1) throw Exception('Not found');

      return getOne(updateTodo.id, tnx: tnx);
    }, tnx);
  }
}
