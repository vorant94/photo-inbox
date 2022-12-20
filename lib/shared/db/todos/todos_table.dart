import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/shared/db/tags/tags_table.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/entities_table.dart';
import '../tags/create_tag.dart';
import '../tags/tag_fields.dart';
import '../with_tnx.dart';
import 'create_todo.dart';
import 'todo.dart';
import 'todo_fields.dart';
import 'update_todo.dart';

@immutable
class TodosTable implements EntitiesTable<Todo, CreateTodo, UpdateTodo> {
  static const name = 'todos';

  const TodosTable();

  @override
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
               ${TagsTable.name}.${TagFields.name} AS tag,
               ${TodoFields.isCompleted}
        FROM ${TodosTable.name}
        LEFT JOIN ${TagsTable.name} ON ${TagsTable.name}.${TagFields.id} = ${TodosTable.name}.${TodoFields.tagId}
        $where
        ORDER BY ${TodoFields.createdDate} DESC;
      ''';

      final maps = await tnx.rawQuery(query);

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
      final json = createTodo.toJson();

      await _replaceTagWithTagId(json, tnx: tnx);

      final id = await tnx.insert(
        TodosTable.name,
        json,
      );

      return getOne(id, tnx: tnx);
    }, tnx);
  }

  @override
  Future<Todo> update(UpdateTodo updateTodo, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final json = updateTodo.toJson();

      await _replaceTagWithTagId(json, tnx: tnx);

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

  Future<void> _replaceTagWithTagId(
    Map<String, dynamic> json, {
    Transaction? tnx,
  }) async {
    final tagsTable = GetIt.I<TagsTable>();

    final tagName = json[TodoFields.tag];
    if (tagName == null) {
      json[TodoFields.tagId] = null;
      json.remove(TodoFields.tag);
      return;
    }

    final existingTag = await tagsTable.findOneByName(tagName, tnx: tnx);
    if (existingTag != null) {
      json[TodoFields.tagId] = existingTag.id;
      json.remove(TodoFields.tag);
      return;
    }

    final createTag = CreateTag(name: tagName);
    final newTag = await tagsTable.create(createTag, tnx: tnx);
    json[TodoFields.tagId] = newTag.id;
    json.remove(TodoFields.tag);
  }
}
